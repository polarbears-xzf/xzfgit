-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
-- Name:
-- 		datanode_install.sql
-- Description:
-- 	安装运维管理系统数据节点
	--  
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
-- 创建运维管理相关用户
@@create_user.sql

--创建运维管理相关对象
	--数据节点表
@@datanode_create_table.sql
	--基础安全包
@@zoefun_crypto_key.sql
@@zoepkg_security.pks
@@zoepkg_security.pkb
@@zoefun_encrypt_user.pls
@@zoefun_decrypt_user.pls
@@zoeprc_set_devops_context.pls
	--创建上下文
@@create_context.sql
	--加密安全函数
DECLARE 
	lv_ddl_text VARCHAR2(32767);
    lv_ddl_pkg  VARCHAR2(32767);
BEGIN
--	加密用户函数
	SELECT DBMS_METADATA.GET_DDL('FUNCTION','ZOEFUN_ENCRYPT_USER','ZOEDEVOPS') INTO lv_ddl_text FROM DUAL;
	lv_ddl_text := replace(lv_ddl_text,'EDITIONABLE','');
	dbms_ddl.create_wrapped(lv_ddl_text);
--	解密用户函数
	SELECT DBMS_METADATA.GET_DDL('FUNCTION','ZOEFUN_DECRYPT_USER','ZOEDEVOPS') INTO lv_ddl_text FROM DUAL;
	lv_ddl_text := replace(lv_ddl_text,'EDITIONABLE','');
	dbms_ddl.create_wrapped(lv_ddl_text);
--	密钥函数
	SELECT DBMS_METADATA.GET_DDL('FUNCTION','ZOEFUN_CRYPTO_KEY','ZOEDEVOPS') INTO lv_ddl_text FROM DUAL;
	lv_ddl_text := replace(lv_ddl_text,'EDITIONABLE','');
	dbms_ddl.create_wrapped(lv_ddl_text);
--	基础安全包
	SELECT DBMS_METADATA.GET_DDL('PACKAGE','ZOEPKG_SECURITY','ZOEDEVOPS') INTO lv_ddl_text FROM DUAL;
	lv_ddl_text := replace(lv_ddl_text,'EDITIONABLE','');
	lv_ddl_pkg := substr(lv_ddl_text,1,instr(lv_ddl_text,'CREATE OR REPLACE',1,2)-1);
	dbms_ddl.create_wrapped(lv_ddl_pkg);
	lv_ddl_pkg := substr(lv_ddl_text,instr(lv_ddl_text,'CREATE OR REPLACE',1,2));
	dbms_ddl.create_wrapped(lv_ddl_pkg);
END;
/
	--相关类型
@@create_type.sql
	--基本工具包
@@zoepkg_utility.pks
@@zoepkg_utility.pkb
	--初始化数据库信息功能包
@@datanode_zoepkg_ops_db_info.pks
@@datanode_zoepkg_ops_db_info.pkb
	--远程sql调用
@@datanode_zoeprc_exec_sql.pls



	
