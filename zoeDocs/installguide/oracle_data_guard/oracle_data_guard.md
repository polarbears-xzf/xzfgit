# 基于rac-rac的dataguard搭建步骤  #  
  
##  一、数据库环境配置 ##
| - | primary | standby |
| :----| :------ | :------ |
| **操作系统** | Oracle Enterprise Linux 6.7 x86_64 | Oracle Enterprise Linux 6.7 x86_64 |
| **是否RAC** | 是 | 是 |
| **数据库名（db_name,db_unique_name,service_name）** | (zya,zya,zya) | (zya,zyadg,zyadg) |
| **tns网络服务名** | primary | standby |
| **数据库文件路径** | db_create_file_dest='+DATA' | db_create_file_dest='+DATA' |
| **归档路径** | +DATA | USE_DB_RECOVERY_FILE_DEST<br>db_recovery_file_dest=+DATA<br>db_recovery_file_dest_size=10240g |
| **IP地址** | rac1 10.1.100.1<br>rac2 10.1.100.2<br>rac3 10.1.100.3<br>rac4 10.1.100.4<br>scan 10.1.100.201 | dgrac1 10.1.100.13<br>dgrac2 10.1.100.14<br>dgrac3 10.1.100.15<br>dgrac4 10.1.100.16<br>dgscan 10.1.100.204 |

## 二、primary端配置 ##
### 1.设置为归档模式   ###
1. 设置log_archive_dest_1(主节点执行即可）
```  
SQL> alter system set log_archive_dest_1='LOCATION=+DATA' scope=both sid='*';
```
2. 开启数据库归档   
```
srvctl stop database -d zya  
srvctl start database –d zya –o mount  
```
```
SQL> alter database archivelog;  
```
```
srvctl stop database -d zya  
srvctl start database -d zya  
```
3. 开启强制归档  
```
SQL> alter database force logging;  
```

### 2.配置tnsnames ###
- 在Primary数据库的所有节点的tnsnames.ora里面加入以下内容  
```  
primary =  
  (DESCRIPTION =  
    (ADDRESS = (PROTOCOL = TCP)(HOST = rac1)(PORT = 1521))  
    (CONNECT_DATA =  
      (SERVER = DEDICATED)  
      (SERVICE_NAME = zya)  
    )  
  )  
standby =  
  (DESCRIPTION =  
    (ADDRESS_LIST =  
      (ADDRESS = (PROTOCOL = TCP)(HOST = dgrac1)(PORT = 1521))  
    )  
    (CONNECT_DATA =  
      (SERVICE_NAME = zyadg)  
    )  
  )  
```

### 3.创建standby redo log file ###
- 在standby数据库创建standby redo log file不是必需的，但建议创建。
- 在primary数据库创建standby redo log file也不是必需的，但在创建physical standby的时候，可自动创建standby redo logfile;

1. 检查当前联机重做日志的成员和日志大小
```
SQL> select a.thread#,
       a.group#,
       a.status,
       a.bytes / 1024 / 1024 SizeMB,
       b.member
  from v$log a, v$logfile b
 where a.group# = b.group#
 order by group#;
```
2. 按照以下规则添加standby redo log file
- standby redo log file组数＝online redo log file组数+1
- standby redo log file大小与online redo log file一样
```
SQL> ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 group 5 '+DATA' SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 group 6 '+DATA' SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 group 7 '+DATA' SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 group 8 '+DATA' SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 group 9 '+DATA' SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 2 group 10 '+DATA' SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 2 group 11 '+DATA' SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 2 group 12 '+DATA' SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 2 group 13 '+DATA' SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 2 group 14 '+DATA' SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 3 group 15 '+DATA' SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 3 group 16 '+DATA' SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 3 group 17 '+DATA' SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 3 group 18 '+DATA' SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 3 group 19 '+DATA' SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 4 group 20 '+DATA' SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 4 group 21 '+DATA' SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 4 group 22 '+DATA' SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 4 group 23 '+DATA' SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 4 group 24 '+DATA' SIZE 200M;
```
3. 查看添加后的状态
```
SQL> select a.thread#,
       a.group#,
       b.type,
       a.status,
       a.bytes / 1024 / 1024 SizeMB,
       b.member
  from v$standby_log a, v$logfile b
 where a.group# = b.group#
 order by group#;
```

### 4.修改初始化参数 ###
- 12c RAC无法修改db_unique_name,主库无需修改,默认即可;
```
--SQL> alter system set db_unique_name=zya scope=spfile sid='*';
```
- 配置归档路径相关参数
```
SQL> alter system set LOG_ARCHIVE_CONFIG='DG_CONFIG=(zya,zyadg)'  scope=both sid= '*';
SQL> alter system set LOG_ARCHIVE_DEST_1='LOCATION=+DATA VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=zya' scope=both sid='*';
SQL> alter system set LOG_ARCHIVE_DEST_2='SERVICE=standby ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=zyadg' scope=both sid='*';
```
- 配置主库切换为备库时所需参数
```
SQL> alter system set FAL_SERVER=standby scope=both sid='*';
SQL> alter system set STANDBY_FILE_MANAGEMENT=AUTO scope=both sid='*';
```
本次配置使用omf，无需配置DB_FILE_NAME_CONVERT和LOG_FILE_NAME_CONVERT；
否则需要针对datafile，tempfile配置DB_FILE_NAME_CONVERT；
针对logfile配置LOG_FILE_NAME_CONVERT
```
--SQL> alter system set DB_FILE_NAME_CONVERT='/u01/app/oracle/oradata/zya/datafile','+DATA/zya/314B860EEB2B6162E053DE07A8C0DDA7/DATAFILE','/u01/app/oracle/oradata/zya/datafile','+DATA/zya/2FE37D1F857A280DE053DE07A8C0BB2B/DATAFILE','/u01/app/oracle/oradata/zya/datafile','+DATA/zya/DATAFILE','/u01/app/oracle/oradata/zya/datafile','+DATA/zya/FD9AC20F64D244D7E043B6A9E80A2F2F/DATAFILE','/u01/app/oracle/oradata/zya/datafile','+DATA/zya/314B860EEB2B6162E053DE07A8C0DDA7/TEMPFILE','/u01/app/oracle/oradata/zya/datafile','+DATA/zya/2FE37D1F857A280DE053DE07A8C0BB2B/TEMPFILE','/u01/app/oracle/oradata/zya/datafile','+DATA/zya/TEMPFILE','/u01/app/oracle/oradata/zya/datafile','+DATA/zya/FD9AC20F64D244D7E043B6A9E80A2F2F/TEMPFILE' scope=spfile sid='*';
--SQL> alter system set LOG_FILE_NAME_CONVERT='/u01/app/oracle/oradata/ZYA/onlinelog','+DATA/ZYA/ONLINELOG','/u01/app/oracle/fast_recovery_area/ZYA/onlinelog','+DATA/ZYA/ONLINELOG' scope=spfile sid='*';
```

## 三、standby端配置 ##

### 1.数据库环境配置 ###
- 通过dbca搭建名为zyadg（即db_unique_name）的rac空实例,配置sys的密码与主库的sys密码一致

### 2.配置tnsnames ###
- 在Standby数据库的主节点的tnsnames.ora里面加入以下内容  
```  
primary =  
  (DESCRIPTION =  
    (ADDRESS = (PROTOCOL = TCP)(HOST = rac1)(PORT = 1521))  
    (CONNECT_DATA =  
      (SERVER = DEDICATED)  
      (SERVICE_NAME = zya)  
    )  
  )  
standby =  
  (DESCRIPTION =  
    (ADDRESS_LIST =  
      (ADDRESS = (PROTOCOL = TCP)(HOST = dgrac1)(PORT = 1521))  
    )  
    (CONNECT_DATA =  
      (SERVICE_NAME = zyadg)  
    )  
  )  
```

### 4.配置静态监听 ###
- 在Standby数据库的主节点的grid用户下，修改$ORACLE_HOME/network/admin/listener.ora，添加以下内容：
（如果是单机环境，listener.ora在oracle用户下配置）
```
SID_LIST_LISTENER =
 (SID_LIST =
    (SID_DESC =
      (SID_NAME = zya)
      (ORACLE_HOME = /u01/app/oracle/product/12.1.0/db_1)
      (GLOBAL_DBNAME = zya)
    )
  )
```
- 在Standby数据库的主节点的grid用户下重启监听
```
lsnrctl reload
```

### 5.配置初始化参数 ###
#### 1.关闭整个集群实例 ####
在Standby数据库的主节点的grid用户下,执行
```
srvctl stop database -d zyadg -o immediate
```
#### 2.生成pfile文件 ####
```
SQL> create pfile='/home/oracle/pfile.ora' from spfile;
```
#### 3.配置初始化参数 ####
- 对刚刚生成的pfile文件，将db_name修改为zya（与primary一致）
```
*.db_name='zya'
```
- 配置db_unique_name（与primary不同）
```
*.db_unique_name='zyadg'
```
- 配置归档路径相关参数
```
*.log_archive_config='DG_CONFIG=(zya,zyadg)'
*.log_archive_dest_1='LOCATION=USE_DB_RECOVERY_FILE_DEST valid_for=(all_logfiles,all_roles) db_unique_name=zyadg'
*.log_archive_dest_2='SERVICE=zya async valid_for=(online_logfiles,primary_role)  db_unique_name=zya'
*.db_recovery_file_dest='+DATA'
*.db_recovery_file_dest_size=10240g
```
- 配置日志重传及备库自动文件管理参数
```
alter system set FAL_SERVER=primary scope=both sid='*';
alter system set STANDBY_FILE_MANAGEMENT=AUTO scope=both sid='*';
```
本次配置使用omf，无需配置DB_FILE_NAME_CONVERT和LOG_FILE_NAME_CONVERT；
否则需要针对datafile，tempfile配置DB_FILE_NAME_CONVERT；
针对logfile配置LOG_FILE_NAME_CONVERT
```
--*.DB_FILE_NAME_CONVERT='/u01/app/oracle/oradata/zya/datafile','+DATA/zya/314B860EEB2B6162E053DE07A8C0DDA7/DATAFILE','/u01/app/oracle/oradata/zya/datafile','+DATA/zya/2FE37D1F857A280DE053DE07A8C0BB2B/DATAFILE','/u01/app/oracle/oradata/zya/datafile','+DATA/zya/DATAFILE','/u01/app/oracle/oradata/zya/datafile','+DATA/zya/FD9AC20F64D244D7E043B6A9E80A2F2F/DATAFILE','/u01/app/oracle/oradata/zya/datafile','+DATA/zya/314B860EEB2B6162E053DE07A8C0DDA7/TEMPFILE','/u01/app/oracle/oradata/zya/datafile','+DATA/zya/2FE37D1F857A280DE053DE07A8C0BB2B/TEMPFILE','/u01/app/oracle/oradata/zya/datafile','+DATA/zya/TEMPFILE','/u01/app/oracle/oradata/zya/datafile','+DATA/zya/FD9AC20F64D244D7E043B6A9E80A2F2F/TEMPFILE'
--*.LOG_FILE_NAME_CONVERT='/u01/app/oracle/oradata/ZYA/onlinelog','+DATA/ZYA/ONLINELOG','/u01/app/oracle/fast_recovery_area/ZYA/onlinelog','+DATA/ZYA/ONLINELOG'
```

#### 4.重新生成spfile ####
- 因为实例未装载，需指定spfile具体路径，否则spfile文件将生成到+DATA/DB_UNKNOW/PARAMETER/目录下
```
SQL> create spfile='+DATA/zyadg/spfilezyadg.ora' from pfile='/home/oracle/pfile.ora';
```

#### 5.修改crs配置db资源中的信息 ####
- crs中保存的db信息是根据db_unique_name来判断的，如果需要修改db_unique_name，需重建db资源。因为本次是以db_unique_name为名搭建的空实例，所以无需修改db_unique_name

- 查看db资源配置情况(grid执行)
```
srvctl config database -d zyadg
```
- 修改db资源配置中的spfile位置,指向新生成的spfile文件
```
srvctl modify database -d zyadg -p '+DATA/zyadg/spfilezyadg.ora' 
```
- 修复db资源配置中的磁盘组依赖关系，重新配置config中的磁盘组，如果有多个磁盘组，用逗号隔开
```
srvctl modify database -d zyad -a DATA 
```
- 修改db资源配置中的db_name
```
srvctl modify database -d zyad -n zya
```

#### 6.启动主节点实例到nomount ####
```
srvctl start instance -d zyadg -i zyadg1 -o nomount
```

## 四、使用rman duplicate创建Standby数据库 ##
1. 在primary端的主节点的oracle用户下，执行
```
rman target sys/oracle@primary auxiliary sys/oracle@standby
```
2. 开始duplicate操作
```
RMAN> duplicate target database for standby from active database;
```

## 五、启动standby进行同步 ##
1. 启动备库主节点数据库到read noly
在standby端的主节点的oracle用户下，通过sqlplus登录数据库，执行
```
SQL>alter database open;
```
2. Active datagurad（事先创建standby redo）
```
SQL> alter database recover managed standby database using current logfile disconnect from session;
```
若需取消应用
```
--SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
```
3. 确认数据库状态
```
SQL> select name,open_mode from v$database;
```
4. pdb open
```
SQL> alter pluggable database all open;
```
5. 确认pdb状态 
```
SQL>show pdbs
```

## 六、监控及维护 ##
### 1.检查进程状态 ###
```
SQL> select process,status from v$managed_standby;
```


### 2.检查数据库角色状态 ###
```
SQL> select switchover_status,database_role,protection_mode,protection_level from v$database;
```

### 3.查DG是否同步 ###
```
SQL> select a.thread, a.received, b.applied
  from (select thread# thread, max(sequence#) received
          from v$archived_log
         group by thread#) a,
       (select thread# thread, max(sequence#) applied
          from v$log_history
         group by thread#) b
 where a.thread = b.thread
 order by 1;
```
