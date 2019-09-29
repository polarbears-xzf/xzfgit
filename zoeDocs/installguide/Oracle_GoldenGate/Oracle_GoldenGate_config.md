<link href="zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../../index.html)
[上一页](../Oracle_GoldenGate_index.html)

>	_Created in 2019.09.29 by xuyinan  
>	_Copyright (c) 20xx, CHINA and/or affiliates._  
###	Oracle_GoldenGate部署  
*	两台虚拟机准备  
	源端虚拟机服务器机器名：xyn-ogg1，ip地址为：192.168.248.133  
	目标虚拟机服务器机器名：xyn-ogg2；ip地址为：192.168.248.136
	两台服务器均安装了Oracle版本12.2.0.1版本以及ogg（版本12.3.0.15）安装路径为：C:\app\oracle\ggs  
	同时创建数据库名称为test
*	创建用户
	1.	在源端数据库创建用户ogguser1，并授于dba的权限（其实可以不需要到dba权限），同时创建表table1  
	2.	在目标端数据库创建用户ogguser2，并授于dba的权限（其实可以不需要到dba权限），同时创建表table1  
		为了区别里面的配置，所以创建两个不同的用户  
		create user OGGUSER2 identified by ORACLE;  
		grant dba to OGGUSER2;  
*	查看数据库状态  
	1.	数据库需要开启归档模式  
		查询语句：select log_mode FROM v$database;  
		NOARCHIVELOG：未开启归档状态  ARCHIVELOG：已开启归档状态  
		如果未开启归档状态，请先开启归档状态  
		sql>shutdown immediate;  
		sql>startup mount;  
		sql>alter database archivelog;  
		sql>alter database open;  
		这个是需要关闭数据库在mount状态下改变的  
	2.	查询补充日志状态  
		查询语句：select supplemental_log_data_min, force_logging from v$database;  
		开启补充日志状态  
		sql>alter database add supplemental log data;  
		sql>alter database force logging;  
		sql>alter system switch logfile;  
	3.	确保redo和archivelog包含supplemental log数据  
		sql>alter system switch logfile;  
*	设置环境变量  
	在源端和目标端配置环境变量  
	变量名：LD_LIBRARY_PATH  
	变量值：C:\app\oracle\product\12.2.0\dbhome_1\lib（ogg的安装目录\lib） 
*	在源端和目标端都创建ogg目录	 
	ggsci->CREATE SUBDIRS  
*	ogg部署  
	1.	配置mgr进程  
		ggsci->edit param mgr打开配置文件  
		PORT 7809  
	2.	在源端配置抽取进程  
		ggsci->edit param exta打开配置文件，内容如下：  
		EXTRACT exta  
		setenv ( NLS_LANG = AMERICAN_AMERICA.ZHS16GBK )  
		setenv (ORACLE_SID = test)  
		USERID ogguser1, PASSWORD ORACLE--用户名为 ogguser1,密码ORACLE  
		EXTTRAIL ./dirdat/lc--配置的路径，C:\app\oracle\ggs\dirdat  
		dynamicresolution  
		table ogguser1.table1;--配置的表，如果全部那就是*  
	3.	在源端配置投递进程  
		ggsci->edit param pmpa打开配置文件，内容如下：  
		extract pmpa  
		setenv ( NLS_LANG = AMERICAN_AMERICA.ZHS16GBK )  
		passthru  
		rmthost 192.168.248.136, mgrport 7809, compress--投递的目录  
		rmttrail ./dirdat/rc--投递的路径  
		dynamicresolution  
		table ogguser1.table1;--投递的表信息  
	4.	目标端配置复制进程  
		ggsci->edit param repla打开配置文件，内容如下  
		replicat rep1a  
		setenv ( NLS_LANG = AMERICAN_AMERICA.ZHS16GBK )  
		setenv (ORACLE_SID = test)  
		userid ogguser2, password ORACLE--用户名为 ogguser1,密码ORACLE  
		reperror default,abend  
		discardfile ./dirrpt/rep1a.dsc,append, megabytes 10  
		map ogguser1.table1,target ogguser2.table1;--前面为源端过来的表，后面为目标端需要复制的表  
	5.	启动停止进程  
		info mgr查看管理进程状态  
		start mgr启动管理进程  
		stop mgr关闭管理进程   
		保证所配置的进程状态位running，则配置成功，可以在源端对table1进行数据增加修改进行测试
*	ogg配置常见问题  
	1.	日志存放路径：  
		C:\app\oracle\ggs\dirrpt  
		C:\app\oracle\ggs\ggserr.txt  
	2.	在启动进程exta的时候，无法启动，  
		报错OGG-02091  Operation not supported because enable_goldengate_replication is not set to true  
		执行语句，把这个参数ENABLE_GOLDENGATE_REPLICATION设置为TRUE  
		ALTER SYSTEM SET ENABLE_GOLDENGATE_REPLICATION = TRUE;   
	3.	如果投递数据日志文件有产生，但是数据没有被复制，那么一般是复制进程有问题  
		（1）查看进程是否正常运行：ggsci->info all  
		（2）查询复制参数文件配置的源端数据跟目标端数据是否正常  
			map ogguser1.table1,target ogguser2.table1;  
			
			
[文档主页](../../index.html)
[上一页](../Oracle_GoldenGate_index.html)
