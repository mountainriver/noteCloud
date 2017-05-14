### 上传新建的本地库到git:
1. 在新建的文件夹：  
	git init
2. 把文件夹内所有文件添加到暂存区：  
	git add .
3. 提交：  
	git commit -m 'xxx'
4. 添加远程库：(需要先WEB建一个远程库)  
	git remote add origin 远程库地址
5. 获取远程库，于本地库合并（如果远程库不为空，必须作这步）：  
	git pull --rebase origin master
6. 把本地库推送到远程：  
	git push -u origin master
### 添加ssh key
1. 设置git的user name和email：
```
$ git config --global user.name "xuhaiyan"
$ git config --global user.email "haiyan.xu.vip@gmail.com"
```
2. 生成key
- 查看是否已经有了ssh密钥：cd ~/.ssh
如果没有密钥则不会有此文件夹，有则备份删除
- 生存密钥：
`$ ssh-keygen -t rsa -C “haiyan.xu.vip@gmail.com”`
按3个回车，密码为空。
最后得到了两个文件：id_rsa和id_rsa.pub
- 添加密钥到ssh：ssh-add 文件名
需要之前输入密码。
3. 在github上添加ssh密钥，这要添加的是“id_rsa.pub”里面的公钥。
