-- Created in 2017.10.10 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoe_aud_create_user.sql
--	Description:
-- 		创建智业安全系统数据库用户
--  Relation:
--      
--	Notes:
--		
--	修改 - （年-月-日） - 描述
set echo off
SET SERVEROUTPUT ON
DEFINE sv_username = ZOESECURITY
DEFINE sv_tablespace_name = ZOESECURITY_TAB

-- ===================================================
-- 创建表空间: ZOECHECKUP_TAB 
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

-- ===================================================
-- 创建用户                                        
-- ===================================================
VAR sv_password         VARCHAR2(128)
DECLARE
lv_password VARCHAR2(128);
lv_sql_ddl  VARCHAR2(400);
BEGIN
SELECT  DBMS_RANDOM.STRING('X',12) INTO :sv_password FROM DUAL;
lv_password := 'zoe'||:sv_password;
--创建用户
lv_sql_ddl := 'CREATE USER &sv_username IDENTIFIED BY '||lv_password||' DEFAULT TABLESPACE &sv_tablespace_name';
DBMS_OUTPUT.PUT_LINE(lv_password);
EXECUTE IMMEDIATE lv_sql_ddl;
--授权用户
lv_sql_ddl := 'GRANT ADMINISTER DATABASE TRIGGER,
      CREATE JOB,
      CREATE PROCEDURE,
      CREATE TABLE,
      CREATE TRIGGER,
      CREATE VIEW,
      CREATE TYPE,
      CREATE ANY CONTEXT,
      DROP ANY CONTEXT TO ZOESECURITY';
EXECUTE IMMEDIATE lv_sql_ddl;
lv_sql_ddl := 'ALTER USER ZOESECURITY QUOTA UNLIMITED ON &sv_tablespace_name';
EXECUTE IMMEDIATE lv_sql_ddl;
lv_sql_ddl := 'GRANT EXECUTE ON SYS.DBMS_RLS TO ZOESECURITY';
EXECUTE IMMEDIATE lv_sql_ddl;
END;
/



