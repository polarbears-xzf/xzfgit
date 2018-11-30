-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
-- Name:
-- 		install_OPS.sql
-- Description:
-- 		安装运维管理系统
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
	
-- 安装运维管理node对象
@@install_lops.sql
 --创建运维管理master对象
	--表
@@create_ops_table.sql
	--类型
		--集合类型：数据库对象、字符串
@@create_type.sql

	--基础功能包
@@zoepkg_devops.pks
@@zoepkg_devops.pkb
@@zoefun_decrypt_user.pls


	--公共工具包
		--函数：分割字符串
@@zoepkg_utility.pks
@@zoepkg_utility.pkb
	--基础功能包
@@zoepkg_devops.pks
@@zoepkg_devops.pkb
@@zoefun_decrypt_user.pls

	--数据采集包
@@zoepkg_sqlldr.pks
@@zoepkg_sqlldr.pkb


DECLARE 
	lv_ddl_text VARCHAR2(32767);
    lv_ddl_pkg  VARCHAR2(32767);
BEGIN
	SELECT DBMS_METADATA.GET_DDL('FUNCTION','DECRYPT_USER','ZOEDEVOPS') INTO lv_ddl_text FROM DUAL;
  lv_ddl_text := replace(lv_ddl_text,'EDITIONABLE','');
	dbms_ddl.create_wrapped(lv_ddl_text);
END;
/



