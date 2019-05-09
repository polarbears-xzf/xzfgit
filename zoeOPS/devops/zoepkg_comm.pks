--
CREATE OR REPLACE PACKAGE ZOEDEVOPS.ZOEPKG_COMM AS
-- Created in 2017.10.10 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoepkg_comm.pks
--	Description:
-- 		运维管理基础包
--  Relation:
--      
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--

-- ===================================================
-- 枚举Oracle自身产品用户列表
-- ===================================================
  FUNCTION GET_ORACLE_USER 
    RETURN zoetyp_db_object_list;

END ZOEPKG_COMM;
/