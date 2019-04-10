--获取常用索引创建语法，基于常用ID字段

SELECT 'CREATE INDEX '||RPAD(OWNER||'.ID_'||TABLE_NAME||'_'||SUBSTR(COLUMN_NAME,1,INSTR(COLUMN_NAME,'_')-1),60)||
    ' ON '||RPAD(OWNER||'.'||TABLE_NAME,42)||' '||rpad('('||COLUMN_NAME||')',32)||
    ' TABLESPACE '||OWNER||'_IND;' AS "创建索引SQL"
FROM DBA_TAB_COLUMNS a
WHERE TABLE_NAME NOT LIKE 'BIN$%' AND OWNER <> 'ZOETMP' AND TABLE_NAME NOT LIKE 'V_%' 
AND OWNER IN (SELECT USERNAME FROM ZOESTD.v_zoesoft_user)
AND COLUMN_NAME IN ('PATIENT_ID','EVENT_NO','CARD_ID','LAY_NO','PRES_NO','SETTLE_NO')
AND NOT EXISTS (SELECT NULL FROM DBA_IND_COLUMNS c 
    WHERE a.owner=c.table_owner and a.table_name=c.table_name and a.column_name=c.column_name
   AND INDEX_NAME LIKE 'PK_%' 
    )
ORDER BY OWNER,TABLE_NAME;

--获取常用索引创建语法，基于常用时间字段

SELECT 'CREATE INDEX '||RPAD(OWNER||'.TIME_'||TABLE_NAME||'_'||SUBSTR(COLUMN_NAME,1,INSTR(COLUMN_NAME,'_')-1),60)||
    ' ON '||RPAD(OWNER||'.'||TABLE_NAME,42)||' '||rpad('('||COLUMN_NAME||')',32)||
    ' TABLESPACE '||OWNER||'_IND;' AS "创建索引SQL"
FROM DBA_TAB_COLUMNS a
WHERE TABLE_NAME NOT LIKE 'BIN$%' AND OWNER <> 'ZOETMP' AND TABLE_NAME NOT LIKE 'V_%' 
AND OWNER IN (SELECT USERNAME FROM ZOESTD.v_zoesoft_user)
AND COLUMN_NAME IN ('APPLY_TIME','CHARGE_TIME','EXEC_TIME','LAY_TIME','BEGIN_EXEC_TIME')
AND NOT EXISTS (SELECT NULL FROM DBA_IND_COLUMNS c 
    WHERE a.owner=c.table_owner and a.table_name=c.table_name and a.column_name=c.column_name
   AND INDEX_NAME LIKE 'PK_%' 
    )
ORDER BY OWNER,TABLE_NAME;

--更新列非空信息
update zoestd.meta_col$ a set nullable = (select b.nullable from dba_tab_columns b , zoestd.v_zoesoft_table c 
    where  b.owner=c.owner and b.table_name=c.table_name
        and c.obj_id=a.obj_id#
        and b.column_name=a.col_name)
		
--更新列主键信息
update zoestd.meta_col$ a set pk_flag = 1
    where exists (select null from dba_cons_columns b , dba_constraints c , zoestd.v_zoesoft_table d
        where b.constraint_name=c.constraint_name and c.constraint_type='P'
            and d.owner=c.owner and d.table_name=c.table_name
            and d.obj_id=a.obj_id#
            and b.column_name=a.col_name);


