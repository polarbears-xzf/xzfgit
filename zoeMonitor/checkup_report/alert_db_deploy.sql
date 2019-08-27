-- Created in 2018.10.11 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		alert_db_deploy.sql
--	Description:
-- 		基本说明
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--

--检查指标
	--是否RAC：      为"否" 时进行提示处理
	--是否开启归档： 为"否" 时进行提示处理
	--实例及数据库状态
	--是否有offline状态的表空间： 为"否" 时进行提示处理
    --审计日志表是否存放于SYSTEM表空间： 为"是" 时进行提示处理
	--密码属性检查： 为"否" 时进行提示处理
set markup html off
--SET SERVEROUTPUT ON
prompt  <center>
DECLARE
	lv_is_rac  VARCHAR2(32);
	lv_is_archive VARCHAR2(32);
	lv_is_offlinetablespace VARCHAR2(3);
	lv_tbsname VARCHAR2(64);
	lv_dbstatus VARCHAR2(512);
	lv_is_audit VARCHAR2(32);
	lv_is_password1 VARCHAR2(32);
	lv_is_password2 VARCHAR2(32);
	log_archive_dest VARCHAR2(64);
	db_recovery_file_dest VARCHAR2(64);
	log_archive_dest_n VARCHAR2(128);
	slimit VARCHAR2(16);
	sused VARCHAR2(16);
BEGIN
	--是否RAC
	select decode(value,'TRUE','是','FALSE','否',value)  INTO lv_is_rac
	from gv$parameter where name = 'cluster_database' and rownum=1;
	IF lv_is_rac = '否' THEN 
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE('<td>Oracle RAC 未部署，系统存在高可用性缺陷</td>');
		DBMS_OUTPUT.PUT_LINE('</table> ');
	END IF;
	--是否开启归档以及判断归档路径
	select decode(log_mode,'ARCHIVELOG','是','否')INTO lv_is_archive from v$database;
	select value into log_archive_dest from v$parameter where name = 'log_archive_dest';
	select value into db_recovery_file_dest from v$parameter where name = 'db_recovery_file_dest';
	select (LISTAGG(substr(value,10), ' ; ') WITHIN GROUP(ORDER BY value)) into log_archive_dest_n from v$parameter where name not like 'log_archive_dest_s%'   and name like 'log_archive_dest_%' and value like 'location%' or value like 'LOCATION%';
	IF lv_is_archive = '否' THEN 
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE(' <td> 紧急：数据库未开启归档模式，存在严重安全隐患，已开启</td>');
		DBMS_OUTPUT.PUT_LINE('</table> ');
			ELSE IF log_archive_dest is null  and  db_recovery_file_dest is not null and log_archive_dest_n is null then
					select round(space_limit/1024/1024,2) into slimit from v$recovery_file_dest;
					select round(space_used/1024/1024,2) into sused from v$recovery_file_dest;
					DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
					DBMS_OUTPUT.PUT_LINE('<td>警告：当前归档路径在闪回恢复区,其大小为'||slimit||'M,已使用'||sused||'M</td>');
					DBMS_OUTPUT.PUT_LINE('</table> ');
			else if log_archive_dest is not null then
					DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
					DBMS_OUTPUT.PUT_LINE('<td>警告：当前归档参数使用log_archive_dest</td>');
					DBMS_OUTPUT.PUT_LINE('</table> ');
			END IF;
		END IF;
	END IF;
	--实例及数据库状态（rac环境下判断）
	IF lv_is_rac = '是' THEN 
	select LISTAGG('警告：实例：'||instance_name||'；实例状态：'||status||',数据库状态：'||database_status||'','<br />') WITHIN GROUP(ORDER BY inst_id) into lv_dbstatus from gv$instance where status !='OPEN' or database_status!='ACTIVE';
	    DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>'); 
		DBMS_OUTPUT.PUT_LINE('<td>'||lv_dbstatus||'</td>');
		DBMS_OUTPUT.PUT_LINE('</table> ');
	END IF;
	--是否有offline状态的表空间
	select to_char(COUNT(*)) INTO lv_is_offlinetablespace from dba_tablespaces where status!='ONLINE';
	IF lv_is_offlinetablespace > 0 THEN 
	select (LISTAGG(tablespace_name,',') WITHIN GROUP(ORDER BY tablespace_name))into lv_tbsname  from dba_tablespaces where status!='ONLINE';
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE('<td>存在offline状态的表空间，已检查'||lv_tbsname||'表空间</td>');
		DBMS_OUTPUT.PUT_LINE('</table> ');
	END IF;
	--审计检查
	select decode(tablespace_name,'SYSTEM','是','否')INTO lv_is_audit from dba_tables where table_name='AUD$';
	IF lv_is_archive = '是' THEN 
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE(' <td> 审计日志表存放于SYSTEM表空间,按需调整</td>');
		DBMS_OUTPUT.PUT_LINE('</table> ');
	END IF;
	--密码属性检查
	select decode(limit,'UNLIMITED','是','否')INTO lv_is_password1 from dba_profiles t where t.resource_name='PASSWORD_LIFE_TIME' and t.profile='DEFAULT';
	IF lv_is_password1 = '否' THEN 
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE(' <td> 密码参数(PASSWORD_LIFE_TIME)不是无限制，存在密码无效隐患，按需调整</td>');
		DBMS_OUTPUT.PUT_LINE('</table> ');
	END IF;
	select decode(limit,'UNLIMITED','是','否')INTO lv_is_password2 from dba_profiles t where t.resource_name='FAILED_LOGIN_ATTEMPTS' and t.profile='DEFAULT';
	IF lv_is_password1 = '否' THEN 
		DBMS_OUTPUT.PUT_LINE('<table WIDTH=600 BORDER=1>');
		DBMS_OUTPUT.PUT_LINE(' <td> 密码参数(FAILED_LOGIN_ATTEMPTS)不是无限制，存在用户被锁隐患，按需调整</td>');
		DBMS_OUTPUT.PUT_LINE('</table> ');
	END IF;
END; 
/