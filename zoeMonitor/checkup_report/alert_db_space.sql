-- Created in 2018.10.11 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		alert_db_space.sql
--	Description:
-- 		基本说明
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--

--检查指标
	--数据库总使用率：  大于95%提醒
	--表空间剩余空间：  小于日均增量*90，增加数据文件
	--日志日增量：      大于日志日均增量3倍，提醒是否存在异常业务
	--日志最小切换时间：  小于3分钟，增加日志大小
	--统计信息最近收集时间：	大于三天提醒
	--OFFLINE的回滚段：	存在提醒
	
set markup html off
prompt <br />

DECLARE
LOG_AVG_SWITCH_TIME NUMBER(10);
ANALYZED_DAY NUMBER(10);


CURSOR ASM_CURSOR IS
--查询ASM磁盘空闲率及空闲空间(GB)
select name, pct_used, free_gb, total_gb
  from (select name,
               100 - round(free_mb / total_mb * 100, 2) pct_used,
               ((total_mb - free_mb) / 1024) free_gb,
               (total_mb / 1024) total_gb
          from v$asm_diskgroup);


CURSOR tab_cursor IS
-- 查询使用率大于70% 同时剩余表空间小于100Gb的表空间
select tablespace_name,pct_used,free_gb,max_gb from
(
	select tablespace_name,
       (max_gb-used_gb) free_gb,
       round(100 * used_gb / max_gb) pct_used,
	   max_gb
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
         where a.tablespace_name = b.tablespace_name(+)))
where pct_used>70 and  free_gb <100;

CURSOR seg_cursor IS
--查询回滚段STATUS
select d.tablespace_name, s.STATUS, n.name
  from dba_rollback_segs d, v$rollstat s, v$rollname n
 where n.usn = s.USN
   and d.segment_name = n.name;

BEGIN
--检查表空间使用率及剩余大小并告警
	FOR t in tab_cursor loop
		if t.pct_used > 80 and t.pct_used <90 then
			DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
			DBMS_OUTPUT.PUT_LINE('<td>表空间 '||t.tablespace_name||' 余量较少,请注意扩展</br>');
			DBMS_OUTPUT.PUT_LINE('使用率:'||t.pct_used||'% 剩余空间:'||t.free_gb||'GB 最大表空间大小:'||t.max_gb||'GB');
			DBMS_OUTPUT.PUT_LINE('</table> ');
		end if;
		if t.pct_used > 90  then
			DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
			DBMS_OUTPUT.PUT_LINE('<td>表空间 '||t.tablespace_name||' 余量极少,请立即扩展</br>');
			DBMS_OUTPUT.PUT_LINE('使用率:'||t.pct_used||'% 剩余空间:'||t.free_gb||'GB 最大表空间大小:'||t.max_gb||'GB');
			DBMS_OUTPUT.PUT_LINE('</table> ');
		end if;
	end loop;

--判断ASM磁盘使用情况并告警
	FOR A in ASM_CURSOR loop
		if A.pct_used >= 70 and A.pct_used <80 then
			DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
			DBMS_OUTPUT.PUT_LINE('<td> ASM磁盘组 '||A.NAME||' 余量较少,请注意扩展</br>');
			DBMS_OUTPUT.PUT_LINE('使用率:'||A.pct_used||'% 剩余空间:'||A.free_gb||'GB 总大小:'||A.total_gb||'GB');
			DBMS_OUTPUT.PUT_LINE('</table> ');
		end if;
		if A.pct_used >= 80 and A.pct_used <90 then
			DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
			DBMS_OUTPUT.PUT_LINE('<td> ASM磁盘组 '||A.NAME||' 余量极少,请立即扩展</br>');
			DBMS_OUTPUT.PUT_LINE('使用率:'||A.pct_used||'% 剩余空间:'||A.free_gb||'GB 总大小:'||A.total_gb||'GB');
			DBMS_OUTPUT.PUT_LINE('</table> ');
		end if;
		if A.pct_used >= 90 then
			DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
			DBMS_OUTPUT.PUT_LINE('<td> ASM磁盘组 '||A.NAME||' 余量极少,请立即扩展</br>');
			DBMS_OUTPUT.PUT_LINE('使用率:'||A.pct_used||'% 剩余空间:'||A.free_gb||'GB 总大小:'||A.total_gb||'GB');
			DBMS_OUTPUT.PUT_LINE('</table> ');
		end if;
	end loop;
	
--判断是否存在OFFLINE回滚段
	FOR S in seg_cursor loop
		if s.status = 'OFFLINE' then
			DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
			DBMS_OUTPUT.PUT_LINE('<td> 表空间 '||s.tablespace_name||'中回滚段 '||s.name||' 处于OFFLINE状态，请检查</br>');
			DBMS_OUTPUT.PUT_LINE('</table> ');
		end if;
	end loop;

--查询上午9-12时归档平均切换时间
	SELECT decode(a.total_count,
				  0,
				  0,
				  trunc(180 / (a.total_count / b.days), 2)) into LOG_AVG_SWITCH_TIME
	  FROM (SELECT COUNT(*) /
				   decode(count(distinct dest_id), 0, 1, count(distinct dest_id)) total_count
			  FROM gv$archived_log
			 WHERE to_number(TO_CHAR(completion_time, 'hh24')) >= 9
			   AND to_number(TO_CHAR(completion_time, 'hh24')) < 12
			   AND standby_dest = 'NO') a,
		   (SELECT MAX(completion_time) - MIN(completion_time) days
			  FROM gv$archived_log
			 where standby_dest = 'NO') b;
			 
--判断9-12时归档平均切换时间并给出告警
	IF LOG_AVG_SWITCH_TIME = 0 THEN
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE('<td> 9-12时归档生成数量为零,请确认是否存在异常');
		DBMS_OUTPUT.PUT_LINE('</table> ');
	ELSE
		IF LOG_AVG_SWITCH_TIME > 0 AND LOG_AVG_SWITCH_TIME <= 5 THEN
			DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
			DBMS_OUTPUT.PUT_LINE('<td> 9-12时归档平均切换时间小于5分钟,数据库性能将受影响,请立即扩大REDO日志');
			DBMS_OUTPUT.PUT_LINE('</table> ');
		ELSE 
			IF LOG_AVG_SWITCH_TIME > 5 AND LOG_AVG_SWITCH_TIME <= 15 THEN
				DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
				DBMS_OUTPUT.PUT_LINE('<td> 9-12时归档平均切换时间小于15分钟,数据库性能可能受影响,请尽快扩大REDO日志');
				DBMS_OUTPUT.PUT_LINE('</table> ');
			END IF;
		END IF;
	END IF;

--查询统计信息最近收集时间
	select trunc(sysdate-max(last_analyzed)) into ANALYZED_DAY from dba_tables;
--判断最近统计信息收集时间并告警
	IF ANALYZED_DAY > 0 AND ANALYZED_DAY <= 7 THEN
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE('<td> 最近统计信息最近收集时间超过1天,建议进行收集');
		DBMS_OUTPUT.PUT_LINE('</table> ');
	ELSE IF ANALYZED_DAY > 7 AND ANALYZED_DAY <= 30 THEN
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE('<td> 最近统计信息最近收集时间超过一周,请尽快进行收集,未收集可能影响数据库性能');
		DBMS_OUTPUT.PUT_LINE('</table> ');
	ELSE IF ANALYZED_DAY > 30 THEN
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE('<td> 最近统计信息最近收集时间超过一月,请立即进行收集,否则可能影响数据库性能');
		DBMS_OUTPUT.PUT_LINE('</table> ');
	END IF;
	END IF;
	END IF;

		
END;
/
