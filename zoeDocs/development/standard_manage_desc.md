<link href="../zoe_docs.css" rel="stylesheet" type="text/css" />


[上一页](./devops_index.html)

###	数据库标准管理
>	__功能说明__  
1.	数据库元数据同步
	*	实现功能：目标数据库对象元数据完全同步数据库到标准管理库
	*	实现方法：Oracle存储过程
	*	传入参数：数据库唯一标识，强制同步标识“YES”
	*	使用示例：
		*	ZOEDEVOPS.ZOEPKG_METADATA_SYNC.INTI_SYNC_ALL('db_id')
	*	实现功能：目标数据库对象元数据完全同步数据库到标准管理库
	*	实现方法：Oracle存储过程
	*	传入参数：数据库唯一标识
	*	使用示例：
		*	ZOEDEVOPS.ZOEPKG_METADATA_SYNC.INCREMENT_SYNC_ALL('db_id')
		
[上一页](./devops_index.html)
