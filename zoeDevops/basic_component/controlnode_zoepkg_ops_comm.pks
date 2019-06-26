--  ===================================================

CREATE OR REPLACE PACKAGE ZOEDEVOPS.ZOEPKG_OPS_COMM

-- Created in 2017.10.10 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoepkg_ops_comm.pks
--	Description:
-- 		运维管理控制节点公共功能包
--  Relation:
--      
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--

 AS
 
-- ===================================================
--  创建数据库用户或修改用户密码
-- ===================================================
  PROCEDURE SET_DB_USER(iv_key VARCHAR2, iv_username IN VARCHAR2, iv_db_id IN VARCHAR2 DEFAULT NULL, iv_password IN VARCHAR2 DEFAULT NULL);
  
END ZOEPKG_OPS_COMM;
