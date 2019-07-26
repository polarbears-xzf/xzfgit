<link href="../../zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../../index.html)
[上一页](../installguide_index.html)


>	_Created in 2019.07.26 by polarbears_  
>	_Copyright (c) 20xx, CHINA and/or affiliates._  
>	_docname database_version_controlnode_install_guide_  
###	安装数据版本与发布管理控制节点 
>	__脚本目录：zoeDevops\database_version_release__
1.	创建标准目录  
	>	create_standard_dir.sh  
2.	前置条件：运维管理基础组件
3.	控制节点：组件部署
	>	@controlnode_install.sql  
	>	__内容说明__  
	1.	创建用户
		*	运维管理系统模式用户：ZOEDEVOPS
	2.	创建表对象
		*	数据库版本管理操作员信息、数据库版本管理子系统字典、数据库变更数据类型字典、数据库角色字典
		*	数据库变更登记记录、数据库变更数据结构记录、数据库变更字典数据记录、数据库变更关联子系统
		*	产品信息、产品数据库配置、产品项目数据库配置
		*	版本发布记录、数据库变更数据字典配置主表、数据库变更数据字典配置细表
4.	控制节点：产品与项目数据库维护
	1.	添加产品
		*	编辑产品信息表-VER_PRODUCT_INFO
			>	增加“产品ID”:sys_guid  
			>	增加“产品名称”  
	2.	添加产品数据库
		*	前提条件：为需要加入的产品数据库安装“运维管理基础组件”-“数据节点”
		*	编辑产品数据库配置表-VER_PRODUCT_DB_CONFIG
			>	增加“产品ID”：从VER_PRODUCT_INFO  
			>	增加“产品数据库ID”：从DVP_PROJ_DB_BASIC_INFO  




[文档主页](../../index.html)
[上一页](../installguide_index.html)