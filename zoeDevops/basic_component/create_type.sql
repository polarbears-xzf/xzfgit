-- Created in 2019.06.20 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		create_type.sql
--	Description:
-- 		
--  Relation:
--      
--	Notes:
--		
--	修改 - （年-月-日） - 描述

--用于数据库基本信息，区分唯一数据库
CREATE OR REPLACE TYPE ZOEDEVOPS.zoeto_db_basic_info AS OBJECT(
	HOST_NAME     VARCHAR2(128),
	IP_ADDRESS    VARCHAR2(128),
	DB_NAME       VARCHAR2(128),
	CREATED_TIME  DATE,
	DB_VERSION    VARCHAR2(80)
)
/
CREATE OR REPLACE TYPE ZOEDEVOPS.zoett_db_basic_info AS TABLE OF zoeto_db_basic_info;
/

--用于获取数据库对象信息
CREATE OR REPLACE TYPE ZOEDEVOPS.zoett_db_object_list IS TABLE OF VARCHAR2(64);
/
