-- Created in 2017.10.10 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoe_aud_create_user.sql
--	Description:
-- 		创建智业元数据管理相关类型
--  Relation:
--      
--	Notes:
--		
--	修改 - （年-月-日） - 描述

ALTER SESSION SET SCHEMA=ZOESTD;

CREATE OR REPLACE TYPE zoetyp_db_object_list IS TABLE OF VARCHAR2(64);

