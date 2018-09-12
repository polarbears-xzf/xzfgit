-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		文件名
--	Description:
-- 		基本说明
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--
--zoecheckup/DLS4PVI4LWGB@192.168.137.3/devops
SET SERVEROUTPUT ON SIZE 1000000
-- =======================================
-- 获取并设置数据库连接信息
-- =======================================
DEFINE sh_username=ZOECHECKUP
PROMPT "输入数据库IP地址："
ACCEPT sh_ip_address   
PROMPT "输入数据库服务名："  
ACCEPT sh_service_name 
ACCEPT sh_password     PROMPT '输入&sh_username 密码:' hide 

DECLARE 
lv_username VARCHAR2(64);
lv_passward VARCHAR2(128);
lv_encrypt_password VARCHAR2(128);
lv_db_guid  VARCHAR2(64);
lv_db_name  VARCHAR2(64);
lv_db_service_name  VARCHAR2(64);
lv_db_host_name     VARCHAR2(64);
lv_db_ip_address    VARCHAR2(64);
lv_db_link_name     VARCHAR2(64);
lv_sql_ddl          VARCHAR2(400);
lv_sql_insert       VARCHAR2(2000);
ld_date             DATE;
BEGIN
  lv_db_guid   := 'B';
  lv_passward  := '&sh_password';
  lv_username  := '&sh_username';
  lv_db_service_name   := '&sh_service_name';
  lv_db_ip_address     := '&sh_ip_address';
  lv_db_link_name  := 'zoe_'||replace(lv_db_ip_address,'.','_')||'_'||lv_db_service_name;
  lv_sql_ddl   := 'DROP DATABASE LINK '||lv_db_link_name;
  BEGIN 
	EXECUTE IMMEDIATE lv_sql_ddl;
  EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(lv_sql_ddl);
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END;
  lv_sql_ddl   := 'CREATE DATABASE LINK '||lv_db_link_name||
	' CONNECT TO '||lv_username||' IDENTIFIED BY '||lv_passward||
	' USING '''||lv_db_ip_address||'/'||lv_db_service_name||'''';
  BEGIN 
	EXECUTE IMMEDIATE lv_sql_ddl;
  EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(lv_sql_ddl);
		RAISE;
  END;
  lv_sql_insert := 'SELECT SYSDATE FROM DUAL@'||''||lv_db_link_name;
  BEGIN 
	EXECUTE IMMEDIATE lv_sql_insert;
  EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(lv_sql_insert);
		RAISE;
  END;
  lv_encrypt_password := zoesysman.zoepkg_utility.encrypt_des(lv_passward);
  lv_sql_insert := 'INSERT INTO ZOECHECKUP.CHK_DB_INFO (DB_ID,SERVICE_NAME,IP_ADDRESS,CONNECT_USER,CONNECT_PASSWORD) VALUES ('''||
	lv_db_guid||''','''||lv_db_service_name||''','''||lv_db_ip_address||''','''||lv_username||''','''||lv_encrypt_password||''')';
  EXECUTE IMMEDIATE lv_sql_insert;
  COMMIT;
  EXCEPTION
	WHEN OTHERS THEN 
		DBMS_OUTPUT.PUT_LINE(lv_sql_insert);
		ROLLBACK;
		RAISE;
  END;
/
undefine sh_username
undefine sh_ip_address
undefine sh_service_name
undefine sh_password
