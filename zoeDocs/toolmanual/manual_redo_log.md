<link href="../zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../index.html)


###	修改重做日志的大小
1.	查看日志组
	*	select * from v$logfile;
2.	创建3个新的日志组
	*	SQL> ALTER DATABASE ADD LOGFILE GROUP 4 ('/u01/app/oracle/oradata/orcl/redo04.log') SIZE 500M;
	*	SQL> ALTER DATABASE ADD LOGFILE GROUP 5 ('/u01/app/oracle/oradata/orcl/redo05.log') SIZE 500M;
	*	SQL> ALTER DATABASE ADD LOGFILE GROUP 6 ('/u01/app/oracle/oradata/orcl/redo06.log') SIZE 500M;
3.	切换当前日志到新的日志组
	*	SQL> alter system switch logfile;
4.	查看日志的状态
	*	SQL> select group#,sequence#,bytes,members,status from v$log;
5.	将要删除的日志的状态切换为INACTIVE
	*	SQL> alter system switch logfile;
	*	SQL> alter system archive log current;
	*	SQL> alter system checkpoint;
6.	查看日志的状态
	*	SQL> select group#,sequence#,bytes,members,status from v$log;
7.	删除旧的日志组
	*	SQL> alter database drop logfile group 1;
	*	SQL> alter database drop logfile group 2;
	*	SQL> alter database drop logfile group 3;
8.	查看是否删除了日志组
	*	SQL> select group#,sequence#,bytes,members,status from v$log;
9.	操作系统删除原日志组1、2、3中的文件
10.	重建日志组1、2、3
	*	SQL> ALTER DATABASE ADD LOGFILE GROUP 1 ('/u01/app/oracle/oradata/orcl/redo01.log') SIZE 500M;
	*	SQL> ALTER DATABASE ADD LOGFILE GROUP 2 ('/u01/app/oracle/oradata/orcl/redo02.log') SIZE 500M;
	*	SQL> ALTER DATABASE ADD LOGFILE GROUP 3 ('/u01/app/oracle/oradata/orcl/redo03.log') SIZE 500M;
11.	重复步骤3-6，然后删除日志组4、5、6，并在操作系统删除对应的日志文件

	
[文档主页](../index.html)