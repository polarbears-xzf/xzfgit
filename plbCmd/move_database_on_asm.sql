1. 移动spfile文件
	shutdown immediate
	cp +oldasm/dbname/spfiledbname.ora  +newasm/dbname/spfiledbname.ora
	srvctl config database -d dbname
	srvctl modify database -d dbname -p +newasm/dbname/spfiledbname.ora
	vi $ORACLE_HOME/dbs/initSID.ora
		spfile='+newasm/dbname/spfiledbname.ora'
2. 移动控制文件
	cp +oldasm/dbname/control01.ctl  +newasm/dbname/control01.ctl
	cp +oldasm/dbname/control02.ctl  +newasm/dbname/control02.ctl
	create pfile='/home/oracle/init.txt' from spfile='+newasm/dbname/spfiledbname.ora'
	vi /home/oracle/init.txt
		control_files='+newdata/dbname/control01.ctl','+newdata/dbname/control02.ctl'
	或 startup nomount 后 alter system set control_files='+newdata/dbname/control01.ctl','+newdata/dbname/control02.ctl' scope=spfile;
3. 移动在线日志文件
	set pagesize 32
	set linesize 140
	startup mount
	select 'cp '||member||' +NEWDATA/dbname'||substr(member,instr(member,'/',-1)) from v$logfile;
	select 'alter database rename file '''||member||''' to ''+NEWDATA/dbname'||substr(member,instr(member,'/',-1))||''';' from v$logfile;
4. 移动数据文件
	set pagesize 0
	set linesize 140
	spool /home/oracle/cp_file.sh
	select 'cp '||name||' +NEWDATA/dbname'||substr(name,instr(name,'/',-1)) from v$datafile;
	spool off
	cat /home/oracle/cp_file.sh | asmcmd
	spool /home/oracle/alter_file.sql
	select 'alter database rename file '''||name||''' to ''+NEWDATA/dbname'||substr(name,instr(name,'/',-1))||''';' from v$datafile;
	spool off
	@/home/oracle/alter_file.sql
5. 移动临时文件
	set linesize 140
	select 'cp '||name||' +NEWDATA/dbname'||substr(name,instr(name,'/',-1)) from v$tempfile;
	select 'alter database rename file '''||name||''' to ''+NEWDATA/dbname'||substr(name,instr(name,'/',-1))||''';' from v$tempfile;
6. 修改归档日志路径
	archive log list
	alter system set log_archive_dest_1='location=+newdata';
7. 打开数据库
	alter database open;

