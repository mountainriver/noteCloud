- iptables不是服务，只是在有些发行版中做成了服务。
- debian从7开始，iptables做成了内核组件，不再是服务，不能用起停服务的方式控制。只能卸载。
```
iptables -P INPUT DROP	#默认禁止所有进入的。
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT	#必须，允许。。。
iptables -A INPUT -s 127.0.0.1 -j ACCEPT	#第一条会把本地访问本地也禁止掉，加上这条允许本地访问本地。
......

iptables-save > /etc/iptables.rules	#保存配置。

vim /etc/network/if-pre-up.d/iptables	#当网络启用时生效。
	#!/bin/sh
	iptables-restore < /etc/iptables.rules
```
- 需要配置多个连续或不连续的端口
1. 连续
```
-A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 60001:60006 -j ACCEPT
```
2. 对于非连续段或多段， 用mport或multiport 是不错的选择。
