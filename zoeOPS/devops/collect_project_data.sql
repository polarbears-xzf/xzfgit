-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		collect_project_date.sql
--	Description:
-- 		获取运维管理汇总主库的数据和控制文件用于数据加载
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--
SET SERVEROUTPUT ON 
SET ECHO OFF
SET VERI OFF
SET FEEDBACK OFF
SET TERMOUT OFF

SET LINESIZE 512
SET PAGESIZE 0

ALTER SESSION SET NLS_DATE_FORMAT='yyyy-mm-dd hh24:mi:ss';

DEFINE loadctl_path='c:\zoedir\scripts\'
DEFINE loaddata_path='c:\zoedir\data\'


--获取 ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO 数据和控制文件
DEFINE table_owner='ZOEDEVOPS'
DEFINE table_name='DVP_PROJ_DB_BASIC_INFO'
--		生成数据加载控制文件
SPOOL &loadctl_path.load&table_name..ctl
EXEC ZOEDEVOPS.ZOEPKG_SQLLDR.SQLLDR_GET_CTL('&loaddata_path' , '&table_owner' , '&table_name' )
SPOOL OFF
-- 		生成加载数据
VAR  v_column_data  VARCHAR2(4000)  
EXEC ZOEDEVOPS.ZOEPKG_SQLLDR.SQLLDR_GET_DATA('&table_owner' , '&table_name' , :v_column_data)
COLUMN column_list NEW_VALUE columnlist 
select :v_column_data as "column_list" from dual;

SPOOL &loaddata_path.load&table_name..csv
SELECT &columnlist  FROM &table_owner..&table_name;
SPOOL OFF

UNDEFINE table_owner
UNDEFINE table_name


--获取 ZOEDEVOPS.DVP_PROJ_DB_USER_ADMIN_INFO 数据和控制文件
DEFINE table_owner='ZOEDEVOPS'
DEFINE table_name='DVP_PROJ_DB_USER_ADMIN_INFO'
--		生成数据加载控制文件
SPOOL &loadctl_path.load&table_name..ctl
EXEC ZOEDEVOPS.ZOEPKG_SQLLDR.SQLLDR_GET_CTL('&loaddata_path' , '&table_owner' , '&table_name' )
SPOOL OFF
-- 		生成加载数据
VAR  v_column_data  VARCHAR2(4000)  
EXEC ZOEDEVOPS.ZOEPKG_SQLLDR.SQLLDR_GET_DATA('&table_owner' , '&table_name' , :v_column_data)
COLUMN column_list NEW_VALUE columnlist 
select :v_column_data as "column_list" from dual;

SPOOL &loaddata_path.load&table_name..csv
SELECT &columnlist  FROM &table_owner..&table_name;
SPOOL OFF

UNDEFINE table_owner
UNDEFINE table_name


--获取 ZOEDEVOPS.DVP_PROJ_SERVER_BASIC_INFO 数据和控制文件
DEFINE table_owner='ZOEDEVOPS'
DEFINE table_name='DVP_PROJ_SERVER_BASIC_INFO'
--		生成数据加载控制文件
SPOOL &loadctl_path.load&table_name..ctl
EXEC ZOEDEVOPS.ZOEPKG_SQLLDR.SQLLDR_GET_CTL('&loaddata_path' , '&table_owner' , '&table_name' )
SPOOL OFF
-- 		生成加载数据
VAR  v_column_data  VARCHAR2(4000)  
EXEC ZOEDEVOPS.ZOEPKG_SQLLDR.SQLLDR_GET_DATA('&table_owner' , '&table_name' , :v_column_data)
COLUMN column_list NEW_VALUE columnlist 
select :v_column_data as "column_list" from dual;

SPOOL &loaddata_path.load&table_name..csv
SELECT &columnlist  FROM &table_owner..&table_name;
SPOOL OFF

UNDEFINE table_owner
UNDEFINE table_name


--获取 ZOEDEVOPS.DVP_PROJ_SERVER_ADMIN_INFO 数据和控制文件
DEFINE table_owner='ZOEDEVOPS'
DEFINE table_name='DVP_PROJ_SERVER_ADMIN_INFO'
--		生成数据加载控制文件
SPOOL &loadctl_path.load&table_name..ctl
EXEC ZOEDEVOPS.ZOEPKG_SQLLDR.SQLLDR_GET_CTL('&loaddata_path' , '&table_owner' , '&table_name' )
SPOOL OFF
-- 		生成加载数据
VAR  v_column_data  VARCHAR2(4000)  
EXEC ZOEDEVOPS.ZOEPKG_SQLLDR.SQLLDR_GET_DATA('&table_owner' , '&table_name' , :v_column_data)
COLUMN column_list NEW_VALUE columnlist 
select :v_column_data as "column_list" from dual;

SPOOL &loaddata_path.load&table_name..csv
SELECT &columnlist  FROM &table_owner..&table_name;
SPOOL OFF

UNDEFINE table_owner
UNDEFINE table_name

UNDEFINE loadctl_path
UNDEFINE loaddata_path
