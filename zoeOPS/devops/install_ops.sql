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
-- 安装运维管理node对象
@@intall_lops.sql
 --创建运维管理master对象
	--表
@@create_ops_table.sql
	--类型
		--集合类型：数据库对象、字符串
@@create_type.sql

	--公共工具包
		--函数：分割字符串
@@zoepkg_utility.pks
@@zoepkg_utility.pkb
	--基础功能包
@@zoepkg_devops.pks
@@zoepkg_devops.pkb
@@zoefun_decrypt_user.pls

conn zoedevops/zoe$Y406FCFK8Z6J@192.168.1.41/zoemops	
create database link zoetmpl41zoeagent connect to zoeagent identified by zoe4S3YOS37F9A5 using '192.168.1.41/zoetmpl';
INSERT INTO ZOEDEVOPS.DVP_PROJ_NODE_DB_LINKS (project_id#,db_id#,db_link_name,connect_to_user,CREATOR_CODE,CREATED_TIME) VALUES (1,1,'ZOETMPL41ZOEAGENT','ZOEAGENT','xzf',SYSDATE);
exec zoedevops.zoepkg_devops.SYNC_PROJ_DB_INFO(1);
