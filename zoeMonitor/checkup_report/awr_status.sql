-- Created in 2018.10.11 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		alert_db_physic.sql
--	Description:
-- 		基本说明
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--
---检查指标
	--Top 5 Foreground Events by Total Wait Time
	--
	--

set markup html off
prompt  <H3 class='zoecomm'>  <center><a name="#awr_status"></a>性能报告指标</center>  </H3>

declare
z_beg_snap number(20);
z_end_snap number(20);
z_DBID     number(20);
z_INST_NUM number(20);
L_z_DBID   number(20);

  --查询TOP5等待事件
 cursor TOP is
    SELECT EVENT,
           WAITS,
           trunc(TIME,2) time,
           trunc(DECODE(WAITS,
                        NULL,
                        TO_NUMBER(NULL),
                        0,
                        TO_NUMBER(NULL),
                        TIME / WAITS * 1000),2) AVGWT,
           trunc(PCTWTT, 2) pctwtt,
           WAIT_CLASS
      FROM (SELECT EVENT, WAITS, TIME, PCTWTT, WAIT_CLASS
              FROM (SELECT E.EVENT_NAME EVENT,
                           E.TOTAL_WAITS_FG - NVL(B.TOTAL_WAITS_FG, 0) WAITS,
                           (E.TIME_WAITED_MICRO_FG -
                           NVL(B.TIME_WAITED_MICRO_FG, 0)) / 1000000 TIME,
                           100 * (E.TIME_WAITED_MICRO_FG -
                           NVL(B.TIME_WAITED_MICRO_FG, 0)) /
                           ((SELECT sum(value)
                               FROM DBA_HIST_SYS_TIME_MODEL e
                              WHERE e.SNAP_ID = z_end_snap
                                AND e.DBID = z_DBID
                                AND e.INSTANCE_NUMBER = z_INST_NUM
                                AND e.STAT_NAME = 'DB time') -
                           (SELECT sum(value)
                               FROM DBA_HIST_SYS_TIME_MODEL b
                              WHERE b.SNAP_ID = z_beg_snap
                                AND b.DBID = z_DBID
                                AND b.INSTANCE_NUMBER = z_INST_NUM
                                AND b.STAT_NAME = 'DB time')) PCTWTT,
                           E.WAIT_CLASS WAIT_CLASS
                      FROM DBA_HIST_SYSTEM_EVENT B, DBA_HIST_SYSTEM_EVENT E
                     WHERE B.SNAP_ID(+) = z_beg_snap
                       AND E.SNAP_ID = z_end_snap
                       AND B.DBID(+) = z_DBID
                       AND E.DBID = z_DBID
                       AND B.INSTANCE_NUMBER(+) = z_INST_NUM
                       AND E.INSTANCE_NUMBER = z_INST_NUM
                       AND B.EVENT_ID(+) = E.EVENT_ID
                       AND E.TOTAL_WAITS_FG > NVL(B.TOTAL_WAITS_FG, 0)
                       AND E.WAIT_CLASS != 'Idle'
                    UNION ALL
                    SELECT 'CPU time' EVENT,
                           TO_NUMBER(NULL) WAITS,
                           ((SELECT sum(value)
                               FROM DBA_HIST_SYS_TIME_MODEL e
                              WHERE e.SNAP_ID = z_end_snap
                                AND e.DBID = z_DBID
                                AND e.INSTANCE_NUMBER = z_INST_NUM
                                AND e.STAT_NAME = 'DB CPU') -
                           (SELECT sum(value)
                               FROM DBA_HIST_SYS_TIME_MODEL b
                              WHERE b.SNAP_ID = z_beg_snap
                                AND b.DBID = z_DBID
                                AND b.INSTANCE_NUMBER = z_INST_NUM
                                AND b.STAT_NAME = 'DB CPU')) / 1000000 TIME,
                           100 * ((SELECT sum(value)
                                     FROM DBA_HIST_SYS_TIME_MODEL e
                                    WHERE e.SNAP_ID = z_end_snap
                                      AND e.DBID = z_DBID
                                      AND e.INSTANCE_NUMBER = z_INST_NUM
                                      AND e.STAT_NAME = 'DB CPU') -
                           (SELECT sum(value)
                                     FROM DBA_HIST_SYS_TIME_MODEL b
                                    WHERE b.SNAP_ID = z_beg_snap
                                      AND b.DBID = z_DBID
                                      AND b.INSTANCE_NUMBER = z_INST_NUM
                                      AND b.STAT_NAME = 'DB CPU')) /
                           ((SELECT sum(value)
                               FROM DBA_HIST_SYS_TIME_MODEL e
                              WHERE e.SNAP_ID = z_end_snap
                                AND e.DBID = L_z_DBID
                                AND e.INSTANCE_NUMBER = z_INST_NUM
                                AND e.STAT_NAME = 'DB time') -
                           (SELECT sum(value)
                               FROM DBA_HIST_SYS_TIME_MODEL b
                              WHERE b.SNAP_ID = z_beg_snap
                                AND b.DBID = z_DBID
                                AND b.INSTANCE_NUMBER = z_INST_NUM
                                AND b.STAT_NAME = 'DB time')) PCTWTT,
                           NULL WAIT_CLASS
                      from dual
                     WHERE ((SELECT sum(value)
                               FROM DBA_HIST_SYS_TIME_MODEL e
                              WHERE e.SNAP_ID = z_end_snap
                                AND e.DBID = z_DBID
                                AND e.INSTANCE_NUMBER = z_INST_NUM
                                AND e.STAT_NAME = 'DB CPU') -
                           (SELECT sum(value)
                               FROM DBA_HIST_SYS_TIME_MODEL b
                              WHERE b.SNAP_ID = z_beg_snap
                                AND b.DBID = z_DBID
                                AND b.INSTANCE_NUMBER = z_INST_NUM
                                AND b.STAT_NAME = 'DB CPU')) > 0)
             ORDER BY TIME DESC, WAITS DESC)
     WHERE ROWNUM <= 5;

-- load_profile
cursor load_profile is 
-- redo size
select 'redo size' as name,
       to_char(round((SELECT sum(e.value) - sum(b.value)
                FROM DBA_HIST_SYSSTAT e, DBA_HIST_SYSSTAT b
               WHERE e.SNAP_ID = z_end_snap
                 AND e.DBID = z_dbid
                 AND e.INSTANCE_NUMBER = z_INST_NUM
                 AND e.STAT_NAME = 'redo size'
                 and b.SNAP_ID = z_beg_snap
                 AND b.DBID = z_dbid
                 AND b.INSTANCE_NUMBER = z_INST_NUM
                 AND b.STAT_NAME = 'redo size') /
             (SELECT EXTRACT(DAY FROM
                             E.END_INTERVAL_TIME - B.END_INTERVAL_TIME) *
                     86400 + EXTRACT(HOUR FROM E.END_INTERVAL_TIME -
                                     B.END_INTERVAL_TIME) * 3600 +
                     EXTRACT(MINUTE FROM
                             E.END_INTERVAL_TIME - B.END_INTERVAL_TIME) * 60 +
                     EXTRACT(SECOND FROM
                             E.END_INTERVAL_TIME - B.END_INTERVAL_TIME)
                FROM DBA_HIST_SNAPSHOT B, DBA_HIST_SNAPSHOT E
               where e.snap_id = z_end_snap
                 and b.snap_id = z_beg_snap
                 AND b.DBID = z_dbid
                 AND b.INSTANCE_NUMBER = z_INST_NUM
                 AND e.DBID = z_dbid
                 AND e.INSTANCE_NUMBER = z_INST_NUM),
             2)) as per_second,
       to_char(round(((SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT e
                WHERE e.SNAP_ID = z_end_snap
                  AND e.DBID = z_dbid
                  AND e.INSTANCE_NUMBER = z_INST_NUM
                  AND e.STAT_NAME in ('redo size')) -
             (SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT b
                WHERE b.SNAP_ID = z_beg_snap
                  AND b.DBID = z_dbid
                  AND b.INSTANCE_NUMBER = z_INST_NUM
                  AND b.STAT_NAME in ('redo size'))) /
             ((SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT e
                WHERE e.SNAP_ID = z_end_snap
                  AND e.DBID = z_dbid
                  AND e.INSTANCE_NUMBER = z_INST_NUM
                  AND e.STAT_NAME in ('user rollbacks', 'user commits')) -
             (SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT b
                WHERE b.SNAP_ID = z_beg_snap
                  AND b.DBID = z_dbid
                  AND b.INSTANCE_NUMBER = z_INST_NUM
                  AND b.STAT_NAME in ('user rollbacks', 'user commits'))),
             2)) as per_transaction
  from dual
union all
---- Logical reads
select 'Logical reads' as name,
       to_char(round(((SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT e
                WHERE e.SNAP_ID = z_end_snap
                  AND e.DBID = z_dbid
                  AND e.INSTANCE_NUMBER = z_INST_NUM
                  AND e.STAT_NAME in ('session logical reads')) -
             (SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT b
                WHERE b.SNAP_ID = z_beg_snap
                  AND b.DBID = z_dbid
                  AND b.INSTANCE_NUMBER = z_INST_NUM
                  AND b.STAT_NAME in ('session logical reads'))) /
             (SELECT EXTRACT(DAY FROM
                             E.END_INTERVAL_TIME - B.END_INTERVAL_TIME) *
                     86400 + EXTRACT(HOUR FROM E.END_INTERVAL_TIME -
                                     B.END_INTERVAL_TIME) * 3600 +
                     EXTRACT(MINUTE FROM
                             E.END_INTERVAL_TIME - B.END_INTERVAL_TIME) * 60 +
                     EXTRACT(SECOND FROM
                             E.END_INTERVAL_TIME - B.END_INTERVAL_TIME)
                FROM DBA_HIST_SNAPSHOT B, DBA_HIST_SNAPSHOT E
               where e.snap_id = z_end_snap
                 and b.snap_id = z_beg_snap
                 AND b.DBID = z_dbid
                 AND b.INSTANCE_NUMBER = z_INST_NUM
                 AND e.DBID = z_dbid
                 AND e.INSTANCE_NUMBER = z_INST_NUM),
             2)) as per_second,
       to_char(round(((SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT e
                WHERE e.SNAP_ID = z_end_snap
                  AND e.DBID = z_dbid
                  AND e.INSTANCE_NUMBER = z_INST_NUM
                  AND e.STAT_NAME in ('session logical reads')) -
             (SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT b
                WHERE b.SNAP_ID = z_beg_snap
                  AND b.DBID = z_dbid
                  AND b.INSTANCE_NUMBER = z_INST_NUM
                  AND b.STAT_NAME in ('session logical reads'))) /
             ((SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT e
                WHERE e.SNAP_ID = z_end_snap
                  AND e.DBID = z_dbid
                  AND e.INSTANCE_NUMBER = z_INST_NUM
                  AND e.STAT_NAME in ('user rollbacks', 'user commits')) -
             (SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT b
                WHERE b.SNAP_ID = z_beg_snap
                  AND b.DBID = z_dbid
                  AND b.INSTANCE_NUMBER = z_INST_NUM
                  AND b.STAT_NAME in ('user rollbacks', 'user commits'))),
             2)) as per_transaction
  from dual
union all
---- Block changes
select 'Block changes' as name,
       to_char(round(((SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT e
                WHERE e.SNAP_ID = z_end_snap
                  AND e.DBID = z_dbid
                  AND e.INSTANCE_NUMBER = z_INST_NUM
                  AND e.STAT_NAME in ('db block changes')) -
             (SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT b
                WHERE b.SNAP_ID = z_beg_snap
                  AND b.DBID = z_dbid
                  AND b.INSTANCE_NUMBER = z_INST_NUM
                  AND b.STAT_NAME in ('db block changes'))) /
             (SELECT EXTRACT(DAY FROM
                             E.END_INTERVAL_TIME - B.END_INTERVAL_TIME) *
                     86400 + EXTRACT(HOUR FROM E.END_INTERVAL_TIME -
                                     B.END_INTERVAL_TIME) * 3600 +
                     EXTRACT(MINUTE FROM
                             E.END_INTERVAL_TIME - B.END_INTERVAL_TIME) * 60 +
                     EXTRACT(SECOND FROM
                             E.END_INTERVAL_TIME - B.END_INTERVAL_TIME)
                FROM DBA_HIST_SNAPSHOT B, DBA_HIST_SNAPSHOT E
               where e.snap_id = z_end_snap
                 and b.snap_id = z_beg_snap
                 AND b.DBID = z_dbid
                 AND b.INSTANCE_NUMBER = z_INST_NUM
                 AND e.DBID = z_dbid
                 AND e.INSTANCE_NUMBER = z_INST_NUM),
             2)) as per_second,
       to_char(round(((SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT e
                WHERE e.SNAP_ID = z_end_snap
                  AND e.DBID = z_dbid
                  AND e.INSTANCE_NUMBER = z_INST_NUM
                  AND e.STAT_NAME in ('db block changes')) -
             (SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT b
                WHERE b.SNAP_ID = z_beg_snap
                  AND b.DBID = z_dbid
                  AND b.INSTANCE_NUMBER = z_INST_NUM
                  AND b.STAT_NAME in ('db block changes'))) /
             ((SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT e
                WHERE e.SNAP_ID = z_end_snap
                  AND e.DBID = z_dbid
                  AND e.INSTANCE_NUMBER = z_INST_NUM
                  AND e.STAT_NAME in ('user rollbacks', 'user commits')) -
             (SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT b
                WHERE b.SNAP_ID = z_beg_snap
                  AND b.DBID = z_dbid
                  AND b.INSTANCE_NUMBER = z_INST_NUM
                  AND b.STAT_NAME in ('user rollbacks', 'user commits'))),
             2)) as per_transaction
  from dual
union all
---- Physical reads
select 'Physical reads' as name,
to_char(round(((SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT e
                WHERE e.SNAP_ID = z_end_snap
                  AND e.DBID = z_dbid
                  AND e.INSTANCE_NUMBER = z_INST_NUM
                  AND e.STAT_NAME in ('physical reads')) -
             (SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT b
                WHERE b.SNAP_ID = z_beg_snap
                  AND b.DBID = z_dbid
                  AND b.INSTANCE_NUMBER = z_INST_NUM
                  AND b.STAT_NAME in ('physical reads'))) /
             (SELECT EXTRACT(DAY FROM
                             E.END_INTERVAL_TIME - B.END_INTERVAL_TIME) *
                     86400 + EXTRACT(HOUR FROM E.END_INTERVAL_TIME -
                                     B.END_INTERVAL_TIME) * 3600 +
                     EXTRACT(MINUTE FROM
                             E.END_INTERVAL_TIME - B.END_INTERVAL_TIME) * 60 +
                     EXTRACT(SECOND FROM
                             E.END_INTERVAL_TIME - B.END_INTERVAL_TIME)
                FROM DBA_HIST_SNAPSHOT B, DBA_HIST_SNAPSHOT E
               where e.snap_id = z_end_snap
                 and b.snap_id = z_beg_snap
                 AND b.DBID = z_dbid
                 AND b.INSTANCE_NUMBER = z_INST_NUM
                 AND e.DBID = z_dbid
                 AND e.INSTANCE_NUMBER = z_INST_NUM),
             2)) as per_second,
       to_char(round(((SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT e
                 WHERE e.SNAP_ID = z_end_snap
                   AND e.DBID = z_dbid
                   AND e.INSTANCE_NUMBER = z_INST_NUM
                   AND e.STAT_NAME in ('physical reads')) -
              (SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT b
                 WHERE b.SNAP_ID = z_beg_snap
                   AND b.DBID = z_dbid
                   AND b.INSTANCE_NUMBER = z_INST_NUM
                   AND b.STAT_NAME in ('physical reads'))) /
              ((SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT e
                 WHERE e.SNAP_ID = z_end_snap
                   AND e.DBID = z_dbid
                   AND e.INSTANCE_NUMBER = z_INST_NUM
                   AND e.STAT_NAME in ('user rollbacks', 'user commits')) -
              (SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT b
                 WHERE b.SNAP_ID = z_beg_snap
                   AND b.DBID = z_dbid
                   AND b.INSTANCE_NUMBER = z_INST_NUM
                   AND b.STAT_NAME in ('user rollbacks', 'user commits'))),
              2)) as per_transaction
  from dual
  union all
 ---- Physical writes
 select 'Physical writes' as name, to_char(round(((SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT e
                 WHERE e.SNAP_ID = z_end_snap
                   AND e.DBID = z_dbid
                   AND e.INSTANCE_NUMBER = z_INST_NUM
                   AND e.STAT_NAME in ('physical writes')) -
              (SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT b
                 WHERE b.SNAP_ID = z_beg_snap
                   AND b.DBID = z_dbid
                   AND b.INSTANCE_NUMBER = z_INST_NUM
                   AND b.STAT_NAME in ('physical writes'))) /
              (SELECT EXTRACT(DAY FROM
                              E.END_INTERVAL_TIME - B.END_INTERVAL_TIME) *
                      86400 + EXTRACT(HOUR FROM E.END_INTERVAL_TIME -
                                      B.END_INTERVAL_TIME) * 3600 +
                      EXTRACT(MINUTE FROM
                              E.END_INTERVAL_TIME - B.END_INTERVAL_TIME) * 60 +
                      EXTRACT(SECOND FROM
                              E.END_INTERVAL_TIME - B.END_INTERVAL_TIME)
                 FROM DBA_HIST_SNAPSHOT B, DBA_HIST_SNAPSHOT E
                where e.snap_id = z_end_snap
                  and b.snap_id = z_beg_snap
                  AND b.DBID = z_dbid
                  AND b.INSTANCE_NUMBER = z_INST_NUM
                  AND e.DBID = z_dbid
                  AND e.INSTANCE_NUMBER = z_INST_NUM),
              2)) as per_second,
        to_char(round(((SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT e
                 WHERE e.SNAP_ID = z_end_snap
                   AND e.DBID = z_dbid
                   AND e.INSTANCE_NUMBER = z_INST_NUM
                   AND e.STAT_NAME in ('physical writes')) -
              (SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT b
                 WHERE b.SNAP_ID = z_beg_snap
                   AND b.DBID = z_dbid
                   AND b.INSTANCE_NUMBER = z_INST_NUM
                   AND b.STAT_NAME in ('physical writes'))) /
              ((SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT e
                 WHERE e.SNAP_ID = z_end_snap
                   AND e.DBID = z_dbid
                   AND e.INSTANCE_NUMBER = z_INST_NUM
                   AND e.STAT_NAME in ('user rollbacks', 'user commits')) -
              (SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT b
                 WHERE b.SNAP_ID = z_beg_snap
                   AND b.DBID = z_dbid
                   AND b.INSTANCE_NUMBER = z_INST_NUM
                   AND b.STAT_NAME in ('user rollbacks', 'user commits'))),
              2)) as per_transaction
   from dual
   union all
 ---- User calls
 select 'User calls' as name, to_char(round(((SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT e
                 WHERE e.SNAP_ID = z_end_snap
                   AND e.DBID = z_dbid
                   AND e.INSTANCE_NUMBER = z_INST_NUM
                   AND e.STAT_NAME in ('user calls')) -
              (SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT b
                 WHERE b.SNAP_ID = z_beg_snap
                   AND b.DBID = z_dbid
                   AND b.INSTANCE_NUMBER = z_INST_NUM
                   AND b.STAT_NAME in ('user calls'))) /
              (SELECT EXTRACT(DAY FROM
                              E.END_INTERVAL_TIME - B.END_INTERVAL_TIME) *
                      86400 + EXTRACT(HOUR FROM E.END_INTERVAL_TIME -
                                      B.END_INTERVAL_TIME) * 3600 +
                      EXTRACT(MINUTE FROM
                              E.END_INTERVAL_TIME - B.END_INTERVAL_TIME) * 60 +
                      EXTRACT(SECOND FROM
                              E.END_INTERVAL_TIME - B.END_INTERVAL_TIME)
                 FROM DBA_HIST_SNAPSHOT B, DBA_HIST_SNAPSHOT E
                where e.snap_id = z_end_snap
                  and b.snap_id = z_beg_snap
                  AND b.DBID = z_dbid
                  AND b.INSTANCE_NUMBER = z_INST_NUM
                  AND e.DBID = z_dbid
                  AND e.INSTANCE_NUMBER = z_INST_NUM),
              2)) as per_second,
        to_char(round(((SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT e
                 WHERE e.SNAP_ID = z_end_snap
                   AND e.DBID = z_dbid
                   AND e.INSTANCE_NUMBER = z_INST_NUM
                   AND e.STAT_NAME in ('user calls')) -
              (SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT b
                 WHERE b.SNAP_ID = z_beg_snap
                   AND b.DBID = z_dbid
                   AND b.INSTANCE_NUMBER = z_INST_NUM
                   AND b.STAT_NAME in ('user calls'))) /
              ((SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT e
                 WHERE e.SNAP_ID = z_end_snap
                   AND e.DBID = z_dbid
                   AND e.INSTANCE_NUMBER = z_INST_NUM
                   AND e.STAT_NAME in ('user rollbacks', 'user commits')) -
              (SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT b
                 WHERE b.SNAP_ID = z_beg_snap
                   AND b.DBID = z_dbid
                   AND b.INSTANCE_NUMBER = z_INST_NUM
                   AND b.STAT_NAME in ('user rollbacks', 'user commits'))),
              2)) as per_transaction
   from dual
   union all
   ---- Parses
 select 'Parses' as name, to_char(round(((SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT e
                 WHERE e.SNAP_ID = z_end_snap
                   AND e.DBID = z_dbid
                   AND e.INSTANCE_NUMBER = z_INST_NUM
                   AND e.STAT_NAME in ('parse count (total)')) -
              (SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT b
                 WHERE b.SNAP_ID = z_beg_snap
                   AND b.DBID = z_dbid
                   AND b.INSTANCE_NUMBER = z_INST_NUM
                   AND b.STAT_NAME in ('parse count (total)'))) /
              (SELECT EXTRACT(DAY FROM
                              E.END_INTERVAL_TIME - B.END_INTERVAL_TIME) *
                      86400 + EXTRACT(HOUR FROM E.END_INTERVAL_TIME -
                                      B.END_INTERVAL_TIME) * 3600 +
                      EXTRACT(MINUTE FROM
                              E.END_INTERVAL_TIME - B.END_INTERVAL_TIME) * 60 +
                      EXTRACT(SECOND FROM
                              E.END_INTERVAL_TIME - B.END_INTERVAL_TIME)
                 FROM DBA_HIST_SNAPSHOT B, DBA_HIST_SNAPSHOT E
                where e.snap_id = z_end_snap
                  and b.snap_id = z_beg_snap
                  AND b.DBID = z_dbid
                  AND b.INSTANCE_NUMBER = z_INST_NUM
                  AND e.DBID = z_dbid
                  AND e.INSTANCE_NUMBER = z_INST_NUM),
              2)) as per_second,
        to_char(round(((SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT e
                 WHERE e.SNAP_ID = z_end_snap
                   AND e.DBID = z_dbid
                   AND e.INSTANCE_NUMBER = z_INST_NUM
                   AND e.STAT_NAME in ('parse count (total)')) -
              (SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT b
                 WHERE b.SNAP_ID = z_beg_snap
                   AND b.DBID = z_dbid
                   AND b.INSTANCE_NUMBER = z_INST_NUM
                   AND b.STAT_NAME in ('parse count (total)'))) /
              ((SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT e
                 WHERE e.SNAP_ID = z_end_snap
                   AND e.DBID = z_dbid
                   AND e.INSTANCE_NUMBER = z_INST_NUM
                   AND e.STAT_NAME in ('user rollbacks', 'user commits')) -
              (SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT b
                 WHERE b.SNAP_ID = z_beg_snap
                   AND b.DBID = z_dbid
                   AND b.INSTANCE_NUMBER = z_INST_NUM
                   AND b.STAT_NAME in ('user rollbacks', 'user commits'))),
              2)) as per_transaction
   from dual
   union all  
   ---- Hard parses
 select 'Hard parses' as name, to_char(round(((SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT e
                 WHERE e.SNAP_ID = z_end_snap
                   AND e.DBID = z_dbid
                   AND e.INSTANCE_NUMBER = z_INST_NUM
                   AND e.STAT_NAME in ('parse count (hard)')) -
              (SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT b
                 WHERE b.SNAP_ID = z_beg_snap
                   AND b.DBID = z_dbid
                   AND b.INSTANCE_NUMBER = z_INST_NUM
                   AND b.STAT_NAME in ('parse count (hard)'))) /
              (SELECT EXTRACT(DAY FROM
                              E.END_INTERVAL_TIME - B.END_INTERVAL_TIME) *
                      86400 + EXTRACT(HOUR FROM E.END_INTERVAL_TIME -
                                      B.END_INTERVAL_TIME) * 3600 +
                      EXTRACT(MINUTE FROM
                              E.END_INTERVAL_TIME - B.END_INTERVAL_TIME) * 60 +
                      EXTRACT(SECOND FROM
                              E.END_INTERVAL_TIME - B.END_INTERVAL_TIME)
                 FROM DBA_HIST_SNAPSHOT B, DBA_HIST_SNAPSHOT E
                where e.snap_id = z_end_snap
                  and b.snap_id = z_beg_snap
                  AND b.DBID = z_dbid
                  AND b.INSTANCE_NUMBER = z_INST_NUM
                  AND e.DBID = z_dbid
                  AND e.INSTANCE_NUMBER = z_INST_NUM),
              2)) as per_second,
        to_char(round(((SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT e
                 WHERE e.SNAP_ID = z_end_snap
                   AND e.DBID = z_dbid
                   AND e.INSTANCE_NUMBER = z_INST_NUM
                   AND e.STAT_NAME in ('parse count (hard)')) -
              (SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT b
                 WHERE b.SNAP_ID = z_beg_snap
                   AND b.DBID = z_dbid
                   AND b.INSTANCE_NUMBER = z_INST_NUM
                   AND b.STAT_NAME in ('parse count (hard)'))) /
              ((SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT e
                 WHERE e.SNAP_ID = z_end_snap
                   AND e.DBID = z_dbid
                   AND e.INSTANCE_NUMBER = z_INST_NUM
                   AND e.STAT_NAME in ('user rollbacks', 'user commits')) -
              (SELECT sum(value)
                  FROM DBA_HIST_SYSSTAT b
                 WHERE b.SNAP_ID = z_beg_snap
                   AND b.DBID = z_dbid
                   AND b.INSTANCE_NUMBER = z_INST_NUM
                   AND b.STAT_NAME in ('user rollbacks', 'user commits'))),
              2)) as per_transaction
   from dual
   union all
---- Logons
select 'Logons' as name,
       to_char(round(((SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT e
                WHERE e.SNAP_ID = z_end_snap
                  AND e.DBID = z_dbid
                  AND e.INSTANCE_NUMBER = z_INST_NUM
                  AND e.STAT_NAME in ('logons cumulative')) -
             (SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT b
                WHERE b.SNAP_ID = z_beg_snap
                  AND b.DBID = z_dbid
                  AND b.INSTANCE_NUMBER = z_INST_NUM
                  AND b.STAT_NAME in ('logons cumulative'))) /
             (SELECT EXTRACT(DAY FROM
                             E.END_INTERVAL_TIME - B.END_INTERVAL_TIME) *
                     86400 + EXTRACT(HOUR FROM E.END_INTERVAL_TIME -
                                     B.END_INTERVAL_TIME) * 3600 +
                     EXTRACT(MINUTE FROM
                             E.END_INTERVAL_TIME - B.END_INTERVAL_TIME) * 60 +
                     EXTRACT(SECOND FROM
                             E.END_INTERVAL_TIME - B.END_INTERVAL_TIME)
                FROM DBA_HIST_SNAPSHOT B, DBA_HIST_SNAPSHOT E
               where e.snap_id = z_end_snap
                 and b.snap_id = z_beg_snap
                 AND b.DBID = z_dbid
                 AND b.INSTANCE_NUMBER = z_INST_NUM
                 AND e.DBID = z_dbid
                 AND e.INSTANCE_NUMBER = z_INST_NUM),
             2)) as per_second,
       to_char(round(((SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT e
                WHERE e.SNAP_ID = z_end_snap
                  AND e.DBID = z_dbid
                  AND e.INSTANCE_NUMBER = z_INST_NUM
                  AND e.STAT_NAME in ('logons cumulative')) -
             (SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT b
                WHERE b.SNAP_ID = z_beg_snap
                  AND b.DBID = z_dbid
                  AND b.INSTANCE_NUMBER = z_INST_NUM
                  AND b.STAT_NAME in ('logons cumulative'))) /
             ((SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT e
                WHERE e.SNAP_ID = z_end_snap
                  AND e.DBID = z_dbid
                  AND e.INSTANCE_NUMBER = z_INST_NUM
                  AND e.STAT_NAME in ('user rollbacks', 'user commits')) -
             (SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT b
                WHERE b.SNAP_ID = z_beg_snap
                  AND b.DBID = z_dbid
                  AND b.INSTANCE_NUMBER = z_INST_NUM
                  AND b.STAT_NAME in ('user rollbacks', 'user commits'))),
             2)) as per_transaction
  from dual
union all
---- Executes
select 'Executes' as name,
       to_char(round(((SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT e
                WHERE e.SNAP_ID = z_end_snap
                  AND e.DBID = z_dbid
                  AND e.INSTANCE_NUMBER = z_INST_NUM
                  AND e.STAT_NAME in ('execute count')) -
             (SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT b
                WHERE b.SNAP_ID = z_beg_snap
                  AND b.DBID = z_dbid
                  AND b.INSTANCE_NUMBER = z_INST_NUM
                  AND b.STAT_NAME in ('execute count'))) /
             (SELECT EXTRACT(DAY FROM
                             E.END_INTERVAL_TIME - B.END_INTERVAL_TIME) *
                     86400 + EXTRACT(HOUR FROM E.END_INTERVAL_TIME -
                                     B.END_INTERVAL_TIME) * 3600 +
                     EXTRACT(MINUTE FROM
                             E.END_INTERVAL_TIME - B.END_INTERVAL_TIME) * 60 +
                     EXTRACT(SECOND FROM
                             E.END_INTERVAL_TIME - B.END_INTERVAL_TIME)
                FROM DBA_HIST_SNAPSHOT B, DBA_HIST_SNAPSHOT E
               where e.snap_id = z_end_snap
                 and b.snap_id = z_beg_snap
                 AND b.DBID = z_dbid
                 AND b.INSTANCE_NUMBER = z_INST_NUM
                 AND e.DBID = z_dbid
                 AND e.INSTANCE_NUMBER = z_INST_NUM),
             2)) as per_second,
       to_char(round(((SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT e
                WHERE e.SNAP_ID = z_end_snap
                  AND e.DBID = z_dbid
                  AND e.INSTANCE_NUMBER = z_INST_NUM
                  AND e.STAT_NAME in ('execute count')) -
             (SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT b
                WHERE b.SNAP_ID = z_beg_snap
                  AND b.DBID = z_dbid
                  AND b.INSTANCE_NUMBER = z_INST_NUM
                  AND b.STAT_NAME in ('execute count'))) /
             ((SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT e
                WHERE e.SNAP_ID = z_end_snap
                  AND e.DBID = z_dbid
                  AND e.INSTANCE_NUMBER = z_INST_NUM
                  AND e.STAT_NAME in ('user rollbacks', 'user commits')) -
             (SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT b
                WHERE b.SNAP_ID = z_beg_snap
                  AND b.DBID = z_dbid
                  AND b.INSTANCE_NUMBER = z_INST_NUM
                  AND b.STAT_NAME in ('user rollbacks', 'user commits'))),
             2)) as per_transaction
  from dual
union all
----Transactions
select 'Transactions' as name,
       to_char(round(((SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT e
                WHERE e.SNAP_ID = z_end_snap
                  AND e.DBID = z_dbid
                  AND e.INSTANCE_NUMBER = z_INST_NUM
                  AND e.STAT_NAME in ('user rollbacks', 'user commits')) -
             (SELECT sum(value)
                 FROM DBA_HIST_SYSSTAT b
                WHERE b.SNAP_ID = z_beg_snap
                  AND b.DBID = z_dbid
                  AND b.INSTANCE_NUMBER = z_INST_NUM
                  AND b.STAT_NAME in ('user rollbacks', 'user commits'))) /
             (SELECT EXTRACT(DAY FROM
                             E.END_INTERVAL_TIME - B.END_INTERVAL_TIME) *
                     86400 + EXTRACT(HOUR FROM E.END_INTERVAL_TIME -
                                     B.END_INTERVAL_TIME) * 3600 +
                     EXTRACT(MINUTE FROM
                             E.END_INTERVAL_TIME - B.END_INTERVAL_TIME) * 60 +
                     EXTRACT(SECOND FROM
                             E.END_INTERVAL_TIME - B.END_INTERVAL_TIME)
                FROM DBA_HIST_SNAPSHOT B, DBA_HIST_SNAPSHOT E
               where e.snap_id = z_end_snap
                 and b.snap_id = z_beg_snap
                 AND b.DBID = z_dbid
                 AND b.INSTANCE_NUMBER = z_INST_NUM
                 AND e.DBID = z_dbid
                 AND e.INSTANCE_NUMBER = z_INST_NUM),
             2)) as per_second,
       '' as  per_transaction
  from dual;



begin
  --传入DBID,INST_NUM
  select DBID into z_DBID from v$database;
  select max(INSTANCE_NUMBER) into z_INST_NUM from gv$instance;
  select DBID into L_z_DBID from v$database;
  --传入beg_snap,本周一或上周一上午9-12点
  select max(snap_id) - 3 into z_beg_snap
     from sys.dba_hist_snapshot
    where to_char(end_interval_time,'day hh24')='星期一 12';
  --传入end_snap,本周一或上周一上午9-12点
  select max(snap_id) into z_end_snap
     from sys.dba_hist_snapshot
    where to_char(end_interval_time,'day hh24')='星期一 12';
  
  --输出top 5
			
	for i in 1..z_INST_NUM loop
			DBMS_OUTPUT.PUT_LINE('<p />节点'||i||'<p />');
			DBMS_OUTPUT.PUT_LINE('<p /> Top 5 Foreground Events by Total Wait Time <p />');
			DBMS_OUTPUT.PUT_LINE('<table border="1" width="600" class="tdiff" summary="This table displays top 5 wait events by total wait time"><tr><th class="awrbg" scope="col">Event</th><th class="awrbg" scope="col">Waits</th><th class="awrbg" scope="col">Total Wait Time (sec)</th><th class="awrbg" scope="col">Wait Avg(ms)</th><th class="awrbg" scope="col">% DB time</th><th class="awrbg" scope="col">Wait Class</th></tr>');
		for t in TOP loop
			DBMS_OUTPUT.PUT_LINE('<tr><td scope="row" class=''awrc''>' ||t.event||
                                 '</td><td align="right" class=''awrc''>'||t.waits||
                                 '</td><td align="right" class=''awrc''>'||t.time ||
                                 '</td><td align="right" class=''awrc''>'||t.avgwt||
                                 '</td><td align="right" class=''awrc''>'||t.pctwtt||
                                 '</td><td align="right" class=''awrc''>'||t.wait_class||'</td></tr>');
		end loop;
			DBMS_OUTPUT.PUT_LINE('</table><p />');
  --输出load_profile
		    DBMS_OUTPUT.PUT_LINE('<p />Load Profile<p />');
			DBMS_OUTPUT.PUT_LINE('<table border="1" width="500" summary="This table displays load profile">');
			DBMS_OUTPUT.PUT_LINE('<tr><th class="awrnobg" scope="col"></th><th class="awrbg" scope="col">Per Second</th><th class="awrbg" scope="col">Per Transaction</th></tr>');
		for l in load_profile loop
			DBMS_OUTPUT.PUT_LINE('<tr><td scope="row" class=''awrc''>'||l.name||
							     ':</td><td align="right" class=''awrc''>'||l.per_second||
							     '</td><td align="right" class=''awrc''>'||l.per_transaction||'</td></tr>');
		end loop;
			DBMS_OUTPUT.PUT_LINE('</table><p />');
	end loop;   

END;
/


prompt   <a  href="#top">Back to Top </a></center>
