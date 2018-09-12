-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
-- Name:
-- 		install_checkup.sql
-- Description:
-- 		安装运维管理系统
--  Relation:
--      zoeUtility
-- Notes:
--		基本注意事项
-- 修改 - （年-月-日） - 描述
--

-- 依赖安装
	-- zoeUtility
-- 创建运维管理用户
	--包含运维管理DBA用户，运维管理对象用户，运维管理健康检查用户
@create_user_and_grant.sql

-- 创建运维管理公用对象
@create_type.sql
@zoepkg_utility.pks
@zoepkg_utility.pkb


@create_sequence.sql


@create_table.sql


