CREATE OR REPLACE FUNCTION zoetmp.get_data_for_insert(iv_owner VARCHAR2, iv_table_name VARCHAR2)
RETURN VARCHAR2
AS
--用于以INSERT语句方式从ORACLE数据库导出指定表的数据
	lv_columns    VARCHAR2(32767) := '';
	lv_condition  VARCHAR2(400) := ' 1=1 ';
	lv_sql        VARCHAR2(32767) := '';
	lv_column_vaulue       VARCHAR2(32767) := '';
	TYPE C_TYPE IS REF CURSOR;
	ltc_get_column_vaulue C_TYPE;
BEGIN
	FOR lc_record IN (SELECT COLUMN_NAME FROM DBA_TAB_COLUMNS 
					WHERE OWNER = iv_owner AND TABLE_NAME = iv_table_name
					ORDER BY COLUMN_ID)
	LOOP
		lv_columns :=  lv_columns||','||lc_record.COLUMN_NAME;
	END LOOP;
	lv_columns := SUBSTR(lv_columns,2);
	DBMS_OUTPUT.ENABLE (BUFFER_SIZE=>NULL) ;
	FOR lc_record IN (SELECT COLUMN_NAME,DATA_TYPE FROM DBA_TAB_COLUMNS 
					WHERE OWNER = iv_owner AND TABLE_NAME = iv_table_name
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
			DBMS_OUTPUT.PUT_LINE('INSERT INTO '||iv_owner|| '.' || iv_table_name || '('|| lv_columns ||')  VALUES ('|| lv_column_vaulue ||');');
			FETCH ltc_get_column_vaulue INTO lv_column_vaulue;
		END LOOP;
--	  DBMS_OUTPUT.PUT_LINE('INSERT INTO '||iv_owner|| '.' || iv_table_name || '('|| lv_columns ||')  VALUES ('|| lv_column_vaulue ||');');
      RETURN 1;
END;
/
set feedback off
set serveroutput on 
spool c:\zoedir\scripts\tabledata_i18n.sql
declare
v_return varchar2(64);
begin
    DBMS_OUTPUT.PUT_LINE('spool c:\zoedir\log\tabledata_i18n.log');
    DBMS_OUTPUT.PUT_LINE('DROP TABLE ZOETMP.COM_I18N_DICT_CLASS PURGE;');
    DBMS_OUTPUT.PUT_LINE('DROP TABLE ZOETMP.COM_I18N_DICT_CLASS_DIST PURGE;');
    DBMS_OUTPUT.PUT_LINE('DROP TABLE ZOETMP.COM_I18N_DICT_INFO PURGE;');
    DBMS_OUTPUT.PUT_LINE('DROP TABLE ZOETMP.COM_I18N_DICT_LANG_INFO PURGE;');
    DBMS_OUTPUT.PUT_LINE('CREATE TABLE ZOETMP.COM_I18N_DICT_CLASS  AS SELECT * FROM ZOECOMM.COM_I18N_DICT_CLASS;');
    DBMS_OUTPUT.PUT_LINE('CREATE TABLE ZOETMP.COM_I18N_DICT_CLASS_DIST  AS SELECT * FROM ZOECOMM.COM_I18N_DICT_CLASS_DIST;');
    DBMS_OUTPUT.PUT_LINE('CREATE TABLE ZOETMP.COM_I18N_DICT_INFO  AS SELECT * FROM ZOECOMM.COM_I18N_DICT_INFO;');
    DBMS_OUTPUT.PUT_LINE('CREATE TABLE ZOETMP.COM_I18N_DICT_LANG_INFO  AS SELECT * FROM ZOECOMM.COM_I18N_DICT_LANG_INFO;');
    DBMS_OUTPUT.PUT_LINE('TRUNCATE TABLE ZOECOMM.COM_I18N_DICT_CLASS;');
    DBMS_OUTPUT.PUT_LINE('TRUNCATE TABLE ZOECOMM.COM_I18N_DICT_CLASS_DIST ;');
    DBMS_OUTPUT.PUT_LINE('TRUNCATE TABLE ZOECOMM.COM_I18N_DICT_INFO ;');
    DBMS_OUTPUT.PUT_LINE('TRUNCATE TABLE ZOECOMM.COM_I18N_DICT_LANG_INFO ;');
    
    v_return := zoetmp.get_data_for_insert('ZOECOMM','COM_I18N_DICT_CLASS');
    v_return := zoetmp.get_data_for_insert('ZOECOMM','COM_I18N_DICT_CLASS_DIST');
    v_return := zoetmp.get_data_for_insert('ZOECOMM','COM_I18N_DICT_INFO');
    v_return := zoetmp.get_data_for_insert('ZOECOMM','COM_I18N_DICT_LANG_INFO');
    DBMS_OUTPUT.PUT_LINE('COMMIT;');
    DBMS_OUTPUT.PUT_LINE('SPOOL OFF');
end; 
/
spool off
set feedback on
DROP FUNCTION zoetmp.get_data_for_insert;



