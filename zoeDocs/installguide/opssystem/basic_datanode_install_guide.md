<link href="../../zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../../index.html)
[上一页](../installguide_index.html)

>	_Created in 2019.06.19 by polarbears_  
>	_Copyright (c) 20xx, CHINA and/or affiliates._  
>	_docname basic_datanode_install_guide_  
###	安装运维管理系统数据节点 
>	__脚本目录：zoeDevops\basic_component__
1.	创建标准目录  
	>	create_standard_dir.sh  
2.	数据节点-组件部署（以sysdba角色执行）
	>	@datanode_install.sql  
	>	记录zoeagent密码，记录zoedevops密码（部署控制节点时）  
	>	__内容说明__  
	1.	创建运维管理数据存储表空间
		*	运维管理系统对象模式为zoedevops，对应表空间zoedevops_tab
	2.	创建用户  
		*	数据节点需要创建4个用户；  
			*	zoedevops：运维管理系统对象模式用户
			*	zoedba：用于管理员日常运维管理连接用户
			*	zoeagent：用于运维管理控制节点数据库链路连接用户
			*	zoeopsconn：用于运维管理系统连接用户
	3.	创建表对象  
		*	数据节点创建：数据库基本信息表
	4.	创建存储过程相关对象  
		*	创建基础安全相关包
		*	创建类型
		*	创建初始化数据库信息功能包
3.	数据节点-生成数据库基本信息
	*	准备项目ID(控制节点的DVP_PROJ_BASIC_INFO，如部署数据库为控制节点，则自动生成,project_id为空)
		>	EXEC ZOEDEVOPS.ZOEPKG_OPS_DB_INFO.INIT_PROJ_DB_BASIC_INFO(project_id);
4.	控制节点-创建数据库链路
	*	使用zoedevops连接到控制节点数据库
		>	conn zoedevops/password@ip_address/service_name
	*	创建到数据节点数据库的数据库链路
		>	create database link linkname connect to zoeagent identified by zoeagentpassword using 'ip_address/service_name';  
		>	__注：linkname格式为：数据库名+IP后2位+用户名__
	*	配置项目节点连接信息（ZOEDEVOPS.DVP_PROJ_NODE_DB_LINKS）
		>	INSERT INTO ZOEDEVOPS.DVP_PROJ_NODE_DB_LINKS   
		>	(project_id#,db_id#,db_link_name,connect_to_user,CREATOR_CODE,CREATED_TIME)  
		>	select project_id#,db_id,'linkname','ZOEAGENT','xzf',SYSDATE  
		>	from ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO@linkname;  
		>	__注1：linkname 为上一步创建的数据库链路__  
		>	__注2：部署控制节点时，此步骤在控制节点部署完毕后执行__  
		
	*	同步数据节点数据库信息
		>	INSERT INTO ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO  
		>	(PROJECT_ID#,DB_ID,DB_NAME,SERVER_NAME,SERVER_IP_ADDRESS#,DB_CREATED_TIME,DB_VERSION,CREATOR_CODE,CREATED_TIME)  
		>	SELECT PROJECT_ID#,DB_ID,DB_NAME,SERVER_NAME,SERVER_IP_ADDRESS#,DB_CREATED_TIME,DB_VERSION,CREATOR_CODE,CREATED_TIME  
		>	FROM ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO@linkname;  
		>	__注1：linkname 为上一步创建的数据库链路__  
		>	__注2：部署控制节点时，此步骤无需执行__  
	*	编辑数据库基本信息表-ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO
		>	增加“数据库中文名”  
		>	增加“数据库角色ID”  
		>	增加“数据库部署类型ID”  
		>	增加“数据库角色名”  
		>	增加“数据库部署类型名”  
	*	编辑产品项目数据库表-VER_PRODUCT_PROJECT_CFG
		>	增加“产品数据库ID”：从VER_PRODUCT_DB_CONFIG  
		>	增加“项目数据库ID”：从ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO  
		
5.	附
	*	建立临时sys用户，安装后立刻删除
		>	create user zoetmpsys identified by Zoe$tmp123; grant sysdba to zoetmpsys;
	*	检查主机IP地址是否是IPv6，影响生成数据库唯一ID（db_id），获取过程不支持IPv6 
		>	检查是否支持：select utl_inaddr.get_host_address from dual;  
		>	


[文档主页](../../index.html)
[上一页](../installguide_index.html)
