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
    lv_sql := lv_sql || '  AND db_id#='''||in_db_id||'''';
--    DBMS_OUTPUT.PUT_LINE(lv_sql);
    OPEN lc_ref_cursor FOR lv_sql;
    LOOP 
        FETCH lc_ref_cursor INTO lv_user_id,lv_username;
        EXIT WHEN lc_ref_cursor%NOTFOUND;
        --同步已删除列元数据
        lv_sql := 'DELETE from ZOESTD.meta_col$ where (db_id#,obj_id#) in';
        lv_sql := lv_sql || ' (select a.db_id#,a.obj_id from zoestd.meta_obj$ a, ZOESTD.meta_user$ b';
        lv_sql := lv_sql || ' where a.user_id#=b.user_id ';
        lv_sql := lv_sql || ' and b.db_id#='''||in_db_id||'''';
        lv_sql := lv_sql || ' and b.user_id='''||lv_user_id||''')';
--        DBMS_OUTPUT.PUT_LINE(lv_sql);
        EXECUTE IMMEDIATE lv_sql;
        COMMIT;
        --同步已删除表元数据
        lv_sql := 'DELETE from ZOESTD.meta_tab$ ';
        lv_sql := lv_sql || ' where db_id#='''||in_db_id||'''';
        lv_sql := lv_sql || ' and user_id#='''||lv_user_id||'''';
--        DBMS_OUTPUT.PUT_LINE(lv_sql);
        EXECUTE IMMEDIATE lv_sql;
        COMMIT;
      --同步已删除对象元数据
        lv_sql := 'DELETE from ZOESTD.meta_obj$ ';
        lv_sql := lv_sql || ' where db_id#='''||in_db_id||'''';
        lv_sql := lv_sql || ' and user_id#='''||lv_user_id||'''';
--        DBMS_OUTPUT.PUT_LINE(lv_sql);
        EXECUTE IMMEDIATE lv_sql;
        COMMIT;
        --删除用户元数据
        lv_sql := 'DELETE FROM ZOESTD.meta_user$';
        lv_sql := lv_sql || ' WHERE db_id#='''||in_db_id||'''';
        lv_sql := lv_sql || '  AND user_id='''||lv_user_id||'''';
--        DBMS_OUTPUT.PUT_LINE(lv_sql);
        EXECUTE IMMEDIATE lv_sql;
        COMMIT;
    END LOOP;
    --同步新增用户
    lv_sql := '    INSERT INTO ZOESTD.META_USER$';
    lv_sql := lv_sql || ' (DB_ID#,USER_ID,USERNAME,USER_SOURCE,CREATOR,CREATED_TIME,MODIFIER,MODIFIED_TIME,DB_USER#)';
    lv_sql := lv_sql || ' SELECT '''||in_db_id||''',SYS_GUID(),USERNAME,';
    lv_sql := lv_sql || ' CASE WHEN USERNAME LIKE ''ZOE%'' THEN ''ZOESOFT''';
    lv_sql := lv_sql || ' WHEN USERNAME = (SELECT COLUMN_VALUE FROM TABLE(ZOEDEVOPS.ZOEPKG_UTILITY.GET_ORACLE_USER) B'; 
    lv_sql := lv_sql || ' WHERE B.COLUMN_VALUE=A.USERNAME) THEN ''ORACLE''';
    lv_sql := lv_sql || ' ELSE '''' END,';
    lv_sql := lv_sql || ' SYS_CONTEXT(''USERENV'',''SESSION_USER''),SYSDATE,';
    lv_sql := lv_sql || ' SYS_CONTEXT(''USERENV'',''SESSION_USER''),SYSDATE,USER_ID';
    lv_sql := lv_sql || ' FROM DBA_USERS@'||in_db_link||' A ';
    lv_sql := lv_sql || ' WHERE NOT EXISTS (SELECT 1 FROM ZOESTD.META_USER$ C WHERE A.USERNAME=C.USERNAME AND C.DB_ID#='''||in_db_id||''')';
    lv_sql := lv_sql || ' ORDER BY CREATED';
--    DBMS_OUTPUT.PUT_LINE(lv_sql);
    EXECUTE IMMEDIATE lv_sql;
    COMMIT;
   EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
 END increment_sync_user;
  
  
  PROCEDURE increment_sync_object(in_db_id IN VARCHAR2, in_db_link IN VARCHAR2)
  AS
    -- =======================================
    -- 局部变量声明
    -- =======================================
    lv_sql      VARCHAR2(4000);
 BEGIN
    --同步删除对象
    lv_sql := 'DELETE from ZOESTD.meta_obj$ a';
    lv_sql := lv_sql || ' where not exists (select 1 from zoestd.meta_user$ b ,dba_objects@'||in_db_link||' c ';
    lv_sql := lv_sql || ' where a.user_id#=b.user_id and b.username=c.owner and a.obj_name=c.object_name';
    lv_sql := lv_sql || ' and b.db_id#='''||in_db_id||''')';
    lv_sql := lv_sql || ' and a.db_id#='''||in_db_id||'''';
--    DBMS_OUTPUT.PUT_LINE(lv_sql);
    EXECUTE IMMEDIATE lv_sql;
    COMMIT;
    --同步新增对象
    lv_sql := 'INSERT INTO ZOESTD.META_OBJ$';
    lv_sql := lv_sql || ' (DB_ID#,OBJ_ID,USER_ID#,OBJ_NAME,OBJ_TYPE_ID#,CREATOR,CREATED_TIME,MODIFIER,MODIFIED_TIME,DB_OBJ_ID#)';
    lv_sql := lv_sql || ' SELECT '''||in_db_id||''',SYS_GUID(),USER_ID,A.OBJECT_NAME,';
    lv_sql := lv_sql || ' DECODE(OBJECT_TYPE,''TABLE'',''1'',''VIEW'',''2'',''SEQUENCE'',3,NULL) AS OBJECT_TYPE#,';
    lv_sql := lv_sql || ' SYS_CONTEXT(''USERENV'',''SESSION_USER''),SYSDATE,';
    lv_sql := lv_sql || ' SYS_CONTEXT(''USERENV'',''SESSION_USER''),SYSDATE,OBJECT_ID';
    lv_sql := lv_sql || ' FROM DBA_OBJECTS@'||in_db_link||' A , ZOESTD.META_USER$ B';
    lv_sql := lv_sql || ' WHERE A.OWNER=B.USERNAME AND (A.OWNER LIKE ''ZOE%'' OR A.OWNER = ''QUERY'') ';
    lv_sql := lv_sql || ' AND OBJECT_TYPE IN (''TABLE'',''VIEW'',''SEQUENCE'')';
    lv_sql := lv_sql || ' AND B.USERNAME NOT IN (''ZOETMP'')';
    lv_sql := lv_sql || ' AND B.DB_ID#='''||in_db_id||'''';
    lv_sql := lv_sql || ' AND NOT EXISTS (SELECT 1 FROM ZOESTD.META_OBJ$ Z ,ZOESTD.META_USER$ Y ';
    lv_sql := lv_sql || ' WHERE A.OBJECT_NAME=Z.OBJ_NAME AND Y.USERNAME=A.OWNER AND Z.USER_ID#=Y.USER_ID';
    lv_sql := lv_sql || ' AND Z.DB_ID#='''||in_db_id||'''';
    lv_sql := lv_sql || ' AND Y.DB_ID#='''||in_db_id||''')';
    lv_sql := lv_sql || ' ORDER BY TIMESTAMP';
--    DBMS_OUTPUT.PUT_LINE(lv_sql);
    EXECUTE IMMEDIATE lv_sql;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
        
  END increment_sync_object;
  
  PROCEDURE increment_sync_table(in_db_id IN VARCHAR2, in_db_link IN VARCHAR2)
  AS
    -- =======================================
    -- 局部变量声明
    -- =======================================
    lv_sql      VARCHAR2(4000);
  BEGIN
    --同步删除表
    lv_sql := 'DELETE from ZOESTD.meta_tab$ a';
    lv_sql := lv_sql || ' where not exists (select 1 from zoestd.meta_user$ b ,dba_tables@'||in_db_link||' c ';
    lv_sql := lv_sql || ' where a.user_id#=b.user_id and b.username=c.owner and a.tab_name=c.table_name';
    lv_sql := lv_sql || ' and b.db_id#='''||in_db_id||''')';
    lv_sql := lv_sql || ' and a.db_id#='''||in_db_id||'''';
--    DBMS_OUTPUT.PUT_LINE(lv_sql);
    EXECUTE IMMEDIATE lv_sql;
    COMMIT;
    --同步新增表
    lv_sql := 'INSERT INTO ZOESTD.META_TAB$';
    lv_sql := lv_sql || ' (DB_ID#,OBJ_ID#,USER_ID#,TAB_NAME,MODIFIER,MODIFIED_TIME)';
    lv_sql := lv_sql || ' SELECT  '''||in_db_id||''',OBJ_ID,USER_ID#,A.OBJ_NAME,';
    lv_sql := lv_sql || ' SYS_CONTEXT(''USERENV'',''SESSION_USER''),SYSDATE';
    lv_sql := lv_sql || ' FROM ZOESTD.META_OBJ$ A ';
    lv_sql := lv_sql || ' WHERE OBJ_TYPE_ID#=1 ';
    lv_sql := lv_sql || ' AND A.DB_ID#='''||in_db_id||'''';
    lv_sql := lv_sql || ' AND NOT EXISTS (SELECT 1 FROM ZOESTD.META_TAB$ Z ';
    lv_sql := lv_sql || ' WHERE A.USER_ID#=Z.USER_ID# AND A.OBJ_NAME=Z.TAB_NAME ';
    lv_sql := lv_sql || ' AND Z.DB_ID#='''||in_db_id||''')';
--    DBMS_OUTPUT.PUT_LINE(lv_sql);
    EXECUTE IMMEDIATE lv_sql;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
  END increment_sync_table;
  
  PROCEDURE increment_sync_column(in_db_id IN VARCHAR2, in_db_link IN VARCHAR2)
  AS
    -- =======================================
    -- 局部变量声明
    -- =======================================
    lv_sql                 VARCHAR2(4000);
    ld_last_modified_time  DATE;
    lv_obj_id              VARCHAR2(64);
    lv_username            VARCHAR2(64);
    lv_table_name          VARCHAR2(64);
    lc_ref_cursor SYS_REFCURSOR;
  BEGIN
    --同步删除列
    lv_sql := 'DELETE from ZOESTD.meta_col$ a';
    lv_sql := lv_sql || ' where not exists (select 1 from zoestd.meta_user$ b ,ZOESTD.meta_tab$ c ,dba_tab_columns@'||in_db_link||' d';
    lv_sql := lv_sql || ' where a.obj_id#=c.obj_id# and b.user_id=c.user_id#';
    lv_sql := lv_sql || ' and b.username=d.owner and c.tab_name=d.table_name and a.col_name=d.column_name';
    lv_sql := lv_sql || ' and b.db_id#='''||in_db_id||'''';
    lv_sql := lv_sql || ' and c.db_id#='''||in_db_id||''')';
    lv_sql := lv_sql || ' and a.db_id#='''||in_db_id||'''';
--    DBMS_OUTPUT.PUT_LINE(lv_sql);
    EXECUTE IMMEDIATE lv_sql;
    COMMIT;
    --同步新增列
    SELECT MAX(MODIFIED_TIME) INTO ld_last_modified_time FROM ZOESTD.meta_col$ WHERE db_id#=in_db_id;
    lv_sql := 'select b.obj_id#,c.owner,c.object_name from zoestd.meta_user$ a, zoestd.meta_tab$ b,dba_objects@'||in_db_link||' c';
    lv_sql := lv_sql || ' where c.last_ddl_time >= TO_DATE('''||to_char(ld_last_modified_time,'YYYY-MM-DD')||''',''YYYY-MM-DD'')';
    lv_sql := lv_sql || ' and a.user_id=b.user_id# and a.username=c.owner and b.tab_name=c.object_name';
    lv_sql := lv_sql || ' and a.db_id#='''||in_db_id||''' and b.db_id#='''||in_db_id||'''';
    OPEN lc_ref_cursor FOR lv_sql;
    LOOP 
        FETCH lc_ref_cursor INTO lv_obj_id,lv_username,lv_table_name; 
        EXIT WHEN lc_ref_cursor%NOTFOUND;
        --删除表改变列
        lv_sql := 'DELETE from zoestd.meta_col$';
        lv_sql := lv_sql || ' where db_id#='''||in_db_id||'''';
        lv_sql := lv_sql || ' and obj_id#='''||lv_obj_id||'''';
--        DBMS_OUTPUT.PUT_LINE(lv_sql);
        EXECUTE IMMEDIATE lv_sql;
        COMMIT;
        --重新同步表改变列
        lv_sql := 'INSERT INTO ZOESTD.META_COL$(';
        lv_sql := lv_sql || ' DB_ID#,OBJ_ID#,COL_ID,COL_NAME,COL_CHN_NAME,';
        lv_sql := lv_sql || ' DATA_TYPE,DATA_LENGTH,DATA_PRECISION,DATA_SCALE,NULLABLE,PK_FLAG,';
        lv_sql := lv_sql || ' MEMO, CREATOR,CREATED_TIME,MODIFIER,MODIFIED_TIME)';
        lv_sql := lv_sql || ' SELECT '''||in_db_id||''', '''||lv_obj_id||''',cl.COLUMN_ID,cl.COLUMN_NAME, ';
        lv_sql := lv_sql || ' SUBSTR(cm.COMMENTS,1,DECODE(INSTR(cm.COMMENTS,''#|''),';
        lv_sql := lv_sql || ' 0,LENGTH(cm.COMMENTS),INSTR(cm.COMMENTS,''#|'')-1)) AS COLUMN_CHN_NAME,';
        lv_sql := lv_sql || ' cl.DATA_TYPE,cl.DATA_LENGTH,cl.DATA_PRECISION,cl.DATA_SCALE, ';
        lv_sql := lv_sql || ' cl.nullable, ';
        lv_sql := lv_sql || ' nvl((select ''1'' from dba_constraints@'||in_db_link||' a, dba_cons_columns@'||in_db_link||' b';
        lv_sql := lv_sql || ' where a.constraint_type = ''P'' and a.constraint_name=b.constraint_name and a.owner=b.owner';
        lv_sql := lv_sql || ' and a.owner=cl.owner and a.table_name=cl.table_name and b.column_name=cl.column_name), null),';
        lv_sql := lv_sql || ' SUBSTR(cm.COMMENTS,DECODE(INSTR(cm.COMMENTS,''#|''),';
        lv_sql := lv_sql || ' 0,LENGTH(cm.COMMENTS)+1,INSTR(cm.COMMENTS,''#|'')+2),LENGTH(cm.COMMENTS)) AS MEMO,';
        lv_sql := lv_sql || ' SYS_CONTEXT(''USERENV'',''SESSION_USER''),SYSDATE,';
        lv_sql := lv_sql || ' SYS_CONTEXT(''USERENV'',''SESSION_USER''),SYSDATE';
        lv_sql := lv_sql || ' FROM DBA_TAB_COLUMNS@'||in_db_link||' cl ,DBA_COL_COMMENTS@'||in_db_link||' cm ';
        lv_sql := lv_sql || ' WHERE cl.OWNER = cm.OWNER';
        lv_sql := lv_sql || ' AND cl.TABLE_NAME = cm.TABLE_NAME';
        lv_sql := lv_sql || ' AND cl.COLUMN_NAME = cm.COLUMN_NAME';
        lv_sql := lv_sql || ' AND cl.OWNER = '''||lv_username||'''';
        lv_sql := lv_sql || ' AND cl.TABLE_NAME = '''||lv_table_name||'''';
--        DBMS_OUTPUT.PUT_LINE(lv_sql);
        EXECUTE IMMEDIATE lv_sql;
        COMMIT;
    END LOOP;
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
-- DBMS_OUTPUT.PUT_LINE(lv_db_link);
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
    EXECUTE IMMEDIATE lv_sql;
    COMMIT;
--  初始化META_OBJ$，从DBA_TABLES。排除Oracle用户，依据ZOEDEVOPS.ZOEPKG_UTILITY.GET_ORACLE_USER
    lv_sql := 'INSERT INTO ZOESTD.META_OBJ$';
    lv_sql := lv_sql || ' (DB_ID#,OBJ_ID,DB_OBJ_ID#,USER_ID#,OBJ_NAME,OBJ_TYPE_ID#,';
    lv_sql := lv_sql || ' CREATOR,CREATED_TIME,MODIFIER,MODIFIED_TIME)';
    lv_sql := lv_sql || ' SELECT '''||in_db_id||''', SYS_GUID(), OBJECT_ID,';
    lv_sql := lv_sql || ' (SELECT USER_ID FROM ZOESTD.META_USER$ u WHERE u.USERNAME=o.OWNER AND u.DB_ID#='''||in_db_id||''') AS USER#,';
    lv_sql := lv_sql || ' OBJECT_NAME,';
    lv_sql := lv_sql || ' DECODE(OBJECT_TYPE,''TABLE'',''1'',''VIEW'',''2'',''SEQUENCE'',3,NULL) AS OBJECT_TYPE#,'; 
    lv_sql := lv_sql || ' SYS_CONTEXT(''USERENV'',''SESSION_USER'') AS CREATOR,SYSDATE,';
    lv_sql := lv_sql || ' SYS_CONTEXT(''USERENV'',''SESSION_USER''),SYSDATE';
    lv_sql := lv_sql || ' FROM DBA_OBJECTS@'||lv_db_link||' o';
    lv_sql := lv_sql || ' WHERE OWNER NOT IN';
    lv_sql := lv_sql || ' ( SELECT COLUMN_VALUE FROM TABLE(ZOEDEVOPS.ZOEPKG_UTILITY.GET_ORACLE_USER))';
    lv_sql := lv_sql || ' AND OBJECT_TYPE IN (''TABLE'',''VIEW'',''SEQUENCE'')';
--    DBMS_OUTPUT.PUT_LINE(lv_sql);
    EXECUTE IMMEDIATE lv_sql;
    COMMIT;
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
    lv_sql := lv_sql || ' AND o.USER_ID# = u.USER_ID';
    lv_sql := lv_sql || ' AND o.DB_ID# ='''||in_db_id||'''';
    lv_sql := lv_sql || ' AND u.DB_ID# ='''||in_db_id||'''';
    lv_sql := lv_sql || ' AND tm.OWNER     =u.USERNAME';
    lv_sql := lv_sql || ' AND tm.TABLE_NAME=o.OBJ_NAME';
--    DBMS_OUTPUT.PUT_LINE(lv_sql);
    EXECUTE IMMEDIATE lv_sql;
    COMMIT;
--  初始化META_COL$，从META_TAB$，DBA_TAB_COLS视图
    FOR c1 IN (SELECT u.USERNAME, t.TAB_NAME, t.OBJ_ID# FROM ZOESTD.META_TAB$ t, ZOESTD.META_USER$ u WHERE t.USER_ID# = u.USER_ID AND u.DB_ID#=in_db_id)
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
    --增量同步对象
    increment_sync_object(in_db_id,lv_db_link);
    --增量同步表
    increment_sync_table(in_db_id,lv_db_link);
    --增量同步列
    increment_sync_column(in_db_id,lv_db_link);
  EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
  END increment_sync_all;

PROCEDURE compare_user_struct(in_source_db_id IN VARCHAR2, in_source_username IN VARCHAR2, in_target_db_id IN VARCHAR2, in_target_username IN VARCHAR2)
  AS
    -- =======================================
    -- 局部变量声明
    -- =======================================
    lv_source_db_link  VARCHAR2(64);
    lv_target_db_link  VARCHAR2(64);
    lv_owner           VARCHAR2(64);
    lv_table_name      VARCHAR2(64);
    lv_column_name     VARCHAR2(64);
    lv_comments        VARCHAR2(400);
    lv_data_type       VARCHAR2(64);
    ln_data_length     NUMBER;
    lv_nullable        VARCHAR2(1);
    lv_char_used       VARCHAR2(1);
    lv_sql             VARCHAR2(2000);
    lv_change_sql      VARCHAR2(2000);
    lv_remode_sql      VARCHAR2(4000);
    lv_remode_exec     VARCHAR2(2000);
    lv_table_sql       VARCHAR2(4000);
    ld_sysdate         DATE;
    lc_ref_cursor SYS_REFCURSOR;
    ln_count NUMBER;
    ln_rows  NUMBER;
  BEGIN
    ld_sysdate := SYSDATE;
    SELECT DB_LINK_NAME INTO lv_source_db_link FROM ZOEDEVOPS.DVP_PROJ_NODE_DB_LINKS WHERE DB_ID#=in_source_db_id;
    SELECT DB_LINK_NAME INTO lv_target_db_link FROM ZOEDEVOPS.DVP_PROJ_NODE_DB_LINKS WHERE DB_ID#=in_target_db_id;
--  处理源数据库新增表
    lv_sql := 'select a.owner, a.table_name ';
    lv_sql := lv_sql || ' from dba_tables@'||lv_source_db_link||' a';
    lv_sql := lv_sql || ' where not exists ';
    lv_sql := lv_sql || ' (select 1 from dba_tables@'||lv_target_db_link||' b';
    lv_sql := lv_sql || ' where b.owner=UPPER('''||in_target_username||''')';
    lv_sql := lv_sql || ' and a.table_name=b.table_name)';
    lv_sql := lv_sql || ' and a.owner=UPPER('''||in_source_username||''')';
    lv_sql := lv_sql || ' and a.table_name not like ''BIN$%''';
    OPEN lc_ref_cursor FOR lv_sql;
    ln_count:=0;
    lv_remode_exec :='BEGIN ZOEDEVOPS.ZOEPRC_EXEC_SQL@'||lv_source_db_link||'(:1, :2); END;';
    lv_remode_sql := 'CREATE TABLE ZOEDEVOPS.ZOERPCEXEC_TEMPTABLE (OWNER VARCHAR2(64),TABLE_NAME VARCHAR2(64),TABLE_DDL VARCHAR2(4000))';
    EXECUTE IMMEDIATE lv_remode_exec using IN lv_remode_sql,OUT ln_rows;
    LOOP
        FETCH lc_ref_cursor INTO lv_owner, lv_table_name;
        EXIT WHEN lc_ref_cursor%NOTFOUND;
        ln_count:=ln_count+1; 
        lv_remode_sql := 'DECLARE';
        lv_remode_sql := lv_remode_sql || ' lv_sql VARCHAR2(4000);';
        lv_remode_sql := lv_remode_sql || ' BEGIN';
        lv_remode_sql := lv_remode_sql || ' SELECT DBMS_METADATA.GET_DDL(''TABLE'','''||lv_table_name||''','''||lv_owner||''')';
        lv_remode_sql := lv_remode_sql || ' INTO lv_sql';
        lv_remode_sql := lv_remode_sql || ' FROM DUAL;';
        --xyn 2019-08-08 modify 对于一些没有主键的表获取的语法特殊处理
        lv_remode_sql := lv_remode_sql || ' if INSTR(lv_sql,''USING INDEX'',1) > 0 then';
        lv_remode_sql := lv_remode_sql || ' lv_sql := SUBSTR(lv_sql,1,INSTR(lv_sql,''USING INDEX'',1)+11)||'');'';';
        lv_remode_sql := lv_remode_sql || ' else';
        lv_remode_sql := lv_remode_sql || ' lv_sql := SUBSTR(lv_sql,1,INSTR(lv_sql,''SEGMENT'',1) - 1)||'';'';';
        lv_remode_sql := lv_remode_sql || ' end if;';
        lv_remode_sql := lv_remode_sql || ' INSERT INTO ZOEDEVOPS.ZOERPCEXEC_TEMPTABLE (OWNER,TABLE_NAME,TABLE_DDL) VALUES ('''||lv_owner||''','''||lv_table_name||''',lv_sql);';
        lv_remode_sql := lv_remode_sql || ' COMMIT;';
        lv_remode_sql := lv_remode_sql || ' END;';
        EXECUTE IMMEDIATE lv_remode_exec using IN lv_remode_sql,OUT ln_rows;
        --xyn 2019-08-08 modify 把表名替换ZOEODS_HIS或者ZOEODS_EMR
        lv_remode_sql := 'SELECT TRIM(REPLACE(TABLE_DDL,''"'||lv_owner||'".'',''"'||in_target_username||'".'')) FROM ZOEDEVOPS.ZOERPCEXEC_TEMPTABLE@'||lv_source_db_link;
        lv_remode_sql := lv_remode_sql || ' WHERE OWNER='''||lv_owner||''' AND TABLE_NAME='''||lv_table_name||'''';
        EXECUTE IMMEDIATE lv_remode_sql INTO lv_table_sql;
        INSERT INTO ZOESTD.CHK_OBJECT_COMPARE_RECORD 
            (RECORD_NO,SOURCE_DB_ID#,TARGET_DB_ID#,CHECK_TIME,OBJECT_OWNER,OBJECT_NAME,OBJECT_TYPE,CHECKER,ATTRIBUTE_DATA,SYNC_SQL) 
            VALUES 
            (SYS_GUID(),lv_source_db_link,lv_target_db_link,ld_sysdate,
                lv_owner,lv_table_name,'TABLE','ZOEDEVOPS.zoepkg_metadata_sync.compare_user_struct',
                '{"operation":"add","operation_content":"table"}',lv_table_sql);
--        DBMS_OUTPUT.PUT_LINE(lv_table_sql);
    END LOOP;
        lv_remode_sql := 'DROP TABLE ZOEDEVOPS.ZOERPCEXEC_TEMPTABLE PURGE';
        EXECUTE IMMEDIATE lv_remode_exec using IN lv_remode_sql,OUT ln_rows;
        COMMIT;
--     DBMS_OUTPUT.PUT_LINE(ln_count);
--  处理源表增加的列
    lv_sql := 'select a.owner, a.table_name, a.column_name,a.data_type,a.data_length,a.nullable,char_used ';
    lv_sql := lv_sql || ' from dba_tab_columns@'||lv_source_db_link||' a, dba_tables@'||lv_target_db_link||' c';
    lv_sql := lv_sql || ' where not exists ';
    lv_sql := lv_sql || ' (select 1 from dba_tab_columns@'||lv_target_db_link||' b';
    lv_sql := lv_sql || ' where b.owner=UPPER('''||in_target_username||''')';
    lv_sql := lv_sql || ' and a.table_name=b.table_name';
    lv_sql := lv_sql || ' and a.column_name=b.column_name)';
    lv_sql := lv_sql || ' and a.owner=UPPER('''||in_source_username||''')';
    lv_sql := lv_sql || ' and c.owner=UPPER('''||in_target_username||''')';
    lv_sql := lv_sql || ' and a.table_name not like ''BIN$%''';
    lv_sql := lv_sql || ' and a.table_name = c.table_name';
    OPEN lc_ref_cursor FOR lv_sql;
    ln_count:=0;
    LOOP
        FETCH lc_ref_cursor INTO lv_owner, lv_table_name, lv_column_name,lv_data_type,ln_data_length,lv_nullable,lv_char_used;
        EXIT WHEN lc_ref_cursor%NOTFOUND;
        ln_count:=ln_count+1; 
        IF lv_char_used = 'C' THEN
            lv_change_sql := 'ALTER TABLE '||in_target_username||'.'||lv_table_name;
            lv_change_sql := lv_change_sql || ' ADD ('||lv_column_name||' '||lv_data_type||'('||ln_data_length||' CHAR));';
        ELSIF lv_data_type = 'DATE' OR lv_data_type = 'BLOB' OR lv_data_type = 'CLOB' THEN
            lv_change_sql := 'ALTER TABLE '||in_target_username||'.'||lv_table_name;
            lv_change_sql := lv_change_sql || ' ADD ('||lv_column_name||' '||lv_data_type||');';
        ELSE
            lv_change_sql := 'ALTER TABLE '||in_target_username||'.'||lv_table_name;
            lv_change_sql := lv_change_sql || ' ADD ('||lv_column_name||' '||lv_data_type||'('||ln_data_length||'));';
        END IF;
        INSERT INTO ZOESTD.CHK_OBJECT_COMPARE_RECORD 
            (RECORD_NO,SOURCE_DB_ID#,TARGET_DB_ID#,CHECK_TIME,OBJECT_OWNER,OBJECT_NAME,OBJECT_TYPE,CHECKER,ATTRIBUTE_DATA,SYNC_SQL) 
            VALUES 
            (SYS_GUID(),lv_source_db_link,lv_target_db_link,ld_sysdate,
                lv_owner,lv_table_name,'TABLE','ZOEDEVOPS.zoepkg_metadata_sync.compare_user_struct',
                '{"operation":"add","operation_content":"column"}',lv_change_sql);
--        DBMS_OUTPUT.PUT_LINE(lv_change_sql);
    END LOOP;
      COMMIT;
--    DBMS_OUTPUT.PUT_LINE(ln_count);
--  处理源表修改的列
    lv_sql := 'select a.owner, a.table_name, a.column_name,a.data_type,a.data_length,a.nullable,char_used  ';
    lv_sql := lv_sql || ' from dba_tab_columns@'||lv_source_db_link||' a ';
    lv_sql := lv_sql || ' where exists ';
    lv_sql := lv_sql || ' (select 1 from dba_tab_columns@'||lv_target_db_link||' b';
    lv_sql := lv_sql || ' where b.owner=UPPER('''||in_target_username||''')';
    lv_sql := lv_sql || ' and a.table_name=b.table_name';
    lv_sql := lv_sql || ' and a.column_name=b.column_name';
    lv_sql := lv_sql || ' and (a.data_type<>a.data_type';
    lv_sql := lv_sql || ' or a.data_length<>a.data_length';
    lv_sql := lv_sql || ' or a.nullable<>b.nullable))';
    lv_sql := lv_sql || ' and a.owner=UPPER('''||in_source_username||''')';
    lv_sql := lv_sql || ' and a.table_name not like ''BIN$%''';
    OPEN lc_ref_cursor FOR lv_sql;
    ln_count:=0;
    LOOP
        FETCH lc_ref_cursor INTO lv_owner, lv_table_name, lv_column_name,lv_data_type,ln_data_length,lv_nullable,lv_char_used;
        EXIT WHEN lc_ref_cursor%NOTFOUND;
        ln_count:=ln_count+1;
        IF lv_char_used = 'C' THEN
            lv_change_sql := 'ALTER TABLE '||in_target_username||'.'||lv_table_name;
            lv_change_sql := lv_change_sql || ' MODIFY ('||lv_column_name||' '||lv_data_type||'('||ln_data_length||' CHAR));';
        ELSIF lv_data_type = 'DATE' OR lv_data_type = 'BLOB' OR lv_data_type = 'CLOB' THEN
            lv_change_sql := 'ALTER TABLE '||in_target_username||'.'||lv_table_name;
            lv_change_sql := lv_change_sql || ' MODIFY ('||lv_column_name||' '||lv_data_type||');';
        ELSE
            lv_change_sql := 'ALTER TABLE '||in_target_username||'.'||lv_table_name;
            lv_change_sql := lv_change_sql || ' MODIFY ('||lv_column_name||' '||lv_data_type||'('||ln_data_length||'));';
        END IF;
        INSERT INTO ZOESTD.CHK_OBJECT_COMPARE_RECORD 
            (RECORD_NO,SOURCE_DB_ID#,TARGET_DB_ID#,CHECK_TIME,OBJECT_OWNER,OBJECT_NAME,OBJECT_TYPE,CHECKER,ATTRIBUTE_DATA,SYNC_SQL) 
            VALUES 
            (SYS_GUID(),lv_source_db_link,lv_target_db_link,ld_sysdate,
                lv_owner,lv_table_name,'TABLE','ZOEDEVOPS.zoepkg_metadata_sync.compare_user_struct',
                '{"operation":"add","operation_content":"column"}',lv_change_sql);
--        DBMS_OUTPUT.PUT_LINE(lv_change_sql);
    END LOOP;
        COMMIT;
--    DBMS_OUTPUT.PUT_LINE(ln_count);

    --xyn 2019-08-08 生成表注释
    lv_sql := 'select a.owner,a.table_name,a.comments ';
    lv_sql := lv_sql || ' from dba_tab_comments@'||lv_source_db_link||' a '; 
    lv_sql := lv_sql || ' where owner = '''||upper(in_source_username)||''''; 
    lv_sql := lv_sql || ' and comments is not null ';
    lv_sql := lv_sql || ' and table_type = ''TABLE''';
    lv_sql := lv_sql || ' and not exists (select 1 from dba_tab_comments@'||lv_target_db_link||' b '; 
    lv_sql := lv_sql || ' where a.owner = '''||in_target_username||'''';
    lv_sql := lv_sql || ' and a.table_name = b.table_name';
    lv_sql := lv_sql || ' and b.comments is null)';
    OPEN lc_ref_cursor FOR lv_sql;
    ln_count:=0;
    LOOP
        FETCH lc_ref_cursor INTO lv_owner, lv_table_name, lv_comments;
        EXIT WHEN lc_ref_cursor%NOTFOUND;
        ln_count:=ln_count+1;
        lv_change_sql := 'COMMENT ON TABLE '||in_target_username||'.'||lv_table_name||' IS '''||lv_comments||''';';
        INSERT INTO ZOESTD.CHK_OBJECT_COMPARE_RECORD 
            (RECORD_NO,SOURCE_DB_ID#,TARGET_DB_ID#,CHECK_TIME,OBJECT_OWNER,OBJECT_NAME,OBJECT_TYPE,CHECKER,ATTRIBUTE_DATA,SYNC_SQL) 
            VALUES 
            (SYS_GUID(),lv_source_db_link,lv_target_db_link,ld_sysdate,
                lv_owner,lv_table_name,'TABLE_COMMENT','ZOEDEVOPS.zoepkg_metadata_sync.compare_user_struct',
                '{"operation":"add","operation_content":"column"}',lv_change_sql);
--        DBMS_OUTPUT.PUT_LINE(lv_change_sql);
    END LOOP;
    
    COMMIT;
    --生成列注释
    --xyn 2019-08-08 生成表注释
    lv_sql := 'select a.owner,a.table_name,a.column_name,a.comments ';
    lv_sql := lv_sql || ' from dba_col_comments@'||lv_source_db_link||' a '; 
    lv_sql := lv_sql || ' where owner = '''||upper(in_source_username)||''''; 
    lv_sql := lv_sql || ' and comments is not null ';
    lv_sql := lv_sql || ' and not exists (select 1 from dba_col_comments@'||lv_target_db_link||' b '; 
    lv_sql := lv_sql || ' where a.owner = b.owner';
    lv_sql := lv_sql || ' and a.table_name = '''||in_target_username||'''';
    lv_sql := lv_sql || ' and a.column_name = b.column_name';
    lv_sql := lv_sql || ' and b.comments is null)';
    OPEN lc_ref_cursor FOR lv_sql;
    ln_count:=0;
    LOOP
        FETCH lc_ref_cursor INTO lv_owner, lv_table_name,lv_column_name,lv_comments;
        EXIT WHEN lc_ref_cursor%NOTFOUND;
        ln_count:=ln_count+1;
        lv_change_sql := 'COMMENT ON COLUMN '||in_target_username||'.'||lv_table_name||'.'||lv_column_name||' IS '''||lv_comments||''';';
        INSERT INTO ZOESTD.CHK_OBJECT_COMPARE_RECORD 
            (RECORD_NO,SOURCE_DB_ID#,TARGET_DB_ID#,CHECK_TIME,OBJECT_OWNER,OBJECT_NAME,OBJECT_TYPE,CHECKER,ATTRIBUTE_DATA,SYNC_SQL) 
            VALUES 
            (SYS_GUID(),lv_source_db_link,lv_target_db_link,ld_sysdate,
                lv_owner,lv_table_name,'COLUMN_COMMENT','ZOEDEVOPS.zoepkg_metadata_sync.compare_user_struct',
                '{"operation":"add","operation_content":"column"}',lv_change_sql);
--        DBMS_OUTPUT.PUT_LINE(lv_change_sql);
    END LOOP;
    
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        RAISE;
  END compare_user_struct;
  
  END zoepkg_metadata_sync;
/
