CREATE OR REPLACE PACKAGE BODY ZOEAPEX.ZOEPKG_APEX
AS

    FUNCTION apex_query_tree(iv_db_link VARCHAR2) RETURN zoett_apex_tree
    AS
    ltt_apex_tree zoett_apex_tree ;
    lc_apex_tree SYS_REFCURSOR;
    lv_sql       VARCHAR2(4000);
    TYPE         r_apex_tree is record(
	TREE_STATUS      NUMBER,
	TREE_LEVEL       NUMBER,
	TREE_TITLE       VARCHAR2(128),
	TREE_ICON        VARCHAR2(128),
	TREE_VALUE       VARCHAR2(128),
	TREE_TOOLTIP     VARCHAR2(128),
	TREE_LINK        VARCHAR2(1024));
    type t_apex is table of r_apex_tree index by binary_integer;
    lt_apex t_apex;
    BEGIN
    ltt_apex_tree:= zoett_apex_tree();
        lv_sql := 'SELECT CASE WHEN CONNECT_BY_ISLEAF = 1 THEN 0 WHEN level = 1 THEN 1 ELSE - 1  END AS status, ';
        lv_sql :=  lv_sql||'level,''会话'' AS title,NULL AS icon, ';
        lv_sql :=  lv_sql||'inst_id||''.''||sid AS value,NULL AS tooltip, '; 
        lv_sql :=  lv_sql||'inst_id||'',''||sid as link ';
        IF iv_db_link IS NULL THEN   
            lv_sql :=  lv_sql||'FROM gv$session ';
        ELSE 
            lv_sql :=  lv_sql||'FROM gv$session@'||iv_db_link||' ';
        END IF ;
        lv_sql :=  lv_sql||'WHERE username IS NOT NULL ';
        lv_sql :=  lv_sql||'    START WITH blocking_session IS NULL ';
        lv_sql :=  lv_sql||'           AND ( inst_id,sid ) IN (SELECT DISTINCT blocking_instance, blocking_session ';
        lv_sql :=  lv_sql||'                    FROM  gv$session) CONNECT BY PRIOR inst_id = blocking_instance ';
        lv_sql :=  lv_sql||'           AND PRIOR sid = blocking_session' ;
        DBMS_OUTPUT.put_line(lv_sql);
        OPEN lc_apex_tree FOR lv_sql;
        FETCH lc_apex_tree bulk COLLECT INTO lt_apex;
        FOR i IN 1..lt_apex.count LOOP
            ltt_apex_tree.extend;
            ltt_apex_tree(i) := zoeto_apex_tree(null,null,null,null,null,null,null);
            ltt_apex_tree(i).TREE_STATUS := lt_apex(i).TREE_STATUS;
            ltt_apex_tree(i).TREE_LEVEL := lt_apex(i).TREE_LEVEL;
            ltt_apex_tree(i).TREE_TITLE := lt_apex(i).TREE_TITLE;
            ltt_apex_tree(i).TREE_ICON := lt_apex(i).TREE_ICON;
            ltt_apex_tree(i).TREE_VALUE := lt_apex(i).TREE_VALUE;
            ltt_apex_tree(i).TREE_TOOLTIP := lt_apex(i).TREE_TOOLTIP;
            ltt_apex_tree(i).TREE_LINK := lt_apex(i).TREE_LINK;
        END LOOP;
        RETURN ltt_apex_tree;
        
    EXCEPTION 
        WHEN OTHERS THEN
            RETURN NULL;
    END;

END ZOEPKG_APEX;