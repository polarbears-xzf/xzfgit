<link href="../../zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../../index.html)
[上一页](../installguide_index.html)


>	_Created in 2019.06.19 by polarbears_  
>	_Copyright (c) 20xx, CHINA and/or affiliates._  
>	_docname datanode_install_guide_  
###	安装运维管理系统控制节点 
>	__脚本目录：zoeDevops\basic_component__	
1.  前置条件：已安装数据节点
2.	控制节点-组件部署
	>	@controlnode_install.sql  
	>	__内容说明__  
	1.	创建表对象
		*	省份字典、数据库部署类型字典
		*	项目基本信息、用户基本信息、项目服务器基本信息、项目合同基本信息
		*	项目远程管理信息、项目服务器管理信息、项目数据库用户管理信息
		*	项目数据节点数据库链路信息
		*	项目合同回款信息
	2.	加载字典数据
3.	控制节点-采集项目数据
	>	@cellect_data\collect_project_data.sql  
	>	__包含表数据__
	*	DVP_PROJ_DB_BASIC_INFO
	*	DVP_PROJ_DB_USER_ADMIN_INFO
	*	DVP_PROJ_SERVER_BASIC_INFO
	*	DVP_PROJ_SERVER_ADMIN_INFO
4.	控制节点-加载项目数据（将数据导回公司运维管理控制节点）
	>	cellect_data\collect_project_data.sh
	
		
[文档主页](../../index.html)
[上一页](../installguide_index.html)
	
