-- Created in 2019.06.21 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		create_user.sql
--	Description:
--		创建运维管理所需用户，包括：
-- 			zoedevops：运维管理系统对象模式用户
-- 			zoedba：用于管理员日常运维管理连接用户
-- 			zoeagent：用于运维管理控制节点数据库链路连接用户
-- 			zoeopsconn：用于运维管理系统连接用户
--  Relation:
--      
--	Notes:
--		
--	修改 - （年-月-日） - 描述



SET SERVEROUTPUT ON 

--定义运维管理存储表空间
DEFINE sv_tablespace_name = ZOEDEVOPS_TAB
--运维管理模式用户
DEFINE sv_zoedevops  = ZOEDEVOPS
DEFINE sv_zoedba     = ZOEDBA
DEFINE sv_zoeagent   = ZOEAGENT
DEFINE sv_zoeopsconn = ZOEOPSCONN


-- ===================================================
-- 创建表空间: ZOEDEVOPS_TAB 
--	
   --不支持裸设备，仅支持文件系统 
   --通过获取system表空间数据文件的路径，决定新建表空间数据文件的位置
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
-- 创建敏捷运维模式用户，并授权                                   
-- ===================================================
	-- 创建用户
VAR sv_password         VARCHAR2(128)
DECLARE
lv_password VARCHAR2(128);
lv_sql_ddl  VARCHAR2(400);
BEGIN
SELECT  DBMS_RANDOM.STRING('X',12) INTO :sv_password FROM DUAL;
lv_password := 'Zoe$'||:sv_password;
lv_sql_ddl := 'CREATE USER &sv_zoedevops IDENTIFIED BY '||lv_password||' DEFAULT TABLESPACE &sv_tablespace_name';
DBMS_OUTPUT.PUT_LINE('&sv_zoedevops : '||lv_password);
EXECUTE IMMEDIATE lv_sql_ddl;
END;
/

	-- 授权系统权限
ALTER USER &sv_zoedevops QUOTA UNLIMITED ON &sv_tablespace_name;
GRANT CONNECT                                     TO &sv_zoedevops;
GRANT ALTER USER, CREATE USER                     TO &sv_zoedevops;
GRANT CREATE DATABASE LINK                        TO &sv_zoedevops;

	-- 授权对象权限
GRANT EXECUTE ON  SYS.DBMS_CRYPTO                 TO &sv_zoedevops;
GRANT EXECUTE ON  SYS.UTL_I18N                    TO &sv_zoedevops;
GRANT EXECUTE ON  SYS.UTL_RAW                     TO &sv_zoedevops;
GRANT EXECUTE ON  SYS.DBMS_OBFUSCATION_TOOLKIT    TO &sv_zoedevops;

GRANT SELECT  ON  DBA_CONSTRAINTS                 TO &sv_zoedevops;
GRANT SELECT  ON  DBA_CONS_COLUMNS                TO &sv_zoedevops;
GRANT SELECT  ON  DBA_DB_LINKS                    TO &sv_zoedevops;
GRANT SELECT  ON  DBA_TAB_COLUMNS                 TO &sv_zoedevops;
GRANT SELECT  ON  V_$DATABASE                     TO &sv_zoedevops;
GRANT SELECT  ON  V_$PDBS                         TO &sv_zoedevops;
GRANT SELECT  ON  DBA_USERS                       TO &sv_zoedevops;

	-- 授权网络访问权限权限
begin
  dbms_network_acl_admin.create_acl (       -- 创建访问控制文件（ACL）
	acl         => 'user_zoedevops.xml',          -- 文件名称
	description => 'zoedevops Network Access',    -- 描述
	principal   => 'ZOEDEVOPS',                   -- 授权或者取消授权账号，大小写敏感
	is_grant    => TRUE,                    -- 授权还是取消授权
	privilege   => 'connect',               -- 授权或者取消授权的权限列表
	start_date  => null,                    -- 起始日期
	end_date    => null                     -- 结束日期
  );
 dbms_network_acl_admin.add_privilege (     -- 添加访问权限列表项
	acl        => 'user_zoedevops.xml',     -- 刚才创建的acl名称 
	principal  => 'ZOEDEVOPS',              -- 授权或取消授权用户
	is_grant   => TRUE,                     -- 与上同 
	privilege  => 'resolve',                -- 权限列表
	start_date => null,                     
	end_date   => null
  );
 dbms_network_acl_admin.assign_acl ( -- 允许访问acl名为utl_http.xml下授权的用户，所允许访问的目的主机，及其端口范围。,可以授权多个主机，或者多个主机的多个端口
	acl        => 'user_zoedevops.xml',
	host       => 'localhost',              -- ip地址或者域名   
	lower_port => NULL,                     -- 允许访问的起始端口号
	upper_port =>NULL                      -- 允许访问的截止端口号
  );
  commit;
end;
/

-- ===================================================
-- 创建敏捷运维DBA用户，并授权                                   
-- ===================================================
	-- 创建用户
VAR sv_password         VARCHAR2(128)
DECLARE
lv_password VARCHAR2(128);
lv_sql_ddl  VARCHAR2(400);
BEGIN
SELECT  DBMS_RANDOM.STRING('X',12) INTO :sv_password FROM DUAL;
lv_password := 'Zoe$'||:sv_password;
lv_sql_ddl := 'CREATE USER &sv_zoedba IDENTIFIED BY '||lv_password||' DEFAULT TABLESPACE &sv_tablespace_name';
EXECUTE IMMEDIATE lv_sql_ddl;
END;
/
	-- 授权系统权限
GRANT DBA TO &sv_zoedba;

-- ===================================================
-- 创建敏捷运维控制节点管理连接用户，并授权                                   
-- ===================================================
	-- 创建用户
VAR sv_password         VARCHAR2(128)
DECLARE
lv_password VARCHAR2(128);
lv_sql_ddl  VARCHAR2(400);
BEGIN
SELECT  DBMS_RANDOM.STRING('X',12) INTO :sv_password FROM DUAL;
lv_password := 'Zoe$'||:sv_password;
lv_sql_ddl := 'CREATE USER &sv_zoeagent IDENTIFIED BY '||lv_password||' DEFAULT TABLESPACE &sv_tablespace_name';
DBMS_OUTPUT.PUT_LINE('&sv_zoeagent : '||lv_password);
EXECUTE IMMEDIATE lv_sql_ddl;
END;
/
	-- 授权系统权限
GRANT DBA TO &sv_zoeagent;

-- ===================================================
-- 创建敏捷运维管理系统连接用户，并授权                                   
-- ===================================================
	-- 创建用户
VAR sv_password         VARCHAR2(128)
DECLARE
lv_password VARCHAR2(128);
lv_sql_ddl  VARCHAR2(400);
BEGIN
SELECT  DBMS_RANDOM.STRING('X',12) INTO :sv_password FROM DUAL;
lv_password := 'Zoe$'||:sv_password;
lv_sql_ddl := 'CREATE USER &sv_zoeopsconn IDENTIFIED BY '||lv_password||' DEFAULT TABLESPACE &sv_tablespace_name';
EXECUTE IMMEDIATE lv_sql_ddl;
END;
/
	-- 授权系统权限
GRANT CONNECT                                     TO &sv_zoeopsconn;

UNDEFINE sv_tablespace_name
UNDEFINE sv_zoedevops
UNDEFINE sv_zoedba
UNDEFINE sv_zoeagent
UNDEFINE sv_zoeopsconn


