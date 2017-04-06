ORACLE自带审计功能，一般没有开，据说对性能影响大。可以通过建触发器，来记录登陆、登出信息。

alertlog

# Alert log概述
告警日志文件是一类特殊的跟踪文件（trace file）。
告警日志文件命名一般为alert_<SID>.log，其中SID为Oracle数据库实例名称。
数据库告警日志是按时间顺序记录message和错误信息。

## Alert log contents

The alert log is a chronological log of messages and errors, and includes the following items:

1：所有的内部错误（ORA-600）信息，块损坏错误（ORA-1578）信息，以及死锁错误（ORA-60）信息等。

2：管理操作，例如CREATE、ALTER、DROP语句等，以及数据库启动、关闭以及日志归档的一些信息。

    2.1 涉及物理结构的所有操作：例如创建、删除、重命名数据文件与联机重做日志文件的ALTER DATABASE命令.
    此外还涉及重新分配数据文件大小以及将数据文件联机与脱机的操作。 

    2.2 表空间操作，例如DROP与CREATE命令，此外还包括为了进行用户管理的备份而将表空间置入和取出热备份模式的操作 
3：与共享服务器或调度进程相关功能的消息和错误信息。
4：物化视图的自动刷新过程中出现的错误。
5：动态参数的修改信息。
## Alert log location
### For oracle 9i&10g
在下面的目录下：
$ORACLE_BASE/admin/$ORACLE_SID/bdump/
在ORACLE 10g中，BACKGROUND_DUMP_DEST参数确定了告警日志的位置，但是告警日志的文件名无法修改，告警日志的名称为：alert_.log ,其中是实例的名称。BACKGROUND_DUMP_DEST参数是动态的。
告警日志以及所有后台跟踪文件都会被写至BACKGROUND_DUMP_DEST参数所指定的目录
SQL> show parameter background_dump_dest;
### For oracle11g/12C
在下面的目录下：
$ORACLE_BASE/diag/rdbms/$ORACLE_SID/$ORACLE_SID/trace/
在ORACLE 11g 以及ORACLE 12c中，告警日志文件的位置有了变化。主要是因为引入了ADR(Automatic Diagnostic Repository:一个存放数据库诊断日志、跟踪文件的目录)，关于ADR对应的目录位置可以通过查看v$diag_info系统视图。
```
select * from v$diag_info;
```
Diag Trace对应的目录为文本格式的告警日志文件所在的目录,
而Diag Alert对应的目录为XML格式的警告日志(对应为log_x.xml)
11g也有 background_dump_des
```
SQL> show parameter background_dump_dest`
NAME                     TYPE        VALUE
-------------------- ----------- -------------------------
background_dump_dest   string    /oracle/diag/rdbms/cc/cc/trace
```
Notes:
> 1,The Oracle base location is the location where Oracle Database binaries are stored.
> 2,ORACLE_SID:a system identifier (SID) identifies each Oracle database instance for internal connectivity on the Oracle server itself
## Alert log Monitor
既然告警日志如此重要，而我们也不可能随时手工去查看告警日志文件，那么我们就必须监控告警日志，那么监控告警日志有哪些方案呢？下面归纳一下
### 方案1(仅适用于ORACLE 10g)
Tom大师给出的一个方案 ，将告警日志文件信息读入全局临时表，然后我们就可以定制一些SQL语句查询告警日志的信息。
```
create global temporary table alert_log
( line   int primary key,
  text   varchar2(4000)
)
on commit preserve rows
/
create or replace procedure load_alert
as
    l_background_dump_dest   v$parameter.value%type;
    l_filename               varchar2(255);
    l_bfile                  bfile;
    l_last                   number;
    l_current                number;
    l_start                  number := dbms_utility.get_time;
begin
    select a.value, 'alert_' || b.instance || '.log'
      into l_background_dump_dest, l_filename
      from v$parameter a, v$thread b
     where a.name = 'background_dump_dest';
    execute immediate
    'create or replace directory x$alert_log$x as
    ''' || l_background_dump_dest || '''';
    dbms_output.put_line( l_background_dump_dest );
    dbms_output.put_line( l_filename );
    delete from alert_log;
    l_bfile := bfilename( 'X$ALERT_LOG$X', l_filename );
    dbms_lob.fileopen( l_bfile );
    l_last := 1;
    for l_line in 1 .. 50000
    loop
        dbms_application_info.set_client_info( l_line || ', ' ||
        to_char(round((dbms_utility.get_time-l_start)/100, 2 ) ) 
        || ', '||
        to_char((dbms_utility.get_time-l_start)/l_line)
        );
        l_current := dbms_lob.instr( l_bfile, '0A', l_last, 1 );
        exit when (nvl(l_current,0) = 0);
        insert into alert_log
        ( line, text )
        values
        ( l_line, 
          utl_raw.cast_to_varchar2( 
              dbms_lob.substr( l_bfile, l_current-l_last+1, 
                                                    l_last ) )
        );
        l_last := l_current+1;
    end loop;
    dbms_lob.fileclose(l_bfile);
end;
/
```
弊端：但是这又一个问题，如果数据库宕机了的情况下，是无法获取这些错误信息，比方案3（从操作系统监控告警日志）对比，有些特定场景不适用。另外有一定不足之处，就是日志文件比较大的时候，监控告警日志信息比较频繁的时候，会产生不必要的IO操作。

### 方案2：通过外部表来查看告警日志文件的内容
通过外部表来查看告警日志文件的内容。相当的方便。然后也是使用定制SQL语句来查询错误信息。
```
SQL> create or replace directory bdump as '/u01/app/oracle/admin/GSP/bdump';
Directory created.
SQL> create table alert_logs
   (
       text  varchar2(2000)
   )
    organization external
    (
      type oracle_loader
      default directory bdump
        access parameters
    (
       records delimited by newline
       fields
      reject rows with all null fields
    )
   location
   (
             'alert_GSP.log'
   )
  )
 reject limit unlimited;

Table created.

 SQL> select * from alert_logs;
```
### 方案3
监控ORACLE数据库告警日志
Alert log Archive
告警日志如果不及时归档，时间长了，告警日志文件会变得非常大，查看、读取告警日志会引起额外的IO开销。所以一般应该按天归档告警日志文件，保留一段时间（例如 90天），超过规定时间的删除。
background_dump_dest目录下的跟踪文件除了告警日志外都能删除.当进程向告警日志写入记录时就会生成新的告警日志文件 (未验证，生产环境慎重操作。)
