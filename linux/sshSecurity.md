# 一、在配置文件：
- port 50115	//更改默认端口
- PermitRootLogin no	//禁止root远程登录
强化密码
- Protocol 2,1 	//默认是1和2都可以，将其改为Protocol 2 
- AllowUsers  john     jason	//指定用户(白名单) 
- AllowGroups sysadmin dba		指定组 
- ListenAddress 192.168.10.200	//限制监听IP
- MaxAuthTries 3  最大登录尝试次数
- CllientAliveInerval  60s	//指定服务器端向客户端请求消息的时间间隔, 默认是0, 不发送.而ClientAliveInterval 60表示每60秒发送一次, 然后客户端响应, 这样就保持长连接了
- ClientAliveCountMax  3	//表示服务器发出请求后客户端没有响应的次数达到一定值, 就自动断开. 正常情况下, 客户端不会不响应.
# 二、采用公钥认证
```
$ ssh-keygen -t rsa -b 3072 -f id_mailserver	//创建两个新的密钥: id_mailserver;id_mailserver.pub
$ ssh-copy-id -i  id_rsa.pub user@remoteserver	//命令安全地复制你的公钥到你的远程服务器。你必须确保在远程服务器上有可用的 SSH 登录方式。
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
user@remoteserver's password:
Number of key(s) added: 1
Now try logging into the machine, with:   "ssh 'user@remoteserver'"
and check to make sure that only the key(s) you wanted were added.

//ssh-copy-id 会确保你不会无意间复制了你的私钥。从上述输出中复制登录命令，记得带上其中的单引号，以测试你的新的密钥登录。
$ ssh 'user@remoteserver'
它将用你的新密钥登录，如果你为你的私钥设置了密码，它会提示你输入。
```
# 三、取消密码认证
```
vim /etc/sshd_config
	PasswordAuthentication no
```
# 四、设置别名
ssh -u username -p 2222 remote.site.with.long-name

你可以使用

ssh remote1

- 你的客户端机器上的 ~/.ssh/config文件可以参照如下设置
```
Host remote1
HostName remote.site.with.long-name
Port 2222
User username
PubkeyAuthentication no
```
- 如果你正在使用公钥登录，可以参照这个：
```
Host remote1
HostName remote.site.with.long-name
Port 2222
User username
IdentityFile  ~/.ssh/id_remoteserver
```
