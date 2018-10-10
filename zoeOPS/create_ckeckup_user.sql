-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		create_checkup_user.sql
--	Description:
-- 		创建健康检查用户并授权
--  Relation:
--      zoeOPS
--	Notes:
--		首先安装zoeOPS
--	修改 - （年-月-日） - 描述
--

SET SERVEROUTPUT ON 
--定义运维管理存储表空间
DEFINE sv_tablespace_name = ZOEOPS_TAB
--运维管理DBA用户
DEFINE sv_checkupusername = ZOECKUP

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
lv_sql_ddl := 'CREATE USER &sv_checkupusername IDENTIFIED BY '||lv_password||' DEFAULT TABLESPACE &sv_tablespace_name';
EXECUTE IMMEDIATE lv_sql_ddl;
lv_sql_ddl := 'ALTER USER &sv_checkupusername QUOTA UNLIMITED ON &sv_tablespace_name';
EXECUTE IMMEDIATE lv_sql_ddl;
ZOEDEVOPS.ZOEPKG_DEVOPS.SAVE_DB_USER_INFO(ZOEDEVOPS.ZOEPKG_DEVOPS.GET_DB_ID,'&sv_checkupusername',lv_password);
END;
/



