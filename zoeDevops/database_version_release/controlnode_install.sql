-- Created in 2019.07.26 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
-- Name:
-- 		controlnode_install.sql
-- Description:
-- 	安装运维管理系统数据库版本与发布管理控制节点
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
-- 创建数据库版本与发布管理相关用户
@@create_user.sql
-- 创建数据库版本与发布管理相关表
@@create_table.sql
-- 创建标准管理相关视图
@@create_view.sql

