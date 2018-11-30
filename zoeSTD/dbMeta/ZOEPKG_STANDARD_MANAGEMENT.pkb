CREATE OR REPLACE PACKAGE BODY ZOEMETA.ZOEPKG_STANDARD_MANAGEMENT
AS
  PROCEDURE get_word_resolve_string_db
  AS
    lv_phrase_length    NUMBER;
    lv_separator_start  NUMBER := 1;
    lv_separator_end    NUMBER := 1;
    lv_separator        VARCHAR2(1);
    lt_word_list_database  ZOEMETA.MET_WORD_LIST_DATABASE%ROWTYPE;
    lv_word             VARCHAR2(30);
    CURSOR crsr_string
    IS
      SELECT TABLE_NAME PHARSE_STRING,COMMENTS PHRASE_COMMENT ,'TABLE' PHRASE_CLASS,
        OWNER PHRASE_OWNER,TABLE_NAME PHRASE_OBJECT,NULL OBJECT_COMMENT
      FROM SYS.DBA_TAB_COMMENTS
      WHERE OWNER IN (SELECT SCHEMA_NAME FROM ZOEMETA.MET_STD_SCHEMA_DICT WHERE SCHEMA_AUDIT_FLAG = 1) AND TABLE_NAME NOT LIKE 'BIN$%'
    UNION ALL
    SELECT COLUMN_NAME PHARSE_STRING,COMMENTS PHRASE_COMMENT ,'COLUMN' PHRASE_CLASS,
      OWNER PHRASE_OWNER, TABLE_NAME PHRASE_OBJECT,NULL OBJECT_COMMENT
    FROM SYS.DBA_COL_COMMENTS
    WHERE OWNER IN (SELECT SCHEMA_NAME FROM ZOEMETA.MET_STANDARD_SCHEMA_DICT)  AND OWNER NOT IN ('ZOEACT') AND TABLE_NAME NOT LIKE 'BIN$%'
    ORDER BY PHRASE_CLASS,PHARSE_STRING;
  BEGIN
      OPEN crsr_string;
      LOOP 
        FETCH crsr_string INTO lt_word_list_database.standard_phrase,lt_word_list_database.phrase_comment,lt_word_list_database.phrase_class,
          lt_word_list_database.owner,lt_word_list_database.object_name,lt_word_list_database.object_comment;
        EXIT WHEN crsr_string%NOTFOUND;
        lv_separator_start := 1;
        lv_separator_end := 1;
        lv_phrase_length := LENGTH(lt_word_list_database.standard_phrase);
        LOOP
          lv_separator_end := INSTR(lt_word_list_database.standard_phrase,'_',lv_separator_start);
          IF lv_separator_end = 0 THEN
            lv_word := SUBSTR(lt_word_list_database.standard_phrase,lv_separator_start,lv_phrase_length);
            insert into ZOEMETA.MET_WORD_LIST_DATABASE values (lv_word,lt_word_list_database.standard_phrase,lt_word_list_database.phrase_comment,
              lt_word_list_database.phrase_class,lt_word_list_database.owner,lt_word_list_database.object_name,lt_word_list_database.object_comment);
            EXIT;
          ELSE
            lv_word := SUBSTR(lt_word_list_database.standard_phrase,lv_separator_start , lv_separator_end - lv_separator_start);
            IF INSTR(lt_word_list_database.standard_phrase,lv_word,lv_separator_start,2) > 0 THEN
              NULL;
            ELSE
              insert into ZOEMETA.MET_WORD_LIST_DATABASE values (lv_word,lt_word_list_database.standard_phrase,lt_word_list_database.phrase_comment,
                lt_word_list_database.phrase_class,lt_word_list_database.owner,lt_word_list_database.object_name,lt_word_list_database.object_comment);
            END IF;
         END IF;
         lv_separator_start := lv_separator_end + 1;
        END LOOP;
      END LOOP;
      COMMIT;
      CLOSE crsr_string;
  END get_word_resolve_string_db;
  
  PROCEDURE get_create_table_sql
  AS
    lv_owner          VARCHAR2(30);
    lv_table_name     VARCHAR2(30);
    lv_column_name    VARCHAR2(30);
    lv_data_type      VARCHAR2(30);
    ln_data_length    NUMBER;
    lv_primary_key    VARCHAR2(30);
    ln_primary_key_count  NUMBER;
    lv_owner_key      VARCHAR2(30);
    lv_table_name_key VARCHAR2(30);
    lv_column_name_key VARCHAR2(30);
    lv_data_type_key  VARCHAR2(30);
    ln_data_length_key NUMBER;
    lv_ct_sql         VARCHAR2(8000);
    CURSOR lcs_macr_column
      IS SELECT    SCHEMA_NAME,
          PHRASE_NAME_TABLE,
          SUBSTR(PHRASE_NAME,1,30),
          DATA_TYPE,
          DATA_LENGTH
        FROM ZOEMETA.MET_AUDIT_COLUMN_RECORD
        WHERE PROCESS_MODE <> 'É¾³ý' --AND SCHEMA_NAME = c_owner
        ORDER BY SCHEMA_NAME,PHRASE_NAME_TABLE,COLUMN_ORDER;
      CURSOR lcs_macr_pk(c_owner varchar2,c_table_name varchar2)
      IS SELECT  SUBSTR(PHRASE_NAME,1,30)
        FROM ZOEMETA.MET_AUDIT_COLUMN_RECORD
        WHERE SCHEMA_NAME = c_owner
          AND PHRASE_NAME_TABLE = c_table_name
          AND PRIMARY_KEY_FLAG=1
        ORDER BY PRIMARY_KEY_ORDER;
      CURSOR lcs_macr_pk_count(c_owner varchar2,c_table_name varchar2)
      IS SELECT  count(1)
        FROM ZOEMETA.MET_AUDIT_COLUMN_RECORD
        WHERE SCHEMA_NAME = c_owner
          AND PHRASE_NAME_TABLE = c_table_name
          AND PRIMARY_KEY_FLAG=1
        ORDER BY PRIMARY_KEY_ORDER;    
  BEGIN
    lv_ct_sql := '';
    OPEN lcs_macr_column;
    FETCH lcs_macr_column INTO lv_owner,lv_table_name,lv_column_name,lv_data_type,ln_data_length;
    IF lv_data_type = 'VARCHAR2' THEN
      --DBMS_OUTPUT.PUT_LINE('CREATE TABLE '||lv_owner||'.'||lv_table_name||' ('||
      --  lv_column_name||' '||lv_data_type||'('||ln_data_length||'), ');
      lv_ct_sql := lv_ct_sql||'CREATE TABLE '||lv_owner||'.'||lv_table_name||' ('||
        lv_column_name||' '||lv_data_type||'('||ln_data_length||'), ';
    ELSE
      --DBMS_OUTPUT.PUT_LINE('CREATE TABLE '||lv_owner||'.'||lv_table_name||' ('||
      --  lv_column_name||' '||lv_data_type||', ');
      lv_ct_sql := lv_ct_sql||'CREATE TABLE '||lv_owner||'.'||lv_table_name||' ('||
        lv_column_name||' '||lv_data_type||', ';
    END IF;
    lv_owner_key := lv_owner;
    lv_table_name_key := lv_table_name;
    lv_column_name_key := lv_column_name;
    lv_data_type_key := lv_data_type;
    ln_data_length_key := ln_data_length;
    LOOP 
        FETCH lcs_macr_column INTO lv_owner,lv_table_name,lv_column_name,lv_data_type,ln_data_length;
        IF lv_table_name_key<>lv_table_name THEN
            OPEN lcs_macr_pk(lv_owner_key,lv_table_name_key);
            OPEN lcs_macr_pk_count(lv_owner_key,lv_table_name_key);
            FETCH lcs_macr_pk_count INTO ln_primary_key_count;
            FOR I IN 1..ln_primary_key_count LOOP 
              FETCH lcs_macr_pk INTO lv_primary_key;
              IF ln_primary_key_count = 1 THEN
                --DBMS_OUTPUT.PUT_LINE('constraint PK_'||SUBSTR(lv_table_name_key,1,27)||' primary key ('||
                --  lv_primary_key||') using index);');
                lv_ct_sql := lv_ct_sql||'constraint PK_'||SUBSTR(lv_table_name_key,1,27)||' primary key ('||
                  lv_primary_key||') using index)';
                  --DBMS_OUTPUT.PUT_LINE(lv_ct_sql);
                  BEGIN
                  EXECUTE IMMEDIATE lv_ct_sql;
                  EXCEPTION 
                    WHEN OTHERS THEN
                      DBMS_OUTPUT.PUT_LINE(SQLERRM);
                      DBMS_OUTPUT.PUT_LINE('  '||lv_ct_sql);
                      lv_ct_sql:='';
                  END;
                  lv_ct_sql:='';
              ELSIF I =1 THEN
                --DBMS_OUTPUT.PUT_LINE('constraint PK_'||SUBSTR(lv_table_name_key,1,27)||' primary key ('||
                --  lv_primary_key||',');
                lv_ct_sql := lv_ct_sql||'constraint PK_'||SUBSTR(lv_table_name_key,1,27)||' primary key ('||
                  lv_primary_key||',';
              ELSIF I = ln_primary_key_count THEN
                    --DBMS_OUTPUT.PUT_LINE(lv_primary_key||') using index);');
                    lv_ct_sql := lv_ct_sql||lv_primary_key||') using index)';
                  --DBMS_OUTPUT.PUT_LINE(lv_ct_sql);
                  BEGIN
                  EXECUTE IMMEDIATE lv_ct_sql;
                    EXCEPTION 
                    WHEN OTHERS THEN
                     DBMS_OUTPUT.PUT_LINE(SQLERRM);
                     DBMS_OUTPUT.PUT_LINE('  '||lv_ct_sql);
                     lv_ct_sql:='';
                  END;
                lv_ct_sql:='';
              ELSE 
                --DBMS_OUTPUT.PUT_LINE(lv_primary_key||',');
                lv_ct_sql := lv_ct_sql||lv_primary_key||',';
              END IF;
            END LOOP;
            CLOSE lcs_macr_pk_count;
            CLOSE lcs_macr_pk;

          IF lv_data_type = 'VARCHAR2' THEN
            --DBMS_OUTPUT.PUT_LINE('CREATE TABLE '||lv_owner||'.'||lv_table_name||' ('||
              --lv_column_name||' '||lv_data_type||'('||ln_data_length||'), ');
            lv_ct_sql := lv_ct_sql||'CREATE TABLE '||lv_owner||'.'||lv_table_name||' ('||
              lv_column_name||' '||lv_data_type||'('||ln_data_length||'), ';
          ELSE
            --DBMS_OUTPUT.PUT_LINE('CREATE TABLE '||lv_owner||'.'||lv_table_name||' ('||
              --lv_column_name||' '||lv_data_type||', ');
            lv_ct_sql := lv_ct_sql||'CREATE TABLE '||lv_owner||'.'||lv_table_name||' ('||
              lv_column_name||' '||lv_data_type||', ';
          END IF;
        ELSE 
          IF lv_data_type = 'VARCHAR2' THEN
            --DBMS_OUTPUT.PUT_LINE(lv_column_name||' '||lv_data_type||'('||ln_data_length||'), ');
              lv_ct_sql := lv_ct_sql||lv_column_name||' '||lv_data_type||'('||ln_data_length||'), ';
          ELSE
            --DBMS_OUTPUT.PUT_LINE(lv_column_name||' '||lv_data_type||', ');
              lv_ct_sql := lv_ct_sql||lv_column_name||' '||lv_data_type||', ';
          END IF;
        END IF;
        lv_owner_key := lv_owner;
        lv_table_name_key := lv_table_name;
        lv_column_name_key := lv_column_name;
        lv_data_type_key := lv_data_type;
        ln_data_length_key := ln_data_length;
    EXIT WHEN lcs_macr_column%NOTFOUND;
    END LOOP;

    CLOSE lcs_macr_column;
  END get_create_table_sql;
  
  PROCEDURE update_pbcatcol_relation_cmnt
  AS 
    lv_pbc_owner          SYSTEM.PBCATCOL.PBC_OWNR%TYPE;
    lv_pbc_table          SYSTEM.PBCATCOL.PBC_TNAM%TYPE;
    lv_pbc_column         SYSTEM.PBCATCOL.PBC_CNAM%TYPE;
    lv_pbc_labl           SYSTEM.PBCATCOL.PBC_LABL%TYPE;
    lv_pbc_relation_dict  SYSTEM.PBCATCOL.PBC_RELATION_DICT%TYPE;
    lv_pdb_cmnt           SYSTEM.PBCATCOL.PBC_CMNT%TYPE;
    lv_labl_sub1          VARCHAR2(31 CHAR);
    lv_labl_sub2          VARCHAR2(254 CHAR);
    CURSOR lcs_pbcatcol IS
      SELECT PBC_OWNR,PBC_TNAM,PBC_CNAM,PBC_LABL,PBC_RELATION_DICT,PBC_CMNT FROM SYSTEM.PBCATCOL
      WHERE PBC_OWNR IN (SELECT schema_name FROM ZOEMETA.met_std_schema_dict) ;
  BEGIN
    OPEN lcs_pbcatcol;
    LOOP
      FETCH lcs_pbcatcol INTO lv_pbc_owner,lv_pbc_table,lv_pbc_column,lv_pbc_labl,lv_pbc_relation_dict,lv_pdb_cmnt;
      EXIT WHEN lcs_pbcatcol%NOTFOUND;
      lv_pbc_labl := SUBSTR(lv_pbc_labl,1,254);
      IF lv_pbc_relation_dict IS NULL THEN
        lv_labl_sub1 := SUBSTR(ZOEMETA.zoepkg_common_tools.get_substr_spec_terminal(lv_pbc_labl,'#|',2),1,31);
        lv_labl_sub2 := ZOEMETA.zoepkg_common_tools.get_substr_spec_terminal(lv_pbc_labl,'#|',3);
        IF (lv_labl_sub1 IS NOT NULL OR lv_labl_sub2 IS NOT NULL) AND  length(lv_labl_sub1)=lengthb(lv_labl_sub1) THEN
          UPDATE SYSTEM.PBCATCOL SET PBC_RELATION_DICT=lv_labl_sub1 , PBC_CMNT=lv_labl_sub2
            WHERE PBC_OWNR = lv_pbc_owner AND PBC_TNAM = lv_pbc_table AND PBC_CNAM = lv_pbc_column;
        END IF;
      END IF;
      
    END LOOP;
    CLOSE lcs_pbcatcol;
    COMMIT;
    EXCEPTION 
      WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE(sqlerrm);
        ROLLBACK;
        
  END update_pbcatcol_relation_cmnt;
  
    PROCEDURE update_pbcatcol_labl
  AS 
    lv_pbc_owner          SYSTEM.PBCATCOL.PBC_OWNR%TYPE;
    lv_pbc_table          SYSTEM.PBCATCOL.PBC_TNAM%TYPE;
    lv_pbc_column         SYSTEM.PBCATCOL.PBC_CNAM%TYPE;
    lv_pbc_labl           SYSTEM.PBCATCOL.PBC_LABL%TYPE;
    lv_pbc_relation_dict  SYSTEM.PBCATCOL.PBC_RELATION_DICT%TYPE;
    lv_pdb_cmnt           SYSTEM.PBCATCOL.PBC_CMNT%TYPE;
    lv_labl_sub           VARCHAR2(254 CHAR);
    lv_labl_sub1          VARCHAR2(31 CHAR);
    lv_labl_sub2          VARCHAR2(254 CHAR);
    CURSOR lcs_pbcatcol IS
      SELECT PBC_OWNR,PBC_TNAM,PBC_CNAM,PBC_LABL,PBC_RELATION_DICT,PBC_CMNT FROM SYSTEM.PBCATCOL
      WHERE PBC_OWNR IN (SELECT schema_name FROM ZOEMETA.met_std_schema_dict) 
        AND (PBC_RELATION_DICT IS NOT NULL OR PBC_CMNT IS NOT NULL);
  BEGIN
    OPEN lcs_pbcatcol;
    LOOP
      FETCH lcs_pbcatcol INTO lv_pbc_owner,lv_pbc_table,lv_pbc_column,lv_pbc_labl,lv_pbc_relation_dict,lv_pdb_cmnt;
      EXIT WHEN lcs_pbcatcol%NOTFOUND;
        lv_labl_sub1 := SUBSTR(ZOEMETA.zoepkg_common_tools.get_substr_spec_terminal(lv_pbc_labl,'#|',2),1,31);
        IF lv_labl_sub1 IS NULL THEN
          IF lv_pbc_relation_dict IS NOT NULL and LENGTH(lv_pbc_relation_dict) < 32 THEN
            lv_labl_sub1 := lv_pbc_relation_dict;
          END IF;
        END IF;
        
        lv_labl_sub2 := ZOEMETA.zoepkg_common_tools.get_substr_spec_terminal(lv_pbc_labl,'#|',3);
        IF lv_labl_sub2 IS NULL THEN
          IF lv_pdb_cmnt IS NOT NULL THEN
            lv_labl_sub2 := lv_pdb_cmnt;
          END IF;
        END IF;
        IF instr(lv_pbc_labl,'#|',1,1) = 0 THEN
          lv_labl_sub := lv_pbc_labl;
        ELSE
          lv_labl_sub := substr(lv_pbc_labl,1,instr(lv_pbc_labl,'#|',1,1)-1);
        END IF;
        lv_labl_sub := lv_labl_sub||'#|'||lv_labl_sub1||'#|'||lv_labl_sub2;
        lv_labl_sub := substr(lv_labl_sub,1,254);
--        dbms_output.put_line(lv_labl_sub);
         UPDATE SYSTEM.PBCATCOL SET PBC_LABL = lv_labl_sub 
           WHERE PBC_OWNR = lv_pbc_owner AND PBC_TNAM = lv_pbc_table AND PBC_CNAM = lv_pbc_column;
      
    END LOOP;
    CLOSE lcs_pbcatcol;
    COMMIT;
    EXCEPTION 
      WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE(sqlerrm);
        ROLLBACK;
        
  END update_pbcatcol_labl;
  
END ZOEPKG_STANDARD_MANAGEMENT;