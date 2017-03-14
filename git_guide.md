### 上传新建的本地库到git:
1. 在新建的文件夹：  
	git init
2. 把文件夹内所有文件添加到暂存区：  
	git add .
3. 提交：  
	git commit -m 'xxx'
4. 添加远程库：  
	git remote add origin 远程库地址
5. 获取远程库，于本地库合并（如果远程库不为空，必须作这步）：  
	git pull --rebase origin master
6. 把本地库推送到远程：  
	git push -u origin master

