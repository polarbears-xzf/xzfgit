CREATE OR REPLACE PACKAGE BODY ZOEDEVOPS.ZOEPKG_SECURITY 
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
    lv_text    := lv_text;
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


END ZOEPKG_SECURITY;
/

