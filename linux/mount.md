1. 挂载windows共享文件夹(设定用户/组/权限)
mount.cifs -o username="Administrator",password="PasswordForWindows",Mysa,gid=Mysa,dir_mode=0777 //16.187.190.50/test /mnt/
