-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		文件名
--	Description:
-- 		基本说明
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述

SET SERVEROUTPUT ON
SET ECHO OFF  
SET VERI OFF
SET FEEDBACK OFF
SET TERMOUT ON
SET HEADING OFF 
   
set pagesize 0
set linesize 121

define porjectName="厦门市卫计委"
define porjectCode="xmswjw"
define reportType="awr"
define checkupSystem="his"
define scriptPath="c:\zoedir\scripts\"
-- "
define reportPath="c:\zoedir\orarpt\"
-- "
column report_time NEW_VALUE reportTime noprint
select to_char(sysdate,'yyyymmdd') as "report_time" from dual;


variable ln_dbid           NUMBER;
variable ln_inst_number    NUMBER;
variable ln_begin_snap_id  NUMBER;
variable ln_end_snap_id    NUMBER;
variable ln_snap_days      NUMBER;
variable lv_db_name        VARCHAR2(64);
BEGIN
	DBMS_OUTPUT.PUT_LINE('Enter Days: ');
END;
/
BEGIN	
	:ln_snap_days := &days;
END;
/


SELECT SNAP_ID, STARTUP_TIME+0, BEGIN_INTERVAL_TIME+0 , END_INTERVAL_TIME+0 
FROM DBA_HIST_SNAPSHOT
WHERE BEGIN_INTERVAL_TIME > SYSDATE - :ln_snap_days 
ORDER BY SNAP_ID;

BEGIN
	DBMS_OUTPUT.PUT_LINE('Enter begin snap id: ');
END;
/
BEGIN	
	:ln_begin_snap_id := &begin_snap_id;
	:lv_db_name := SYS_CONTEXT('USERENV','DB_NAME');
	select dbid,instance_number into :ln_dbid, :ln_inst_number from DBA_HIST_SNAPSHOT where snap_id = :ln_begin_snap_id;
END;
/
BEGIN
	DBMS_OUTPUT.PUT_LINE('Enter end snap id: ');
END;
/
BEGIN	
	:ln_end_snap_id := &end_snap_id;
END;
/


SET TERMOUT OFF;  
SPOOL &reportPath.&reportType._&checkupSystem._&porjectCode._&lv_db_name._&ln_begin_snap_id._&ln_end_snap_id..html
	SELECT output FROM TABLE (DBMS_WORKLOAD_REPOSITORY.awr_report_html(:ln_dbid,:ln_inst_number,:ln_begin_snap_id,:ln_end_snap_id));
SPOOL OFF

undefine porjectName
undefine porjectCode
undefine reportType
undefine checkupSystem
undefine scriptPath
undefine reportPath

SET TERMOUT ON;
CLEAR COLUMNS SQL;  
TTITLE OFF;  
BTITLE OFF;  
REPFOOTER OFF;  

