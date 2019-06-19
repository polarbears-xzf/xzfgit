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

--检查指标
	--数据文件数：与控制文件和参数文件中对比，当差值小于10时临界严重警告，当差值小于50时警告
	--控制文件数：小于2时进行提示处理
	
set markup html off
--prompt <br />

/* DECLARE
	lv_is_rac  VARCHAR2(3);
	lv_is_archive VARCHAR2(3); */
DECLARE
    DB_FILE_DIFF number(5);
    CON_FILES number(5);
	   
	   
BEGIN

-- 查询数据文件剩余可用量；
select (max_db_files - db_files) difference into DB_FILE_DIFF
   from (select value max_db_files from v$parameter where NAME = 'db_files'),
        (select count(*) db_files from v$datafile);
		 
-- 查询控制文件数量
select type into CON_FILES from v$parameter where NAME = 'control_files';

--判断数据文件剩余可用量值范围   
	if DB_FILE_DIFF >= 10 and  DB_FILE_DIFF < 30 then
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE('<td> 注意:最大数据文件剩余可用数量='|| DB_FILE_DIFF ||',少于30个,请注意添加');
		DBMS_OUTPUT.PUT_LINE('</table> ');
	else if  DB_FILE_DIFF < 10 and DB_FILE_DIFF >= 0 then
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE('<td> 告警:最大数据文件剩余可用数量='|| DB_FILE_DIFF ||',少于10个,请立即添加');
		DBMS_OUTPUT.PUT_LINE('</table> ');
	else 
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE('<td> 数据文件剩余可用数量:'|| DB_FILE_DIFF);
		DBMS_OUTPUT.PUT_LINE('</table> ');
		end if;
	end if;

--判断控制文件数量
	if con_files < 2 and con_files >=0 then
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
        DBMS_OUTPUT.PUT_LINE('<td> 控制文件数量少于2个,请立即增加控制文件');
		DBMS_OUTPUT.PUT_LINE('</table> ');
    else
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
        DBMS_OUTPUT.PUT_LINE('<td> 控制文件数量:'|| CON_FILES );
		DBMS_OUTPUT.PUT_LINE('</table> ');
    end if;

			   
END;
/

