--获取常用索引创建语法，基于常用关联字段

SELECT 'CREATE INDEX '||RPAD(TABLE_NAME||'_'||SUBSTR(COLUMN_NAME,1,INSTR(COLUMN_NAME,'_')-1),40)||
    ' ON '||RPAD(OWNER||'.'||TABLE_NAME,42)||' '||rpad('('||COLUMN_NAME||')',32)||
    ' TABLESPACE '||OWNER||'_IND;' AS "创建索引SQL"
FROM DBA_TAB_COLUMNS a ,ZOETMP.TEST1 b
WHERE a.owner = b.a and a.table_name = b.b
AND OWNER IN (SELECT USERNAME FROM ZOESTD.v_zoesoft_user)
AND COLUMN_NAME IN ('PATIENT_ID','EVENT_NO','CARD_ID')
AND NOT EXISTS (SELECT 1 FROM DBA_IND_COLUMNS c 
    WHERE INDEX_NAME LIKE 'PK_%' AND COLUMN_NAME IN ('PATIENT_ID','EVENT_NO','CARD_ID') 
        AND a.owner=c.table_owner and a.table_name=c.table_name and a.column_name=c.column_name)
ORDER BY OWNER,TABLE_NAME;

