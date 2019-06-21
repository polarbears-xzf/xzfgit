-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
-- Name:
-- 		install_OPS.sql
-- Description:
-- 		安装运维管理系统本地组件
--  Relation:
--      
-- Notes:
--		基本注意事项
-- 修改 - （年-月-日） - 描述
--
-- 依赖安装
	-- 
SET SERVEROUTPUT ON	
SET ECHO OFF
SET VERIFY OFF

	
-- 创建运维管理用户
@@create_lops_user.sql
--创建运维管理相关对象
	--表
@@create_lops_table.sql
		--加载表数据
@@load_lops_dvp_db_deploy_type_dict.sql
@@load_lops_dvp_db_role_dict.sql
	--类型
		--集合类型：数据库对象
@@create_lops_type.sql
	--安全管理包
		--函数：加密函数，校验函数
@@zoepkg_security.pks
@@zoepkg_security.pkb
	--加密用户密码函数
@@zoefun_encrypt_user.pls
--加密安全函数
DECLARE 
	lv_ddl_text VARCHAR2(32767);
    lv_ddl_pkg  VARCHAR2(32767);
BEGIN
	SELECT DBMS_METADATA.GET_DDL('FUNCTION','ENCRYPT_USER','ZOEDEVOPS') INTO lv_ddl_text FROM DUAL;
  lv_ddl_text := replace(lv_ddl_text,'EDITIONABLE','');
	dbms_ddl.create_wrapped(lv_ddl_text);
	SELECT DBMS_METADATA.GET_DDL('PACKAGE','ZOEPKG_SECURITY','ZOEDEVOPS') INTO lv_ddl_text FROM DUAL;
  lv_ddl_text := replace(lv_ddl_text,'EDITIONABLE','');
  lv_ddl_pkg := substr(lv_ddl_text,1,instr(lv_ddl_text,'CREATE OR REPLACE',1,2)-1);
	dbms_ddl.create_wrapped(lv_ddl_pkg);
  lv_ddl_pkg := substr(lv_ddl_text,instr(lv_ddl_text,'CREATE OR REPLACE',1,2));
	dbms_ddl.create_wrapped(lv_ddl_pkg);
END;
/

	--公用功能包
@@zoepkg_comm.pks
@@zoepkg_comm.pkb
	--远程执行SQL
@@zoeprc_exec_sql.pls
	--基本功能包
@@zoepkg_ldevops.pks
@@zoepkg_ldevops.pkb

--初始化数据库信息
BEGIN
	ZOEDEVOPS.ZOEPKG_LDEVOPS.INIT_LOCAL_DB_BASIC_INFO;
END;
/
--创建运维管理DBA用户
@@create_dba_user.sql	
--创建运维管理远程维护用户
@@create_agent_user.sql	

	



