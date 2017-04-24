- iptables不是服务，只是在有些发行版中做成了服务。
- debian从7开始，iptables做成了内核组件，不再是服务，不能用起停服务的方式控制。只能卸载。
```
iptables -P INPUT DROP	#默认禁止所有进入的。
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT	#必须，允许。。。
......

iptables-save > /etc/iptables.rules	#保存配置。

vim /etc/network/if-pre-up.d/iptables	#当网络启用时生效。
	#!/bin/sh
	iptables-restore < /etc/iptables.rules
```
