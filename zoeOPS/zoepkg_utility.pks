CREATE OR REPLACE PACKAGE ZOEDEVOPS.ZOEPKG_UTILITY AS
-- Created in 2017.10.10 by polarbears
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
	
-- ===================================================
-- 拆分字符串：按长度
-- ===================================================
--  
--	参数：传入参数及类型：
  FUNCTION SPLIT_STRING(iv_string IN VARCHAR2, in_split_length IN NUMBER DEFAULT 1872)
    RETURN zoetyp_utility_split_strings;
-- ===================================================
--  拆分字符串：按分割符
-- ===================================================
--	参数：传入参数及类型：
  FUNCTION SPLIT_STRING(iv_string IN VARCHAR2, in_split_delimiter IN VARCHAR2)
    RETURN zoetyp_utility_split_strings
    PIPELINED;

-- ===================================================
-- 拆分字符串：所有数据库表列拼接拆分
-- ===================================================
--	参数：传入参数及类型：
  FUNCTION SPLIT_TABLE(iv_text IN VARCHAR2)
    RETURN zoetyp_utility_split_strings;

-- ===================================================
-- 枚举Oracle自身产品用户列表
-- ===================================================
  FUNCTION GET_ORACLE_USER 
    RETURN zoetyp_db_object_list;
    
-- ===================================================
-- 返回动态表
-- ===================================================
type ref_dyntable is ref cursor;
  FUNCTION SELECT_DYNTABLE(iv_owner VARCHAR2 DEFAULT 'SYS', iv_table_name VARCHAR2 DEFAULT 'DUAL')
    RETURN ref_dyntable;

		
END ZOEPKG_UTILITY;

