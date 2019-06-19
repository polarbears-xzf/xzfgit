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
	
set markup html off
prompt <br />

DECLARE
--	lv_is_rac  VARCHAR2(3);
--	lv_is_archive VARCHAR2(3);
CURSOR tab_cursor IS
-- 查询使用率大于70% 同时剩余表空间小于100Gb的表空间
select tablespace_name,pct_used,free_gb from
(
	select tablespace_name,
       (max_gb-used_gb) free_gb,
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
         where a.tablespace_name = b.tablespace_name(+)))
where pct_used>70 and  free_gb <100;

BEGIN
/* 	--是否RAC
	select decode(value,'TRUE','是','FALSE','否',value)  INTO lv_is_rac
	from gv$parameter where name = 'cluster_database';
	IF lv_is_rac = '否' THEN 
		DBMS_OUTPUT.PUT_LINE('Oracle RAC 未部署，系统存在高可用性缺陷');
	END IF;
	--是否开启归档
	select decode(log_mode,'ARCHIVELOG','是','否')       INTO lv_is_archive
	from v$database;
	IF lv_is_archive = '否' THEN 
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE(' <td> 紧急：数据库未开启归档模式，存在严重安全隐患</td> ');
		DBMS_OUTPUT.PUT_LINE('</table> ');
	END IF; */
	
	FOR t in tab_cursor loop
		if t.pct_used > 80 and t.pct_used <90 then
			DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
			DBMS_OUTPUT.PUT_LINE('<td>表空间'||t.tablespace_name||'余量较少,请注意扩展');
			DBMS_OUTPUT.PUT_LINE('<td>表空间'||t.tablespace_name||'使用率:'||t.pct_used||' 剩余空间:'||t.free_gb);
			DBMS_OUTPUT.PUT_LINE('</table> ');
		end if;
		if t.pct_used > 90  then
			DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
			DBMS_OUTPUT.PUT_LINE('<td>表空间'||t.tablespace_name||'余量极少,请立即扩展');
			DBMS_OUTPUT.PUT_LINE('<td>表空间'||t.tablespace_name||'使用率:'||t.pct_used||' 剩余空间:'||t.free_gb);
			DBMS_OUTPUT.PUT_LINE('</table> ');
		end if;
	end loop;
END;
/
