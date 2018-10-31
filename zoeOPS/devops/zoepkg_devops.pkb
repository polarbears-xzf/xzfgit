CREATE OR REPLACE PACKAGE BODY ZOEDEVOPS.ZOEPKG_DEVOPS
AS

  PROCEDURE MODIFY_REMOTE_USER_INFO (iv_project_id IN VARCHAR2, remote_seq NUMBER, iv_username IN VARCHAR2, iv_password VARCHAR2) AS
    lv_encrypted_text     VARCHAR2(128);
  BEGIN
    lv_encrypted_text := ZOEDEVOPS.ENCRYPT_USER(iv_username,iv_password);
    UPDATE ZOEDEVOPS.DVP_PROJ_REMOTE_ADMIN_INFO SET REMOTE_PASSWORD = lv_encrypted_text, 
        MODIFIER_CODE='ZOEBG', MODIFIED_TIME=SYSDATE
      WHERE project_id#  = iv_project_id AND REMOTE_SEQ = remote_seq AND REMOTE_USER = iv_username;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
  END MODIFY_REMOTE_USER_INFO;

  PROCEDURE MODIFY_SERVER_USER_INFO (iv_project_id IN VARCHAR2, iv_ip_address VARCHAR2, iv_username IN VARCHAR2, iv_password VARCHAR2) AS
    lv_encrypted_text     VARCHAR2(128);
  BEGIN
    lv_encrypted_text := ZOEDEVOPS.ENCRYPT_USER(iv_username,iv_password);
    UPDATE ZOEDEVOPS.DVP_PROJ_SERVER_ADMIN_INFO SET ADMIN_PASSWORD = lv_encrypted_text, MODIFIER_CODE='ZOEBG', MODIFIED_TIME=SYSDATE
      WHERE project_id#  = iv_project_id AND SERVER_IP_ADDRESS = iv_ip_address AND ADMIN_USER = iv_username;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
  END MODIFY_SERVER_USER_INFO;
	
  PROCEDURE SYNC_PROJ_DB_INFO(iv_project_id IN VARCHAR2) 
  AS
    lv_db_id             VARCHAR2(64);
    lv_db_name           VARCHAR2(64);
    lv_host_name         VARCHAR2(64);
    lv_ip_address        VARCHAR2(64);
    ld_db_created_time   VARCHAR2(64);
    lv_db_version        VARCHAR2(64);
    lv_db_link           VARCHAR2(64);
    lv_sql               VARCHAR2(4000);
    ln_db_exist          NUMBER;
  BEGIN
    FOR c1 IN (SELECT A.DB_LINK_NAME
                FROM ZOEDEVOPS.DVP_PROJ_NODE_DB_LINKS A, SYS.DBA_DB_LINKS B
                WHERE A.DB_LINK_NAME = B.DB_LINK)
    LOOP
      ln_db_exist := 0 ;
      lv_db_link    := c1.DB_LINK_NAME;
      lv_sql  := 'SELECT DB_ID,DB_NAME,HOST_NAME,IP_ADDRESS,DB_CREATED_TIME,DB_VERSION ';
      lv_sql  := lv_sql||' FROM ZOEDEVOPS.DVP_DB_BASIC_INFO@'||lv_db_link;
      EXECUTE IMMEDIATE lv_sql INTO lv_db_id, lv_db_name, lv_host_name, lv_ip_address, ld_db_created_time, lv_db_version;
      lv_sql  := 'UPDATE ZOEDEVOPS.DVP_PROJ_NODE_DB_LINKS SET PROJECT_ID#=:1,DB_ID#=:2 WHERE DB_LINK_NAME=:3';
      EXECUTE IMMEDIATE lv_sql USING iv_project_id, lv_db_id, lv_db_link;
      SELECT COUNT(1) INTO ln_db_exist FROM ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO WHERE PROJECT_ID#=iv_project_id AND DB_ID=lv_db_id;
      IF ln_db_exist = 1 THEN
        lv_sql  := 'UPDATE ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO SET ';
        lv_sql  := lv_sql||' DB_NAME=:1, HOST_NAME=:2, IP_ADDRESS=:3, DB_CREATED_TIME=:4, DB_VERSION=:5 ';
        lv_sql  := lv_sql||' WHERE PROJECT_ID#=:6 AND DB_ID=:7';
        EXECUTE IMMEDIATE lv_sql USING lv_db_name, lv_host_name, lv_ip_address, ld_db_created_time, lv_db_version,iv_project_id, lv_db_id;
      ELSE 
        lv_sql  := 'INSERT INTO ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO ';
        lv_sql  := lv_sql||' (PROJECT_ID#, DB_ID, DB_NAME,HOST_NAME,IP_ADDRESS,DB_CREATED_TIME,DB_VERSION)';
        lv_sql  := lv_sql||' VALUES (:1, :2, :3, :4, :5, :6, :7)';
        EXECUTE IMMEDIATE lv_sql USING iv_project_id, lv_db_id, lv_db_name, lv_host_name, lv_ip_address, ld_db_created_time, lv_db_version;
      END IF;
      
      lv_sql  :=         'INSERT INTO  ZOEDEVOPS.DVP_PROJ_DB_USER_ADMIN_INFO ';
      lv_sql  := lv_sql||' (SELECT 1, B.*, '''' FROM ZOEDEVOPS.DVP_DB_USER_INFO@'||lv_db_link||' B WHERE NOT EXISTS ';
      lv_sql  := lv_sql||' (SELECT 1 FROM ZOEDEVOPS.DVP_PROJ_DB_USER_ADMIN_INFO A ';
      lv_sql  := lv_sql||' WHERE A.DB_ID#=B.DB_ID# AND A.USERNAME=B.USERNAME AND A.PROJECT_ID#=:1))';
      EXECUTE IMMEDIATE lv_sql USING iv_project_id;
      lv_sql  :=         'UPDATE ZOEDEVOPS.DVP_PROJ_DB_USER_ADMIN_INFO A SET ';
      lv_sql  := lv_sql||' (USERNAME,USER_PASSWORD,MODIFIER_CODE,MODIFIED_TIME) = ';
      lv_sql  := lv_sql||' (SELECT USERNAME,USER_PASSWORD,MODIFIER_CODE,MODIFIED_TIME FROM ZOEDEVOPS.DVP_DB_USER_INFO@'||lv_db_link||' B ';
      lv_sql  := lv_sql||'     WHERE A.DB_ID#=B.DB_ID# AND A.USERNAME=B.USERNAME AND A.PROJECT_ID#=:1) ';
      lv_sql  := lv_sql||' WHERE EXISTS (SELECT 1 FROM ZOEDEVOPS.DVP_DB_USER_INFO@'||lv_db_link||' B ';
      lv_sql  := lv_sql||'     WHERE A.DB_ID#=B.DB_ID# AND A.USERNAME=B.USERNAME AND A.PROJECT_ID#=:2)';
      EXECUTE IMMEDIATE lv_sql USING iv_project_id,iv_project_id;
    END LOOP;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
  END SYNC_PROJ_DB_INFO;
  
END ZOEPKG_DEVOPS;