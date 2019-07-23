-- Created in 2017.10.10 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name
-- 		zoepkg_metadata_sync - package to metadata synchronize
--	Description
-- 		元数据管理中元数据同步
--	Notes
--		创建用户需要DBA权限
--	Dependence
--		标准管理中数据库元数据相关表
--			数据库用户字典，数据库对象字典，数据库表，数据库列  
--    修改 - （年-月-日） - 描述
--    2019.07.23：
--      1. 重构完全同步，增加DB_ID以支持多数据库
--      2. 重构增量同步，考虑到依赖关系，不再支持同步单个类型对象


CREATE OR REPLACE PACKAGE zoedevops.zoepkg_metadata_sync AS

-- =======================================
-- 全局变量声明
-- =======================================
-- 	数组：用于产品用户列表
    -- TYPE arrry_name IS TABLE OF VARCHAR2(30) INDEX BY BINARY_INTEGER;

--========================================
-- 初始化对象同步
--  =======================================
--  完全同步数据库对象到数据库元数据字典
--  默认重新同步所有对象，要求meta_user$,meta_obj$,meta_tab$,meta_col$为空，或是使用YES参数强制清空。
--  入参：
--    in_force_flag varchar2 ，  YES = 强制清除数据库用户表所有数据，TRUNCATE TABLE META_USER$
--  完全同步所有数据库对象（包含：meta_user$,meta_obj$,meta_tab$,meta_col$）
    PROCEDURE init_sync_all(in_db_id IN VARCHAR2, in_force_flag IN VARCHAR2 DEFAULT NULL);

--  增量同步所有对象（包含：meta_user$,meta_obj$,meta_tab$,meta_col$）
    PROCEDURE increment_sync_all(in_db_id IN VARCHAR2);
    
    

END zoepkg_metadata_sync;