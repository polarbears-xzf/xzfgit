CREATE OR REPLACE PACKAGE BODY ZOEDEVOPS.ZOEPKG_UTILITY 
AS

  FUNCTION ENCRYPT_DES(iv_text VARCHAR2)
    RETURN VARCHAR2
  AS
    lv_text              VARCHAR2(256);
    lv_encrypted_text    VARCHAR2(1024);
    lrw_encrypt_text     RAW(256) ;
    lrw_encrypt_key      RAW(128) ;
    lrw_encrypted_text   RAW(1024);
  BEGIN
    lv_text    := rpad( iv_text, (TRUNC(LENGTH(iv_text)/8)+1)*8, chr(0));
    lrw_encrypt_text := UTL_RAW.CAST_TO_RAW(lv_text);
    lrw_encrypt_key  := UTL_RAW.CAST_TO_RAW('PFN6NX712XVF4N0L1ZLB8ZTWO14QXS3RUUUTHPTSRP1X64NZYML53JUEHRXLQASX');
    DBMS_OBFUSCATION_TOOLKIT.DESENCRYPT(input => lrw_encrypt_text, KEY => lrw_encrypt_key, encrypted_data =>lrw_encrypted_text);
    lv_encrypted_text := rawtohex(lrw_encrypted_text);
    --lv_encrypted_text :=  UTL_RAW.CAST_TO_VARCHAR2(lrw_encrypted_text);
    RETURN lv_encrypted_text;
  END ENCRYPT_DES;

  FUNCTION DECRYPT_DES(iv_encrypted_text VARCHAR2)
    RETURN VARCHAR2
  IS
    lv_text VARCHAR2(256);
    lv_encrypt_key  VARCHAR2(128);
    lv_encrypted_text VARCHAR2(1024);
 BEGIN
    lv_encrypt_key  := ('PFN6NX712XVF4N0L1ZLB8ZTWO14QXS3RUUUTHPTSRP1X64NZYML53JUEHRXLQASX');
    lv_encrypted_text := UTL_RAW.CAST_TO_VARCHAR2(iv_encrypted_text);
    DBMS_OBFUSCATION_TOOLKIT.DESDECRYPT(input_string => lv_encrypted_text, key_string => lv_encrypt_key, decrypted_string => lv_text);
    lv_text := rtrim(lv_text,chr(0));
    RETURN lv_text;
  END DECRYPT_DES;

  FUNCTION VERIFY_SH1(iv_text IN VARCHAR2)
    RETURN VARCHAR2
  AS
    lv_key     VARCHAR2(128);
    lv_text    VARCHAR2(32767);
    lrw_text   RAW(32767);
    lv_verify_text VARCHAR2(128);
  BEGIN
    lv_key     := 'KK3JZS70RM1L3FDDROBSIEH0VK6DMMGH151MKU0HKEN71OXQC28I96WF49WMFOHS';
    lv_text    := iv_text || lv_key;
    lrw_text   := SYS.UTL_I18N.STRING_TO_RAW(lv_text, 'AL32UTF8');
    lv_verify_text := dbms_crypto.HASH(lrw_text, dbms_crypto.HASH_SH1);
    RETURN lv_verify_text;
  END VERIFY_SH1;  

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
      ln_index := instr(iv_string, in_split_delimiter, ln_start);
      IF ln_index = 0 THEN
        PIPE ROW(substr(iv_string, ln_start));
        ln_start := ln_length + 1;
      ELSE
        PIPE ROW(substr(iv_string, ln_start, ln_index - ln_start));
        ln_start := ln_index + 1;
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
        AND a.table_name=b.table_name AND LENGTH(TABLE_INFO||TABLE_PK_INFO)>2000 AND ROWNUM=1 ;
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

END ZOEPKG_UTILITY;