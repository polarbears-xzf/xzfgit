<link href="../zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../index.html)


###	Oracle RAC 存储CDP容灾切换测试
>	Linux平台
1.	切换挂载容灾存储（如：EMC的RPA）
2.	Linux操作系统重新扫描磁盘
	*	获取重新扫描磁盘的语句
		>	\#  ls /sys/class/scsi_host/ | awk '{print "echo \"- - -\" > /sys/class/scsi_host/" $1 "/scan"}'
	*	执行获取语句重新扫描磁盘
3.	使用oracleasm命令重新扫描asm磁盘
	*	扫描asm磁盘
		>	\#  /usr/sbin/oracleasm scandisks
	*	查看asm磁盘
		>	\#  /usr/sbin/oracleasm listdisks
4.	使用asmcmd挂载asm磁盘组
	*	登录grid用户
		>	\#  su - grid
	*	运行asmcmd
		>	grid$	asmcmd
	*	查看asmcmd磁盘组
		>	asmcmd>	lsdg --disrecovery
	*	挂载磁盘组
		>	asmcmd>	mount data
		>	asmcmd>	mount fra
	*	检查磁盘组状态
		>	asmcmd>	lsdg
5.	启动数据库
	*	检查集群与数据库启动状态
		>	crsctl stat res -t
	*	启动数据库
		>	srvctl start database -d _db_uniq_name_
	*	检查数据库启动状态
		>	srvctl status database -d dyyy
6.	切换IP地址
	*	执行switch_vip_to_ _ipaddress_脚本切换vip
		>	\#   ./switch_vip_to_xxx.sh




[文档主页](../index.html)