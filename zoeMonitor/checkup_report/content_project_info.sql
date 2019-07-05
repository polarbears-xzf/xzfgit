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
--定义操作系统类型
column platform_name  NEW_VALUE platform noprint
/*select platform_name as "platform_name" from dba_hist_database_instance WHERE ROWNUM <= 1; 10g版本没有platform_name字段*/
select PLATFORM_NAME as "platform_name" from V$DATABASE;
--定义数据库创建时间
column dbcreate  NEW_VALUE db_create noprint
select created as "dbcreate" from V$DATABASE;
--定义服务器ip信息
column ips  NEW_VALUE ips noprint
select (LISTAGG('节点'||inst_id||'  机器名: '||host_name||'  ip: '||utl_inaddr.get_host_address(host_name)||'','</td>')WITHIN GROUP(ORDER BY inst_id))as "ips" from gv$instance order by inst_id;

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
	prompt  <tr>
		prompt  <td> 操作系统类型 </td>
		prompt  <td> &platform  </td>
	prompt  </tr>
	prompt  </tr>
		prompt  <tr>
		prompt  <td> 服务器ip信息</td>
		prompt  <td> &ips </td>
	prompt  </tr>
	prompt </table>  </center> <br> <br>

