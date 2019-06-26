--  ===================================================

CREATE OR REPLACE PACKAGE BODY ZOEDEVOPS.ZOEPKG_OPS_COMM

-- Created in 2017.10.10 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoepkg_ops_comm.pkb
--	Description:
-- 		运维管理控制节点公共功能包
--  Relation:
--      
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--

 AS
 
-- ===================================================
--  创建数据库用户或修改用户密码
-- ===================================================
PROCEDURE SET_DB_USER(iv_key VARCHAR2, iv_username IN VARCHAR2, iv_db_id IN VARCHAR2 DEFAULT NULL, iv_password IN VARCHAR2 DEFAULT NULL) AS
    lv_username VARCHAR2(64);
    lv_password VARCHAR2(128);
    lv_sql_ddl  VARCHAR2(400);
    lv_remode_sql VARCHAR2(400);
    ln_user_exist NUMBER;
    lv_db_id     VARCHAR2(64);
    lv_db_link           VARCHAR2(64);
    ln_rows     NUMBER;
    lv_encryp_password  VARCHAR2(128);
  BEGIN
    lv_username := UPPER(iv_username);
    IF iv_password is null THEN
      SELECT  DBMS_RANDOM.STRING('X',12) INTO lv_password FROM DUAL;
      lv_password := 'Zoe$'||lv_password;
    ELSE 
      lv_password := iv_password;
    END IF;
    IF iv_db_id IS NULL THEN
        select count(1) INTO ln_user_exist from dba_users where username=lv_username;
        IF ln_user_exist = 1 THEN
          lv_sql_ddl := 'ALTER USER '||lv_username||' IDENTIFIED BY '||lv_password;
        ELSE
          lv_sql_ddl := 'CREATE USER '||lv_username||' IDENTIFIED BY '||lv_password;
        END IF;
        lv_db_id := ZOEDEVOPS.ZOEPKG_OPS_DB_INFO.GET_DB_ID;
        EXECUTE IMMEDIATE lv_sql_ddl;
    ELSE 
        lv_db_id := iv_db_id;
        SELECT A.DB_LINK_NAME INTO lv_db_link
            FROM ZOEDEVOPS.DVP_PROJ_NODE_DB_LINKS A
            WHERE A.DB_ID# = lv_db_id;
        EXECUTE IMMEDIATE 'select count(1) from dba_users@'||lv_db_link||' where username='''||lv_username||'''' INTO ln_user_exist;
        IF ln_user_exist = 1 THEN
          lv_sql_ddl := 'ALTER USER '||lv_username||' IDENTIFIED BY '||lv_password;
        ELSE
          lv_sql_ddl := 'CREATE USER '||lv_username||' IDENTIFIED BY '||lv_password;
        END IF;
        lv_remode_sql :='BEGIN ZOEDEVOPS.ZOEPRC_EXEC_SQL@'||lv_db_link||'(:1, :2); END;';
        EXECUTE IMMEDIATE lv_remode_sql using IN lv_sql_ddl,OUT ln_rows;
    END IF;
    select count(1) INTO ln_user_exist from ZOEDEVOPS.DVP_PROJ_DB_USER_ADMIN_INFO where DB_ID# = lv_db_id and USERNAME = lv_username;
    lv_encryp_password := zoedevops.zoefun_encrypt_user(lv_username,lv_password,iv_key);
    IF ln_user_exist = 1 THEN
        UPDATE ZOEDEVOPS.DVP_PROJ_DB_USER_ADMIN_INFO SET
            (user_password,modifier_code,modified_time) =
            (select lv_encryp_password,'ZOEPKG_CN_COMM.SET_DB_USER',SYSDATE from dual) 
        WHERE db_id# = lv_db_id and username = lv_username;
    ELSE
        INSERT INTO ZOEDEVOPS.DVP_PROJ_DB_USER_ADMIN_INFO 
            (project_id#,db_id#,username,user_password,creator_code,created_time) 
            SELECT project_id#,db_id,lv_username,lv_encryp_password,'ZOEPKG_CN_COMM.SET_DB_USER',SYSDATE 
                FROM ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO 
                WHERE DB_ID = lv_db_id;
      dbms_output.put_line('not exist user');
      COMMIT;
    END IF;
    EXCEPTION
      WHEN OTHERS THEN
      dbms_output.put_line('ERROR');
        ROLLBACK;
        RAISE;
  END SET_DB_USER;
  
END ZOEPKG_OPS_COMM;
