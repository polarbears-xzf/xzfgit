##磁盘操作命令
####查看磁盘大小
lsdev -Cc disk | awk '{printf($1) "(MB): "}{system("bootinfo -s" $1)}'
getconf DISK_SIZE /dev/hdisk0
####查看存储磁盘基本信息
prtconf | grep Disk | grep -v SAS | sort -k 3


##基本查询
####查看CPU
prtconf | grep Processor
####查看内存
prtconf | grep Memory

