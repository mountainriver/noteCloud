#!/bin/bash

ping -c 2 192.168.0.157
if [ $?==0 ];then
	echo -e "`date`\tBeging mount.\n"
	mount.cifs //192.168.0.157/sharefolder /mnt -o username=xx,password=xx
	if [ $?==0 ];then
		echo -e "`date`\tmount remote folder complete.\n" >> /var/log/rsyncForShareFile.log
	else
		echo -e "`date`\tmount remote folder failed. Exit.\n" >> /var/log/rsyncForShareFile.log
		return 1
	fi

	echo -e "`date`\tBeging rsync.\n"
	rsync  -av /mnt /wd1T/nextCloudData/jordan/files >> /var/log/rsyncForShareFile.log
	if [ $?==0 ];then
		echo -e "`date`\tRsync remote folder complete.\n" >> /var/log/rsyncForShareFile.log
	else
		echo -e "`date`\tRsync remote folder failed. Exit.\n" >> /var/log/rsyncForShareFile.log
		return 1
	fi
fi
