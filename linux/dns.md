## 重启失效解决
linxu中网络管理软件networking和NetworkManager似乎冲突。
/etc/resolv.conf文件被建立未一个链接指向/var/run/NetworkManager/resolv.conf,但没有这个文件，添加了后重启一回消失，此文件应该是在内存中。
方法是删除此链接文件，重新创建resolv.conf。
