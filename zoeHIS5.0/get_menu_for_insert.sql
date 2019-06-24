/*
获取HIS5新增加的菜单信息，并生成tabledata_menu.sql，用于同步其他数据库菜单
zoetmp.GET_MENU_FOR_INSERT，若没有指定时间，那么就是导出所有菜单信息，若指定时间，那么将在该时间之后的所有菜单导更新到现场
*/

CREATE OR REPLACE FUNCTION ZOETMP.GET_MENU_FOR_INSERT(iv_owner VARCHAR2, 
                                           iv_table_name       VARCHAR2,
                          				   iv_new_owner        VARCHAR2,
                                           iv_new_table_name   VARCHAR2,
                                           id_last_date        DATE)
RETURN NUMBER
AS
    lv_condition           VARCHAR2(400) := ' 1=1 ';
	lv_sql                 VARCHAR2(32767) := '';
    lv_columns             VARCHAR2(32767) := '';    
    lv_column_vaulue       VARCHAR2(32767) := '';
	TYPE C_TYPE IS REF CURSOR;
	ltc_get_column_vaulue C_TYPE;
BEGIN
    IF id_last_date IS NULL THEN
       lv_condition := ' 1=1 ';
    ELSE
	   lv_condition := ' 1=1 and MODIFIED_TIME >= to_date('''||to_char(id_last_date,'yyyy-mm-dd')||''',''yyyy-mm-dd'')';
    END IF;
    
	FOR lc_record IN (SELECT COLUMN_NAME 
	                    FROM DBA_TAB_COLUMNS 
					   WHERE OWNER = iv_owner AND TABLE_NAME = iv_table_name
					   ORDER BY COLUMN_ID)
	LOOP
		lv_columns :=  lv_columns||','||lc_record.COLUMN_NAME;
	END LOOP;
    
	lv_columns := SUBSTR(lv_columns,2);
	DBMS_OUTPUT.ENABLE (BUFFER_SIZE=>NULL);
	FOR lc_record IN (SELECT COLUMN_NAME,
	                         DATA_TYPE 
	                    FROM DBA_TAB_COLUMNS 
					   WHERE OWNER = iv_owner 
					     AND TABLE_NAME = iv_table_name
					   ORDER BY COLUMN_ID)
	LOOP
		IF  lc_record.DATA_TYPE = 'VARCHAR2' THEN        
			lv_sql :=  lv_sql||'||'',''||'||'DECODE('||lc_record.COLUMN_NAME||',NULL,''NULL'',''''''''||' ||lc_record.COLUMN_NAME||'||'''''''')';
		ELSIF   lc_record.DATA_TYPE = 'DATE' THEN        
			lv_sql := lv_sql||'||'',''||'||'DECODE('||lc_record.COLUMN_NAME||  ',NULL,''NULL'',''TO_DATE(''''''||TO_CHAR('  ||lc_record.COLUMN_NAME|| ',''YYYY-MM-DD HH24:MI:SS'')||'''''', ''''YYYY-MM-DD HH24:MI:SS'''')'')';
		ELSE  
			lv_sql :=  lv_sql||'||'',''||'||'DECODE('||lc_record.COLUMN_NAME||',NULL,''NULL'','||lc_record.COLUMN_NAME||')';
		END IF;   
	 END LOOP;   
     
	 lv_sql := SUBSTR(lv_sql,8);
	 IF lv_sql IS NULL THEN 
		DBMS_OUTPUT.PUT_LINE('lv_sql NULL');
		RETURN -1;
	 END IF;
        lv_sql := 'SELECT '|| lv_sql ||' FROM '||iv_owner|| '.' || iv_table_name || ' WHERE ' || lv_condition;
    OPEN ltc_get_column_vaulue FOR lv_sql;
    FETCH ltc_get_column_vaulue INTO lv_column_vaulue;
    LOOP
    	EXIT WHEN ltc_get_column_vaulue%NOTFOUND;
    	DBMS_OUTPUT.PUT_LINE('INSERT INTO '||iv_new_owner|| '.' || iv_new_table_name || '('|| lv_columns ||')  VALUES ('|| lv_column_vaulue ||');');
    	FETCH ltc_get_column_vaulue INTO lv_column_vaulue;
    END LOOP;
        
    RETURN 0;
END;
/
set feedback off
set serveroutput on 
spool c:\zoedir\scripts\tabledata_menu.sql
declare
v_return varchar2(64);
begin
    DBMS_OUTPUT.PUT_LINE('spool c:\zoedir\log\tabledata_menu.log');
    DBMS_OUTPUT.PUT_LINE('DROP TABLE ZOETMP.COM_MENU_TABLE PURGE;');
    DBMS_OUTPUT.PUT_LINE('DROP TABLE ZOETMP.COM_MENU_CONFIG PURGE;');

    DBMS_OUTPUT.PUT_LINE('DROP TABLE ZOETMP.COM_MENU_TABLE_TMP PURGE;');
    DBMS_OUTPUT.PUT_LINE('DROP TABLE ZOETMP.COM_MENU_CONFIG_TMP PURGE;');

    DBMS_OUTPUT.PUT_LINE('CREATE TABLE ZOETMP.COM_MENU_TABLE  AS SELECT * FROM ZOECOMM.COM_MENU_TABLE;');
    DBMS_OUTPUT.PUT_LINE('CREATE TABLE ZOETMP.COM_MENU_CONFIG  AS SELECT * FROM ZOECOMM.COM_MENU_CONFIG;');

    DBMS_OUTPUT.PUT_LINE('CREATE TABLE ZOETMP.COM_MENU_TABLE_TMP  AS SELECT * FROM ZOECOMM.COM_MENU_TABLE WHERE 1=2;');
    DBMS_OUTPUT.PUT_LINE('CREATE TABLE ZOETMP.COM_MENU_CONFIG_TMP  AS SELECT * FROM ZOECOMM.COM_MENU_CONFIG WHERE 1=2;');
    
    v_return := zoetmp.GET_MENU_FOR_INSERT('ZOECOMM','COM_MENU_TABLE','ZOETMP','COM_MENU_TABLE_TMP',TO_DATE('2019-06-15','YYYY-MM-DD'));
    v_return := zoetmp.GET_MENU_FOR_INSERT('ZOECOMM','COM_MENU_CONFIG','ZOETMP','COM_MENU_CONFIG_TMP',TO_DATE('2019-06-15','YYYY-MM-DD'));

	--先做更新再做插入
    DBMS_OUTPUT.PUT_LINE('UPDATE ZOECOMM.COM_MENU_TABLE');
    DBMS_OUTPUT.PUT_LINE('   SET (PARENT_MENU_ID,MENU_NAME,ICON_URL,MENU_URL,MENU_TYPE_CODE,SPELL_CODE,WBZX_CODE,MODIFIED_TIME,MODIFIER_CODE,CREATOR_CODE,CREATED_TIME) ');
    DBMS_OUTPUT.PUT_LINE('       = (SELECT PARENT_MENU_ID,MENU_NAME,ICON_URL,MENU_URL,MENU_TYPE_CODE,SPELL_CODE,WBZX_CODE,MODIFIED_TIME,MODIFIER_CODE,CREATOR_CODE,CREATED_TIME');
    DBMS_OUTPUT.PUT_LINE('            FROM ZOETMP.COM_MENU_TABLE_TMP');
    DBMS_OUTPUT.PUT_LINE('           WHERE ZOECOMM.COM_MENU_TABLE.MENU_ID = ZOETMP.COM_MENU_TABLE_TMP.MENU_ID)');
    DBMS_OUTPUT.PUT_LINE(' WHERE EXISTS (SELECT 1 ');
    DBMS_OUTPUT.PUT_LINE('                 FROM ZOETMP.COM_MENU_TABLE_TMP');
    DBMS_OUTPUT.PUT_LINE('                WHERE ZOECOMM.COM_MENU_TABLE.MENU_ID = ZOETMP.COM_MENU_TABLE_TMP.MENU_ID);');

    DBMS_OUTPUT.PUT_LINE('UPDATE ZOECOMM.COM_MENU_CONFIG');
    DBMS_OUTPUT.PUT_LINE('   SET (PARENT_CONFIG_ID,MENU_ID,MENU_NAME,ICON_URL,MENU_URL,SORT_NO,SPELL_CODE,PORTAL_URL,CLOSE_REMIND_FLAG,WBZX_CODE,');
    DBMS_OUTPUT.PUT_LINE('        MENU_TYPE_CODE,SHORTCUT_KEY,SHORTCUT_KEY_CODE,SPECIAL_TYPE_CODE,MODIFIED_TIME,MODIFIER_CODE,CREATOR_CODE,CREATED_TIME) ');
    DBMS_OUTPUT.PUT_LINE('       = (SELECT PARENT_CONFIG_ID,MENU_ID,MENU_NAME,ICON_URL,MENU_URL,SORT_NO,SPELL_CODE,PORTAL_URL,CLOSE_REMIND_FLAG,WBZX_CODE,');
    DBMS_OUTPUT.PUT_LINE('                 MENU_TYPE_CODE,SHORTCUT_KEY,SHORTCUT_KEY_CODE,SPECIAL_TYPE_CODE,MODIFIED_TIME,MODIFIER_CODE,CREATOR_CODE,CREATED_TIME');
    DBMS_OUTPUT.PUT_LINE('            FROM ZOETMP.COM_MENU_CONFIG_TMP');
    DBMS_OUTPUT.PUT_LINE('           WHERE ZOECOMM.COM_MENU_CONFIG.CONFIG_ID = ZOETMP.COM_MENU_CONFIG_TMP.CONFIG_ID)');
    DBMS_OUTPUT.PUT_LINE(' WHERE EXISTS (SELECT 1 ');
    DBMS_OUTPUT.PUT_LINE('                 FROM ZOETMP.COM_MENU_CONFIG_TMP');
    DBMS_OUTPUT.PUT_LINE('                WHERE ZOECOMM.COM_MENU_CONFIG.CONFIG_ID = ZOETMP.COM_MENU_CONFIG_TMP.CONFIG_ID);');

	--插入没有的数据
    DBMS_OUTPUT.PUT_LINE('INSERT INTO ZOECOMM.COM_MENU_TABLE ');
    DBMS_OUTPUT.PUT_LINE('SELECT *');
    DBMS_OUTPUT.PUT_LINE('  FROM ZOETMP.COM_MENU_TABLE_TMP');
    DBMS_OUTPUT.PUT_LINE(' WHERE NOT EXISTS (SELECT 1 ');
    DBMS_OUTPUT.PUT_LINE('                     FROM ZOECOMM.COM_MENU_TABLE');
    DBMS_OUTPUT.PUT_LINE('                    WHERE ZOECOMM.COM_MENU_TABLE.MENU_ID = ZOETMP.COM_MENU_TABLE_TMP.MENU_ID);');

    DBMS_OUTPUT.PUT_LINE('INSERT INTO ZOECOMM.COM_MENU_CONFIG');
    DBMS_OUTPUT.PUT_LINE('SELECT *');
    DBMS_OUTPUT.PUT_LINE('  FROM ZOETMP.COM_MENU_CONFIG_TMP');
    DBMS_OUTPUT.PUT_LINE(' WHERE NOT EXISTS (SELECT 1 ');
    DBMS_OUTPUT.PUT_LINE('                     FROM ZOECOMM.COM_MENU_CONFIG');
    DBMS_OUTPUT.PUT_LINE('                    WHERE ZOECOMM.COM_MENU_CONFIG.CONFIG_ID = ZOETMP.COM_MENU_CONFIG_TMP.CONFIG_ID);');

    DBMS_OUTPUT.PUT_LINE('COMMIT;');
    DBMS_OUTPUT.PUT_LINE('SPOOL OFF');
end; 
/
spool off
set feedback on
DROP FUNCTION ZOETMP.GET_MENU_FOR_INSERT;



