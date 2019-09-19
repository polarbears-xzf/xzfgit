<link href="../zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../index.html)


###	数据泵的导入导出
>	数据泵使用前的检查
1.	适用范围
	*	Linux系统下RAC集群11g数据库版本的导出导入
2.	导出导入前的检查
	*	数据库版本的检查（目标库版本>=源库版本）
		*	select * from v$version;
	*	字符集类型的检查
		*	select userenv('language') from dual;
	*	数据库使用情况
		*	select 'DB Size/Used/Rate', 
       trunc(sum(a.bytes)/1024/1024/1024,2)||'G/'||trunc((sum(a.bytes)-sum(b.bytes))/1024/1024/1024,2)||'G/'||trunc((1-sum(b.bytes)/sum(a.bytes))*100,2)||'%' 
from dba_data_files a, (select tablespace_name,file_id,sum(bytes) bytes from dba_free_space group by tablespace_name,file_id) b
where a.tablespace_name=b.tablespace_name(+) and a.file_id=b.file_id(+);
	*	查看目标端与源端系统磁盘空间是否充足
	*	源端数据库的表空间使用情况（根据表空间大小，修改获取的创建表空间语句，避免由于表空间不足导致卡住）
>	expdp导出
1.	在导出端建立存放的逻辑目录
	*	select * from dba_directories;
	*	create or replace directory expdpdir as '/home/oracle/expdp';
2.	全库导出
	*	export ORACLE_SID=zyhis1
	*	expdp system/oracle directory=expdpdir dumpfile=hisdata_%U.dmp logfile=expdata.log FULL=Y filesize=16G
3.	获取源库的表空间创建语句
	*	通过语法get_create_tabespace.sql获取create_tabespace.sql，注意修改脚本生成路径
根据源库表空间使用情况，修改create_tabespace.sql语法。
4.	查看导出日志及拷贝
>	impdp导入
1.	在导入端建立存放的逻辑目录
	*	select * from dba_directories;
	*	create or replace directory impdpdir as '/home/oracle/impdp';
2.	查看impdp文件夹所属用户及权限
	*	ls -al /home/oracle/impdp
	*	chown -R oracle:oinstall /home/oracle/impdp
	*	chmod 777 /home/oracle/impdp
3.	创建表空间（执行前，注意修改数据文件的存储路径）
	*	select file_id,file_name,tablespace_name from dba_data_files;
	*	select name from v$tempfile;（通常情况下注释掉create_tabespace.sql中临时表空间的创建语法）
	*	执行create_tabespace.sql脚本
4.	全库导入
	*	export ORACLE_SID=zyhis1
	*	impdp system/oracle directory=impdpdir dumpfile=hisdata_%U.dmp logfile=impdata.log  cluster=N
5.	检查日志，确认导入情况
	
[文档主页](../index.html)