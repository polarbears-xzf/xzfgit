-- Created in 2017.10.10 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoe_aud_create_user.sql
--	Description:
-- 		创建智业安全系统数据库用户
--  Relation:
--      
--	Notes:
--		
--	修改 - （年-月-日） - 描述

--创建表空间
create tablespace ZOESECURITY_TAB
datafile 'path/zoesecurity_tab01.ora' size 10M
autoextend on next 10M maxsize UNLIMITED;

--创建用户
create user ZOESECURITY identified by "zoe$2017scrt";

--授权系统权限
grant ADMINISTER DATABASE TRIGGER,CREATE JOB,
	CREATE PROCEDURE,CREATE SESSION,CREATE TABLE,
	CREATE TRIGGER,CREATE VIEW,CREATE TYPE,
	CREATE ANY CONTEXT,DROP ANY CONTEXT,
	UNLIMITED TABLESPACE to ZOESECURITY;
--授权包执行权限	
GRANT EXECUTE ON SYS.DBMS_RLS TO ZOESECURITY;
