-- Created in 2017.10.10 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoesql_create_user.sql
--	Description:
-- 		创建智业HIS5索引表空间
--  Relation:
--      
--	Notes:
--		
--	修改 - （年-月-日） - 描述

SET SERVEROUTPUT ON 

-- ===================================================
-- 创建索引表空间 
--
   --不支持裸设备，仅支持文件系统                                             
-- ===================================================
DECLARE
  lv_name             VARCHAR2(512);
  lv_dir              VARCHAR2(512);
  lv_sql              VARCHAR2(4000);
  lv_sysfile_name     VARCHAR2(513);
  lv_tablespace_name  VARCHAR2(64);
BEGIN

  --获取表空间创建路径，取SYSTEM表空间路径。
  SELECT file_name INTO lv_sysfile_name FROM dba_data_files where tablespace_name = 'SYSTEM' AND ROWNUM=1;
  FOR lc_for IN (SELECT USERNAME FROM ZOESTD.V_ZOESOFT_USER) LOOP 
	lv_tablespace_name := lc_for.USERNAME||'_IND';
	  IF SUBSTR(lv_sysfile_name,1,1) = '+' or SUBSTR(lv_sysfile_name,1,1) = '/' THEN
		SELECT file_name      
		INTO lv_name
		FROM dba_data_files
		WHERE tablespace_name='SYSTEM' and rownum = 1;
		lv_dir              := SUBSTR(lv_name,1,instr(lv_name,'/',-1));
		lv_sql              := 'CREATE TABLESPACE '||lv_tablespace_name||' ';
		lv_sql              := lv_sql||'LOGGING ' ;
		lv_sql              := lv_sql||'DATAFILE '''||lv_dir||lv_tablespace_name||'01.ora'' SIZE 10M REUSE ';
		lv_sql              := lv_sql||'AUTOEXTEND ON NEXT 10M MAXSIZE 30000M ';
		lv_sql              := lv_sql||'EXTENT MANAGEMENT LOCAL';
		EXECUTE immediate lv_sql;
		--dbms_output.put_line(lv_sql);
	  ELSE
		SELECT file_name      
		INTO lv_name
		FROM dba_data_files
		WHERE tablespace_name='SYSTEM' and rownum = 1;
		lv_dir              := SUBSTR(lv_name,1,instr(lv_name,'\',-1));
		lv_sql              := 'CREATE TABLESPACE '||lv_tablespace_name||' ';
		lv_sql              := lv_sql||'LOGGING ' ;
		lv_sql              := lv_sql||'DATAFILE '''||lv_dir||lv_tablespace_name||'01.ora'' SIZE 10M REUSE ';
		lv_sql              := lv_sql||'AUTOEXTEND ON NEXT 10M MAXSIZE 30000M ';
		lv_sql              := lv_sql||'EXTENT MANAGEMENT LOCAL';
		EXECUTE immediate lv_sql;
		--dbms_output.put_line(lv_sql);
		END IF;
	END LOOP;
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  dbms_output.put_line(SQLCODE||'--'||sqlerrm);
END;
/

