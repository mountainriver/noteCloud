如果一个主机配置有多个IP，发送数据包时，源IP的选择。
分两种情况：被动响应和主动响应。
# 一、主机接受外部数据包，发送响应包时源IP是客户端请求IP。可以改不？

# 二、主机主动对外发起请求时
## 默认
1. 如果Linux 的网卡有多个IP 且位于不同的子网之中，如果数据包目标地址为某个子网中的 IP,  那么对应的与目标同子网的 IP 将会被使用。如果 eth0 有两个 IP 192.168.1.12/24,  10.1.1.1/8 ，那么到 10.0.0.0 子网的数据包的源地址将使用 10.1.1.1 。
2. 如果绑定的几个IP 处于同一个子网内，那么主要 IP 地址将被使用。(如Linux 主机绑定有以下几个 IP （网关为 192.168.0.1 ）eth0 192.168.0.250/24,  eth0: 1  192.168.0.22/24,   eth0:2 192.168.0.23/24，另外，绑定多个IP 可使用 ip addr add 命令，不产生子接口。在上述案例中192.168.0.250 将成为默认主要 IP 。) 
## 修改
1. 修改路由表的源IP 属性
```
[root@localhost ~]#  ip route
192.168.0.0/24 dev eth0  proto kernel  scope link  src 192.168.0.250 
172.16.25.0/24 dev eth0  proto kernel  scope link  src 172.16.25.1 
169.254.0.0/16 dev eth0  scope link 
default via 192.168.0.1 dev eth0 
注意以上输出，会发现到同一子网的路由的源IP 地址会使用主要 IP 地址。而到默认网关的路由没有指定源 IP （实际上会用与网关同一子网的主要 IP ）。
 修改路由表，让系统使用指定IP(192.168.0.22) 作为源址：
 [root@localhost ~]#  ip route change default dev eth0 src 192.168.0.22
 [root@localhost ~]#  ip route change to 192.168.0.0/24 dev eth0 src 192.168.0.22
 [root@localhost ~]#  ip route
 192.168.0.0/24 dev eth0  scope link  src 192.168.0.22 
 172.16.25.0/24 dev eth0  proto kernel  scope link  src 172.16.25.1 
 169.254.0.0/16 dev eth0  scope link 
 default dev eth0  scope link  src 192.168.0.22 
```
2. 用iptables修改源IP地址：(可以发送响应包时生效不？)
```
iptables -t nat -I POSTROUTING -o eth0 -d  0.0.0.0 /0 -s 192.168.0. 250  -j SNAT --to-source 192.168. 0.22
```
