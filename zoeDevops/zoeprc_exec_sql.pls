--
CREATE OR REPLACE PROCEDURE zoedevops.zoeprc_exec_sql(iv_sql IN varchar2, on_sql_count OUT number)
 AS
BEGIN
	EXECUTE IMMEDIATE iv_sql;
	on_sql_count := SQL%ROWCOUNT;
		
END zoeprc_exec_sql;
/
