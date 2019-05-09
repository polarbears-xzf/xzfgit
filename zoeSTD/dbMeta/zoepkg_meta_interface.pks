CREATE OR REPLACE PACKAGE ZOESTD.ZOEPKG_META_INTERFACE AS
-- Created in 2017.10.10 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		ZOEPKG_META_INTERFACE
--	Description:
-- 		元数据管理接口
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
-- 更新元数据信息接口：根据元数据存储表的主键更新元数据信息
-- ===================================================
--	参数：元数据存储表所有者，元数据存储表名，主键列，主键值，更新列，更新列值：JSON字符串类型：
--  {
--    "OWNER":"所有者名",
--    "TABLE_NAME":"表名",
--    "PRIMARY_KEY":
--      [{"COLUMN_NAME":"列名1","COLUMN_VALUE":"列值1"},{"COLUMN_NAME":"列名2","COLUMN_VALUE":"列值2"}]
--    "UPDATE_COLUMN":
--      [{"COLUMN_NAME":"列名1","COLUMN_VALUE":"列值1"},{"COLUMN_NAME":"列名2","COLUMN_VALUE":"列值2"}]
--  }
--	返回值：：、
	PROCEDURE SET_META_DATA(iv_json_data VARCHAR2);
	--PROCEDURE 存储过程名称(iv_str VARCHAR2,in_num INTEGER);

	
-- ===================================================
-- 函数功能说明
-- ===================================================
--	参数：传入参数及类型：
	--FUNCTION 函数名称(iv_str VARCHAR2,in_num INTEGER)
		--RETURN VARCHAR2;
		
END ZOEPKG_META_INTERFACE;