-- Created in 2017.10.10 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name
-- 		zoepkg_meta_sync - package to metadata synchronize
--	Description
-- 		元数据管理中数据库元数据同步
--	Notes
--		创建用户需要DBA权限
--		  
--    修改 - （年-月-日） - 描述
--


CREATE OR REPLACE PACKAGE zoestd.zoepkg_meta_sync AS

-- =======================================
-- 全局变量声明
-- =======================================
-- 	数组：用于产品用户列表
    -- TYPE arrry_name IS TABLE OF VARCHAR2(30) INDEX BY BINARY_INTEGER;

--========================================
-- 初始化对象同步
--  =======================================
--  完全同步当前数据库用户名到数据库用户字典
--  默认重新同步所有用户，要求meta_user$,meta_obj$,meta_tab$,meta_col$为空，或是使用YES参数强制清空。
--  入参：
--    in_force_flag varchar2 ，  YES = 强制清除数据库用户表所有数据，TRUNCATE TABLE META_USER$
--  完全同步所有数据库对象（包含：meta_user$,meta_obj$,meta_tab$,meta_col$）
    PROCEDURE init_meta_all(in_force_flag VARCHAR2 DEFAULT NULL);

--========================================
-- 增量对象同步
--  =======================================
--  增量同步当前数据库用户名到数据库用户字典
    PROCEDURE sync_meta_user;
--  =======================================
--  增量同步当前数据库表名到数据库对象字典
    PROCEDURE sync_meta_object;
--  =======================================
--  增量同步当前数据库表名到数据库对象字典
    PROCEDURE sync_meta_table;
--  =======================================
--  增量同步当前数据库列到数据库列字典
    PROCEDURE sync_meta_column;
--  =======================================
--  增量同步所有对象
    PROCEDURE sync_meta_all;
    
    

END zoepkg_meta_sync;