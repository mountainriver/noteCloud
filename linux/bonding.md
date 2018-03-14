# 网卡配置文件
1. 创建bond0启动配置文件:
```
cd /etc/sysconfig/network-scripts/
vi ifcfg-bond0
DEVICE=bond0
ONBOOT=yes
BOOTPROTO=static
IPADDR=192.168.100.12
NETMASK=255.255.255.0
USERCTL=no
```
2. 编辑网卡配置文件ifcfg-eth0，ifcfg-eth1
	1. 配置网卡一
```
vi ifcfg-eth0
DEVICE=eth0
USERCTL=no
ONBOOT=yes
MASTER=bond0
SLAVE=yes
BOOTPROTO=none
```
	2. 配置网卡二
```
vi ifcfg-eth1`
DEVICE=eth1
USERCTL=no
ONBOOT=yes
MASTER=bond0
SLAVE=yes
BOOTPROTO=none
```
>注：MASTER=bond0和SLAVE=yes这两行主要是用于系统service network restart后自动启用  

# 配置开机自动加载BONGDING模块
创建并配置modprobe.conf文件
```
vi /etc/modprobe.conf
alias bond0 bonding
options bond0 miimon=100 mode=1
```
>注  
1：millmon表示链路监测时间间隔，单位为ms，millmon=100表示每100ms监测一次链路连接状态，如果有一条不通，就转入另一条。这个值建议为100, 设成其它值可能导致不稳定  
2：mode表示两张网卡的运行方式，0 表示load blance，1 表示热备（建议使用热备,共有7种模式）

# 设置开机启动
`echo "ifenslave bond0 eth0 eth1" >> /etc/rc.d/rc.local`

至此配置完毕，重启网络服务或重启服务器即可，如下
`service network restart  或者  # init 6`

# 查看并测试
1. 查看bond0信息
`cat /proc/net/bonding/bond0"`
2. ip adress 看到三个网卡的MAC是一样的。
# 注意
需要关闭NetworkManager服务？
