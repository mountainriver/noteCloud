## rsyslog
### Client 端
1. 
```
[root@study ~]# vim /etc/rsyslog.conf
*.*       @@192.168.1.100
*.*       @192.168.1.100  # 若用 UDP 傳輸，設定要變這樣！
*.*		  :omrelp:192.168.1.100:2514	#采用RELP协议，必须指定端口
[root@study ~]# systemctl restart rsyslog.service]]
```
2. 日志转发  
 在另外一种环境中，让我们假定你已经在机器上安装了一个名为“foobar”的应用程序，它会在/var/log下生成foobar.log日志文件。现在，你想要将它的日志定向到rsyslog服务器，这可以通过像下面这样在rsyslog配置文件中加载imfile模块来实现。
 首先，加载imfile模块，这只需做一次。
```
module(load="imfile" PollingInterval="5")`
```
 然后，指定日志文件的路径以便imfile模块可以检测到：
```
 input(type="imfile"
       File="/var/log/foobar.log"
       Tag="foobar"
       Severity="error"
       Facility="local7")
```
最后，定向local7设备到远程rsyslog服务器：
```
local7.* @192.168.1.25:514

systemctl restart rsyslog
```
### Server 端
1. 修改 rsyslogd 的啟動設定檔，在 /etc/rsyslog.conf 內！
```
[root@study ~]# vim /etc/rsyslog.conf
# 找到底下這幾行：
# Provides UDP syslog reception
#$ModLoad imudp
#$UDPServerRun 514

# Provides TCP syslog reception
#$ModLoad imtcp
#$InputTCPServerRun 514
# 上面的是 UDP 埠口，底下的是 TCP 埠口！如果你的網路狀態很穩定，就用 UDP 即可。
# 不過，如果你想要讓資料比較穩定傳輸，那麼建議使用 TCP 囉！所以修改底下兩行即可！

module(load="imrelp")
input(type="imrelp" port="2514")
#采用RELP协议接收。
```
2. 重新啟動與觀察 rsyslogd 喔！
```
[root@study ~]# systemctl restart rsyslog.service
[root@study ~]# netstat -ltnp | grep syslog
Proto Recv-Q Send-Q Local Address  Foreign Address   State    PID/Program name
tcp        0      0 0.0.0.0:514    0.0.0.0:*         LISTEN   2145/rsyslogd
tcp6       0      0 :::514         :::*              LISTEN   2145/rsyslogd
```
### logger
- 如果你需要记录/var/log/myapp.log文件中的信息, 可以使用:
```
logger -f /var/log/myapp.log
```
- logger命令默认的日志保存在 /var/log/messages
- 另一种用法

```
ping 192.168.0.1 | logger -it logger_test -p local3.notice &
命令logger -it logger_test -p local3.notice中的参数含义：
-i 在每行都记录进程ID
-t logger_test 每行记录都加上“logger_test”这个标签
-p local3.notice 设置记录的设备和级别
```
- 直接发向服务器  
`logger -n IP system reboot for she`
