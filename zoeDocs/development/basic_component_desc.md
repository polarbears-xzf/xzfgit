<link href="../zoe_docs.css" rel="stylesheet" type="text/css" />

[上一页](./devops_index.html)

1.	用户密码加解密
	*	实现功能：对用户密码进行加解密处理
	*	实现方法：Oracle函数
	*	传入参数：用户名/字符串，用户密码/字符串，密钥（16位）
	*	使用示例：
		*	加密用户密码：ZOEDEVOPS.ENCRYPT_USER('username' , 'password', 'crypt_key')
		*	解密用户密码：ZOEDEVOPS.DECRYPT_USER('username' , 'password', 'crypt_key')
2.	安全工具包：ZOEPKG_SECURITY
3.	公用工具包：ZOEPKG_UTILITY
	*	枚举Orale用户，返回嵌套表zoetyp_db_object_list
		>	例：SELECT * FROM TABLE(ZOEDEVOPS.ZOEPKG_UTILITY.GET_ORACLE_USER);
	*	分割字符串，按照长度.返回嵌套表zoetyp_utility_split_strings
    	>	例：SELECT * FROM TABLE(ZOEDEVOPS.ZOEPKG_UTILITY.SPLIT_STRING('charstringsnn',5));
	*	分割字符串，按照指定分割符.返回嵌套表zoetyp_utility_split_strings
    	>	例：SELECT * FROM TABLE(ZOEDEVOPS.ZOEPKG_UTILITY.SPLIT_STRING('char#|strings#|nn','#|'));
4. 基础功能包：ZOEPKG_DEVOPS
    *	获取数据库基本信息，返回嵌套表zoetyp_db_basic_info
    	>	例：SELECT * FROM TABLE(ZOEDEVOPS.ZOEPKG_DEVOPS.GET_DB_BASIC_INFO);
    *	获取数据库基本信息，区分唯一数据库
    	>	例：SELECT ZOEDEVOPS.ZOEPKG_DEVOPS.GET_DB_ID FROM DUAL;
    *	初始化本地数据库基本信息，生成数据库唯一ID
    	>	例：ZOEDEVOPS.ZOEPKG_DEVOPS.INIT_LOCAL_DB_BASIC_INFO
    *	保存数据库管理用户信息
    	>	例：ZOEDEVOPS.ZOEPKG_DEVOPS.SAVE_DB_USER_INFO(ZOEDEVOPS.ZOEPKG_DEVOPS.GET_DB_ID,'username','password');
    *	修改数据库管理用户信息
    	>	例：ZOEDEVOPS.ZOEPKG_DEVOPS.MODIFY_DB_USER_INFO(ZOEDEVOPS.ZOEPKG_DEVOPS.GET_DB_ID,'username','password');


[上一页](./devops_index.html)


