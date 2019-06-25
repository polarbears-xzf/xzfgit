-- =====================================================

CREATE OR REPLACE PACKAGE ZOEDEVOPS.ZOEPKG_DN_DB_INFO

-- Created in 2019.06.18 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		ZOEPKG_DN_DB_INFO.pks
--	Description:
-- 		基础工具包
--  Relation:
--      建在所有其它包之前
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--
--

AS

-- ===================================================
--  获取数据库基本信息，区分唯一数据库
-- ===================================================
  FUNCTION GET_DB_BASIC_INFO RETURN zoett_db_basic_info;

-- ===================================================
--  获取数据库ID，区分唯一数据库
-- ===================================================
  FUNCTION GET_DB_ID RETURN VARCHAR2;

-- ===================================================
--  数据库基本信息设置
-- ===================================================
--  	初始化本地数据库信息
  PROCEDURE INIT_PROJ_DB_BASIC_INFO(in_project_id IN VARCHAR2 DEFAULT NULL);
--		保存数据库管理用户信息



END ZOEPKG_DN_DB_INFO;
/
