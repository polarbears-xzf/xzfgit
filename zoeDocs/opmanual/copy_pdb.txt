<link href="../zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../index.html)


###	Oracle 12C 克隆pdb操作手册
>	Linux平台
1.	在源端创建用户并授权
	*	create user c##zoedba identified by "zoe$worldhello";
	*	GRANT CREATE SESSION, CREATE PLUGGABLE DATABASE TO c##zoedba CONTAINER=ALL;
2.	目标端
	*	创建dblink：create database link pzyycdb50 connect to c##zoedba identified by "zoe$worldhello" using '172.30.8.50/pzyycdb';
	*	查询db_create_file_dest是否为空：如果这个参数是空值，需要克隆pdb时，需要使用file_name_convert进行文件名转换。如果非空或使用OMF进行文件管理，那数据文件自动命名，可省去file_name_convert参数。
	*	在目标端使用dblink传数据：create pluggable database mdbtest from pzyymdb@pzyycdb50 file_name_convert=('pzyymdb','mdbtest');
	*	使用拔插方法创建pdb
		*	在源端克隆pdb：create pluggable database mdbtest from file_name_convert=('pzyymdb','mdbtest');
		*	拔出PDB生成.PDB压缩文件：ALTER PLUGGABLE DATABASE mdbtest UNPLUG INTO '/home/oracle/mdbtest.pdb';
		*	将PDB压缩文件传输至目标端并使用unzip解压
		*	drop源克隆pdb：DROP PLUGGABLE DATABASE pzyymdb2 ;
		*	插入pdb：CREATE PLUGGABLE DATABASE mdbtest USING '/home/oracle/home/oracle/pzyymdb2.xml' 
NOCOPY SOURCE_FILE_NAME_CONVERT=('/oracle/database/PZYYCDB/8CC55AE97D2866C1E05332081EACC7C1/datafile/','/oracle/datatabse/PZYYCDB/mdbtest/datafile/') STORAGE (MAXSIZE 16G);
	*	打开pdb：alter pluggable database mdbtest open;
	*	保持CDB重启后PDB的状态: alter pluggable database all save state;
	




[文档主页](../index.html)