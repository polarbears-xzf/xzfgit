CREATE OR REPLACE PACKAGE BODY ZOEDEVOPS.ZOEPKG_SQLLDR
AS

  PROCEDURE SQLLDR_GET_CTL (iv_loaddata_path IN VARCHAR2, iv_table_owner IN VARCHAR2, iv_table_name VARCHAR2) AS
    CURSOR lc_table_column is SELECT COLUMN_NAME,DATA_TYPE FROM DBA_TAB_COLUMNS WHERE OWNER=iv_table_owner AND TABLE_NAME=iv_table_name;
    lv_column_name VARCHAR2(64);
    lv_column_datetype VARCHAR2(64);
    ls_column VARCHAR2(4000);
  BEGIN
    DBMS_OUTPUT.PUT_LINE('OPTIONS (skip=0,rows=32)');
    DBMS_OUTPUT.PUT_LINE('LOAD DATA');
    DBMS_OUTPUT.PUT_LINE('INFILE '''||iv_loaddata_path||'load'||iv_table_name||'.csv''');
    DBMS_OUTPUT.PUT_LINE('APPEND');
    DBMS_OUTPUT.PUT_LINE('INTO TABLE '||iv_table_owner||'.'||iv_table_name);
    DBMS_OUTPUT.PUT_LINE('FIELDS TERMINATED BY '',''');
    DBMS_OUTPUT.PUT_LINE('OPTIONALLY ENCLOSED BY ''"''');
    DBMS_OUTPUT.PUT_LINE('TRAILING NULLCOLS');
    ls_column :='(';
    OPEN lc_table_column;
    FETCH lc_table_column INTO lv_column_name,lv_column_datetype;
    LOOP
     IF lv_column_datetype = 'DATE' THEN
       ls_column := ls_column||lv_column_name||' DATE ''yyyy-mm-dd hh24:mi:ss''';
     ELSE 
       ls_column := ls_column||lv_column_name;
     END IF;
     FETCH lc_table_column INTO lv_column_name,lv_column_datetype;
    EXIT WHEN lc_table_column%NOTFOUND;
     ls_column := ls_column||',';
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(ls_column);
    DBMS_OUTPUT.PUT_LINE(')');
    CLOSE lc_table_column;
  END SQLLDR_GET_CTL;
  
  PROCEDURE SQLLDR_GET_DATA (iv_table_owner IN VARCHAR2, iv_table_name IN VARCHAR2, ov_column_data OUT VARCHAR2) AS
    CURSOR lc_table_column is SELECT COLUMN_NAME FROM DBA_TAB_COLUMNS WHERE OWNER=iv_table_owner AND TABLE_NAME=iv_table_name;
    lv_column_name VARCHAR2(64);
    ls_column VARCHAR2(4000);
  BEGIN
    OPEN lc_table_column;
    LOOP
     FETCH lc_table_column INTO lv_column_name;
       ls_column := ls_column||lv_column_name;
    EXIT WHEN lc_table_column%NOTFOUND;
     ls_column := ls_column||'||'',''||';
    END LOOP;
    ov_column_data := ls_column;
    CLOSE lc_table_column;
  END SQLLDR_GET_DATA;
      
      
  END ZOEPKG_SQLLDR;
  /
  