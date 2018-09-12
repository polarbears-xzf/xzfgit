-- Created in 2013-08-23 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
	-- get_create_tablespace.sq
--	Description:
	-- 此脚本用于生成创建表空间的脚本，一般用于导出，导入数据库在不同的路径时建立表空间
	--
--  Relation:
	-- 权限需求：select any dictionary
--	Notes:
	--	基本注意事项
--	修改 - （年-月-日） - 描述
	--2015-08-07 修正每个表空间数据文件数量算法，修正每个数据文件初始化大小算法 -polarbears
	--2018.06.30 格式与输出微调 -polarbears
--其它说明
	-- 环境 SERVEROUTPUT 设置sqlplus显示输出及缓存，此处设置输出缓存为1M，当输出超过1M时被截断
	-- 环境 ECHO         设置sqlplus 是否回显脚本内容，此处设置不回显脚本内容                    
	-- 环境 LINESIZE     设置sqlplus 行长度，用于格式化sqlplus输出结果                            
	-- 环境 HEADING      设置sqlplus 查询语句是否显示表头，用于格式化sqlplus输出结果              
	-- 环境 FEEDBACK     设置sqlplus 查询语句返回状态，用于格式化sqlplus输出结果                  
	-- 环境 HEADING      设置sqlplus 设置页面缓存大小，用于格式化sqlplus输出结果
SET SERVEROUTPUT ON SIZE 1000000
SET LINESIZE 130
SET HEADING OFF
SET FEEDBACK OFF
SET PAGESIZE 7500
SET ECHO OFF

spool d:\cts.sql 

DECLARE
	lv2_tablespace_name VARCHAR2(30);
	lv2_datafile_name VARCHAR2(513);
	lv2_logging VARCHAR2(9);
	ln_datafile_size NUMBER;
	ln_init_extent NUMBER;
	ln_next_extent NUMBER;
	ln_min_extent NUMBER;
	lv2_management VARCHAR2(10);
	lv2_allocation_type VARCHAR2(10);
	ln_sql_error NUMBER;
	ln_tablespace_use_blocks NUMBER;
	ln_file_size NUMBER;
	ln_db_block_size NUMBER;
        ln_tbs_block_size NUMBER;
        ln_tbs_files_count NUMBER;
        lv2_tbs_file_seq CHAR(3);
-- ===================================================
-- 获取数据库中所有表空间名及其基本配置
-- ===================================================
	CURSOR lc_tablespace_status IS 
		SELECT  TABLESPACE_NAME,
			INITIAL_EXTENT,
			NEXT_EXTENT,
			MIN_EXTENTS,
			EXTENT_MANAGEMENT,
			ALLOCATION_TYPE,
      BLOCK_SIZE
		FROM	DBA_TABLESPACES
		ORDER BY TABLESPACE_NAME;
BEGIN
	OPEN lc_tablespace_status;

	lv2_tablespace_name := NULL;
	lv2_datafile_name := NULL;
	lv2_logging := NULL;
	ln_datafile_size := 0;
	ln_init_extent := 0;
	ln_next_extent := 0;
	ln_min_extent := 0;
	lv2_management := NULL;
	lv2_allocation_type := NULL;
	ln_sql_error := 0;
	ln_tablespace_use_blocks := 0;
	ln_file_size := 0;
-- ===================================================
-- 获取数据库块大小
-- ===================================================
	SELECT VALUE INTO ln_db_block_size FROM V$PARAMETER WHERE NAME = 'db_block_size';
-- ===================================================
-- 循环处理表空间
-- ===================================================
	LOOP
	    BEGIN
		FETCH lc_tablespace_status 
		INTO    lv2_tablespace_name,
			ln_init_extent,
			ln_next_extent,
			ln_min_extent,
			lv2_management,
			lv2_allocation_type,
                        ln_tbs_block_size;
		EXIT WHEN lc_tablespace_status%NOTFOUND;
          	EXCEPTION
          	WHEN OTHERS THEN
             	ln_sql_error := SQLCODE;
             	IF ln_sql_error = -1555 THEN 
	           			CLOSE lc_tablespace_status;
                ELSE 
	          			CLOSE lc_tablespace_status;
                RAISE;
             	END IF;
	    END;
	    BEGIN
-- ===================================================
-- 处理本地管理表空间
-- ===================================================
		IF lv2_management = 'LOCAL' THEN
		    SELECT SUM(BLOCKS)
		    INTO  ln_tablespace_use_blocks
		    FROM DBA_SEGMENTS 
		    WHERE TABLESPACE_NAME = lv2_tablespace_name;
		    IF ln_tablespace_use_blocks IS NULL THEN
			    DBMS_OUTPUT.PUT_LINE('CREATE TABLESPACE '||lv2_tablespace_name);
			    DBMS_OUTPUT.PUT_LINE('LOGGING DATAFILE');
			    DBMS_OUTPUT.PUT_LINE('''PATH\'||lv2_tablespace_name||'01.ora'''||' SIZE 10M AUTOEXTEND ON NEXT  10M MAXSIZE 30000M');
			    DBMS_OUTPUT.PUT_LINE('EXTENT MANAGEMENT LOCAL;');
		    ELSE
-- ===================================================
-- 每个数据文件最大值为16GB，如果表空间对象总大小超过数据文件空间合计的90%，那么增加一个数据文件
-- 每个数据文件初始化空间为实际大小的70% 
-- ===================================================
	  ln_file_size := ln_tablespace_use_blocks*ln_db_block_size+10240000;
      SELECT CEIL(ln_file_size/(1024*1024*1024*16*0.9)) INTO ln_tbs_files_count FROM DUAL;
      SELECT CEIL(ln_file_size/ln_tbs_files_count/1024/1024*0.7) INTO ln_datafile_size FROM DUAL;
			DBMS_OUTPUT.PUT_LINE('CREATE TABLESPACE '||lv2_tablespace_name);
			DBMS_OUTPUT.PUT_LINE('LOGGING DATAFILE');
                        for i in 1..ln_tbs_files_count LOOP
                            SELECT lpad(i,3,0) INTO lv2_tbs_file_seq FROM DUAL;
                            IF i = ln_tbs_files_count THEN
			       DBMS_OUTPUT.PUT_LINE('''PATH\'||lv2_tablespace_name||lv2_tbs_file_seq||'.ora'''||' SIZE 10M AUTOEXTEND ON NEXT  10M MAXSIZE 30000M');
                             ELSE
			       DBMS_OUTPUT.PUT_LINE('''PATH\'||lv2_tablespace_name||lv2_tbs_file_seq||'.ora'''||' SIZE 10M AUTOEXTEND ON NEXT  10M MAXSIZE 30000M,');
                            END IF;
                        END LOOP;
			    DBMS_OUTPUT.PUT_LINE('EXTENT MANAGEMENT LOCAL;');
		    END IF;
		END IF;
-- ===================================================
-- 处理字典管理表空间
-- ===================================================
		IF lv2_management = 'DICTIONARY' THEN
		   SELECT SUM(BLOCKS)
		    INTO  ln_tablespace_use_blocks
		    FROM DBA_SEGMENTS 
		    WHERE TABLESPACE_NAME = lv2_tablespace_name;
		    IF ln_tablespace_use_blocks IS NULL  THEN
			    DBMS_OUTPUT.PUT_LINE('CREATE TABLESPACE '||lv2_tablespace_name);
			    DBMS_OUTPUT.PUT_LINE('LOGGING DATAFILE');
			    DBMS_OUTPUT.PUT_LINE('''PATH\'||lv2_tablespace_name||'01.ora'''||' SIZE 10M AUTOEXTEND ON NEXT  10M MAXSIZE 30000M');
			    DBMS_OUTPUT.PUT_LINE('EXTENT MANAGEMENT LOCAL;');
		    ELSE
			IF  ln_file_size < 600000000 THEN
			    DBMS_OUTPUT.PUT_LINE('CREATE TABLESPACE '||lv2_tablespace_name);
			    DBMS_OUTPUT.PUT_LINE('LOGGING DATAFILE');
			    DBMS_OUTPUT.PUT_LINE('''PATH\'||lv2_tablespace_name||'01.ora'''||' SIZE '||ln_file_size||' AUTOEXTEND ON NEXT  10M MAXSIZE 30000M');
			    DBMS_OUTPUT.PUT_LINE('DEFAULT STORAGE (INITIAL '||ln_init_extent||' NEXT ||ln_next_extent MINEXTENTS 1 MAXEXTENTS UNLIMITED PCTINCREASE 0 );');
			END IF;
			IF  (ln_file_size >= 600000000 AND ln_file_size < 1200000000) THEN
			    DBMS_OUTPUT.PUT_LINE('CREATE TABLESPACE '||lv2_tablespace_name);
			    DBMS_OUTPUT.PUT_LINE('LOGGING DATAFILE');
			    DBMS_OUTPUT.PUT_LINE('''PATH\'||lv2_tablespace_name||'01.ora'''||' SIZE '||CEIL(ln_file_size/2)||' AUTOEXTEND ON NEXT  10M MAXSIZE 30000M,');
			    DBMS_OUTPUT.PUT_LINE('''PATH\'||lv2_tablespace_name||'02.ora'''||' SIZE '||CEIL(ln_file_size/2)||' AUTOEXTEND ON NEXT  10M MAXSIZE 30000M');
			    DBMS_OUTPUT.PUT_LINE('DEFAULT STORAGE (INITIAL '||ln_init_extent||' NEXT ||ln_next_extent MINEXTENTS 1 MAXEXTENTS UNLIMITED PCTINCREASE 0 );');
			END IF;
			IF  (ln_file_size >= 1200000000 AND ln_file_size < 1800000000) THEN
			    DBMS_OUTPUT.PUT_LINE('CREATE TABLESPACE '||lv2_tablespace_name);
			    DBMS_OUTPUT.PUT_LINE('LOGGING DATAFILE');
			    DBMS_OUTPUT.PUT_LINE('''PATH\'||lv2_tablespace_name||'01.ora'''||' SIZE '||CEIL(ln_file_size/3)||' AUTOEXTEND ON NEXT  10M MAXSIZE 30000M,');
			    DBMS_OUTPUT.PUT_LINE('''PATH\'||lv2_tablespace_name||'02.ora'''||' SIZE '||CEIL(ln_file_size/3)||' AUTOEXTEND ON NEXT  10M MAXSIZE 30000M,');
			    DBMS_OUTPUT.PUT_LINE('''PATH\'||lv2_tablespace_name||'03.ora'''||' SIZE '||CEIL(ln_file_size/3)||' AUTOEXTEND ON NEXT  10M MAXSIZE 30000M');
			    DBMS_OUTPUT.PUT_LINE('DEFAULT STORAGE (INITIAL '||ln_init_extent||' NEXT ||ln_next_extent MINEXTENTS 1 MAXEXTENTS UNLIMITED PCTINCREASE 0 );');
			END IF; 
			IF  ln_file_size >= 1800000000  THEN
			    DBMS_OUTPUT.PUT_LINE('CREATE TABLESPACE '||lv2_tablespace_name);
			    DBMS_OUTPUT.PUT_LINE('LOGGING DATAFILE');
			    DBMS_OUTPUT.PUT_LINE('''PATH\'||lv2_tablespace_name||'01.ora'''||' SIZE '||CEIL(ln_file_size/4)||' AUTOEXTEND ON NEXT  10M MAXSIZE 30000M,');
			    DBMS_OUTPUT.PUT_LINE('''PATH\'||lv2_tablespace_name||'02.ora'''||' SIZE '||CEIL(ln_file_size/4)||' AUTOEXTEND ON NEXT  10M MAXSIZE 30000M,');
			    DBMS_OUTPUT.PUT_LINE('''PATH\'||lv2_tablespace_name||'03.ora'''||' SIZE '||CEIL(ln_file_size/4)||' AUTOEXTEND ON NEXT  10M MAXSIZE 30000M,');
			    DBMS_OUTPUT.PUT_LINE('''PATH\'||lv2_tablespace_name||'04.ora'''||' SIZE '||CEIL(ln_file_size/4)||' AUTOEXTEND ON NEXT  10M MAXSIZE 30000M');
			    DBMS_OUTPUT.PUT_LINE('DEFAULT STORAGE (INITIAL '||ln_init_extent||' NEXT ||ln_next_extent MINEXTENTS 1 MAXEXTENTS UNLIMITED PCTINCREASE 0 );');
			END IF;   
		    END IF;
		END IF;
	    END;
	END LOOP;
-- ===================================================
-- 关闭游标 lc_tablespace_status
-- ===================================================
	CLOSE lc_tablespace_status;
END;
/
spool off

