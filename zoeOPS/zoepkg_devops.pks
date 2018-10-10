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
--  获取数据库基本信息，区分唯一数据库
-- ===================================================
  FUNCTION GET_DB_BASIC_INFO RETURN zoetyp_db_basic_info;

-- ===================================================
--  获取数据库ID，区分唯一数据库
-- ===================================================
  FUNCTION GET_DB_ID RETURN VARCHAR2;

-- ===================================================
--  保存数据库管理用户信息
-- ===================================================
  PROCEDURE SAVE_DB_USER_INFO (iv_db_id IN VARCHAR2, iv_username IN VARCHAR2, iv_password VARCHAR2);
-- ===================================================
--  修改数据库管理用户信息
-- ===================================================
  PROCEDURE MODIFY_DB_USER_INFO (iv_db_id IN VARCHAR2, iv_username IN VARCHAR2, iv_password VARCHAR2);

-- ===================================================
--  初始化本地数据库信息
-- ===================================================
  PROCEDURE INIT_LOCAL_DB_BASIC_INFO;

  

END ZOEPKG_DEVOPS;