-- Created in 2017.10.10 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoesql_create_user.sql
--	Description:
-- 		创建智业标准管理数据库用户
--  Relation:
--      
--	Notes:
--		
--	修改 - （年-月-日） - 描述

SET SERVEROUTPUT ON 
--定义标准管理存储表空间
DEFINE sv_tablespace_name = ZOESTD_TAB
--运维管理DBA用户
DEFINE sv_dbauser = ZOESTD

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
  lv_tablespace_name := '&sv_tablespace_name';
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
CREATE USER &sv_dbauser IDENTIFIED BY "ZOE$2017STD" DEFAULT TABLESPACE &sv_tablespace_name;

--授权系统权限
grant ADMINISTER DATABASE TRIGGER,CREATE JOB,
	CREATE PROCEDURE,CREATE SESSION,CREATE TABLE,
	CREATE TRIGGER,CREATE VIEW,CREATE TYPE,
	CREATE ANY CONTEXT,DROP ANY CONTEXT,
	UNLIMITED TABLESPACE to &sv_dbauser;
--授权对象权限
grant SELECT on DBA_USERS        to &sv_dbauser;
grant SELECT on DBA_OBJECTS      to &sv_dbauser;
grant SELECT on DBA_TABLES       to &sv_dbauser;
grant SELECT on DBA_TAB_COMMENTS to &sv_dbauser;
grant SELECT on DBA_TAB_COLS     to &sv_dbauser;
grant SELECT on DBA_COL_COMMENTS to &sv_dbauser;
grant SELECT on DBA_CONSTRAINTS  to &sv_dbauser;
grant SELECT on DBA_CONS_COLUMNS to &sv_dbauser;
grant SELECT on DBA_TAB_COLUMNS  to &sv_dbauser;


--授权执行权限
grant execute on DBMS_CRYPTO           to &sv_dbauser;
grant execute on ZOEDEVOPS.ZOEPKG_COMM to &sv_dbauser;


--EXEC ZOESTD.ZOEPKG_META_INTERFACE.SET_META_DATA('{"OWNER":"所有者名","TABLE_NAME":"表名","PRIMARY_KEY":[{"COLUMN_NAME":"键名1","COLUMN_VALUE":"键值1"},{"COLUMN_NAME":"键名2","COLUMN_VALUE":"键值2"}],"UPDATE_COLUMN":[{"COLUMN_NAME":"列名1","COLUMN_VALUE":"列值1"},{"COLUMN_NAME":"列名2","COLUMN_VALUE":"列值2"}]}')
