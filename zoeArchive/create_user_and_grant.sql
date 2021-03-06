﻿-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		create_user_and_grant.sql
--	Description:
-- 		创建数据库归档表空间、用户并授权
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--


-- ===================================================
-- 创建表空间: ZOEARCHIVE_TAB 
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
  lv_tablespace_name := 'ZOEARCHIVE_TAB';
  SELECT file_name INTO lv_sysfile_name FROM dba_data_files where tablespace_name = 'SYSTEM' AND ROWNUM=1;
  IF SUBSTR(lv_sysfile_name,1,1) = '+' or SUBSTR(lv_sysfile_name,1,1) = '/' THEN
    SELECT file_name      
    INTO lv_name
    FROM dba_data_files
    WHERE tablespace_name='SYSTEM' and rownum = 1;
    lv_dir              := SUBSTR(lv_name,1,instr(lv_name,'/',-1));
    lv_sql              := 'CREATE TABLESPACE '||lv_tablespace_name||' ';
    lv_sql              := lv_sql||'LOGGING ' ;
    lv_sql              := lv_sql||'DATAFILE '''||lv_dir||lv_tablespace_name||'01.ora'' SIZE 10M REUSE ';
    lv_sql              := lv_sql||'AUTOEXTEND ON NEXT 10M MAXSIZE 16000M ';
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
    lv_sql              := lv_sql||'AUTOEXTEND ON NEXT 10M MAXSIZE 16000M ';
    lv_sql              := lv_sql||'EXTENT MANAGEMENT LOCAL';
    EXECUTE immediate lv_sql;
    --dbms_output.put_line(lv_sql);
  END IF;
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  dbms_output.put_line(SQLCODE||'--'||sqlerrm);
END;
/

-- ===================================================
-- 创建数据库归档用户
--
   --在生产数据库和归档数据库都要执行                                             
-- ===================================================
CREATE USER ZOEARCHIVE IDENTIFIED BY "zoe$2017arch" DEFAULT TABLESPACE ZOEARCHIVE_TAB;

-- ===================================================
-- 授权系统权限给数据库归档用户
--
   --在生产数据库和归档数据库都要执行                                             
-- ===================================================
GRANT CONNECT,RESOURCE TO zoearchive;
GRANT CREATE DATABASE LINK TO ZOEARCHIVE;
GRANT SELECT ON V_$DATABASE TO ZOEARCHIVE;
--  Oracle 12c 执行
GRANT UNLIMITED TABLESPACE TO zoearchive;
-- ===================================================
-- 授权系统对象给数据库归档用户
--
   --在生产数据库执行
   --需要SYSDBA身份执行   
-- ===================================================
GRANT EXECUTE ON SYS.DBMS_CRYPTO  TO ZOEARCHIVE;
GRANT EXECUTE ON SYS.UTL_I18N     TO ZOEARCHIVE;
GRANT SELECT  ON DBA_TAB_COLUMNS   TO ZOEARCHIVE;

--在归档数据库授权给数据库归档用户
GRANT CREATE ANY TABLE TO ZOEARCHIVE;


--在HIS生产数据库授权给数据库归档用户（HIS归档）
GRANT SELECT        ON SICK_VISIT_INFO               TO ZOEARCHIVE;
GRANT SELECT,DELETE ON SICK_SETTLE_DETAIL            TO ZOEARCHIVE;
GRANT SELECT,DELETE ON SICK_SETTLE_MASTER            TO ZOEARCHIVE;
GRANT SELECT,DELETE ON APPLY_SHEET                   TO ZOEARCHIVE;
GRANT SELECT,DELETE ON APPLY_SHEET_DETAIL            TO ZOEARCHIVE;
GRANT SELECT,DELETE ON PRESCRIBE_RECORD              TO ZOEARCHIVE;
GRANT SELECT,DELETE ON PREPAYMENT_MONEY              TO ZOEARCHIVE;
GRANT SELECT,DELETE ON DISPENSARY_SICK_PRICE_ITEM    TO ZOEARCHIVE;
GRANT SELECT,DELETE ON RESIDENCE_SICK_PRICE_ITEM     TO ZOEARCHIVE;
GRANT SELECT,DELETE ON DISPENSARY_PRESCRIBE_DETAIL   TO ZOEARCHIVE;
GRANT SELECT,DELETE ON DISPENSARY_PRESCRIP_MASTER    TO ZOEARCHIVE;
GRANT SELECT,DELETE ON LAY_PHYSIC_RECORDS            TO ZOEARCHIVE;
GRANT SELECT,DELETE ON DISPENSARY_SICK_CURE_INFO     TO ZOEARCHIVE;


--在EMR生产数据库授权给数据库归档用户（EMR归档）
GRANT SELECT        ON ZEMR.ZEMR_VISIT_RECORD                TO ZOEARCHIVE;
GRANT SELECT,DELETE ON ZEMR.ZEMR_STD_PATIENT_INFO_DOMAIN     TO ZOEARCHIVE;
GRANT SELECT,DELETE ON ZEMR.ZEMR_PATIENT_DIAGNOSIS           TO ZOEARCHIVE;
GRANT SELECT,DELETE ON ZEMR.ZEMR_PATIENT_OPERATION           TO ZOEARCHIVE;
GRANT SELECT,DELETE ON ZEMR.ZEMR_EMR_PRINTLOG                TO ZOEARCHIVE;
GRANT SELECT,DELETE ON ZEMR.ZEMR_EMR_CONTENT                 TO ZOEARCHIVE;
GRANT SELECT,DELETE ON ZEMR.ZEMR_NURSE_DETAIL                TO ZOEARCHIVE;
GRANT SELECT,DELETE ON ZEMR.ZEMR_NURSE_MASTER                TO ZOEARCHIVE;
GRANT SELECT,DELETE ON ZEMR.ZEMR_NURSE_DETAIL_ARCHIVE        TO ZOEARCHIVE;
GRANT SELECT,DELETE ON ZEMR.ZEMR_NURSE_MASTER_ARCHIVE        TO ZOEARCHIVE;
GRANT SELECT,DELETE ON ZEMR.ZEMR_NURSESTAT_DETAIL            TO ZOEARCHIVE;
GRANT SELECT,DELETE ON ZEMR.ZEMR_NURSE_TEMP_ARCHIVE          TO ZOEARCHIVE;
GRANT SELECT,DELETE ON ZEMR.ZEMR_NURSE_BABY_MASTER           TO ZOEARCHIVE;
GRANT SELECT,DELETE ON ZEMR.ZEMR_NURSE_PATIENT_INFO          TO ZOEARCHIVE;
GRANT SELECT,DELETE ON ZEMR.ZEMR_TEMPERATURE_POINT_RECORD    TO ZOEARCHIVE;
GRANT SELECT,DELETE ON ZEMR.ZEMR_TEMPERATURE_FEVER           TO ZOEARCHIVE;
GRANT SELECT,DELETE ON ZEMR.ZEMR_TEMPERATURE_DAY_RECORD      TO ZOEARCHIVE;
GRANT SELECT,DELETE ON ZEMR.ZEMR_TEMPERATURE_WEEK_EMR        TO ZOEARCHIVE;
GRANT SELECT,DELETE ON ZEMR.ZEMR_BABYTP_RECORD               TO ZOEARCHIVE;
GRANT SELECT,DELETE ON ZEMR.ZEMR_TEMPERATURE_ENTIRE_RECORD   TO ZOEARCHIVE;
GRANT SELECT,DELETE ON ZEMR.ZQC_TIME_RULE_RECORD             TO ZOEARCHIVE;
GRANT SELECT,DELETE ON ZEMR.ZEMR_REGISTER_EVENT_RECORD       TO ZOEARCHIVE;

GRANT SELECT,DELETE ON ZEMR.ZEMR_EMR_LOG                     TO ZOEARCHIVE;
GRANT SELECT,DELETE ON ZEMR.ZEMR_USER_OPERATION              TO ZOEARCHIVE;

GRANT SELECT,DELETE ON ZEMR.ZEMR_EMR_SIGNATURE               TO ZOEARCHIVE;
GRANT SELECT,DELETE ON ZEMR.ZEMR_STD_EMR_PARSE_REF_RECORD    TO ZOEARCHIVE;






