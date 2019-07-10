-- Created in 2018.10.11 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		content_project_info.sql
--	Description:
-- 		基本说明
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--


-- =======================================
-- 项目基本信息
-- =======================================
	--	巡检系统名称
	--	操作系统版本
	--  数据库名称
	--	数据库版本
	--  数据库创建时间	
    --  服务器ip信息


set markup html off


prompt  <H3 class='zoecomm'>  <center> 项目基本信息 </center> </H3> <br>

--定义巡检系统
column systemname  NEW_VALUE systemname noprint
select decode('&checkupSystem','his','HIS系统','emr','EMR系统','hdc','HDC系统','hip','HIP系统','其它系统') as "systemname" from dual;
--定义数据库名称
column db_name  NEW_VALUE db_name noprint
select value as "db_name" from V$parameter  where name='db_name';
--定义数据库版本
column banner  NEW_VALUE db_version noprint
select banner as "banner" from v$version where banner like 'Oracle Database%';
--定义数据库创建时间
column dbcreate  NEW_VALUE db_create noprint
select created as "dbcreate" from V$DATABASE;
--定义数据库大小
column db_size  NEW_VALUE db_size noprint
select ''||round(sum(bytes)/1024/1024/1024,2)||'G' as "db_size" from dba_data_files;


prompt  <center> <table WIDTH=600 BORDER=1> 

	prompt  <tr>
			prompt <th> 属性 </th>
			prompt <th> 属性值 </th>
	prompt  </tr>
	prompt  <tr>
		prompt  <td> 系统名称 </td>
		prompt  <td> &systemname  </td>
	prompt  </tr>
	prompt  <tr>
		prompt  <td> 数据库名称 </td>
		prompt  <td> &db_name  </td>
	prompt  </tr>
	prompt  <tr>
		prompt  <td> 数据库版本 </td>
		prompt  <td> &db_version  </td>
	prompt  </tr>
	prompt  <tr>
		prompt  <td> 数据库创建时间</td>
		prompt  <td> &db_create </td>
	prompt  </tr>
	prompt  <tr>
		prompt  <td> 数据库大小</td>
		prompt  <td> &db_size </td>
	prompt  </tr>
	prompt </table>  </center> <br> <br>

