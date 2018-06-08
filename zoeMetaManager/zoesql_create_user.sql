-- Created in 2017.10.10 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoesql_create_user.sql
--	Description:
-- 		创建智业安全系统数据库用户
--  Relation:
--      
--	Notes:
--		
--	修改 - （年-月-日） - 描述

--创建表空间
create tablespace ZOESTD_TAB
datafile 'path/zoestd_tab01.ora' size 10M
autoextend on next 10M maxsize UNLIMITED;

--创建用户
create user ZOESTD identified by "zoe$2017std";

--授权系统权限
grant ADMINISTER DATABASE TRIGGER,CREATE JOB,
	CREATE PROCEDURE,CREATE SESSION,CREATE TABLE,
	CREATE TRIGGER,CREATE VIEW,CREATE TYPE,
	CREATE ANY CONTEXT,DROP ANY CONTEXT,
	UNLIMITED TABLESPACE to ZOESTD;
--授权对象权限
grant SELECT on DBA_USERS to ZOESTD;
grant SELECT on DBA_OBJECTS to ZOESTD;
grant SELECT on DBA_TABLES to ZOESTD;
grant SELECT on DBA_TAB_COMMENTS to ZOESTD;
grant SELECT on DBA_TAB_COLS to ZOESTD;
grant SELECT on DBA_COL_COMMENTS to ZOESTD;

--授权执行权限
grant execute on DBMS_CRYPTO to ZOESTD;

EXEC ZOESTD.ZOEPKG_META_INTERFACE.SET_META_DATA('{"OWNER":"所有者名","TABLE_NAME":"表名","PRIMARY_KEY":[{"COLUMN_NAME":"键名1","COLUMN_VALUE":"键值1"},{"COLUMN_NAME":"键名2","COLUMN_VALUE":"键值2"}],"UPDATE_COLUMN":[{"COLUMN_NAME":"列名1","COLUMN_VALUE":"列值1"},{"COLUMN_NAME":"列名2","COLUMN_VALUE":"列值2"}]}')
