--
CREATE OR REPLACE PACKAGE BODY ZOEDEVOPS.ZOEPKG_UTILITY 
AS

  FUNCTION SPLIT_STRING(iv_string IN VARCHAR2, in_split_length IN NUMBER DEFAULT 1872)
    RETURN ZOETYP_UTILITY_SPLIT_STRINGS
    AS
      ln_length NUMBER := LENGTH(iv_string) ;
      ln_start  NUMBER :=1 ;
      ln_index  NUMBER;
      lt_split_string   ZOETYP_UTILITY_SPLIT_STRINGS := ZOETYP_UTILITY_SPLIT_STRINGS();
    BEGIN
      IF ln_length < in_split_length THEN
       lt_split_string.extend;
       lt_split_string(1) := iv_string;
      ELSE 
        IF MOD(ln_length, in_split_length) = 0 THEN
          ln_index := TRUNC(ln_length/in_split_length);
        ELSE
          ln_index := TRUNC(ln_length/in_split_length) + 1;
        END IF;
        FOR i IN 1..ln_index LOOP
          lt_split_string.extend;
          lt_split_string(i) := SUBSTR(iv_string,ln_start + in_split_length * (i - 1),in_split_length );
        END LOOP;
      END IF;
      RETURN lt_split_string;
    END SPLIT_STRING;

  FUNCTION SPLIT_STRING(iv_string IN VARCHAR2, in_split_delimiter IN VARCHAR2)
    RETURN ZOETYP_UTILITY_SPLIT_STRINGS
    PIPELINED
    AS
      ln_length NUMBER := LENGTH(iv_string) ;
      ln_start  NUMBER :=1 ;
      ln_index  NUMBER;
    BEGIN
      WHILE (ln_start <= ln_length) LOOP
      ln_index := instr(iv_string, in_split_delimiter, ln_start) ;
      IF ln_index = 0 THEN
        PIPE ROW(substr(iv_string, ln_start));
        ln_start := ln_length + 1;
      ELSE
        PIPE ROW(substr(iv_string, ln_start, ln_index - ln_start));
        ln_start := ln_index + length(in_split_delimiter);
      END IF;
    END LOOP;
      RETURN;
    END SPLIT_STRING;
    
   FUNCTION SPLIT_TABLE(iv_text IN VARCHAR2)
    RETURN zoetyp_utility_split_strings
   AS
      lv_table_info   VARCHAR2(32767);
      lt_split_string   ZOETYP_UTILITY_SPLIT_STRINGS := ZOETYP_UTILITY_SPLIT_STRINGS();
    BEGIN
    -- Oracle 10g 不支持LISTAGG
    /*
      SELECT TABLE_INFO||TABLE_PK_INFO INTO lv_table_info
      FROM
        (SELECT OWNER,TABLE_NAME, LISTAGG(COLUMN_NAME
          ||DATA_TYPE
          ||DATA_LENGTH
          ||DATA_PRECISION) within GROUP (
        ORDER BY COLUMN_ID) AS TABLE_INFO
        FROM DBA_TAB_COLUMNS
        GROUP BY OWNER,TABLE_NAME
        ) a,
        (SELECT b.OWNER, b.TABLE_NAME, LISTAGG(B.COLUMN_NAME) within GROUP (
        ORDER BY B.POSITION) AS TABLE_PK_INFO
        FROM DBA_CONSTRAINTS a, DBA_CONS_COLUMNS B
        WHERE a.OWNER           =B.OWNER
          AND a.TABLE_NAME      =B.TABLE_NAME
          AND a.CONSTRAINT_NAME = B.CONSTRAINT_NAME
          AND a.CONSTRAINT_TYPE ='P'
        GROUP BY B.OWNER,B.TABLE_NAME
        ) B
      WHERE a.owner     =b.owner
        AND a.table_name=b.table_name AND LENGTH(TABLE_INFO||TABLE_PK_INFO)>2000 AND ROWNUM=1 ; */
        --lt_split_string.extend;
        select ZOEPKG_UTILITY.split_string(lv_table_info) into lt_split_string from dual;
        RETURN lt_split_string;
    END SPLIT_TABLE;  


FUNCTION SELECT_DYNTABLE(iv_owner VARCHAR2 DEFAULT 'SYS', iv_table_name VARCHAR2 DEFAULT 'DUAL')
RETURN ref_dyntable
IS
  lref_sql ref_dyntable;
BEGIN
  OPEN lref_sql FOR 'SELECT * FROM '||iv_owner||'.'||iv_table_name;
  RETURN lref_sql;
END SELECT_DYNTABLE;

END ZOEPKG_UTILITY;
