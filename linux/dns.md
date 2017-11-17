## 重启失效解决
1. 由于DNS是由networkmanager生成的，首先要设置一下networkmanager。   
	在/etc/NetworkManager/NetworkManager.conf中确保
```
managed=true	//如果是false就要改成true
```
2. 配置/etc/network/interface 增加
```
dns-nameservers 8.8.8.8
```
重启network-manager或则系统就都能自动加载了。
