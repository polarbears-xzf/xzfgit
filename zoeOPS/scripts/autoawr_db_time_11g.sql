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

  
SET TERMOUT OFF;  
SPOOL &scriptPath.autoawr_db_time_exec.sql

DECLARE
	ln_con_dbid       NUMBER;
	ln_dbid           NUMBER;
	ln_inst_number    NUMBER;
	ln_begin_snap_id  NUMBER;
	ln_end_snap_id    NUMBER;
	ln_db_time        NUMBER;
	ln_interval_time  NUMBER;
	ln_double_interval_time NUMBER := 0.1;
	lv_begin_interval_time  VARCHAR2(13);
	lv_end_interval_time    VARCHAR2(2);
	lv_db_name              VARCHAR2(64);
BEGIN
	DBMS_OUTPUT.PUT_LINE('SET SERVEROUTPUT ON');
	DBMS_OUTPUT.PUT_LINE('SET ECHO OFF  ');
	DBMS_OUTPUT.PUT_LINE('SET VERI OFF');
	DBMS_OUTPUT.PUT_LINE('SET FEEDBACK OFF');
	DBMS_OUTPUT.PUT_LINE('SET TERMOUT ON');
	DBMS_OUTPUT.PUT_LINE('SET HEADING OFF ');
	DBMS_OUTPUT.PUT_LINE('set pagesize 0;');
	DBMS_OUTPUT.PUT_LINE('set linesize 121;');
	lv_db_name := sys_context('USERENV','DB_NAME');
	FOR c1 IN (SELECT A.DBID , A.INSTANCE_NUMBER, LEAD(SNAP_ID) OVER (ORDER BY A.DBID,A.SNAP_ID) NEXT_SNAP_ID,
		  SNAP_ID SNAP_ID, LEAD(SYS_TIME_VALUE) OVER (ORDER BY A.DBID,A.SNAP_ID) - SYS_TIME_VALUE SYS_TIME_VALUE
		FROM
		  (SELECT A.DBID, A.INSTANCE_NUMBER, A.SNAP_ID,
			A.STAT_NAME , A.VALUE SYS_TIME_VALUE
		  FROM DBA_HIST_SYS_TIME_MODEL A, DBA_HIST_SNAPSHOT B
		  WHERE A.INSTANCE_NUMBER = B.INSTANCE_NUMBER
			AND A.DBID            = B.DBID
			AND A.SNAP_ID         = B.SNAP_ID
			AND A.STAT_NAME       = 'DB time'
		  ) A)
	LOOP
		ln_dbid          := c1.DBID;
		ln_inst_number   := c1.INSTANCE_NUMBER;
		ln_begin_snap_id := c1.SNAP_ID;
		ln_end_snap_id   := c1.NEXT_SNAP_ID;
		ln_db_time       := c1.SYS_TIME_VALUE;
		ln_db_time       := TRUNC(ln_db_time/1000000);
		SELECT TO_CHAR(BEGIN_INTERVAL_TIME+0, 'yyyymmdd-hh24'), 
			TO_CHAR(END_INTERVAL_TIME+0, 'hh24'),
			trunc(((END_INTERVAL_TIME+0)-(BEGIN_INTERVAL_TIME+0))*24*60*60) 
		INTO lv_begin_interval_time,lv_end_interval_time,ln_interval_time 
		FROM DBA_HIST_SNAPSHOT
		WHERE DBID=ln_dbid AND INSTANCE_NUMBER = ln_inst_number AND SNAP_ID = ln_begin_snap_id;
		IF ln_db_time < ln_interval_time * ln_double_interval_time THEN 
			DBMS_OUTPUT.PUT_LINE('SPOOL c:\zoedir\orarpt\&reportType._&checkupSystem._&porjectCode._'||lv_db_name||'_'||lv_begin_interval_time||'_'||lv_end_interval_time||'.html');
			DBMS_OUTPUT.PUT_LINE('SELECT output FROM TABLE (DBMS_WORKLOAD_REPOSITORY.awr_report_html('||
				ln_dbid||', '||ln_inst_number||', '||ln_begin_snap_id||', '||ln_end_snap_id||'));');
			DBMS_OUTPUT.PUT_LINE('SPOOL OFF');
		END IF;
	END LOOP;
	DBMS_OUTPUT.PUT_LINE('SET TERMOUT ON;  ');
	DBMS_OUTPUT.PUT_LINE('CLEAR COLUMNS SQL;');
	DBMS_OUTPUT.PUT_LINE('TTITLE OFF;  ');
	DBMS_OUTPUT.PUT_LINE('BTITLE OFF;  ');
	DBMS_OUTPUT.PUT_LINE('REPFOOTER OFF;  ');

END;
/


SPOOL OFF;  
SET TERMOUT ON;  
CLEAR COLUMNS SQL;  
TTITLE OFF;  
BTITLE OFF;  
REPFOOTER OFF;  
  
UNDEFINE report_name