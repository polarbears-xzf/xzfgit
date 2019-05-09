CREATE OR REPLACE PACKAGE ZOEDEVOPS.ZOEPKG_SQLLDR AS
-- Created in 2017.10.10 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoepkg_sqlldr.pks
--	Description:
-- 		运维管理sqlloader数据加载包
--  Relation:
--    zoemops部署  
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--

-- ===================================================
--  获取数据加载控制文件与数据
-- ===================================================
--  	获取控制文件
  PROCEDURE SQLLDR_GET_CTL (iv_loaddata_path IN VARCHAR2, iv_table_owner IN VARCHAR2, iv_table_name IN VARCHAR2);
--  	获取数据
  PROCEDURE SQLLDR_GET_DATA (iv_table_owner IN VARCHAR2, iv_table_name IN VARCHAR2, ov_column_data OUT VARCHAR2);


  

END ZOEPKG_SQLLDR;
/
