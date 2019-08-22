-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
-- Name:
-- 		controlnode_install.sql
-- Description:
-- 	安装运维管理系统控制节点
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

--创建运维管理相关对象
	--控制节点表
@@controlnode_create_table.sql
	--导入基础字典数据
@@controlnode_dvp_db_deploy_type$.sql
@@controlnode_dvp_db_role$.sql
	--控制节点公共功能包
@@controlnode_zoepkg_ops_comm.pks
@@controlnode_zoepkg_ops_comm.pkb
	--sqlldr数据加载功能包
@@zoepkg_sqlldr.pks
@@zoepkg_sqlldr.pkb





	
