-- =====================================================

CREATE OR REPLACE PACKAGE ZOEDEVOPS.ZOEPKG_UTILITY

-- Created in 2019.06.18 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoepkg_utility.pks
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
-- 枚举Oracle自身产品用户列表
-- ===================================================
  FUNCTION GET_ORACLE_USER 
    RETURN zoett_db_object_list;

END ZOEPKG_UTILITY;
/
