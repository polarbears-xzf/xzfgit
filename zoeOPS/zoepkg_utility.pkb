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

FUNCTION GET_ORACLE_USER 
RETURN zoetyp_db_object_list
IS
	lt_oracle_user zoetyp_db_object_list:=zoetyp_db_object_list();
BEGIN
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'SYS';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'SYSTEM';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'ANONYMOUS';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'APEX_030200';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'APEX_PUBLIC_USER';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'APPQOSSYS';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'AUDSYS';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'CTXSYS';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'DBSNMP';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'DIP';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'DVF';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'DVSYS';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'EXFSYS';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'FLOWS_FILES';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'GSMADMIN_INTERNAL';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'GSMCATUSER';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'GSMUSER';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'LBACSYS';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'MDDATA';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'MDSYS';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'MGMT_VIEW';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'OJVMSYS';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'OLAPSYS';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'ORACLE_OCM';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'ORDDATA';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'ORDPLUGINS';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'ORDSYS';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'OUTLN';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'OWBSYS';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'OWBSYS_AUDIT';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'SCOTT';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'SI_INFORMTN_SCHEMA';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'SPATIAL_CSW_ADMIN_USR';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'SPATIAL_WFS_ADMIN_USR';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'SYSBACKUP';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'SYSDG';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'SYSKM';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'WMSYS';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'XDB';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'XS$NULL';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'SYSRAC';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'REMOTE_SCHEDULER_AGENT';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'DBSFWUSER';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'SYS$UMF';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'GGSYS';
	lt_oracle_user.extend;
	lt_oracle_user(lt_oracle_user.count) := 'SYSMAN';
	RETURN lt_oracle_user;
END GET_ORACLE_USER;

FUNCTION SELECT_DYNTABLE(iv_owner VARCHAR2 DEFAULT 'SYS', iv_table_name VARCHAR2 DEFAULT 'DUAL')
RETURN ref_dyntable
IS
  lref_sql ref_dyntable;
BEGIN
  OPEN lref_sql FOR 'SELECT * FROM '||iv_owner||'.'||iv_table_name;
  RETURN lref_sql;
END SELECT_DYNTABLE;

END ZOEPKG_UTILITY;
