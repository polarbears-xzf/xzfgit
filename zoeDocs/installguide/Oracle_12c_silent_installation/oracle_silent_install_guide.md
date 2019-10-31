<link href="../../zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../../../index.html)
[上一页](../Oracle_12c_silent_installation_index.html)


###	静默安装Oracle数据库软件 

1.	解压数据库软件zip包  
	>
		unzip /home/oracle/linuxx64_12201_database.zip
2.	通过yum安装所需依赖包（root用户）
	>
		yum install binutils compat-libcap1 compat-libstdc++-33 gcc gcc-c++ glibc glibc-devel ksh libaio libaio-devel libgcc libstdc++ libstdc++-devel libXext libXtst libX11 libXau libxcb libXi make h libaio libaio-devel libgcc libstdc++ libstdc++-devel libXex  sysstat  smartmontools
3.	编辑内核参数（root用户）
	>	vim /etc/sysctl.conf
	>
		fs.file-max = 6815744
		kernel.shmmni = 4096
		kernel.shmall = 1073741824
		kernel.shmmax = 4398046511104
		kernel.panic_on_oops = 1
		kernel.sem = 250 32000 100 128
		net.core.rmem_default = 262144
		net.core.rmem_max = 4194304
		net.core.wmem_default = 262144
		net.core.wmem_max = 1048576
		net.ipv4.conf.all.rp_filter = 2
		net.ipv4.conf.default.rp_filter = 2
		fs.aio-max-nr = 1048576
		net.ipv4.ip_local_port_range = 9000 65500
	>
	>	sysctl -p	
4.	编辑配置参数
	>	vim /etc/security/limits.conf
	>
		oracle soft nproc 2047
		oracle hard nproc 16384
		oracle soft nofile 1024
		oracle hard nofile 65536
		oracle soft stack 10240
		oracle hard stack 10240
5.	配置.base_profile(oracle用户)
	>	vim ~/.base_profile
	>
		ORACLE_BASE=/u01/app/oracle
		export ORACLE_BASE
		ORACLE_HOME=/u01/app/oracle/product/12.1.0/db_1
		export ORACLE_HOME
		ORACLE_SID=zoecdb
		export ORACLE_SID
		ORACLE_UNQNAME=zoecdb
		export ORACLE_UNQNAME
6.	创建目录
	>	
		mkdir -p /u01/app/oracle
	 	chown -R oracle:oinstall /u01
	 	chmod -R 775 /u01
	>
7.	编辑静默安装参数文件
	>	vim /home/oracle/database/response/db_install.rsp
		[参数文件](./db_install.rsp)
8.	静默安装Oracle软件(Oracle用户)
	>
		./runInstaller -force -silent -noconfig -responseFile /home/oracle/database/response/db_install.rsp
9.	执行数据库脚本(root用户)
	>
		/u01/app/oracle/oraInventory/orainstRoot.sh  
        /u01/app/oracle/product/12.2.0.1/db_1/root.sh 
10.	参数文件解释
	>	
		oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v12.2.0  //系统生成值,勿修改
		oracle.install.option=INSTALL_DB_SWONLY                     //30行,安装类型,只安装数据库软件
		UNIX_GROUP_NAME=oinstall                                    //35行,INVENTORY目录组名
		INVENTORY_LOCATION=/u01/app/oracle/oraInventory             //42行,INVENTORY目录
		ORACLE_HOME=/u01/app/oracle/product/12.2.0.1/db_1           //46行,Oracle_Home目录
		ORACLE_BASE=/u01/app/oracle                                 //51行,Oracle_Base目录
		oracle.install.db.InstallEdition=EE                         //63行,Oracle软件类型
		oracle.install.db.OSDBA_GROUP=dba                           //80行
		oracle.install.db.OSOPER_GROUP=oper                         //86行 
		oracle.install.db.OSBACKUPDBA_GROUP=dba                     //91行  
		oracle.install.db.OSDGDBA_GROUP=dba                         //96行
		oracle.install.db.OSKMDBA_GROUP=dba                         //101行
		oracle.install.db.OSRACDBA_GROUP=dba                        //106行
	>
		
	
	
[文档主页](../../../index.html)
[上一页](../Oracle_12c_silent_installation_index.html)
