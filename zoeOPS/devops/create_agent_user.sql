-- Created in 2018.10.26 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		create_agent_user.sql	
--	Description:
-- 		创建远程维护用户并授权
--  Relation:
--      ZOEDEVOPS.ZOEPKG_LDEVOPS
--	Notes:
--		
--	修改 - （年-月-日） - 描述
--

SET SERVEROUTPUT ON 
--定义运维管理存储表空间
DEFINE sv_tablespace_name = ZOEOPS_TAB
--运维管理DBA用户
DEFINE sv_dbauser = ZOEAGENT

-- ===================================================
-- 创建DBA用户                                        
-- ===================================================
VAR sv_password         VARCHAR2(128)
DECLARE
lv_password VARCHAR2(128);
lv_sql_ddl  VARCHAR2(400);
ln_user_exist NUMBER;
lv_dbid     VARCHAR2(64);
BEGIN
SELECT  DBMS_RANDOM.STRING('X',12) INTO :sv_password FROM DUAL;
lv_password := 'zoe'||:sv_password;
DBMS_OUTPUT.PUT_LINE('&sv_dbauser : '||lv_password);
select count(1) INTO ln_user_exist from dba_users where username='&sv_dbauser';
IF ln_user_exist = 1 THEN
	lv_sql_ddl := 'ALTER USER &sv_dbauser IDENTIFIED BY '||lv_password;
ELSE
	lv_sql_ddl := 'CREATE USER &sv_dbauser IDENTIFIED BY '||lv_password||' DEFAULT TABLESPACE &sv_tablespace_name';
END IF;
EXECUTE IMMEDIATE lv_sql_ddl;
lv_sql_ddl := 'GRANT DBA TO &sv_dbauser';
EXECUTE IMMEDIATE lv_sql_ddl;
lv_dbid := ZOEDEVOPS.ZOEPKG_LDEVOPS.GET_DB_ID;
select count(1) INTO ln_user_exist from ZOEDEVOPS.DVP_DB_USER_INFO where DB_ID# = lv_dbid and USERNAME = '&sv_dbauser';
IF ln_user_exist = 1 THEN
	ZOEDEVOPS.ZOEPKG_LDEVOPS.MODIFY_DB_USER_INFO(lv_dbid,'&sv_dbauser',lv_password);
ELSE
	ZOEDEVOPS.ZOEPKG_LDEVOPS.SAVE_DB_USER_INFO(lv_dbid,'&sv_dbauser',lv_password);
END IF;
END;
/



