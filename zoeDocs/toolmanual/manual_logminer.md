<link href="../zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../index.html)


###	logminer使用手册
####	定义
*	logminer包括2个包：DBMS_LOGMNR和DBMS_LOGMNR_D，可以分析redo  log  file，也可以分析归档后的archive log file
####	安装
*	创建DBMS_LOGMNR：
	*	SQL> @$ORACLE_HOME/rdbms/admin/dbmslm.sql
*	创建DBMS_LOGMNR_D
	*	SQL> @$ORACLE_HOME/rdbms/admin/dbmslmd.sql
####	日志挖掘前的检查
*	查看存档模式和补充日志状态是否开启
	*	select log_mode, supplemental_log_data_min from v$database;
*	启用补充日志(必须开启)：不启用不影响整个过程，但最终查询时部分操作（像插入，删除，会报"Unsupported"错误）分析不出来
	*	启用补充日志命令：alter database add supplemental log data;
	*	删除补充日志命令：alter database drop supplemental log data;	
####	plsql上logminer归档日志挖掘步骤
1.	查询归档文件：
*	select sequence#,name,first_time,completion_time from v$archived_log;
2.	指定要分析的日志文件(在指定第一个日志文件时，必须用选项"DBMS_LOGMNR.NEW"，后边再添加就用 dbms_logmnr.addfile)
*	exec DBMS_LOGMNR.ADD_LOGFILE('+EMRARCH/zemr/archivelog/2018_08_23/thread_2_seq_72154.5860.984951611', dbms_logmnr.NEW); 
*	exec DBMS_LOGMNR.ADD_LOGFILE('+EMRARCH/zemr/archivelog/2018_08_23/thread_2_seq_72155.5859.984952123', dbms_logmnr.addfile);
3.	启动logminer
*	exec DBMS_LOGMNR.START_LOGMNR(OPTIONS =>SYS.DBMS_LOGMNR.DICT_FROM_ONLINE_CATALOG); 
4.	将V$LOGMNR_CONTENTS保存在表logmnr_contents
*	create table logmnr_contents as select * from v$logmnr_contents;
5.	结束logminer(使用DBMS_LOGMNR.END_LOGMNR结束整个操作，释放资源。不然要等到会话结束才会释放)
*	exec dbms_logmnr.end_logmnr;
*	归档日志挖掘结束后，将创建的表logmnr_contents删除，节省空间

	
[文档主页](../index.html)