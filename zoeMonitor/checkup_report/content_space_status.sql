-- Created in 2018.10.11 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		content_space_status.sql
--	Description:
-- 		基本说明
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--

-- =======================================
-- Oracle空间状态信息
-- =======================================
	--数据库已分配空间大小与使用率
	--日志文件日均增长量
	--归档日志最大切换时间，最小切换时间和高峰期日志平均切换时间
	--表空间使用率
	--ASM磁盘组使用率
	--对象统计信息最近收集时间
	
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
select '日志日均增长量', trunc(a.total_size / b.days / 1024 / 1024) || 'MB'
  from (select Sum(Block_size * blocks) /
               decode(count(distinct dest_id), 0, 1, count(distinct dest_id)) total_size
          From gv$archived_log
         where standby_dest = 'NO') a,
       (select max(completion_time) - min(completion_time) days
          from gv$archived_log
         where standby_dest = 'NO') b
union all
select '最小日志切换时间' , trunc(min(next_time-first_time)*24*60,-2)||'分钟'
from v$archived_log
union all
select '最大日志切换时间' , trunc(max(next_time-first_time)*24*60,-2)||'分钟'
from v$archived_log
union all
SELECT '上午9-12点日志平均切换时间', decode(a.total_count,0,null,trunc(180/(a.total_count/b.days),2)||'分钟')
FROM
  (SELECT COUNT(*)/decode(count(distinct dest_id),0,1,count(distinct dest_id)) total_count
    FROM gv$archived_log
    WHERE to_number(TO_CHAR(completion_time,'hh24')) >= 9
      AND to_number(TO_CHAR(completion_time,'hh24')) < 12
      AND standby_dest='NO'
  ) a,
  (SELECT MAX(completion_time) - MIN(completion_time) days
  FROM gv$archived_log
 where standby_dest = 'NO'
  ) b
union all
SELECT '凌晨0-3点日志平均切换时间', decode(a.total_count,0,null,trunc(180/(a.total_count/b.days),2)||'分钟')
FROM
  (SELECT COUNT(*)/decode(count(distinct dest_id),0,1,count(distinct dest_id)) total_count
    FROM gv$archived_log
    WHERE to_number(TO_CHAR(completion_time,'hh24')) >= 0
      AND to_number(TO_CHAR(completion_time,'hh24')) < 3
      AND standby_dest='NO'
  ) a,
  (SELECT MAX(completion_time) - MIN(completion_time) days
  FROM gv$archived_log
 where standby_dest = 'NO'
  ) b
union all
select '表空间"'||tablespace_name||'"使用率:',pct_used||'%' from
(select tablespace_name,
       max_gb,
       used_gb,
       round(100 * used_gb / max_gb) pct_used
  from (select a.tablespace_name tablespace_name,
               round((a.bytes_alloc - nvl(b.bytes_free, 0)) / power(2, 30),
                     2) used_gb,
               round(a.maxbytes / power(2, 30), 2) max_gb
          from (select f.tablespace_name,
                       sum(f.bytes) bytes_alloc,
                       sum(decode(f.autoextensible,
                                  'YES',
                                  f.maxbytes,
                                  'NO',
                                  f.bytes)) maxbytes
                  from dba_data_files f
                 group by tablespace_name) a,
               (select f.tablespace_name, sum(f.bytes) bytes_free
                  from dba_free_space f
                 group by tablespace_name) b
         where a.tablespace_name = b.tablespace_name(+)) )
where pct_used>70 and  max_gb<used_gb+100
union all
select 'ASM磁盘组"'||name||'"使用率:',100-round(free_mb/total_mb * 100,2)||'%' pct_free from v$asm_diskgroup
union all
select '对象统计信息最近收集时间',to_char(max(last_analyzed)) from dba_tables
union all
select '表空间'||d.tablespace_name||'回滚段状态',s.STATUS from dba_rollback_segs d, v$rollstat s, v$rollname n where n.usn = s.USN and d.segment_name = n.name group by d.tablespace_name,s.status
;


prompt  </center>

