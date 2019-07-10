-- Created in 2018.10.11 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		content_init_parameter.sql
--	Description:
-- 		基本说明
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述


---- =======================================
-- Oracle表空间使用情况
-- =======================================
set markup html off
prompt  <H3 class='zoecomm'>  <center><a name="#00007"></a>表空间使用情况</center>  </H3>
set markup html on entmap off

column column1  format A80  heading '表空间名'
column column2  format A30  heading '总大小'
column column3  format A30  heading '已使用大小'
column column4  format A30  heading '使用率'
column column5  format A30  heading '序号'

set markup html off
prompt  <center>
set markup html on entmap off

set markup html on table "WIDTH=600 BORDER=1"

select to_char(rownum) as "column5",
       to_char(tablespace_name) as "column1",
       rtrim(to_char(max_gb,'fm9990.99'), '.')||'G' as "column2",
       rtrim(to_char(used_gb,'fm9990.99'), '.')||'G' as "column3",
       to_char(round(100 * used_gb / max_gb))||'%' as "column4"
     from
(select 
   tablespace_name,
       max_gb,
       used_gb,
       (round(100 * used_gb / max_gb))
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
         where a.tablespace_name = b.tablespace_name(+)
        union all
        select h.tablespace_name tablespace_name,
               round(sum(nvl(p.bytes_used, 0)) / power(2, 30), 2) used_gb,
               round(sum(decode(f.autoextensible,
                                'YES',
                                f.maxbytes,
                                'NO',
                                f.bytes)) / power(2, 30),
                     2) max_gb
          from v$temp_space_header h, v$temp_extent_pool p, dba_temp_files f
         where p.file_id(+) = h.file_id
           and p.tablespace_name(+) = h.tablespace_name
           and f.file_id = h.file_id
           and f.tablespace_name = h.tablespace_name
         group by h.tablespace_name)
order by 4);

prompt   <a  href="#top">Back to Top </a></center>
