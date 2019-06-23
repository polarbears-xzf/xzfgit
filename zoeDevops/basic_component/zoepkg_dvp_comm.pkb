CREATE OR REPLACE PACKAGE ZOEDEVOPS.ZOEPKG_DVP_COMM

-- Created in 2019.06.18 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoepkg_dvp_comm.pkb
--	Description:
-- 		基础工具包
--  Relation:
--      建在所有其它包之前
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--
--

AS

-- ===================================================
--  获取数据库版本
-- ===================================================
  FUNCTION GET_DB_VERSION RETURN VARCHAR2 AS
    lv_db_version VARCHAR2(80);
  BEGIN
    SELECT BANNER INTO lv_db_version FROM V$VERSION WHERE BANNER LIKE 'Oracle Database%';
    RETURN lv_db_version;
  END GET_DB_VERSION;

-- ===================================================
--  获取数据库ID
-- ===================================================
  FUNCTION GET_DB_ID RETURN VARCHAR2 AS
     lv_db_version         VARCHAR2(3);          --数据库软件版本号
     lv_ip_address  VARCHAR2(15);                --服务器IP地址
     lv_host_name        VARCHAR2(128);          --服务器名称
     lv_db_name            VARCHAR2(64);         --数据库名
     ld_db_created_time    DATE;                 --数据库创建时间
     lv_db_id              VARCHAR2(128);        --数据库DB_ID
     lt_db_basic_info zoetyp_db_basic_info := zoetyp_db_basic_info();      --数据库基本信息对象
  BEGIN
    lt_db_basic_info   := ZOEPKG_DVP_COMM.GET_DB_BASIC_INFO;
    lv_host_name       := lt_db_basic_info(1).host_name   ;
    lv_ip_address      := lt_db_basic_info(1).ip_address  ;
    lv_db_name         := lt_db_basic_info(1).db_name     ;
    ld_db_created_time :=lt_db_basic_info(1).created_time;
    lv_db_version      :=lt_db_basic_info(1).db_version  ;
    lv_db_id := ZOEDEVOPS.ZOEPKG_SECURITY.VERIFY_SH1(lv_host_name||lv_ip_address||lv_db_name||to_char(ld_db_created_time,'yyyy-mm-dd hh24:mi:ss')||lv_db_version);
    RETURN lv_db_id;
  END GET_DB_ID;

 -- ===================================================
--  获取数据库基本信息
-- ===================================================
 FUNCTION GET_DB_BASIC_INFO RETURN zoett_db_basic_info AS
   lt_db_basic_info zoett_db_basic_info := zoett_db_basic_info();      --数据库基本信息对象
   lv_is_cdb             VARCHAR2(3);          --是否容器
   lv_db_version         VARCHAR2(3);         --数据库软件版本号
   ld_db_created_time    DATE;                 --数据库创建时间
   lv_sql                VARCHAR2(4000);       --SQL
  BEGIN
    lv_db_version := SUBSTR(GET_DB_VERSION(), 17,3);
    IF lv_db_version = '12c' THEN
      lv_sql := 'select cdb from v$database';
      EXECUTE IMMEDIATE lv_sql INTO lv_is_cdb;
      IF lv_is_cdb = 'YES' THEN
        lv_sql := 'select creation_time from v$pdbs';
        EXECUTE IMMEDIATE lv_sql INTO ld_db_created_time;
      END IF;
    ELSE 
      select created into ld_db_created_time from v$database;
    END IF;
    lt_db_basic_info.extend;
    lt_db_basic_info(1) := zoetr_db_basic_info(null,null,null,null,null);
    lt_db_basic_info(1).host_name       := SYS_CONTEXT('USERENV', 'SERVER_HOST');
    lt_db_basic_info(1).ip_address      := utl_inaddr.get_host_address;
    lt_db_basic_info(1).db_name         := SYS_CONTEXT('USERENV', 'DB_NAME');
    lt_db_basic_info(1).created_time    := ld_db_created_time;
    lt_db_basic_info(1).db_version      := lv_db_version;
    RETURN lt_db_basic_info;
  END;

END ZOEPKG_DVP_COMM;