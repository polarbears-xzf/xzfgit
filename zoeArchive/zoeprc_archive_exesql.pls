CREATE OR REPLACE PROCEDURE zoearchive.zoeprc_archive_execsql(iv_sql IN varchar2, on_sql_count OUT number)
 AS
-- Created in 2017.10.10 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		存储过程文件名
--	Description:
-- 		基本说明
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--
BEGIN

	EXECUTE IMMEDIATE iv_sql;
	on_sql_count := SQL%ROWCOUNT;

		
END zoeprc_archive_execsql;

