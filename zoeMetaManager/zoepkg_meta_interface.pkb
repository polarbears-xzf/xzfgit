CREATE OR REPLACE PACKAGE BODY ZOESTD.ZOEPKG_META_INTERFACE 
AS

	PROCEDURE SET_META_DATA(iv_json_data VARCHAR2)
	AS
  lv_owner varchar2(64);
  lv_table varchar2(64);
  TYPE t_key_name IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
  TYPE t_key_value IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
  TYPE t_column_name IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
  TYPE t_column_value IS TABLE OF VARCHAR2(2000) INDEX BY BINARY_INTEGER;
  lt_key_name t_key_name;
  lt_key_value t_key_value;
  lt_column_name t_column_name;
  lt_column_value t_column_name;
  ln_key_index NUMBER := 1;
  ln_column_index NUMBER := 1;
  lv_sql VARCHAR2(32767);
  lv_json_data VARCHAR2(4000);
  CURSOR lc_meta_key
  IS
    SELECT JSON_VALUE(lv_json_data,'$.OWNER') AS OWNER, JSON_VALUE(lv_json_data,'$.TABLE_NAME') AS TABLE_NAME, COLUMN_NAME,COLUMN_VALUE
    FROM JSON_TABLE(lv_json_data ,'$.PRIMARY_KEY[*]' COLUMNS(COLUMN_NAME PATH '$.COLUMN_NAME' , COLUMN_VALUE PATH '$.COLUMN_VALUE'));
  CURSOR lc_meta_value
  IS
    SELECT COLUMN_NAME,COLUMN_VALUE
    FROM JSON_TABLE(lv_json_data ,'$.UPDATE_COLUMN[*]' COLUMNS(COLUMN_NAME PATH '$.COLUMN_NAME' , COLUMN_VALUE PATH '$.COLUMN_VALUE'));
	BEGIN 
    lv_json_data := iv_json_data;
 		FOR c_meta_key IN lc_meta_key LOOP
      lv_owner := c_meta_key.OWNER;
      lv_table := c_meta_key.TABLE_NAME;
      lt_key_name(ln_key_index) := c_meta_key.COLUMN_NAME;
      lt_key_value(ln_key_index) := c_meta_key.COLUMN_VALUE;
      ln_key_index := ln_key_index + 1;
    END LOOP;
		FOR c_meta_value IN lc_meta_value LOOP
      lt_column_name(ln_column_index) := c_meta_value.COLUMN_NAME;
      lt_column_value(ln_column_index) := c_meta_value.COLUMN_VALUE;
      ln_column_index := ln_column_index + 1;
    END LOOP;
     lv_sql := 'UPDATE '||lv_owner||'.'||lv_table||' SET (';
     lv_sql := lv_sql || lt_column_name(1);
    FOR i IN 2..ln_column_index-1 LOOP
      lv_sql := lv_sql || ' , '||lt_column_name(i);
    END LOOP;
      lv_sql := lv_sql || ') = ';
      lv_sql := lv_sql || '('''|| lt_column_value(1);
    FOR i IN 2..ln_column_index-1 LOOP
      lv_sql := lv_sql || ''','''||lt_column_value(i);
    END LOOP;
      lv_sql := lv_sql || ''') WHERE ';
      lv_sql := lv_sql ||lt_key_name(1) || ' = '''||lt_key_value(1)||'''';
    FOR i IN 2..ln_key_index-1 LOOP
      lv_sql := lv_sql || ' AND '||lt_key_name(i) || ' = '''||lt_key_value(i)||'''';
    END LOOP;
      lv_sql := lv_sql || '';
      DBMS_OUTPUT.PUT_LINE(lv_sql);
	END SET_META_DATA;
	


END ZOEPKG_META_INTERFACE;