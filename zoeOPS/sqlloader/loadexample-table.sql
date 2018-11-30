-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		loadexample-table.sql
--	Description:
-- 		生成指定表的sqlloader的数据和控制文件用于数据加载
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--
SET SERVEROUTPUT ON 
SET ECHO OFF
SET VERI OFF
SET FEEDBACK OFF
SET TERMOUT OFF

SET LINESIZE 512
SET PAGESIZE 0

ALTER SESSION SET NLS_DATE_FORMAT='yyyy-mm-dd hh24:mi:ss';

DEFINE loadctl_path='c:\zoedir\scripts\'
DEFINE loaddata_path='c:\zoedir\data\'

DEFINE table_owner='ZOEDEVOPS'
DEFINE table_name='DVP_PROJ_DB_BASIC_INFO'

-- 生成加载表DVP_PROJ_DB_BASIC_INFO控制文件
SPOOL &loadctl_path.load&table_name..ctl

DECLARE
  type type_table_column  is table of VARCHAR2(64) index by binary_integer;
  CURSOR lc_table_column is SELECT COLUMN_NAME,DATA_TYPE FROM DBA_TAB_COLUMNS WHERE OWNER='&table_owner' AND TABLE_NAME='&table_name';
  lv_column_name VARCHAR2(64);
  lv_column_datetype VARCHAR2(64);
  ls_column VARCHAR2(4000);
BEGIN
  DBMS_OUTPUT.PUT_LINE('OPTIONS (skip=0,rows=32)');
  DBMS_OUTPUT.PUT_LINE('LOAD DATA');
  DBMS_OUTPUT.PUT_LINE('INFILE ''&loaddata_path.load&table_name..csv''');
  DBMS_OUTPUT.PUT_LINE('APPEND');
  DBMS_OUTPUT.PUT_LINE('INTO TABLE &table_owner..&table_name.');
  DBMS_OUTPUT.PUT_LINE('FIELDS TERMINATED BY '',''');
  DBMS_OUTPUT.PUT_LINE('OPTIONALLY ENCLOSED BY ''"''');
  DBMS_OUTPUT.PUT_LINE('TRAILING NULLCOLS');
  ls_column :='(';
  OPEN lc_table_column;
  FETCH lc_table_column INTO lv_column_name,lv_column_datetype;
  LOOP
	 IF lv_column_datetype = 'DATE' THEN
	 	 ls_column := ls_column||lv_column_name||' DATE ''yyyy-mm-dd hh24:mi:ss''';
	 ELSE 
		 ls_column := ls_column||lv_column_name;
	 END IF;
	 FETCH lc_table_column INTO lv_column_name,lv_column_datetype;
  EXIT WHEN lc_table_column%NOTFOUND;
	 ls_column := ls_column||',';
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(ls_column);
  DBMS_OUTPUT.PUT_LINE(')');
  CLOSE lc_table_column;
END;
/

SPOOL OFF

-- 生成加载表DVP_PROJ_DB_BASIC_INFO数据
VAR  v_column_data  VARCHAR2(4000)
DECLARE
  CURSOR lc_table_column is SELECT COLUMN_NAME FROM DBA_TAB_COLUMNS WHERE OWNER='&table_owner' AND TABLE_NAME='&table_name';
  lv_column_name VARCHAR2(64);
  ls_column VARCHAR2(4000);
BEGIN
  OPEN lc_table_column;
  LOOP
	 FETCH lc_table_column INTO lv_column_name;
     ls_column := ls_column||lv_column_name;
  EXIT WHEN lc_table_column%NOTFOUND;
	 ls_column := ls_column||'||'',''||';
  END LOOP;
  :v_column_data := ls_column;
  CLOSE lc_table_column;
END;
/

COLUMN column_list NEW_VALUE columnlist 
select :v_column_data as "column_list" from dual;

SPOOL &loaddata_path.load&table_name..csv
SELECT &columnlist  FROM &table_owner..&table_name;
SPOOL OFF

UNDEFINE table_owner
UNDEFINE table_name

UNDEFINE loadctl_path
UNDEFINE loaddata_path
