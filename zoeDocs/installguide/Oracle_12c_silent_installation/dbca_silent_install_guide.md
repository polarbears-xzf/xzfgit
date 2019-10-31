<link href="../../zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../../../index.html)
[上一页](../Oracle_12c_silent_installation_index.html)


###	静默创建数据库实例 

1.	编辑静默安装参数文件
	>	vim /home/oracle/database/response/dbca.rsp
		[参数文件](./dbca.rsp)
	>
2.	静默创建数据库实例
	>	
		dbca -silent -createDatabase  -responseFile /home/oracle/database/response/dbca.rsp
3.	参数文件参数解释
	>	
		responseFileVersion=/oracle/assistants/rspfmt_dbca_response_schema_v12.2.0	//系统生成值,勿修改
		gdbName=zoecdb                    //32行,CDB名
		sid=cdb1                      //42行,SID
		databaseConfigType=SI                  //52行,单节点数据库行,RAC环境下参数设置为RAC
		policyManaged=false                //74行,设置管理员管理;ture为策略管理
		createServerPool=false                 //88行,设置服务器池
		force=false                    //127行,服务器池相关
		createAsContainerDatabase=true           //163行,是否创建为CDB
		numberOfPDBs=1                   //172行,创建PDB数量
		pdbName=zoemdb                  //182行,创建PDB名称
		useLocalUndoForPDBs=true  		//192行,本地UNDO设置
		templateName=/u01/app/oracle/product/12.2.0.1/db_1/assistants/dbca/templates/General_Purpose.dbc       //223行,模板名称
		sysPassword=oracle			//233行,sys用户密码
		systemPassword=oracle		//243行,system用户密码
		emExpressPort=5500                 //273,默认存在,未开启EM参数
		runCVUChecks=false                 //284行,是否验证集群检查
		omsPort=0                     //313
		dvConfiguration=false               //341
		olsConfiguration=false               //391
		datafileJarLocation={ORACLE_HOME}/assistants/dbca/templates/           //401行,数据文件Jar目录
		datafileDestination={ORACLE_BASE}/oradata/{DB_UNIQUE_NAME}/           //411行,数据文件目录
		recoveryAreaDestination={ORACLE_BASE}/fast_recovery_area/{DB_UNIQUE_NAME}    //421行,闪回目录
		storageType=FS                                         //431行,存储类型,集群设置为ASM
		characterSet=AL32UTF8                                        //468行,字符集,创建库之后不可更改
		nationalCharacterSet=AL16UTF16                        //478行,国家字符集
		registerWithDirService=false                             //488行,注册目录服务
		listeners=LISTENER                                            //526行,数据库监听	
		variables=DB_UNIQUE_NAME=zoecdb,ORACLE_BASE=/u01/app/oracle,PDB_NAME=zoemdb,DB_NAME=zoecdb,ORACLE_HOME=/u01/app/oracle/product/12.2.0
		/db_1,SID=zoecdb          //546	
		initParams=undo_tablespace=UNDOTBS1,processes=3000,db_block_size=8192BYTES,diagnostic_dest={ORACLE_BASE},audit_file_dest={ORACLE_BASE
		}/admin/{DB_UNIQUE_NAME}/adump,nls_territory=AMERICA,control_files=("/data/oradata/{DB_UNIQUE_NAME}/control01.ctl","/data/fast_recove
		ry_area/{DB_UNIQUE_NAME}/control02.ctl"),db_name=zoecdb,audit_trail=db,remote_login_passwordfile=EXCLUSIVE,open_cur
		sors=300,memory_target=10G,db_recovery_file_dest_size=2780MB                  //555行,参数文件设置
		sampleSchema=false                //565行,是否添加示例schema
		memoryPercentage=60                //574行,物理内存百分比
		databaseType=MULTIPURPOSE                  //584行,数据库类型
		automaticMemoryManagement=false          //594行,是否内存自动管理
		totalMemory=0                   //604行,总内存
				
		
[文档主页](../../../index.html)
[上一页](../Oracle_12c_silent_installation_index.html)
