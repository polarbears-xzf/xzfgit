-- ==============================================================================================

CREATE OR REPLACE PROCEDURE ZOEDEVOPS.ZOEPRC_EXEC_SQL(iv_sql IN varchar2, on_sql_count OUT number)
authid current_user	
-- Created in 2019.06.25 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoeprc_exec_sql.sql
--	Description:
-- 		
--  Relation:
--      zoeUtility
--	Notes:
--		
--	修改 - （年-月-日） - 描述
--  

 AS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	EXECUTE IMMEDIATE iv_sql;
	on_sql_count := SQL%ROWCOUNT;
END ZOEPRC_EXEC_SQL;
/
