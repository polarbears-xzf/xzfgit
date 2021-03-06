-- =====================================================

CREATE OR REPLACE PACKAGE BODY ZOEDEVOPS.ZOEPKG_OPS_DB_INFO


-- Created in 2019.06.18 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		ZOEPKG_OPS_DB_INFO.pkb
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
-- 获取数据库版本
-- ===================================================
  FUNCTION GET_DB_VERSION RETURN VARCHAR2 
  AS
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
     lt_db_basic_info zoett_db_basic_info := zoett_db_basic_info();      --数据库基本信息对象
  BEGIN
    lt_db_basic_info   := ZOEPKG_OPS_DB_INFO.GET_DB_BASIC_INFO;
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
    lt_db_basic_info(1) := zoeto_db_basic_info(null,null,null,null,null);
    lt_db_basic_info(1).host_name       := SYS_CONTEXT('USERENV', 'SERVER_HOST');
    lt_db_basic_info(1).ip_address      := utl_inaddr.get_host_address;
    lt_db_basic_info(1).db_name         := SYS_CONTEXT('USERENV', 'DB_NAME');
    lt_db_basic_info(1).created_time    := ld_db_created_time;
    lt_db_basic_info(1).db_version      := lv_db_version;
    RETURN lt_db_basic_info;
  END;
  
  PROCEDURE INIT_PROJ_DB_BASIC_INFO(in_project_id IN VARCHAR2 DEFAULT NULL) AS
     lv_db_version         VARCHAR2(3);          --数据库软件版本号
     lv_ip_address         VARCHAR2(15);         --服务器IP地址
     lv_host_name          VARCHAR2(128);        --服务器名称
     lv_db_name            VARCHAR2(64);         --数据库名
     ld_db_created_time    DATE;                 --数据库创建时间
     lv_db_id              VARCHAR2(128);        --数据库DB_ID
     lv_porject_id         VARCHAR2(64);         --项目ID
     lt_db_basic_info zoett_db_basic_info := zoett_db_basic_info();      --数据库基本信息对象
  BEGIN
    lt_db_basic_info   := ZOEPKG_OPS_DB_INFO.GET_DB_BASIC_INFO;
    lv_host_name       := lt_db_basic_info(1).host_name   ;
    lv_ip_address      := lt_db_basic_info(1).ip_address  ;
    lv_db_name         := lt_db_basic_info(1).db_name     ;
    ld_db_created_time :=lt_db_basic_info(1).created_time;
    lv_db_version      :=lt_db_basic_info(1).db_version  ;
    lv_db_id := ZOEPKG_OPS_DB_INFO.GET_DB_ID;
    IF in_project_id IS NULL  THEN
        lv_porject_id := sys_guid();
    ELSE 
        lv_porject_id := in_project_id;
    END IF;
    
    --EXECUTE IMMEDIATE 'TRUNCATE TABLE ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO';
      insert into ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO(PROJECT_ID#,DB_ID,DB_NAME,
            SERVER_NAME,SERVER_IP_ADDRESS#,DB_CREATED_TIME,DB_VERSION,CREATOR_CODE,CREATED_TIME) 
        values (lv_porject_id,lv_db_id,lv_db_name,
            lv_host_name,lv_ip_address,ld_db_created_time,lv_db_version,
            SYS_CONTEXT('USERENV','OS_USER')||':'||SYS_CONTEXT('USERENV','HOST')||':'||SYS_CONTEXT('USERENV','SESSION_USER'),SYSDATE);
      commit;
  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
  END INIT_PROJ_DB_BASIC_INFO;

 
END ZOEPKG_OPS_DB_INFO;

/
