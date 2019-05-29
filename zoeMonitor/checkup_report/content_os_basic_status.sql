-- Created in 2018.10.11 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		content_os_basic_status.sql
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
	--	CPU
	--	内存
	--	磁盘
	
set markup html off
prompt  <H3 class='zoecomm'> <center> 操作基本状态信息 </center>  </H3>
set markup html on entmap off

column column1  format A80  heading '状态'
column column2  format 9999999999999 heading '状态值'

set markup html off
prompt  <center>
set markup html on entmap off
set markup html on table "WIDTH=600 BORDER=1"

select STAT_NAME as "column1",
       value  as "column2"
from v$osstat
where STAT_NAME IN ('NUM_CPUS','','PHYSICAL_MEMORY_BYTES','FREE_MEMORY_BYTES','VM_IN_BYTES','VM_OUT_BYTES');

prompt  </center>

