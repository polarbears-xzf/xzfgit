CREATE OR REPLACE PACKAGE BODY zoestd.zoepkg_meta_sync
AS
--  初始化对象同步
--    初始化用户
  PROCEDURE init_db_user(
      in_force_flag VARCHAR2 DEFAULT NULL)
  AS
--  =======================================
--  局部变量声明
--  =======================================
  BEGIN
    IF in_force_flag = 'YES' THEN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE META_USER$';
    END IF;
--  从DBA_USER表获取数据用户
    INSERT INTO META_USER$
      (USERNAME,ORACLE_MAINTAINED_FLAG,CREATOR,CREATED_TIME
      )
    SELECT USERNAME,ORACLE_MAINTAINED, SYS_CONTEXT('USERENV','SESSION_USER'), CREATED
    FROM DBA_USERS
    ORDER BY CREATED;
--  通过ZOE开头的条件获取智业数据库用户，设置“USER_SOURCE”为“ZOESOFT”。
    UPDATE META_USER$ SET USER_SOURCE='ZOESOFT' WHERE USERNAME LIKE 'ZOE%';
--  通过函数zoefun_get_oracle_user获取Oracle用户，设置设置“USER_SOURCE”为“ORACLE”。
    UPDATE META_USER$
    SET USER_SOURCE ='ORACLE'
    WHERE USERNAME IN
      (SELECT COLUMN_VALUE FROM TABLE(ZOESYSMAN.Zoepkg_Utility.Get_Oracle_User)
      );
    COMMIT;
  END init_db_user;
----初始化对象
  PROCEDURE init_db_object(
      in_force_flag VARCHAR2 DEFAULT NULL)
  AS
    -- =======================================
    -- 局部变量声明
    -- =======================================
  BEGIN
    IF in_force_flag = 'YES' THEN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE META_OBJ$';
    END IF;
    INSERT
    INTO ZOESTD.META_OBJ$
      (
        DB_OBJ#,USER#,OBJ_NAME,OBJ_TYPE#,
        CREATOR,CREATED_TIME,MODIFIER,MODIFIED_TIME
      )
    SELECT OBJECT_ID,
      (SELECT USER# FROM META_USER$ u WHERE u.USERNAME=o.OWNER) AS USER#,OBJECT_NAME, 
      DECODE(OBJECT_TYPE,'TABLE','1','VIEW','2','SEQUENCE',3,NULL) AS OBJECT_TYPE#, 
      SYS_CONTEXT('USERENV','SESSION_USER') AS CREATOR,
      CREATED,SYS_CONTEXT('USERENV','SESSION_USER') AS MODIFIER,TO_DATE(TIMESTAMP,'YYYY-MM-DD HH24:MI:SS')
    FROM DBA_OBJECTS o
    WHERE OWNER NOT IN
      ( SELECT COLUMN_VALUE FROM TABLE(ZOESYSMAN.Zoepkg_Utility.Get_Oracle_User)
      )
      AND OBJECT_TYPE IN ('TABLE','VIEW','SEQUENCE');
      COMMIT;
  END init_db_object;
----初始化表
  PROCEDURE init_db_table(
      in_force_flag VARCHAR2 DEFAULT NULL)
  AS
    -- =======================================
    -- 局部变量声明
    -- =======================================
  BEGIN
    IF in_force_flag = 'YES' THEN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE META_TAB$';
    END IF;
    INSERT INTO META_TAB$
      (obj#,user#,tab_name,tab_chn_name,tab_checksum,memo
      )
    SELECT o.OBJ#,o.USER#,o.OBJ_NAME, SUBSTR(tm.COMMENTS,1,DECODE(INSTR(tm.COMMENTS,'#|'),0,LENGTH(tm.COMMENTS),INSTR(tm.COMMENTS,'#|')-1)) AS COLUMN_CHN_NAME,
          (SELECT ZOESYSMAN.ZOEPKG_UTILITY.VERIFY_SH1(TABLE_INFO||TABLE_PK_INFO）
          FROM
            (SELECT 
              LISTAGG(COLUMN_NAME||DATA_TYPE||DATA_LENGTH||DATA_PRECISION) within GROUP (ORDER BY COLUMN_ID) AS TABLE_INFO
            FROM DBA_TAB_COLUMNS where owner=tm.OWNER and table_name=tm.TABLE_NAME) a,
            (SELECT 
              LISTAGG(B.COLUMN_NAME) within GROUP (ORDER BY B.POSITION) AS TABLE_PK_INFO
            FROM DBA_CONSTRAINTS a, DBA_CONS_COLUMNS B
            WHERE a.OWNER = B.OWNER AND a.TABLE_NAME =B.TABLE_NAME
              AND a.CONSTRAINT_NAME = B.CONSTRAINT_NAME AND a.CONSTRAINT_TYPE ='P'
              and A.owner=tm.OWNER and A.table_name=tm.TABLE_NAME
            ) B
       ),
          SUBSTR(tm.COMMENTS,DECODE(INSTR(tm.COMMENTS,'#|'),0,LENGTH(tm.COMMENTS)+1,INSTR(tm.COMMENTS,'#|')+2),LENGTH(tm.COMMENTS)) AS MEMO
        FROM ZOESTD.META_OBJ$ o , ZOESTD.META_USER$ u , DBA_TAB_COMMENTS tm
        WHERE o.OBJ_TYPE#  =1
          AND o.USER#      =u.USER#
          AND tm.OWNER     =u.USERNAME
          AND tm.TABLE_NAME=o.OBJ_NAME;
    COMMIT;
  END init_db_table;
----初始化列
  PROCEDURE init_db_column(
      in_force_flag VARCHAR2 DEFAULT NULL)
  AS
    -- =======================================
    -- 局部变量声明
    -- =======================================
  BEGIN
    IF in_force_flag = 'YES' THEN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE META_COL$';
    END IF;
    INSERT
    INTO META_COL$
      (
        OBJ#,COL_ID,COL_NAME,COL_CHN_NAME,
        DATA_TYPE,DATA_LENGTH,DATA_PRECISION,DATA_SCALE,
        DATA_DEFAULT,MEMO
      )
    SELECT t.OBJ#,cl.COLUMN_ID,cl.COLUMN_NAME, 
      SUBSTR(cm.COMMENTS,1,DECODE(INSTR(cm.COMMENTS,'#|'),0,LENGTH(cm.COMMENTS),INSTR(cm.COMMENTS,'#|')-1)) AS COLUMN_CHN_NAME,
      cl.DATA_TYPE,cl.DATA_LENGTH,cl.DATA_PRECISION,cl.DATA_SCALE,to_lob(cl.DATA_DEFAULT), 
      SUBSTR(cm.COMMENTS,DECODE(INSTR(cm.COMMENTS,'#|'),0,LENGTH(cm.COMMENTS)+1,INSTR(cm.COMMENTS,'#|')+2),LENGTH(cm.COMMENTS)) AS MEMO
    FROM DBA_TAB_COLS cl ,DBA_COL_COMMENTS cm ,META_TAB$ t ,META_USER$ u
    WHERE cl.OWNER      =cm.OWNER
      AND cl.TABLE_NAME =cm.TABLE_NAME
      AND cl.COLUMN_NAME=cm.COLUMN_NAME
      AND t.USER#       =u.USER#
      AND u.USERNAME    =cl.OWNER
      AND t.TAB_NAME  =cl.TABLE_NAME;
    COMMIT;
  END init_db_column;
--增量对象同步
  PROCEDURE sync_db_user
  AS
    -- =======================================
    -- 局部变量声明
    -- =======================================
    -- Oracle 用户列表
    lv_username_string   VARCHAR2(32767);
    lv_checksum_string   VARCHAR2(128);
    ld_last_created_time DATE;
  BEGIN
    --获取数据库所有用户名并用户名排序拼接成字符串
    SELECT listagg(username) within GROUP (
    ORDER BY username)
    INTO lv_username_string
    FROM DBA_USERS;
    --获取数据库用户最后创建时间
    SELECT MAX(CREATED) INTO ld_last_created_time FROM DBA_USERS;
    lv_checksum_string := zoefun_string_checksum(lv_username_string);
    DBMS_OUTPUT.PUT_LINE(lv_checksum_string);
  END sync_db_user;
  PROCEDURE sync_db_object
  AS
    -- =======================================
    -- 局部变量声明
    -- =======================================
  BEGIN
    NULL;
  END sync_db_object;
  PROCEDURE sync_db_table
  AS
    -- =======================================
    -- 局部变量声明
    -- =======================================
  BEGIN
    NULL;
  END sync_db_table;
  PROCEDURE sync_db_column
  AS
    -- =======================================
    -- 局部变量声明
    -- =======================================
  BEGIN
    NULL;
  END sync_db_column;
END zoepkg_meta_sync;