<link href="../../zoe_docs.css" rel="stylesheet" type="text/css" />


[上一页](../fault_running.html)

###	RAC环境DBlink连接报错ORA-24777的处理

1.	环境信息  
	>|应用系统|数据库版本|应用环境|操作系统版本|
	>|:---|:---|:---|:---|
	>|HIS|Oracle 11.2.0.4|Oracle RAC(4节点)|Oracle Linux 6.9|
	>|EMR|Oracle 11.2.0.4|Oracle RAC(4节点)|Oracle Linux 6.9|
	
2.	问题出现场景及解决方案
	1.	EMR有业务需求连接HIS数据库(通过dblink连接数据库)
	2.	HIS及EMR系统由单机环境迁移至Oracle RAC环境(dblink目标端为RAC集群)
	3.	存在分布式事务(XA驱动JDBC调用了存在dblink的分布式事务)
	4.	解决方案:通过配置service的方式,实现解决ORA-24777报错及高可用性的结合。
	*	(srvctl add service -s emrlink -d zzsy -r zzsy1 -a zzsy2,zzsy3,zzsy4)

3.	问题处理过程
	1.	整体过程描述
		*	迁移后环境出现报错ORA-24777 不允许使用不可移植的数据库链路
			1.	将数据库迁移至新环境后,应用测试抛出报错ORA-24777 不允许使用不可移植的数据库链路
			2.	检查语法发现语法中存在EMR连接HIS的dblink链接,dblink的配置IP为HIS的SCAN-IP
			3.	排查发现,当在XA驱动的JDBC下，使用dblink就会出现该报错
			4.	使用shared dblink可以避免出现该报错
			5.	使用shared dblink后出现ORA-01001 invalid cursor的报错
			6.	调整系统参数OPEN_LINKS及OPEN_LINKS_PER_INSTANCE后报错不再出现
			7.	运行一段时间后,抛出报错ORA-02046 分布式事务已经开始
			8.	调整连接HIS数据库的dblink中IP形式从SCAN-IP到配置多个VIP的形式后,不再报错
			9.	运行一段时间后,科室业务反馈病例无法连接,重启组件后恢复正常
			10.	检查发现节点1有大量来自dblink的session持续出现,直至达到process的最大值
			11.	在节点1添加service(名称:emrlink)并启动
			12.	调整DBlink中的server_name参数为emrlink,调整IP为HIS集群的SCAN-IP,同时取消dblink的shared模式
			13.	调整后process数量恢复正常,不再出现以上报错
	
	2.	出现问题分析
		*	ORA-24777 不允许使用不可移植的数据库链路
			*	出现原因:	当使用XA驱动JDBC,调用存在dblink的分布式事务时会出现该报错
						ORA-24777 reported when using a database link from within an XA coordinated transaction (文档 ID 1506756.1)
			*	处理方法:	
						1.	将Oracle服务器设置成shared server;
						2.	将dblink设置成shared dblink;
						3.	在目标RAC集群中添加service,dblink使用该服务名连接;
			*	后续结果:	
						1.	可能造成较大影响,未进行尝试;
						2.	造成后续ORA-01001/ora-02046/产生过多的dblink连接不释放等问题;
						3.	目前使用未发现问题;
		*	ORA-01001 invalid cursor
			*	出现原因:	dblink连接后session未释放,导致达到参数上限无法创建新的连接
			*	处理方法:	
						1.	alter system set open_links=255 scope=spfile;
							alter system set open_links_per_instance=255 scope=spfile;
			*	后续结果:	
						1.	由于连接未释放,造成连接数过多的问题及产生ORA-02046问题
		*	ORA-02046 分布式事务已经开始
			*	出现原因:	大量的dblink连接未释放,当达到process参数的最大值时,抛出该报错
			*	处理方法:	
						1.	释放连接
			*	后续结果:	
						1.	由于连接未释放,造成连接数达到上限而无法连接
4.	最终解决方案
	1.	方案介绍
		*	通过添加service的形式,修改dblink中的server_name为新增的service,不使用shared dblink
		*	service只在单个节点运行,所以即使使用包含dblink的分布式事务也不会产生报错
		*	当service的运行节点出现异常时会自动切换至备选节点,实现高可用性	
	2.	选择理由:使用该方案可以同时满足dblink使用及连接高可用性的需求,且不存在连接不释放的问题
	3.	操作方法:
		1.	连接目标数据库节点一
		2.	切换到oracle用户下进行service添加
			*	su - oracle
			*	srvctl add service -s server_name -d unique_name -r sid1 -a sid2,sid3,sid4
		3.	启动新添加的service
			*	srvctl start service -s server_name -d unique_name
		4.	使用新添加的server_name及目标端scan-ip创建dblink
							
	
[上一页](../fault_running.html)
