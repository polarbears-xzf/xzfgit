-- Created in 2018.10.11 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		content_db_basic_status.sql
--	Description:
-- 		基本说明
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--

-- =======================================
-- 数据库基本状态信息
-- =======================================
	--是否RAC数据库状态
	--数据库归档状态
	--当前进程数、会话数
	--当前表空间数、数据文件数与控制文件数
	--当前热备状态文件数
	
set markup html off
prompt  <H3 class='zoecomm'> <center> 数据库基本状态信息 </center>  </H3>
set markup html on entmap off

column column1  format A80  heading '状态'
column column2  format A255 heading '状态值'

set markup html off
prompt  <center>
set markup html on entmap off
set markup html on table "WIDTH=600 BORDER=1"

select '是否集群数据库' as "column1",
       decode(value,'TRUE','是','FALSE','否',value)  as "column2"
from gv$parameter
where name = 'cluster_database'
union all
select '是否开启归档', decode(log_mode,'ARCHIVELOG','是','否') from v$database
union all
select '当前进程数',to_char(count(*)) from v$process
union all
select '当前会话数',to_char(count(*)) from v$session
union all
select '当前表空间数',to_char(count(*)) from v$tablespace
union all
select '当前数据文件数',to_char(count(*)) from v$datafile
union all
select '当前控制文件数',to_char(count(*)) from v$controlfile
union all
select '当前热备状态文件数',decode(count(status),0,'否',count(status)) from v$backup where status='ACTIVE';

prompt  </center>