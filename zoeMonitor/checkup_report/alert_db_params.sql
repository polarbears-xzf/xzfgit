-- Created in 2018.10.11 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		alert_db_params.sql
--	Description:
-- 		基本说明
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--

--检查指标
	--processes：
	--memory_target：
	--open_cursors：
	
set markup html off
prompt <br />

DECLARE
--	lv_is_rac  VARCHAR2(3);
--	lv_is_archive VARCHAR2(3);
	PROCESSES number(10);
	MAX_PROCESSES number(10);
	PGA_USED_PCT number(10);
	MEMORY_TARGET number(10);
	
BEGIN
	--是否RAC
/*	select decode(value,'TRUE','是','FALSE','否',value)  INTO lv_is_rac
	from gv$parameter where name = 'cluster_database';
	IF lv_is_rac = '否' THEN 
		DBMS_OUTPUT.PUT_LINE('Oracle RAC 未部署，系统存在高可用性缺陷');
	END IF;
	--是否开启归档
	select decode(log_mode,'ARCHIVELOG','是','否')       INTO lv_is_archive
	from v$database;
	IF lv_is_archive = '否' THEN 
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE(' <td> 紧急：数据库未开启归档模式，存在严重安全隐患</td> ');
		DBMS_OUTPUT.PUT_LINE('</table> ');
	END IF;
*/	

	--判断当前连接数是否超过阈值
	select count(*) into PROCESSES from gv$process;
	select p.VALUE  into MAX_PROCESSES from v$parameter p where p.NAME = 'processes';

	IF (0 < MAX_PROCESSES AND MAX_PROCESSES <= 2500 and PROCESSES > 0.8* MAX_PROCESSES)  THEN
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE('当前连接较接近最大连接数,请关注');
		DBMS_OUTPUT.PUT_LINE('</table> ');
	ELSE IF (0 < MAX_PROCESSES AND MAX_PROCESSES <= 2500 and PROCESSES > 0.85* MAX_PROCESSES) THEN
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE('当前连接接近最大连接数,请注意增加');
		DBMS_OUTPUT.PUT_LINE('</table> ');
	ELSE IF (2500 < MAX_PROCESSES and PROCESSES > 0.9* MAX_PROCESSES) THEN
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE('当前连接超过最大连接数,请注意增加');
		DBMS_OUTPUT.PUT_LINE('</table> ');
	END IF;
	END IF;
	END IF;
	
	select value into MEMORY_TARGET from v$parameter where name = 'memory_target';
	
	select USED/(PGA_TAG+1) into PGA_USED_PCT FROM 
		(select value/1024/1024 USED from v$pgastat where name = 'total PGA allocated'),
		(select value/1024/1024 PGA_TAG from v$parameter t where name = 'pga_aggregate_target');
		
	IF MEMORY_TARGET > 0 THEN
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE(' <td> 当前数据库使用自动内存管理,建议使用手动管理');
		DBMS_OUTPUT.PUT_LINE('</table> ');		
	--问题:自动内存管理的情况
	ELSE IF MEMORY_TARGET = 0 AND PGA_USED_PCT > 2 THEN
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE('<td> 紧急：当前PGA使用率超过200%,请关注内存使用情况');
		DBMS_OUTPUT.PUT_LINE('</table> ');
	END IF;
	END IF;
	
END;
/
