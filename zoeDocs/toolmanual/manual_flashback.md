<link href="../zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../index.html)


###	闪回技术应用
>	闪回开启
1.	开启闪回必要条件
	*	开启归档
		*	archive log list;
		*	如未开启，在mount状态下执行alter database archivelog;
	*	设置合理的闪回区间
		*	db_recovery_file_dest：指定闪回恢复区的位置
		*	db_recovery_file_dest_size：指定闪回恢复区的可用空间大小
		*	db_flashback_retention_target：指定数据库可以回退的时间，单位为分钟，默认1440分钟(1天),实际取决于闪回区大小
		*	如未设置，使用alter system set XXXX scope=both;语句进行更改
	*	开启闪回
		*	select flashback_on from v$database;
		*	如未开启，在mount状态下执行alter database flashback on;
>	闪回使用
1.	闪回查询：允许用户查询过去某个时间点的数据，用以重构由于意外删除或更改的数据，数据不会变化。
	*	select * from scott.dept as of timestamp sysdate-10/1440;
	*	select * from scott.dept as of timestamp to_timestamp('2017-12-14 16:20:00','yyyy-mm-dd hh24:mi:ss');
	*	select * from scott.dept as of scn 16801523;
2.	闪回表：闪回表就是对表的数据做回退。使用表闪回前，需要允许表启动行迁移(row movement)
	*	条件允许下，闪回表前对表做备份：create table scott.dept_bak as select * from scott.dept;
	*	alter table table_name enable row movement;
	*	flashback table scott.dept to timestamp to_timestamp('2017-12-14 16:20:00','yyyy-mm-dd hh24:mi:ss');
	*	alter table table_name disable row movement;
3.	闪回丢弃：当一个表被drop掉，表会被放入recyclebin回收站，可通过回收站做表的闪回
	*	show parameter recycle
	*	flashback table cube_scope to before drop rename to cube_scope_old
4.	闪回数据库：数据库闪回必须在mount状态下进行，主要是将数据库还原值过去的某个时间点或SCN
	*	由于故障情况下闪回库，最好做个备库进行闪回，以免闪回失败破坏原有故障现场
		*	全库闪回
			*	startup mount
			*	flashback database to timestamp to_timestamp('2017-12-14 14:12:46','yyyy-mm-dd HH24:MI:SS');
			*	alter database open resetlogs;
		*	快照闪回
			*	create restore point test20190603;
			*	startup mount
			*	flashback database to restore point test20190603;
			*	alter database open resetlogs;
			*	drop restore point test20190603;
			
[文档主页](../index.html)