-- Created in 2018.10.11 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		alert_db_deploy.sql
--	Description:
-- 		基本说明
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--

--检查指标
	--是否RAC：      为"否" 时进行提示处理
	--是否开启归档： 为"否" 时进行提示处理
	--实例及数据库状态
	--是否有offline状态的表空间： 为"否" 时进行提示处理
set markup html off
--SET SERVEROUTPUT ON
DECLARE
	lv_is_rac  VARCHAR2(32);
	lv_is_archive VARCHAR2(32);
	lv_is_offlinetablespace VARCHAR2(3);
	lv_tbsname VARCHAR2(64);
	lv_dbstatus VARCHAR2(512);
BEGIN
	--是否RAC
	select decode(value,'TRUE','是','FALSE','否',value)  INTO lv_is_rac
	from gv$parameter where name = 'cluster_database' and rownum=1;
	IF lv_is_rac = '否' THEN 
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE('<td>Oracle RAC 未部署，系统存在高可用性缺陷</td>');
		DBMS_OUTPUT.PUT_LINE('</table> ');
	END IF;
	--是否开启归档
	select decode(log_mode,'ARCHIVELOG','是','否')       INTO lv_is_archive
	from v$database;
	IF lv_is_archive = '否' THEN 
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE(' <td> 紧急：数据库未开启归档模式，存在严重安全隐患</td>');
		DBMS_OUTPUT.PUT_LINE('</table> ');
	END IF;
	--实例及数据库状态
	select WMSYS.WM_CONCAT('实例：'||instance_name||'；启动于'||startup_time||',实例状态：'||status||',数据库状态：'||database_status||'') into lv_dbstatus from gv$instance;
	    DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE('<td>'||lv_dbstatus||'</td>');
		DBMS_OUTPUT.PUT_LINE('</table> ');
	--是否有offline状态的表空间
	select to_char(COUNT(*)) INTO lv_is_offlinetablespace from dba_tablespaces where status!='ONLINE';
	select WMSYS.WM_CONCAT(tablespace_name) into lv_tbsname from dba_tablespaces where status!='ONLINE';
	IF lv_is_offlinetablespace > 0 THEN 
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE('<td>存在offline状态的表空间，请检查'||lv_tbsname||'表空间</td>');
		DBMS_OUTPUT.PUT_LINE('</table> ');
	END IF;
END; 
/
