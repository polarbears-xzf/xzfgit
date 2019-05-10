-- Created in 2018.10.11 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		alert_db_space.sql
--	Description:
-- 		基本说明
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--

--检查指标
	--数据库总使用率：  大于95%提醒
	--表空间剩余空间：  小于日均增量*90，增加数据文件
	--日志日增量：      大于日志日均增量3倍，提醒是否存在异常业务
	--日志最小切换时间：  小于3分钟，增加日志大小
	
set markup html off
prompt <br />

DECLARE
	lv_is_rac  VARCHAR2(3);
	lv_is_archive VARCHAR2(3);
BEGIN
	--是否RAC
	select decode(value,'TRUE','是','FALSE','否',value)  INTO lv_is_rac
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
	
END;
/
