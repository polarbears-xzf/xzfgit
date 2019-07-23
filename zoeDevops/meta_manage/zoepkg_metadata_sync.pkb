CREATE OR REPLACE PACKAGE BODY ZOEDEVOPS.zoepkg_metadata_sync
AS
--  同步用户
  PROCEDURE increment_sync_user(in_db_id IN VARCHAR2, in_db_link IN VARCHAR2)
  AS
    -- =======================================
    -- 局部变量声明
    -- =======================================
    lv_username VARCHAR2(64);
    lv_user_id  VARCHAR2(64);
    lv_sql      VARCHAR2(4000);
    lc_ref_cursor SYS_REFCURSOR;
  BEGIN
    --同步已删除用户
    lv_sql := 'SELECT USER_ID,USERNAME FROM ZOESTD.meta_user$';
    lv_sql := lv_sql || ' WHERE USERNAME NOT IN(SELECT USERNAME FROM DBA_USERS@'||in_db_link||')';
    lv_sql := lv_sql || '  AND db_id#='''||in_db_id||''')';
    OPEN lc_ref_cursor FOR lv_sql;
    LOOP 
        FETCH lc_ref_cursor INTO lv_user_id,lv_username;
        EXIT WHEN lc_ref_cursor%NOTFOUND;
        lv_sql := 'DELETE FROM ZOESTD.meta_user$@'||in_db_link;
        lv_sql := lv_sql || ' WHERE USERNAME='''||lv_username||'''';
        lv_sql := lv_sql || '  AND db_id#='''||in_db_id||''')';
        DBMS_OUTPUT.PUT_LINE(lv_sql);
--        EXECUTE IMMEDIATE lv_sql;
    END LOOP;
    --同步新增用户
    lv_sql := '    INSERT INTO ZOESTD.META_USER$';
    lv_sql := lv_sql || ' (USER_ID,USERNAME,USER_SOURCE,CREATOR,CREATED_TIME,DB_USER#)';
    lv_sql := lv_sql || ' SELECT SYS_GUID(),USERNAME,';
    lv_sql := lv_sql || ' CASE WHEN USERNAME LIKE ''ZOE%'' THEN ''ZOESOFT''';
    lv_sql := lv_sql || ' WHEN USERNAME = (SELECT COLUMN_VALUE FROM TABLE(ZOEDEVOPS.ZOEPKG_UTILITY.GET_ORACLE_USER) B'; 
    lv_sql := lv_sql || ' WHERE B.COLUMN_VALUE=A.USERNAME) THEN ''ORACLE''';
    lv_sql := lv_sql || ' ELSE '''' END,';
    lv_sql := lv_sql || ' SYS_CONTEXT(''USERENV'',''SESSION_USER''),';
    lv_sql := lv_sql || ' SYSDATE,USER_ID';
    lv_sql := lv_sql || ' FROM DBA_USERS@'||in_db_link||' A ';
    lv_sql := lv_sql || ' WHERE NOT EXISTS (SELECT 1 FROM ZOESTD.META_USER$ C WHERE A.USERNAME=C.USERNAME)';
    lv_sql := lv_sql || ' ORDER BY CREATED';
    DBMS_OUTPUT.PUT_LINE(lv_sql);
--  EXECUTE IMMEDIATE lv_sql;
--  COMMIT;
   EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
 END increment_sync_user;
  
  
  PROCEDURE increment_sync_object
  AS
  BEGIN
    INSERT INTO ZOESTD.META_OBJ$
      (OBJ_ID,USER_ID#,OBJ_NAME,OBJ_TYPE_ID#,CREATOR,CREATED_TIME,DB_OBJ_ID#
      )
    SELECT SYS_GUID(),USER_ID,A.OBJECT_NAME,
        DECODE(OBJECT_TYPE,'TABLE','1','VIEW','2','SEQUENCE',3,NULL) AS OBJECT_TYPE#,
        SYS_CONTEXT('USERENV','SESSION_USER'),
        SYSDATE,OBJECT_ID
    FROM DBA_OBJECTS@ZOEMDB141ZOEAGENT A , ZOESTD.META_USER$ B
    WHERE A.OWNER=B.USERNAME AND A.OWNER LIKE 'ZOE%' 
        AND OBJECT_TYPE IN ('TABLE','VIEW','SEQUENCE')
        AND B.USERNAME NOT IN ('ZOETMP')
        AND NOT EXISTS (SELECT 1 FROM ZOESTD.META_OBJ$ Z ,ZOESTD.META_USER$ Y 
                        WHERE A.OBJECT_NAME=Z.OBJ_NAME AND Y.USERNAME=A.OWNER AND Z.USER_ID#=Y.USER_ID)
        ORDER BY TIMESTAMP;
        COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
        
  END increment_sync_object;
  
  PROCEDURE increment_sync_table
  AS
    -- =======================================
    -- 局部变量声明
    -- =======================================
  BEGIN
    INSERT INTO ZOESTD.META_TAB$
    (OBJ_ID#,USER_ID#,TAB_NAME,MODIFIER,MODIFIED_TIME
    )
    SELECT  OBJ_ID,USER_ID#,A.OBJ_NAME,
        SYS_CONTEXT('USERENV','SESSION_USER'),
        SYSDATE
    FROM ZOESTD.META_OBJ$ A 
    WHERE OBJ_TYPE_ID#=1 
        AND NOT EXISTS (SELECT 1 FROM ZOESTD.META_TAB$ Z 
                        WHERE A.USER_ID#=Z.USER_ID# AND A.OBJ_NAME=Z.TAB_NAME );
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
  END increment_sync_table;
  
  PROCEDURE increment_sync_column
  AS
    -- =======================================
    -- 局部变量声明
    -- =======================================
    ln NUMBER;
  BEGIN
    INSERT INTO ZOESTD.META_COL$
      (
        OBJ_ID#,COL_ID,COL_NAME,COL_CHN_NAME,
        DATA_TYPE,DATA_LENGTH,DATA_PRECISION,DATA_SCALE,
        DATA_DEFAULT,MEMO,CREATED_TIME
      )
    SELECT t.OBJ_ID#,cl.COLUMN_ID,cl.COLUMN_NAME, 
      SUBSTR(cm.COMMENTS,1,DECODE(INSTR(cm.COMMENTS,'#|'),0,LENGTH(cm.COMMENTS),INSTR(cm.COMMENTS,'#|')-1)) AS COLUMN_CHN_NAME,
      cl.DATA_TYPE,cl.DATA_LENGTH,cl.DATA_PRECISION,cl.DATA_SCALE,to_lob(cl.DATA_DEFAULT), 
      SUBSTR(cm.COMMENTS,DECODE(INSTR(cm.COMMENTS,'#|'),0,LENGTH(cm.COMMENTS)+1,INSTR(cm.COMMENTS,'#|')+2),LENGTH(cm.COMMENTS)) AS MEMO,SYSDATE
    FROM DBA_TAB_COLUMNS@ZOEMDB141ZOEAGENT cl ,DBA_COL_COMMENTS@ZOEMDB141ZOEAGENT cm ,ZOESTD.META_TAB$ t ,ZOESTD.META_USER$ u
    WHERE cl.OWNER      =cm.OWNER
      AND cl.TABLE_NAME =cm.TABLE_NAME
      AND cl.COLUMN_NAME=cm.COLUMN_NAME
      AND t.USER_ID#       =u.USER_ID
      AND u.USERNAME    =cl.OWNER
      AND t.TAB_NAME  =cl.TABLE_NAME
      AND NOT EXISTS (SELECT NULL FROM ZOESTD.META_COL$ mc WHERE  t.OBJ_ID#=mc.OBJ_ID# AND cl.COLUMN_NAME=mc.COL_NAME);
    
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
  END increment_sync_column;
  
--  初始化对象同步
--    初始化用户
  PROCEDURE INIT_SYNC_ALL(in_db_id IN VARCHAR2, in_force_flag IN  VARCHAR2 DEFAULT NULL)
  AS
--  =======================================
--  局部变量声明
--  =======================================
  lv_db_link VARCHAR2(64);
  lv_sql     VARCHAR2(4000);
  BEGIN
    IF in_force_flag = 'YES' THEN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE ZOESTD.META_USER$';
      EXECUTE IMMEDIATE 'TRUNCATE TABLE ZOESTD.META_OBJ$';
      EXECUTE IMMEDIATE 'TRUNCATE TABLE ZOESTD.META_TAB$';
      EXECUTE IMMEDIATE 'TRUNCATE TABLE ZOESTD.META_COL$';
    END IF;

--获取远程数据库连接
SELECT DB_LINK_NAME INTO lv_db_link FROM ZOEDEVOPS.DVP_PROJ_NODE_DB_LINKS WHERE DB_ID#=in_db_id;

--  初始化META_USER$，从DBA_USERS。设置用于所属系统，如：ORACLE，ZOESOFT
    lv_sql := 'INSERT INTO ZOESTD.META_USER$';
    lv_sql := lv_sql || ' (DB_ID#,USER_ID,USERNAME,USER_SOURCE,CREATOR,CREATED_TIME,MODIFIER,MODIFIED_TIME,DB_USER#)';
    lv_sql := lv_sql || ' SELECT '''||in_db_id||''', SYS_GUID(),USERNAME,';
    lv_sql := lv_sql || ' CASE WHEN USERNAME LIKE ''ZOE%'' THEN ''ZOESOFT''';
    lv_sql := lv_sql || ' WHEN USERNAME = (SELECT COLUMN_VALUE FROM TABLE(ZOEDEVOPS.ZOEPKG_UTILITY.GET_ORACLE_USER) B'; 
    lv_sql := lv_sql || ' WHERE B.COLUMN_VALUE=A.USERNAME) THEN ''ORACLE''';
    lv_sql := lv_sql || ' ELSE '''' END,';
    lv_sql := lv_sql || ' SYS_CONTEXT(''USERENV'',''SESSION_USER''),SYSDATE,';
    lv_sql := lv_sql || ' SYS_CONTEXT(''USERENV'',''SESSION_USER''),SYSDATE,USER_ID';
    lv_sql := lv_sql || ' FROM DBA_USERS@'||lv_db_link||' A ';
    lv_sql := lv_sql || ' ORDER BY CREATED';
--    DBMS_OUTPUT.PUT_LINE(lv_sql);
    --EXECUTE IMMEDIATE lv_sql;
--    COMMIT;
--  初始化META_OBJ$，从DBA_TABLES。排除Oracle用户，依据ZOEDEVOPS.ZOEPKG_UTILITY.GET_ORACLE_USER
    lv_sql := 'INSERT INTO ZOESTD.META_OBJ$';
    lv_sql := lv_sql || ' (DB_ID#,OBJ_ID,DB_OBJ_ID#,USER_ID#,OBJ_NAME,OBJ_TYPE_ID#,';
    lv_sql := lv_sql || ' CREATOR,CREATED_TIME,MODIFIER,MODIFIED_TIME)';
    lv_sql := lv_sql || ' SELECT '''||in_db_id||''', SYS_GUID(), OBJECT_ID,';
    lv_sql := lv_sql || ' (SELECT USER_ID FROM ZOESTD.META_USER$ u WHERE u.USERNAME=o.OWNER) AS USER#,OBJECT_NAME,';
    lv_sql := lv_sql || ' DECODE(OBJECT_TYPE,''TABLE'',''1'',''VIEW'',''2'',''SEQUENCE'',3,NULL) AS OBJECT_TYPE#,'; 
    lv_sql := lv_sql || ' SYS_CONTEXT(''USERENV'',''SESSION_USER'') AS CREATOR,SYSDATE,';
    lv_sql := lv_sql || ' SYS_CONTEXT(''USERENV'',''SESSION_USER''),SYSDATE';
    lv_sql := lv_sql || ' FROM DBA_OBJECTS@'||lv_db_link||' o';
    lv_sql := lv_sql || ' WHERE OWNER NOT IN';
    lv_sql := lv_sql || ' ( SELECT COLUMN_VALUE FROM TABLE(ZOEDEVOPS.ZOEPKG_UTILITY.GET_ORACLE_USER))';
    lv_sql := lv_sql || ' AND OBJECT_TYPE IN (''TABLE'',''VIEW'',''SEQUENCE'')';
--    DBMS_OUTPUT.PUT_LINE(lv_sql);
    --EXECUTE IMMEDIATE lv_sql;
--    COMMIT;
--  初始化META_TAB$，从META_OBJ$视图
    lv_sql := 'INSERT INTO ZOESTD.META_TAB$';
    lv_sql := lv_sql || ' (DB_ID#,obj_ID#,user_ID#,tab_name,tab_chn_name,tab_checksum,memo)';
    lv_sql := lv_sql || ' SELECT '''||in_db_id||''', o.OBJ_ID,o.USER_ID#,o.OBJ_NAME, SUBSTR(tm.COMMENTS,1,DECODE(INSTR(tm.COMMENTS,''#|''),';
    lv_sql := lv_sql || ' 0,LENGTH(tm.COMMENTS),INSTR(tm.COMMENTS,''#|'')-1)) AS COLUMN_CHN_NAME,';
    lv_sql := lv_sql || ' (SELECT ZOEDEVOPS.ZOEPKG_SECURITY.VERIFY_SH1(TABLE_INFO||TABLE_PK_INFO)';
    lv_sql := lv_sql || ' FROM (SELECT ';
    lv_sql := lv_sql || ' LISTAGG(COLUMN_NAME||DATA_TYPE||DATA_LENGTH||DATA_PRECISION) within GROUP (ORDER BY COLUMN_ID) AS TABLE_INFO';
    lv_sql := lv_sql || ' FROM DBA_TAB_COLUMNS@'||lv_db_link||' where owner=tm.OWNER and table_name=tm.TABLE_NAME) a,';
    lv_sql := lv_sql || ' (SELECT LISTAGG(B.COLUMN_NAME) within GROUP (ORDER BY B.POSITION) AS TABLE_PK_INFO';
    lv_sql := lv_sql || ' FROM DBA_CONSTRAINTS a, DBA_CONS_COLUMNS B';
    lv_sql := lv_sql || ' WHERE a.OWNER = B.OWNER AND a.TABLE_NAME =B.TABLE_NAME';
    lv_sql := lv_sql || ' AND a.CONSTRAINT_NAME = B.CONSTRAINT_NAME AND a.CONSTRAINT_TYPE =''P''';
    lv_sql := lv_sql || ' and A.owner=tm.OWNER and A.table_name=tm.TABLE_NAME) B ),';
    lv_sql := lv_sql || ' SUBSTR(tm.COMMENTS,DECODE(INSTR(tm.COMMENTS,''#|''),';
    lv_sql := lv_sql || ' 0,LENGTH(tm.COMMENTS)+1,INSTR(tm.COMMENTS,''#|'')+2),LENGTH(tm.COMMENTS)) AS MEMO';
    lv_sql := lv_sql || ' FROM ZOESTD.META_OBJ$ o , ZOESTD.META_USER$ u , DBA_TAB_COMMENTS@'||lv_db_link||' tm';
    lv_sql := lv_sql || ' WHERE o.OBJ_TYPE_ID#  =1';
    lv_sql := lv_sql || ' AND o.USER_ID#      =u.USER_ID';
    lv_sql := lv_sql || ' AND tm.OWNER     =u.USERNAME';
    lv_sql := lv_sql || ' AND tm.TABLE_NAME=o.OBJ_NAME';
--    DBMS_OUTPUT.PUT_LINE(lv_sql);
    --EXECUTE IMMEDIATE lv_sql;
--    COMMIT;
--  初始化META_COL$，从META_TAB$，DBA_TAB_COLS视图
    FOR c1 IN (SELECT u.USERNAME, t.TAB_NAME, t.OBJ_ID# FROM ZOESTD.META_TAB$ t, ZOESTD.META_USER$ u WHERE t.USER_ID# = u.USER_ID)
    LOOP
        lv_sql := 'INSERT INTO ZOESTD.META_COL$(';
        lv_sql := lv_sql || ' DB_ID#,OBJ_ID#,COL_ID,COL_NAME,COL_CHN_NAME,';
        lv_sql := lv_sql || ' DATA_TYPE,DATA_LENGTH,DATA_PRECISION,DATA_SCALE,NULLABLE,PK_FLAG,';
        lv_sql := lv_sql || ' MEMO, CREATOR,CREATED_TIME,MODIFIER,MODIFIED_TIME)';
        lv_sql := lv_sql || ' SELECT '''||in_db_id||''', '''||c1.OBJ_ID#||''',cl.COLUMN_ID,cl.COLUMN_NAME, ';
        lv_sql := lv_sql || ' SUBSTR(cm.COMMENTS,1,DECODE(INSTR(cm.COMMENTS,''#|''),';
        lv_sql := lv_sql || ' 0,LENGTH(cm.COMMENTS),INSTR(cm.COMMENTS,''#|'')-1)) AS COLUMN_CHN_NAME,';
        lv_sql := lv_sql || ' cl.DATA_TYPE,cl.DATA_LENGTH,cl.DATA_PRECISION,cl.DATA_SCALE, ';
        lv_sql := lv_sql || ' cl.nullable, ';
        lv_sql := lv_sql || ' nvl((select ''1'' from dba_constraints@'||lv_db_link||' a, dba_cons_columns@'||lv_db_link||' b';
        lv_sql := lv_sql || ' where a.constraint_type = ''P'' and a.constraint_name=b.constraint_name and a.owner=b.owner';
        lv_sql := lv_sql || ' and a.owner=cl.owner and a.table_name=cl.table_name and b.column_name=cl.column_name), null),';
        lv_sql := lv_sql || ' SUBSTR(cm.COMMENTS,DECODE(INSTR(cm.COMMENTS,''#|''),';
        lv_sql := lv_sql || ' 0,LENGTH(cm.COMMENTS)+1,INSTR(cm.COMMENTS,''#|'')+2),LENGTH(cm.COMMENTS)) AS MEMO,';
        lv_sql := lv_sql || ' SYS_CONTEXT(''USERENV'',''SESSION_USER''),SYSDATE,';
        lv_sql := lv_sql || ' SYS_CONTEXT(''USERENV'',''SESSION_USER''),SYSDATE';
        lv_sql := lv_sql || ' FROM DBA_TAB_COLUMNS@'||lv_db_link||' cl ,DBA_COL_COMMENTS@'||lv_db_link||' cm ';
        lv_sql := lv_sql || ' WHERE cl.OWNER = cm.OWNER';
        lv_sql := lv_sql || ' AND cl.TABLE_NAME = cm.TABLE_NAME';
        lv_sql := lv_sql || ' AND cl.COLUMN_NAME = cm.COLUMN_NAME';
        lv_sql := lv_sql || ' AND cl.OWNER = '''||c1.USERNAME||'''';
        lv_sql := lv_sql || ' AND cl.TABLE_NAME = '''||c1.TAB_NAME||'''';
--        DBMS_OUTPUT.PUT_LINE(lv_sql);
        EXECUTE IMMEDIATE lv_sql;
        COMMIT;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        RAISE;
  END INIT_SYNC_ALL;

--增量同步
  PROCEDURE increment_sync_all(in_db_id IN VARCHAR2)
  AS
    -- =======================================
    -- 局部变量声明
    -- =======================================
    lv_db_link VARCHAR2(64);
  BEGIN
    --获取远程数据库连接
    SELECT DB_LINK_NAME INTO lv_db_link FROM ZOEDEVOPS.DVP_PROJ_NODE_DB_LINKS WHERE DB_ID#=in_db_id;
    --增量同步用户
    increment_sync_user(in_db_id,lv_db_link);
  EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
  END increment_sync_all;



  END zoepkg_metadata_sync;
/
