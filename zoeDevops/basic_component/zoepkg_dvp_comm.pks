-- =====================================================

CREATE OR REPLACE PACKAGE ZOEDEVOPS.ZOEPKG_DVP_COMM

-- Created in 2019.06.18 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoepkg_dvp_comm.pks
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



END ZOEPKG_DVP_COMM;
