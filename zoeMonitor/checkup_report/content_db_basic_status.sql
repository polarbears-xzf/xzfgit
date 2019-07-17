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
	--数据库强制日志状态
	--数据库附加日志状态
	--当前进程数、会话数
	--当前表空间数、数据文件数与控制文件数
	--当前在线日志组数、成员数、大小
	--控制文件历史归档日志数
	--当前热备状态文件数
	
set markup html off
prompt  <H3 class='zoecomm'> <center> <a name="#00004"></a>数据库基本状态信息 </center>  </H3>
set markup html on entmap off

column column1  format A80  heading '状态'
column column2  format A255 heading '状态值'

set markup html off
prompt  <center>
set markup html on entmap off
set markup html on table "WIDTH=600 BORDER=1"

WITH cluster_or_not AS 
(select value from v$parameter where name = 'cluster_database')
select '是否集群数据库' as "column1", decode(value,'TRUE','是','FALSE','否',value)  as "column2" from cluster_or_not
union all
select '是否开启归档', decode(log_mode,'ARCHIVELOG','是','否') from v$database
union all
select '是否开启强制日志', decode(force_logging,'YES','是','否') from v$database
union all
select '是否开启附加日志', decode(supplemental_log_data_min,'YES','是','否') from v$database
union all
select '当前进程数',LISTAGG(decode(b.value,'TRUE','节点'||a.inst_id||' : ',null)||to_char(count(1)),'<br/>') within group(order by 2)  from gv$process a,cluster_or_not b group by decode(b.value,'TRUE','节点'||a.inst_id||' : ',null)
union all
select '当前会话数',LISTAGG(decode(b.value,'TRUE','节点'||a.inst_id||' : ',null)||to_char(count(1)),'<br/>') within group(order by 2)  from gv$session a,cluster_or_not b group by decode(b.value,'TRUE','节点'||a.inst_id||' : ',null)
union all
select '当前表空间数',to_char(count(*)) from v$tablespace
union all
select '当前数据文件数',to_char(count(*)) from v$datafile
union all
select '当前控制文件数',to_char(count(*)) from v$controlfile
union all
select '在线日志组数/成员数/大小',to_char(count(group#)/max(thread#)||'/'||max(members)||'/'||trunc(min(bytes)/1024/1024)||'M') from v$log
union all
select '历史归档日志数',to_char(records_total) from v$controlfile_record_section where type='ARCHIVED LOG'
union all
select '当前热备状态文件数',decode(count(status),0,'否',count(status)) from v$backup where status='ACTIVE'
union all 
SELECT '是否进行rman备份',decode(count(1),0,'否','<a  href="#rman_status">是(点击查看详细备份信息)</a>') FROM V$RMAN_STATUS WHERE OPERATION ='BACKUP'  AND STATUS NOT LIKE 'RUNNING%'
union all
select '用户失效对象数',LISTAGG(to_char(''||owner||'：'||count(1)),'<br/>') within group(order by count(1) desc) from dba_objects where status <> 'VALID' group by owner
union all
select '数据文件路径',LISTAGG(name,'<br/>')within group(order by name desc) from (select distinct SUBSTR(name,1,decode(instr(name,'/',-1),0,instr(name,'\',-1),instr(name,'/',-1)))as name from v$datafile)
union all
select 'TEMP文件路径',LISTAGG(name,'<br/>')within group(order by name desc) from (select distinct SUBSTR(name,1,decode(instr(name,'/',-1),0,instr(name,'\',-1),instr(name,'/',-1)))as name from v$tempfile);

prompt  <a  href="#top">Back to Top </a></center>