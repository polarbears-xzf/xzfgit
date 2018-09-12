-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		checkup_database.sql
--	Description:
-- 		数据库健康检查
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
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
define reportPath="/home/oracle/zoesrc/output/"
define reportName="checkup_test"
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
spool &reportPath&reportName._&reportTime..html
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
select '数据库自"'||to_char(startup_time,'yyyy-mm-dd')||'"启动以来运行了'||trunc(sysdate-startup_time)||'天'  AS "运行时间"
from v$instance;

-- =======================================
-- 获取Oracle非默认初始化参数设置
-- =======================================
prompt  <H3 class='zoecomm'> 
prompt  <center>非默认初始化参数</center>
prompt  </H3>
column column1  format A80  heading '参数名'
column column2  format A255 heading '参数值'
column column3  format 99 heading   '实例号'

set markup html on table "WIDTH=500 BORDER=1"
prompt  <center>
-- select '<A HREF="http://oracle.com/'||name||'.html">'||name||'</A>' "column1",value "column2"
select inst_id as "column3",name as "column1",value as "column2"
from gv$spparameter 
where isspecified = 'TRUE'
order by inst_id , name ;
prompt  </center>

-- =======================================
-- 获取Oracle基本状态信息
-- =======================================
	--获取是否RAC数据库状态，数据库名称，网络服务名称
	--获取表空间数、数据文件数与控制文件数
	--获取数据库归档状态
prompt  <H3 class='zoecomm'> 
prompt  <center>数据库基本状态信息 </center>
prompt  </H3>

set markup html on table "WIDTH=500 BORDER=1"
prompt  <center>
select decode(name,'cluster_database','Cluster DB','db_name','db_name','service_name','service_name',name),
       decode(value,'TRUE','YES','FALSE','NO',value) 
from gv$parameter
where name in ('cluster_database','db_name','service_name')
union 
select 'Number of Tablespace',to_char(count(*)) from v$tablespace
union 
select 'Number of Datafile',to_char(count(*)) from v$datafile
union
select 'Number of Controlfile',to_char(count(*)) from v$controlfile
union
select 'Whether is Archvie', decode(log_mode,'ARCHIVELOG','YES','NO') from v$database
union 
select 'Whether abnormal status of backup ',decode(count(status),0,'NO',count(status)) from v$backup where status='ACTIVE'
union 
select 'Time per Log Switch', decode(count(1),0,'无归档日志',trunc(180*30/count(1),1)||'Minute') From v$archived_log a
Where to_number(to_char(a.completion_time,'hh24')) > 9 
      And to_number(to_char(a.completion_time,'hh24')) < 12
      And dest_id=1 and a.completion_time > sysdate - 30
union
select 'Log growth per Day', trunc(Sum(Block_size*blocks)/30/1024/1204)||'MB' From gv$archived_log a
Where completion_time < Sysdate
      And completion_time > Sysdate - 30
      And dest_id=1
union
select 'DB Size/Used/Rate', 
       trunc(sum(a.bytes)/1024/1024/1024,2)||'G/'||trunc((sum(a.bytes)-sum(b.bytes))/1024/1024/1024,2)||'G/'||trunc((1-sum(b.bytes)/sum(a.bytes))*100,2)||'%' 
from dba_data_files a, (select tablespace_name,file_id,sum(bytes) bytes from dba_free_space group by tablespace_name,file_id) b
where a.tablespace_name=b.tablespace_name(+) and a.file_id=b.file_id(+);
prompt  </center>










set markup html off
spool off 




