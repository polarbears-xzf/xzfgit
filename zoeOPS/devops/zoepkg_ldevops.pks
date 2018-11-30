--
CREATE OR REPLACE PACKAGE ZOEDEVOPS.ZOEPKG_LDEVOPS AS
-- Created in 2017.10.10 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoepkg_ldevops.pks
--	Description:
-- 		运维管理基础包
--  Relation:
--      
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
--  创建数据库用户或修改用户密码
-- ===================================================
  PROCEDURE ALTER_DB_USER(iv_username IN VARCHAR2, iv_password IN VARCHAR2 DEFAULT NULL);


-- ===================================================
--  数据库基本信息设置
-- ===================================================
--  	初始化本地数据库信息
  PROCEDURE INIT_LOCAL_DB_BASIC_INFO;
--		保存数据库管理用户信息
  PROCEDURE SAVE_DB_USER_INFO (iv_db_id IN VARCHAR2, iv_username IN VARCHAR2, iv_password VARCHAR2);
--  	修改数据库管理用户信息
  PROCEDURE MODIFY_DB_USER_INFO (iv_db_id IN VARCHAR2, iv_username IN VARCHAR2, iv_password VARCHAR2);

  

END ZOEPKG_LDEVOPS;
/
