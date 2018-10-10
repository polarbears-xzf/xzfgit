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
-- 创建运维管理用户
@create_ops_user.sql
 --创建运维管理相关对象
	--表
@create_ops_table.sql
	--类型
		--集合类型：数据库对象、字符串
@create_type.sql
	--安全管理包
		--函数：加密函数，校验函数
@zoepkd_security.pks
@zoepkd_security.pkb
	--加密用户密码函数
@zoefun_decrypt_user.pls
@zoefun_decrypt_user.pls
	--公共工具包
		--函数：分割字符串
@zoepkg_utility.pks
@zoepkg_utility.pkb
	--基础功能包
@zoepkg_devops.pks
@zoepkg_devops.pkb
--创建运维管理DBA用户
@create_dba_user.sql		



