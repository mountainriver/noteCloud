# 登陆超时配置
## 方法
1. 系统参数
profile  TMOUT

2. ssh配置
通过修改/etc/ssh/sshd_config中的配置解决自动断开的问题。下面是要修改的两个配置项的含义：

- ClientAliveInterval指定了服务器端向客户端请求消息的时间间隔, 默认是0, 不发送.60表示每分钟发送一次, 然后客户端响应, 这样就保持长连接了.这里比较怪的地方是:不是客户端主动发起保持连接的请求(如FTerm, CTerm等),而是需要服务器先主动。

- ClientAliveCountMax, 使用默认值3即可.ClientAliveCountMax表示服务器发出请求后客户端没有响应的次数达到一定值, 就自动断开。正常情况下, 客户端不会不响应。“
## 操作
1. 查看当前配置

```
grep"ClientAlive" sshd_config
#ClientAliveInterval0
#ClientAliveCountMax3
```
2. 备份原文件  
`cp sshd_configsshd_config.bak`
3. 修改配置文件
```
sed-i "s/#ClientAliveInterval 0/ClientAliveInterval 60/g" sshd_config
sed -i "s/#ClientAliveCountMax3/ClientAliveCountMax 3/g" sshd_config
```
4. 验证修改结果
```
grep"ClientAlive" sshd_config
diff sshd_config sshd_config.bak
```
5. 重启服务
service sshdrestart  
现在无论空闲多久，SSH客户端都不会自动断开了。

# 保持进程运行，即使当前用户退出后
```
nohup cmd &
```
