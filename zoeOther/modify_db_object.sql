--修改大字段回滚段保留
----查看大字段表
	COL COLUMN_NAME FOR A36  
	SELECT COLUMN_NAME, PCTVERSION, RETENTION FROM DBA_LOBS WHERE TABLE_NAME = 'table_name';
----修改大字段回滚段保留时间
	ALTER TABLE owner.table_name MODIFY LOB(column_name)(RETENTION)
	ALTER TABLE owner.table_name MODIFY LOB(column_name)(PCTVERSION 20);
	
