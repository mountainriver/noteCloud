##日常运维
- 扫描所有用户变动
sudo -u www-data php occ files:scan --all
- 列出所有用户
sudo -u www-data php occ user:list	
- 扫描指定用户
sudo -u www-data php occ files:scan ChengYe
- 扫描指定目录
sudo -u www-data php occ files:scan --path="/ChengYe/files/Photos" #指向用户ChengYe的Photos文件夹"
- 解除维护模式
	sudo -u www-data php occ  maintenance:mode --off
- 查看occ帮助
	sudo -u www-data php occ -h
