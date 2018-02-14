# 添加永久路由
## redhat
```
/etc/sysconfig/static-routes : (没有static-routes的话就手动建立一个这样的文件)
any net any gw 192.168.1.1
any net 192.168.3.0/24 gw 192.168.3.254
any host 10.250.228.128 gw 10.250.228.129 
```
改文件是被/etc/init.d/network调用的：
```
# Add non interface-specific static-routes.
if [ -f /etc/sysconfig/static-routes ]; then
    grep "^any" /etc/sysconfig/static-routes | while read ignore args ; do
		/sbin/route add -$args
    done
fi
```
> if [ -f /etc/sysconfig/static-routes ] ， -f 意思是存在 /etc/sysconfig/static-routes 且为普通文件，则执行下面的语句
> grep "^any" /etc/sysconfig/static-routes  将 any 开头的行取出
> while read ignore args 执行后 ignore="any" args=其他
> /sbin/route add -$args 添加路由的命令""""]
## debian
在/etc/interfaces中配置？
