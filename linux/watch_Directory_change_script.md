- 脚本1：将需要监控的目录的原始状态保存到LOG日志
- 脚本2：将脚本1的原始状态与本脚本比对，如果目录文件发生变化，则将变化的内容保存到日志。
> 注：原理实际上利用的是du -sb输出值来判断文件的变化，再利用diff进行比对。
1. 在执行脚本前要保存原始的状态

vi initial.sh
```
#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin/:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
# 监控的目录
DIR=/root
# 临时文件
TMP_A=/tmp/a.txt
# 遍历指定目录下的文件大小及路径并重定向到日志文件
find $DIR -print0 | xargs -0 du -sb  > $TMP_A
```
2. 执行监控脚本

vi monitor.sh
```
#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin/:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
# 监控的目录
DIR=/root
# 日期变量
DATE=`date +%F_%H:%M`
# 临时文件
TMP_A=/tmp/a.txt
TMP_B=/tmp/b.txt
TMP_C=/tmp/c.txt
# 日志文件
LOG=/var/log/filemodify.log
# 遍历指定目录下的文件大小及路径并重定向到日志文件
find $DIR -print0 | xargs -0 du -sb  > $TMP_B
# 比较目录变化，并将变化的文件写入日志
DIFF=$(diff $TMP_A $TMP_B)
if [[ -z $DIFF ]];
 then
   echo "Nothing change" >> $LOG
 else
   echo "Here is the change" >> $LOG
   echo "" >> $LOG
   echo "$DIFF" |awk '{print $3}'|sort -k2n |uniq |sed '/^$/d' |tee $TMP_C >> $LOG
   if [ -s $TMP_C ];
     then
       echo "" >> $LOG
       echo "It modified at $DATE" >> $LOG
# 将当前监控的目录结构覆盖为初始状态
       find $DIR -print0 | xargs -0 du -sb  > $TMP_A
   fi
fi
echo "====================================" >> $LOG
#清理临时文件
rm -rf $TMP_B $TMP_C
```

