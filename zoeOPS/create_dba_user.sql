-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		create_dba_user.sql
--	Description:
-- 		创建DBA用户并授权
--  Relation:
--      zoeUtility
--	Notes:
--		首先安装zoeUtility工具包
--	修改 - （年-月-日） - 描述
--

SET SERVEROUTPUT ON 
--定义运维管理存储表空间
DEFINE sv_tablespace_name = ZOEOPS_TAB
--运维管理DBA用户
DEFINE sv_dbauser = ZOEDBA

-- ===================================================
-- 创建DBA用户                                        
-- ===================================================
VAR sv_password         VARCHAR2(128)
DECLARE
lv_password VARCHAR2(128);
lv_sql_ddl  VARCHAR2(400);
BEGIN
SELECT  DBMS_RANDOM.STRING('X',12) INTO :sv_password FROM DUAL;
lv_password := 'zoe'||:sv_password;
lv_sql_ddl := 'CREATE USER &sv_dbauser IDENTIFIED BY '||lv_password||' DEFAULT TABLESPACE &sv_tablespace_name';
EXECUTE IMMEDIATE lv_sql_ddl;
lv_sql_ddl := 'GRANT DBA TO &sv_dbauser';
EXECUTE IMMEDIATE lv_sql_ddl;
ZOEDEVOPS.ZOEPKG_DEVOPS.SAVE_DB_USER_INFO(ZOEDEVOPS.ZOEPKG_DEVOPS.GET_DB_ID,'&sv_dbauser',lv_password);
END;
/



