CREATE OR REPLACE PACKAGE ZOEDEVOPS.ZOEPKG_DEVOPS AS
-- Created in 2017.10.10 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoepkg_devops.pks
--	Description:
-- 		运维管理基础包
--  Relation:
--    zoedevops.zoepkg_utility  
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--

-- ===================================================
--  项目基本信息设置
-- ===================================================
--  	修改远程管理用户信息
  PROCEDURE MODIFY_REMOTE_USER_INFO (iv_project_id IN VARCHAR2, remote_seq NUMBER, iv_username IN VARCHAR2, iv_password VARCHAR2);
--  	修改服务器管理用户信息
  PROCEDURE MODIFY_SERVER_USER_INFO (iv_project_id IN VARCHAR2, iv_ip_address VARCHAR2, iv_username IN VARCHAR2, iv_password VARCHAR2);
--  	同步可管理项目数据库基本信息及用户信息
--      同步数据库ID到项目数据库链路信息
--      同步数据库ID、名称、IP地址、创建时间到项目数据库基本信息
--      同步数据库管理用户到项目数据库用户管理信息
  PROCEDURE SYNC_PROJ_DB_INFO(iv_project_id IN VARCHAR2);


  

END ZOEPKG_DEVOPS;