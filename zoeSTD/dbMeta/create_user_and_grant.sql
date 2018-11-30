-- Created in 2017.10.10 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoesql_create_user.sql
--	Description:
-- 		创建智业安全系统数据库用户
--  Relation:
--      
--	Notes:
--		
--	修改 - （年-月-日） - 描述

SET SERVEROUTPUT ON SIZE 1000000
-- ===================================================
-- 创建表空间: ZOESTD_TAB 
--
   --不支持裸设备，仅支持文件系统                                             
-- ===================================================
DECLARE
  lv_name             VARCHAR2(512);
  lv_dir              VARCHAR2(512);
  lv_sql              VARCHAR2(4000);
  lv_sysfile_name     VARCHAR2(513);
  lv_tablespace_name  VARCHAR2(64);
BEGIN
  lv_tablespace_name := 'ZOESYSMAN_TAB';
  SELECT file_name INTO lv_sysfile_name FROM dba_data_files where tablespace_name = 'SYSTEM' AND ROWNUM=1;
  IF SUBSTR(lv_sysfile_name,1,1) = '+' or SUBSTR(lv_sysfile_name,1,1) = '/' THEN
    SELECT file_name      
    INTO lv_name
    FROM dba_data_files
    WHERE tablespace_name='SYSTEM' and rownum = 1;
    lv_dir              := SUBSTR(lv_name,1,instr(lv_name,'/',-1));
    lv_sql              := 'CREATE TABLESPACE '||lv_tablespace_name||' ';
    lv_sql              := lv_sql||'LOGGING ' ;
    lv_sql              := lv_sql||'DATAFILE '''||lv_dir||lv_tablespace_name||'01.ora'' SIZE 10M REUSE ';
    lv_sql              := lv_sql||'AUTOEXTEND ON NEXT 10M MAXSIZE 16000M ';
    lv_sql              := lv_sql||'EXTENT MANAGEMENT LOCAL';
    EXECUTE immediate lv_sql;
    --dbms_output.put_line(lv_sql);
  ELSE
    SELECT file_name      
    INTO lv_name
    FROM dba_data_files
    WHERE tablespace_name='SYSTEM' and rownum = 1;
    lv_dir              := SUBSTR(lv_name,1,instr(lv_name,'\',-1));
    lv_sql              := 'CREATE TABLESPACE '||lv_tablespace_name||' ';
    lv_sql              := lv_sql||'LOGGING ' ;
    lv_sql              := lv_sql||'DATAFILE '''||lv_dir||lv_tablespace_name||'01.ora'' SIZE 10M REUSE ';
    lv_sql              := lv_sql||'AUTOEXTEND ON NEXT 10M MAXSIZE 16000M ';
    lv_sql              := lv_sql||'EXTENT MANAGEMENT LOCAL';
    EXECUTE immediate lv_sql;
    --dbms_output.put_line(lv_sql);
  END IF;
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  dbms_output.put_line(SQLCODE||'--'||sqlerrm);
END;
/

--创建用户
CREATE USER ZOESTD IDENTIFIED BY "ZOE$2017STD" DEFAULT TABLESPACE ZOESTD_TAB;

--授权系统权限
grant ADMINISTER DATABASE TRIGGER,CREATE JOB,
	CREATE PROCEDURE,CREATE SESSION,CREATE TABLE,
	CREATE TRIGGER,CREATE VIEW,CREATE TYPE,
	CREATE ANY CONTEXT,DROP ANY CONTEXT,
	UNLIMITED TABLESPACE to ZOESTD;
--授权对象权限
grant SELECT on DBA_USERS to ZOESTD;
grant SELECT on DBA_OBJECTS to ZOESTD;
grant SELECT on DBA_TABLES to ZOESTD;
grant SELECT on DBA_TAB_COMMENTS to ZOESTD;
grant SELECT on DBA_TAB_COLS to ZOESTD;
grant SELECT on DBA_COL_COMMENTS to ZOESTD;
grant SELECT on DBA_CONSTRAINTS to ZOESTD;
grant SELECT on DBA_CONS_COLUMNS to ZOESTD;
grant SELECT on DBA_TAB_COLUMNS to ZOESTD;


--授权执行权限
grant execute on DBMS_CRYPTO to ZOESTD;
grant execute on ZOEDEVOPS.ZOEPKG_COMM to ZOESTD;


EXEC ZOESTD.ZOEPKG_META_INTERFACE.SET_META_DATA('{"OWNER":"所有者名","TABLE_NAME":"表名","PRIMARY_KEY":[{"COLUMN_NAME":"键名1","COLUMN_VALUE":"键值1"},{"COLUMN_NAME":"键名2","COLUMN_VALUE":"键值2"}],"UPDATE_COLUMN":[{"COLUMN_NAME":"列名1","COLUMN_VALUE":"列值1"},{"COLUMN_NAME":"列名2","COLUMN_VALUE":"列值2"}]}')
