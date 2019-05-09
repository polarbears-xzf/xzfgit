-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		checkup_database.sql
--	Description:
-- 		数据库健康检查
--  Relation:
--      
--	Notes:
--		修改报告路径
--			Windows平台
--				c:\zoedir\zoerpt\
--			Linux平台
--				/var/log/zoedir/zoerpt/
--		修改日志增量部分语法
--			Windows平台
--				SELECT DISTINCT SUBSTR(name,instr(name,'\'
--			Linux平台
--				SELECT DISTINCT SUBSTR(name,instr(name,'/'

--	修改 - （年-月-日） - 描述
--

-- =======================================
-- 脚本说明
-- =======================================
-- SQLPLUS环境设置说明
	-- set echo off        关闭执行的SQL语句回显，缺省为on
	-- set feedback off    关闭执行的SQL语句执行返回结果函数显示，缺省为on
	-- set termout off     关闭在屏幕上的输出，这样可以加快spool执行速度
	-- set verity off      关闭显示替换变量后的语句，缺省为on
	-- set wrap off        关闭超过行宽度是自动换行，缺省为on
	-- set trimout off     去掉标准输出行尾空格，缺省为off
	-- set trimspool on    去掉重定向（spool）输出行尾空格，缺省为off
	-- set heading on      显示标题，缺省为on
	-- set colsep' '       设置输出分隔符
	-- set long  1000      设置LONG, BLOB, BFILE, CLOB, NCLOB and XML行宽度为1000
	-- set linesize 200    设置行宽度为200
	-- set pagesize 1000   设置一页显示1000行，0为不分页
-- HTML格式配置说明
	-- entmap [on|off]     用于打开或关闭Sqlplus中指定标示替换，如 <, >, " and & 替换 &lt;, &gt;, &quot; and &amp; 默认值为on
	-- spool [on|off]      是否自动添加<html> <body>标志，如果是在spool filename 和 spool off时添加
	-- pre[format][on|off] 是否使用<pre>标志还是使用html table，默认为off（即html table）
	-- markup   
		-- pagesize 表示一个html table的行数，TTITLE, BTITLE and column headings 在pagesize row 重复
		-- lizesize 在wrapping is on或很长的数据时有影响，输出可能生成分离的行，并且浏览器可能[把换行]理解成空字符
		-- TTITLE and BTITLE content is output to three line positions: left, 
			--center and right, and the maximum line width is preset to 90% of the browser window. 
			--These elements may not align with the main output as expected due to the way they are handled for web output. 
			--Entity mapping in TTITLE and BTITLE is the same as the general ENTMAP setting specified in the MARKUP command 
			-- If you use a title in your output, then SQL*Plus starts a new HTML table for output rows that appear after the title. 
			--Your browser may format column widths of each table differently, depending on the width of data in each column.
		-- SET COLSEP, RECSEP and UNDERLINE only produce output in HTML reports when PREFORMAT is ON
		
-- =======================================
-- 设置SQLPLUS环境
-- =======================================
set echo          off
set feedback      off
set verify        off
set termout       off
set trimspool     off
set trimout       off
set serveroutput  on   size 1000000
set linesize 999
set long     9999
set pagesize 9999
alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';
-- =======================================
-- 定义报表变量
-- =======================================

define porjectName="厦门市卫计委"
define porjectCode="xmswjw"
define reportType="zoeOradb"
define checkupSystem="his"
define reportPath="c:\zoedir\zoerpt\"
-- "
column report_time NEW_VALUE reportTime noprint
select to_char(sysdate,'yyyymmdd') as "report_time" from dual;

-- =======================================
-- 定义HTML格式
-- =======================================
set markup html on spool on preformat off entmap on -
	head ' -
		<title>健康检查报告</title> -
		<style type="text/css"> -
			body.zoecomm {font:bold 10pt Arial,Helvetica,Geneva,sans-serif;color:black; background:White;} -
			pre.zoecomm    {font:8pt Courier;color:black; background:White;} -
			th  {font:bold 8pt Arial,Helvetica,Geneva,sans-serif; color:White; background:#0066CC;padding-left:4px; padding-right:4px;padding-bottom:2px} -
			td  {font:8pt Arial,Helvetica,Geneva,sans-serif;color:black;background:#FFFFCC; vertical-align:top;} -
			h1.zoecomm     {font:bold 20pt Arial,Helvetica,Geneva,sans-serif;color:#336699;background-color:White;border-bottom:1px solid #cccc99;margin-top:0pt; margin-bottom:0pt;padding:0px 0px 0px 0px;} -
			h2.zoecomm     {font:bold 18pt Arial,Helvetica,Geneva,sans-serif;color:#336699;background-color:White;margin-top:4pt; margin-bottom:0pt;} -
			h3.zoecomm     {font:bold 16pt Arial,Helvetica,Geneva,sans-serif;color:#336699;background-color:White;margin-top:4pt; margin-bottom:0pt;} -
			li.zoecomm     {font: 8pt Arial,Helvetica,Geneva,sans-serif; color:black; background:White;} -
			th.zoecommnobg {font:bold 8pt Arial,Helvetica,Geneva,sans-serif; color:black; background:White;padding-left:4px; padding-right:4px;padding-bottom:2px} -
			th.zoecommbg   {font:bold 8pt Arial,Helvetica,Geneva,sans-serif; color:White; background:#0066CC;padding-left:4px; padding-right:4px;padding-bottom:2px} -
			td.zoecommnc   {font:8pt Arial,Helvetica,Geneva,sans-serif;color:black;background:White;vertical-align:top;} -
			td.zoecommc    {font:8pt Arial,Helvetica,Geneva,sans-serif;color:black;background:#FFFFCC; vertical-align:top;} -
			a.zoecomm      {font:bold 8pt Arial,Helvetica,sans-serif;color:#663300; vertical-align:top;margin-top:0pt; margin-bottom:0pt;} -
		</style>' -
	body 'class="zoecomm"'


	
-- =======================================
-- 开始生成报告
-- =======================================
spool &reportPath&reportType._&checkupSystem._&porjectCode._&reportTime..html
set markup html on entmap off


-- =======================================
-- 报告题头
-- =======================================
prompt  <H1 class='zoecomm'> 
prompt  <center>&porjectName 健康检查报告</center> 
prompt  </H1>
prompt  <center><hr>Copyright (c) 2018-2020 <a target=""_blank"" href=""http://www.zoesoft.com.cn/"">智业软件股份有限公司</a>. All rights reserved.</center>

-- =======================================
-- 获取数据库运行时间
-- =======================================
set markup html on table "WIDTH=600 BORDER=1"
prompt  <center>
select TO_CHAR(SYSDATE,'yyyy-mm-dd hh24:mi:ss') AS "报告时间",
	'数据库自'||to_char(startup_time,'yyyy-mm-dd')||'启动以来运行了'||trunc(sysdate-startup_time)||'天'  AS "运行时间"
from v$instance;
prompt  </center>

-- =======================================
-- 系统综合评价
-- =======================================
prompt  <H2 class='zoecomm'> 系统综合评价 </H2>

@@alert_db_deploy.sql
set markup html on entmap off

-- =======================================
-- 数据库配置信息
-- =======================================
@@config_db.sql
set markup html on entmap off

-- =======================================
-- Oracle部署状态信息
-- =======================================
	--是否RAC数据库状态
	--数据库归档状态
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
select '当前表空间数',to_char(count(*)) from v$tablespace
union all
select '当前数据文件数',to_char(count(*)) from v$datafile
union all
select '当前控制文件数',to_char(count(*)) from v$controlfile
union all
select '当前热备状态文件数',decode(count(status),0,'否',count(status)) from v$backup where status='ACTIVE';

prompt  </center>

-- =======================================
-- Oracle空间状态信息
-- =======================================
	--数据库已分配空间大小与使用率
	--日志文件日均增长量
	--归档日志最大切换时间，最小切换时间和高峰期日志平均切换时间
	
set markup html off
prompt  <H3 class='zoecomm'> <center>数据库空间状态信息 </center> </H3>
set markup html on entmap off

column column1  format A80  heading '状态'
column column2  format A255 heading '状态值'

set markup html off
prompt  <center>
set markup html on entmap off

set markup html on table "WIDTH=600 BORDER=1"

select '当前数据库大小/已使用空间/使用率'  as "column1", 
       trunc(sum(a.bytes)/1024/1024/1024,2)||'G/'||trunc((sum(a.bytes)-sum(b.bytes))/1024/1024/1024,2)||'G/'||trunc((1-sum(b.bytes)/sum(a.bytes))*100,2)||'%'    as "column2"
from dba_data_files a, (select tablespace_name,file_id,sum(bytes) bytes from dba_free_space group by tablespace_name,file_id) b
where a.tablespace_name=b.tablespace_name(+) and a.file_id=b.file_id(+)
union all
select '日志日均增长量', trunc(a.total_size/b.days/1024/1024)||'MB' from 
(select Sum(Block_size*blocks) total_size
From  (select distinct substr(name,instr(name,'/',-1)+1),blocks,block_size
from gv$archived_log)) a,
(select max(completion_time)-min(completion_time) days from gv$archived_log) b
union all
select '最小日志切换时间' , trunc(min(next_time-first_time)*24*60,-2)||'分钟'
from v$archived_log
union all
select '最大日志切换时间' , trunc(max(next_time-first_time)*24*60,-2)||'分钟'
from v$archived_log
union all
SELECT '上午9-12点日志平均切换时间', trunc(180/(a.total_count/b.days),-2)||'分钟'
FROM
  (SELECT COUNT(1) total_count
  FROM
    (SELECT DISTINCT SUBSTR(name,instr(name,'/',-1)+1)
    FROM gv$archived_log
    WHERE to_number(TO_CHAR(completion_time,'hh24')) > 9
      AND to_number(TO_CHAR(completion_time,'hh24')) < 12
    )
  ) a,
  (SELECT MAX(completion_time)-MIN(completion_time) days FROM gv$archived_log
  ) b
union all
SELECT '凌晨0-3点日志平均切换时间', trunc(180/(a.total_count/b.days),-2)||'分钟'
FROM
  (SELECT COUNT(1) total_count
  FROM
    (SELECT DISTINCT SUBSTR(name,instr(name,'/',-1)+1)
    FROM gv$archived_log
    WHERE to_number(TO_CHAR(completion_time,'hh24')) > 0
      AND to_number(TO_CHAR(completion_time,'hh24')) < 3
    )
  ) a,
  (SELECT MAX(completion_time)-MIN(completion_time) days FROM gv$archived_log
  ) b;

prompt  </center>

-- =======================================
-- Oracle非默认初始化参数设置
-- =======================================
set markup html off
prompt  <H3 class='zoecomm'>  <center>非默认初始化参数</center>  </H3>
set markup html on entmap off

column column1  format A80  heading '参数名'
column column2  format A255 heading '参数值'
column column3  format 99   heading '实例号'

set markup html off
prompt  <center>
set markup html on entmap off

set markup html on table "WIDTH=600 BORDER=1"
-- select '<A HREF="http://oracle.com/'||name||'.html">'||name||'</A>' "column1",value "column2"
select * from (
select inst_id as "column3",name as "column1",value as "column2"
from gv$system_parameter
where ISDEFAULT = 'FALSE'
order by inst_id , name)
union all
select to_number(''),'合计',to_char(count(*))
from gv$system_parameter
where ISDEFAULT = 'FALSE';

prompt  </center>











set markup html off
spool off 


undefine

