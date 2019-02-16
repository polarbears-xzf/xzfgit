1. ASM Lib相关命令
	初始化配置ASM LISB驱动
		service oracleasm configure
	建立ASM磁盘
		service oracleasm createdisks asm_disk1 /dev/sdb1
	扫描ASM磁盘
		service oracleasm scandisks
	查看ASM磁盘
		service oracleasm listdisks
2. 查看ASM状态SQL语法
	查看磁盘组
		sql>select group_number,name,state,total_mb,free_mb from v$asm_diskgroup
	查看磁盘
		sql>select group_number,disk_number,name,state,path from v$asm_disk
	查看asmcmd当前连接
		sql>select group_number,instance_name,db_name,status from v$asm_client
3. ASM磁盘组管理SQL语法
	创建外部冗余磁盘组
		sql>create diskgroup dg1 external redundancy disk '/dev/oracleasm/disks/dg1_disk1' name dg1_disk1
	创建正常冗余磁盘组
		sql>create diskgroup dg1 normal redundancy failgroup fg1 disk 'ORCL:dg1_disk1' name dg1_disk1
			failgroup fg2 disk 'ORCL:dg2_disk1' name dg2_disk1
	修改磁盘组属性
		 sql>ALTER DISKGROUP data SET ATTRIBUTE 'compatible.rdbms' = '11.1';
	装载磁盘组
		sql>alter diskgroup dg1 mount
	删除磁盘组， ##加include contends会删除包含文件的磁盘组，使用磁盘组的数据库实例必须关闭，所有实例磁盘组在nomount
		sql>drop diskgroup dg1 include contents; 
	删除磁盘组中的磁盘
		sql>alter diskgroup dg1 drop disk disk_name;
	添加磁盘中的磁盘
		sql>alter diskgroup dg1 add disk '';
		sql>alter diskgroup dg1 add failgroup DG1_0001 disk '/dev/rhdisk1' name DG1_0001 force;
	注意：设置asm_power_limit控制rebalance负载
		sql>alter system set asm_power_limit=5;
		sql>alter diskgroup dg1 rebalance power 1;
	
4. ASM文件与目录管理SQL语法
	增加目录
		sql>alter diskgroup DG2 add directory '+DG2/datafile'; 
	重命名目录
		sql>alter diskgroup DG2 rename directory '+DG2/datafile' to '+DG2/dtfile';   
	删除目录
		sql>alter diskgroup DG2 drop directory '+DG2/dtfile'; 
	添加别名
		sql>alter diskgroup DG1 add alias 'users.dbf' for '+DG1/asmdb/datafile/users.263.734885485';
	重命名别名
		sql>alter diskgroup DG1 rename alias 'users.dbf' to 'users01.dbf';
	删除别名
		sql>alter diskgroup DG1 drop alias '+DG1/asmdb/datafile/users01.dbf';
5. ASM相关视图查询
	查询磁盘组
		sql>select name,state,type,total_mb,free_mb,cold_used_mb,usable_file_mb 
        from v$asm_diskgroup;
	查询磁盘
		sql>select group_number gno,name,failgroup fgno,state,total_mb,free_mb,header_status from v$asm_disk;
	查询别名
		sql>select name,group_number,file_number,alias_index,alias_directory,system_created from v$asm_alias; 
	查询磁盘与路径
		sql>select nvl(a.name,b.group_number) group_name,b.disk_number,
			b.mount_status,b.header_status,b.mode_status,b.state,
			b.total_mb,b.path,b.failgroup,b.name,
			b.create_date,b.mount_date
		from v$asm_diskgroup a , v$asm_disk b
		where a.group_number(+) = b.group_number
		order by b.group_number,b.disk_number;
	查看ASM属性
		sql>select b.group_number,a.name group_name,b.name attr_name,b.value 
        from v$asm_diskgroup a, v$asm_attribute b
        where a.group_number = b.group_number
			and name='disk_repair_time'
        order by b.group_number;