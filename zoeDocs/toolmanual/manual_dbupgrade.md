<link href="../zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../index.html)


###	Oracle 12c/18c PDB升级
>	适用范围
*	12c PDB升级至18c PDB
>	注意事项
*	RAC集群环境下每个节点需要依次升级
*	使用dbupgrade工具时使用小写 -c 参数(小写为包含，大写为排除；参数互斥)
*	使用时Linux操作系统使用单引号，Windows系统使用双引号
*	多个PDB并行升级时用空格隔开
*	字符集类型一致
>	操作步骤
1.	源端创建用户及授权
	*	create user USERNAME identified by "PASSWORD";	
	*	grant create session, create pluggable database to USERNAME container=all;
2.	配置TNSNAME
3.	创建DBLINK
	*	create database link DBLINK_NAME connect to USERNAME identified by "PASSWORD" using 'TNSNAME';
4.	从12c版本库克隆PDB至18c版本库
	*	create pluggable database PDB_TARGET from PDB_SOURCE@DBLINK_NAME;
5.	打开PDB至升级状态
	*	alter pluggable database PDB_TARGET open upgrade;
6.	使用dbupgrade工具对PDB进行升级
	*	$ORACLE_HOME/bin/dbupgrade -c 'PDB_TARGET'
7.	升级完成后打开数据库
	*	alter pluggable database PDB_TARGET open;
	
[文档主页](../index.html)