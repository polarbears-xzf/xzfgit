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
prompt  <H3 class='zoecomm'>  <center><a name="rman_status"></a>RMAN备份情况(最近10条记录)</center>  </H3>
set markup html on entmap off

column column1  format A30  heading '类型'
column column2  format A30  heading '级别'
column column3  format A30  heading '备份目录'
column column4  format A30  heading '包含CTL'
column column6  format A30  heading '开始时间'
column column7  format A30  heading '完成时间'
column column8  format A30  heading '大小'
column column5  format A30  heading '备份状态'

set markup html off
prompt  <center>
set markup html on entmap off

set markup html on table "WIDTH=600 BORDER=1"

select a.OBJECT_TYPE as "column1",
       column2 as "column2",
       a.HANDLE as "column3",
       a.CONTROLFILE_INCLUDED as "column4",
       a.START_TIME as "column6",
       to_char(a.ELAPSED_SECONDS) as "column7",
       rtrim(to_char(a.BYTES / 1024 / 1024 / 1024, 'fm9990.99'), '.') || 'G' as "column8",
       decode(a.STATUS, 'COMPLETED', '完成', '') as "column5"
  from (SELECT t.OBJECT_TYPE,
               DECODE(B.INCREMENTAL_LEVEL,
                      '',
                      DECODE(BACKUP_TYPE, 'L', 'Archivelog', 'Full'),
                      1,
                      'Incr-1级',
                      0,
                      'Incr-0级',
                      B.INCREMENTAL_LEVEL) as column2,
               A.HANDLE,
               B.CONTROLFILE_INCLUDED,
               A.START_TIME,
               A.ELAPSED_SECONDS,
               A.BYTES,
               t.STATUS
          FROM V$RMAN_STATUS t, GV$BACKUP_PIECE A, GV$BACKUP_SET B
         WHERE t.OPERATION = 'BACKUP'
           AND t.STATUS = 'COMPLETED'
           and A.SET_STAMP = B.SET_STAMP
           AND A.DELETED = 'NO'
           and t.STAMP = a.RMAN_STATUS_STAMP
         ORDER BY A.COMPLETION_TIME desc) a
 where rownum <= 10;


 set markup html on entmap off

column column9  format A30  heading '类型'
column column10  format A30  heading '备份时间'
column column11  format A30  heading '备份状态'

set markup html off
prompt  <center>
set markup html on entmap off

set markup html on table "WIDTH=600 BORDER=1"

select a.object_type as "column9",
       a.start_time as "column10",
       decode(a.status, 'COMPLETED', '', '失败') as "column11"
  from (SELECT object_type, start_time, status
          FROM V$RMAN_STATUS
         WHERE OPERATION = 'BACKUP'
           AND STATUS != 'COMPLETED'
           AND STATUS NOT LIKE 'RUNNING%'
         order by start_time desc) a
 where rownum <= 10;

prompt   <a  href="#top">Back to Top </a></center>

