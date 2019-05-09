--
CREATE OR REPLACE PACKAGE BODY ZOEDEVOPS.ZOEPKG_LDEVOPS
AS

-- ===================================================
--  获取数据库版本
-- ===================================================
  FUNCTION GET_DB_VERSION RETURN VARCHAR2 AS
    lv_db_version  VARCHAR2(80);
  BEGIN
    SELECT BANNER INTO lv_db_version FROM V$VERSION WHERE BANNER LIKE 'Oracle Database%';
    RETURN lv_db_version;
  END GET_DB_VERSION;

  FUNCTION GET_DB_ID RETURN VARCHAR2 AS
     lv_db_version         VARCHAR2(3);          --数据库软件版本号
     lv_ip_address  VARCHAR2(15);                --服务器IP地址
     lv_host_name        VARCHAR2(128);          --服务器名称
     lv_db_name            VARCHAR2(64);         --数据库名
     ld_db_created_time    DATE;                 --数据库创建时间
     lv_db_id              VARCHAR2(128);        --数据库DB_ID
     lt_db_basic_info zoetyp_db_basic_info := zoetyp_db_basic_info();      --数据库基本信息对象
  BEGIN
    lt_db_basic_info   := ZOEPKG_LDEVOPS.GET_DB_BASIC_INFO;
    lv_host_name       := lt_db_basic_info(1).host_name   ;
    lv_ip_address      := lt_db_basic_info(1).ip_address  ;
    lv_db_name         := lt_db_basic_info(1).db_name     ;
    ld_db_created_time :=lt_db_basic_info(1).created_time;
    lv_db_version      :=lt_db_basic_info(1).db_version  ;
    lv_db_id := ZOEDEVOPS.ZOEPKG_SECURITY.VERIFY_SH1(lv_host_name||lv_ip_address||lv_db_name||to_char(ld_db_created_time,'yyyy-mm-dd hh24:mi:ss')||lv_db_version);
    RETURN lv_db_id;
  END GET_DB_ID;

  FUNCTION GET_DB_BASIC_INFO RETURN zoetyp_db_basic_info AS
   lt_db_basic_info zoetyp_db_basic_info := zoetyp_db_basic_info();      --数据库基本信息对象
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
  
  PROCEDURE ALTER_DB_USER(iv_username IN VARCHAR2, iv_password IN VARCHAR2 DEFAULT NULL) AS
    lv_password VARCHAR2(128);
    lv_sql_ddl  VARCHAR2(400);
    ln_user_exist NUMBER;
    lv_dbid     VARCHAR2(64);
  BEGIN
    IF iv_password is null THEN
      SELECT  DBMS_RANDOM.STRING('X',12) INTO lv_password FROM DUAL;
      lv_password := 'Zoe$'||lv_password;
    ELSE 
      lv_password := iv_password;
    END IF;
    select count(1) INTO ln_user_exist from dba_users where username=iv_username;
    IF ln_user_exist = 1 THEN
      lv_sql_ddl := 'ALTER USER '||iv_username||' IDENTIFIED BY '||lv_password;
    ELSE
      lv_sql_ddl := 'CREATE USER '||iv_username||' IDENTIFIED BY '||lv_password;
    END IF;
    EXECUTE IMMEDIATE lv_sql_ddl;
    lv_dbid := ZOEDEVOPS.ZOEPKG_LDEVOPS.GET_DB_ID;
    select count(1) INTO ln_user_exist from ZOEDEVOPS.DVP_DB_USER_INFO where DB_ID# = lv_dbid and USERNAME = iv_username;
    IF ln_user_exist = 1 THEN
      ZOEDEVOPS.ZOEPKG_LDEVOPS.MODIFY_DB_USER_INFO(lv_dbid, iv_username, lv_password);
    ELSE
      ZOEDEVOPS.ZOEPKG_LDEVOPS.SAVE_DB_USER_INFO(lv_dbid, iv_username, lv_password);
    END IF;
  END ALTER_DB_USER;
  
  PROCEDURE SAVE_DB_USER_INFO (iv_db_id IN VARCHAR2, iv_username IN VARCHAR2, iv_password VARCHAR2) AS
    lv_encrypted_text     VARCHAR2(128);
  BEGIN
    lv_encrypted_text := ZOEDEVOPS.ENCRYPT_USER(iv_username,iv_password);
    INSERT INTO ZOEDEVOPS.DVP_DB_USER_INFO(db_id#,USERNAME,USER_PASSWORD,CREATOR_CODE,CREATED_TIME) VALUES (iv_db_id,iv_username,lv_encrypted_text,'ZOEBG',SYSDATE);
    COMMIT;
  END SAVE_DB_USER_INFO;

  PROCEDURE MODIFY_DB_USER_INFO (iv_db_id IN VARCHAR2, iv_username IN VARCHAR2, iv_password VARCHAR2) AS
    lv_encrypted_text     VARCHAR2(128);
  BEGIN
    lv_encrypted_text := ZOEDEVOPS.ENCRYPT_USER(iv_username,iv_password);
    UPDATE ZOEDEVOPS.DVP_DB_USER_INFO SET USER_PASSWORD = lv_encrypted_text, MODIFIER_CODE='ZOEBG',MODIFIED_TIME=SYSDATE
      WHERE DB_ID#  = iv_db_id AND USERNAME = iv_username;
    COMMIT;
  END MODIFY_DB_USER_INFO;

  PROCEDURE INIT_LOCAL_DB_BASIC_INFO AS
     lv_db_version         VARCHAR2(3);          --数据库软件版本号
     lv_ip_address         VARCHAR2(15);         --服务器IP地址
     lv_host_name          VARCHAR2(128);        --服务器名称
     lv_db_name            VARCHAR2(64);         --数据库名
     ld_db_created_time    DATE;                 --数据库创建时间
     lv_db_id              VARCHAR2(128);        --数据库DB_ID
     lt_db_basic_info zoetyp_db_basic_info := zoetyp_db_basic_info();      --数据库基本信息对象
  BEGIN
    lt_db_basic_info   := ZOEPKG_LDEVOPS.GET_DB_BASIC_INFO;
    lv_host_name       := lt_db_basic_info(1).host_name   ;
    lv_ip_address      := lt_db_basic_info(1).ip_address  ;
    lv_db_name         := lt_db_basic_info(1).db_name     ;
    ld_db_created_time :=lt_db_basic_info(1).created_time;
    lv_db_version      :=lt_db_basic_info(1).db_version  ;
    lv_db_id := ZOEPKG_LDEVOPS.GET_DB_ID;
    EXECUTE IMMEDIATE 'TRUNCATE TABLE ZOEDEVOPS.DVP_DB_BASIC_INFO';
      insert into ZOEDEVOPS.DVP_DB_BASIC_INFO(db_id,db_name,host_name,ip_address,db_created_time,db_version) 
        values (lv_db_id,lv_db_name,lv_host_name,lv_ip_address,ld_db_created_time,lv_db_version);
      commit;
  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
  END INIT_LOCAL_DB_BASIC_INFO;
  

END ZOEPKG_LDEVOPS;
/
