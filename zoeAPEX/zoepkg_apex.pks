CREATE OR REPLACE PACKAGE ZOEAPEX.ZOEPKG_APEX AS
-- Created in 2017.10.10 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		包文件名
--	Description:
-- 		基本说明
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--


-- =======================================
-- 全局变量声明
-- =======================================
--    数组变量
    -- TYPE arrry_name IS TABLE OF VARCHAR2(30) INDEX BY BINARY_INTEGER;
	
-- ===================================================
-- 返回APEX树控件查询
-- ===================================================
--	参数：传入参数及类型：
	FUNCTION apex_query_tree(iv_db_link VARCHAR2)
		RETURN zoett_apex_tree;
        
END ZOEPKG_APEX;