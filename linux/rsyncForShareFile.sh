#!/bin/bash

ping -c 2 192.168.0.157 1>/dev/null
if [ $? -eq 0 ];then
	echo ------------------------------------------------------ >> /var/log/rsyncForShareFile.log
	echo -e "`date`\tBeging mount." >> /var/log/rsyncForShareFile.log
	mount.cifs //192.168.0.157/Picture /mnt -o username="nuc",password="DIebNf#!",uid="www-data",gid="www-data"
	if [ $?-eq 0 ];then
		echo -e "`date`\tmount remote folder complete." >> /var/log/rsyncForShareFile.log
	else
		echo -e "`date`\tmount remote folder failed. Exit." >> /var/log/rsyncForShareFile.log
		exit 1
	fi

	echo -e "`date`\tBeging rsync.\n" >> /var/log/rsyncForShareFile.log
	rsync  -av /mnt/ /wd1T/nextCloudData/jordan/files >> /var/log/rsyncForShareFile.log
	if [ $?-eq 0 ];then
		echo -e "`date`\tRsync remote folder complete." >> /var/log/rsyncForShareFile.log
	else
		echo -e "`date`\tRsync remote folder failed. Exit." >> /var/log/rsyncForShareFile.log
		exit 1
	fi
	umount /mnt
fi
