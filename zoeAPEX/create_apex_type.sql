-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		文件名
--	Description:
-- 		基本说明
--  Relation:
--      对象关联 
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--

--
--用于数据库基本信息，区分唯一数据库
CREATE OR REPLACE TYPE ZOEAPEX.zoeto_apex_tree FORCE AS OBJECT(
	TREE_STATUS      NUMBER,
	TREE_LEVEL       NUMBER,
	TREE_TITLE       VARCHAR2(128),
	TREE_ICON        VARCHAR2(128),
	TREE_VALUE       VARCHAR2(128),
	TREE_TOOLTIP     VARCHAR2(128),
	TREE_LINK        VARCHAR2(1024)
)
/
CREATE OR REPLACE TYPE ZOEAPEX.zoett_apex_tree AS TABLE OF zoeto_apex_tree;
/

