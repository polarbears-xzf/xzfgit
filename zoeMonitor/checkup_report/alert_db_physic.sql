-- Created in 2018.10.11 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		alert_db_physic.sql
--	Description:
-- 		基本说明
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--
---检查指标
-	--数据文件数：与控制文件和参数文件中对比，当差值小于5时临界严重警告，当差值小于20时警告
-	--控制文件数：小于2时进行提示处理
	
set markup html off
prompt <br />

--SET SERVEROUTPUT ON
DECLARE
	lv_datafiles  VARCHAR2(16);
	lv_datas	 VARCHAR2(16);
	lv_ctlfiles  VARCHAR2(16);
BEGIN
	--数据文件数：与控制文件和参数文件中对比，当差值小于5时临界严重警告，当差值小于20时警告
	
	select to_char(count(*)) into lv_datafiles from dba_data_files;
	select value into lv_datas from V$parameter t where t.NAME='db_files';
	if lv_datas-lv_datafiles<5 then 
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE('<td>严重警告！当前库最大数据文个数：'||lv_datas||'，当前数据文件个数：'||lv_datafiles||'，请调整最大数据文件个数</td>');
		DBMS_OUTPUT.PUT_LINE('</table> ');
	else if lv_datas-lv_datafiles<20 and lv_datas-lv_datafiles>=5 then
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE('<td>警告！当前库最大数据文个数：'||lv_datas||'，当前数据文件个数：'||lv_datafiles||'，请注意数据文件个数增长</td>');
		DBMS_OUTPUT.PUT_LINE('</table> ');
	end if;
	end if;
	--控制文件数：小于2时提醒
	select count(1) into lv_ctlfiles from v$controlfile;
	if lv_ctlfiles <2 then
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE('<td>严重警告！当前控制文件个数：'||lv_ctlfiles||'，请及时处理进行备份</td>');
		DBMS_OUTPUT.PUT_LINE('</table> ');
	end if;
END; 
/