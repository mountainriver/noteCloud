## set time 
```
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime   #设置时区
date -s "2008-08-08 12:00:00"   #设置系统时钟
hwclock -w                      #设置硬件时钟
```
## NTP
- 同步时间，可以使用ntpdate命令，也可以使用ntpd服务。
- 使用ntpd服务，要好于ntpdate加cron的组合。因为，ntpdate同步时间，会造成时间的跳跃，对一些依赖时间的程序和服务会造成影响。比 如sleep，timer等。而且，ntpd服务可以在修正时间的同时，修正cpu tick。理想的做法为，在开机的时候，使用ntpdate强制同步时间，在其他时候使用ntpd服务来同步时间。
1. ntpdate
```
crontab -e
  */15 * * * * ntpdate 服务器端IP 
```
2. ntp服务方式
```
vim /etc/ntp.conf
  server 192.168.7.49 prefer 
  server 0.rhel.pool.ntp.org iburst
  server 1.rhel.pool.ntp.org iburst
  server 2.rhel.pool.ntp.org iburst
  server 3.rhel.pool.ntp.org iburst
 ```
 
 ```
service ntpd start
chkconfig --list ntpd
chkconfig ntpd on
ntpstat           #看ntp服务器有无和上层ntp连通
ntpq -p           #查看ntp服务器与上层ntp的状态
```
