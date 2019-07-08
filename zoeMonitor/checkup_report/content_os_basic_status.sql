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
-- 操作系统基本状态信息
-- =======================================
	--	CPU
	--	内存
	--	磁盘
	
/*
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
*/

set markup html off

prompt  <H3 class='zoecomm'>  <center> 操作系统基本状态信息 </center> </H3> <br>

--操作系统活动cpu个数
column NUM_CPUS  NEW_VALUE CPUS noprint
select value "NUM_CPUS" from v$osstat where STAT_NAME='NUM_CPUS';
--操作系统物理内存大小
column PHYSICAL_MEMORY_BYTES NEW_VALUE MEMORYBYTES noprint
select ''||round(value/1024/1024/1024,2)||'G' as "PHYSICAL_MEMORY_BYTES" from v$osstat where STAT_NAME='PHYSICAL_MEMORY_BYTES';
--定义服务器ip信息
column ips  NEW_VALUE ips noprint
select (LISTAGG('节点'||inst_id||'   机器名: '||host_name||'   IP: '||utl_inaddr.get_host_address(host_name)||'','<br />')WITHIN GROUP(ORDER BY inst_id))as "ips" from gv$instance order by inst_id;
--定义操作系统类型
column platform_name  NEW_VALUE platform noprint
/*select platform_name as "platform_name" from dba_hist_database_instance WHERE ROWNUM <= 1; 10g版本没有platform_name字段*/
select PLATFORM_NAME as "platform_name" from V$DATABASE;
--定义VM_IN_BYTES
column VM_IN_BYTES  NEW_VALUE VM_IN_BYTES noprint
select to_char(value) "VM_IN_BYTES" from v$osstat where STAT_NAME='VM_IN_BYTES';
--定义VM_OUT_BYTES
column VM_OUT_BYTES  NEW_VALUE VM_OUT_BYTES noprint
select to_char(value) "VM_OUT_BYTES" from v$osstat where STAT_NAME='VM_OUT_BYTES';


prompt  <center> <table WIDTH=600 BORDER=1> 

  prompt  <tr>
      prompt <th> 属性 </th>
      prompt <th> 属性值 </th>
  prompt  </tr>
  prompt  <tr>
    prompt  <td> 活动CPU个数 </td>
    prompt  <td> &CPUS  </td>
  prompt  </tr>
  prompt  <tr>
    prompt  <td> 操作系统物理内存大小 </td>
    prompt  <td> &MEMORYBYTES  </td>
  prompt  </tr>
  prompt  <tr>
		prompt  <td> 操作系统类型 </td>
		prompt  <td> &platform  </td>
  prompt  </tr>
  prompt  <tr>
		prompt  <td> 服务器ip信息</td>
		prompt  <td> &ips </td>
  prompt  </tr>
  prompt  <tr>
    prompt  <td> 由于虚拟内存交换而调入的字节数 </td>
    prompt  <td> &VM_IN_BYTES  </td>
  prompt  </tr>
  prompt  <tr>
    prompt  <td> 由于虚拟内存交换而调出的字节数</td>
    prompt  <td> &VM_OUT_BYTES </td>
  prompt  </tr>
  prompt </table>  </center> <br> <br>



