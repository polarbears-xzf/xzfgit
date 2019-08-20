
alter system set log_archive_dest_1='LOCATION=+FRA';
alter system set cluster_database=false scope=spfile;
shutdown immediate
startup mount
alter database archivelog
alter system set cluster_database=true scope=spfile;
shutdown immediate
startup

tnsname.ora配置文件
sqdyyy =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 172.18.20.104)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = sqdyyy)
    )
  )
sqdyyydg =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 172.18.20.84)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = sqdyyydg)
    )
  )
sqsyyemr =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 172.18.20.104)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = sqsyyemr)
    )
  )
sqsyyemrdg =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = 172.18.20.84)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = sqsyyemrdg)
    )
  )
  
  
SID_LIST_LISTENER =
	(SID_LIST =
		(SID_DESC =
			(GLOBAL_DBNAME = sqsqhis)
			(ORACLE_HOME = /home/app/oracle/product/11.2.0/db_1/)
			(SID_NAME = sqdyyy)
		)
		(SID_DESC =
			(GLOBAL_DBNAME = sqsqemr)
			(ORACLE_HOME = /home/app/oracle/product/11.2.0/db_1/)
			(SID_NAME = sqsyyemr)
		)
	)
 

ALTER SYSTEM SET LOG_ARCHIVE_CONFIG='DG_CONFIG=(sqsyhis,sqdyyydg)';
ALTER SYSTEM SET LOG_ARCHIVE_DEST_1=
 'LOCATION=+HISFRA 
  VALID_FOR=(ALL_LOGFILES,ALL_ROLES)
  DB_UNIQUE_NAME=sqsyhis';
ALTER SYSTEM SET LOG_ARCHIVE_DEST_2=
 'SERVICE=sqdyyydg ASYNC
  VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) 
  DB_UNIQUE_NAME=sqdyyydg';
ALTER SYSTEM SET FAL_SERVER=sqdyyydg;
ALTER SYSTEM SET STANDBY_FILE_MANAGEMENT=AUTO;

ALTER SYSTEM SET LOG_ARCHIVE_CONFIG='DG_CONFIG=(sqsyemr,sqsyyemrdg)';
ALTER SYSTEM SET LOG_ARCHIVE_DEST_1=
 'LOCATION=+EMRFRA 
  VALID_FOR=(ALL_LOGFILES,ALL_ROLES)
  DB_UNIQUE_NAME=sqsyemr';
ALTER SYSTEM SET LOG_ARCHIVE_DEST_2=
 'SERVICE=sqsyyemrdg ASYNC
  VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) 
  DB_UNIQUE_NAME=sqsyyemrdg';
ALTER SYSTEM SET FAL_SERVER=sqsyyemrdg;
ALTER SYSTEM SET STANDBY_FILE_MANAGEMENT=AUTO;

ALTER DATABASE ADD STANDBY LOGFILE SIZE 500M;
ALTER DATABASE ADD STANDBY LOGFILE SIZE 500M;
ALTER DATABASE ADD STANDBY LOGFILE SIZE 500M;
ALTER DATABASE ADD STANDBY LOGFILE SIZE 500M;


  

create pfile='/home/oracle/inithis.txt' from spfile;
pga_aggregate_target=4G
sga_target=20G
processes=3000
compatible=11.2.0.4
DB_NAME=sqsyhis
DB_UNIQUE_NAME=sqdyyydg
LOG_ARCHIVE_CONFIG='DG_CONFIG=(sqsyhis,sqdyyydg)'
CONTROL_FILES='/oradata/database/sqdyyy/control1.ctl', '/oradata/database/sqdyyy/control2.ctl'
DB_FILE_NAME_CONVERT='+HISDATA/sqsyhis/','/oradata/database/sqdyyy/'
LOG_FILE_NAME_CONVERT='+HISDATA/sqsyhis/onlinelog/','/oradata/database/sqdyyy/','+HISFRA/sqsyhis/onlinelog/','/oradata/database/sqdyyy/'
LOG_ARCHIVE_FORMAT=log%t_%s_%r.arc
LOG_ARCHIVE_DEST_1=
 'LOCATION=
  VALID_FOR=(ALL_LOGFILES,ALL_ROLES) 
  DB_UNIQUE_NAME=sqdyyydg'
LOG_ARCHIVE_DEST_2=
 'SERVICE=sqdyyy ASYNC
  VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) 
  DB_UNIQUE_NAME=sqsyhis'
REMOTE_LOGIN_PASSWORDFILE=EXCLUSIVE
STANDBY_FILE_MANAGEMENT=AUTO
FAL_SERVER=sqdyyy

create pfile='/home/oracle/initemr.txt' from spfile;
pga_aggregate_target=4G
sga_target=20G
processes=3000
DB_NAME=sqsyemr
DB_UNIQUE_NAME=sqsyyemrdg
LOG_ARCHIVE_CONFIG='DG_CONFIG=(sqsyemr,sqsyyemrdg)'
CONTROL_FILES='/oradata/database/sqsyyemr/control1.ctl', '/oradata/database/sqsyyemr/control2.ctl'
DB_FILE_NAME_CONVERT='+EMRDATA/sqsyemr/','/oradata/database/sqsyyemr/'
LOG_FILE_NAME_CONVERT='+EMRDATA/sqsyemr/onlinelog/','/oradata/database/sqsyyemr/','+EMRFRA/sqsyemr/onlinelog/','/oradata/database/sqsyyemr/'
LOG_ARCHIVE_FORMAT=log%t_%s_%r.arc
LOG_ARCHIVE_DEST_1=
 'LOCATION=
  VALID_FOR=(ALL_LOGFILES,ALL_ROLES) 
  DB_UNIQUE_NAME=sqsyyemrdg'
LOG_ARCHIVE_DEST_2=
 'SERVICE=sqsyyemr ASYNC
  VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) 
  DB_UNIQUE_NAME=sqsyemr'
REMOTE_LOGIN_PASSWORDFILE=EXCLUSIVE
STANDBY_FILE_MANAGEMENT=AUTO
FAL_SERVER=sqsyyemr

rman target sys/sqsy2019hisha@172.18.20.87/sqsyhis auxiliary sys/sqsy2019hisha@sqdyyydg
duplicate target database for standby from active database dorecover;

rman target sys/sqsy2019emrha@172.18.20.87/sqsyemr auxiliary sys/sqsy2019emrha@sqdyyydg
duplicate target database for standby from active database dorecover;

select database_role,protection_mode,protection_level,switchover_status from v$database;
ALTER DATABASE SET STANDBY DATABASE TO MAXIMIZE AVAILABILITY;


