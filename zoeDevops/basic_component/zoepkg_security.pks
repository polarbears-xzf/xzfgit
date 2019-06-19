-- =====================================================

CREATE OR REPLACE PACKAGE BODY ZOEDEVOPS.ZOEPKG_SECURITY 

-- Created in 2019.06.18 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		create_ops_table.sql
--	Description:
-- 		创建运维相关表
--  Relation:
--      zoeUtility
--	Notes:
--		
--	修改 - （年-月-日） - 描述
--

AS

  FUNCTION ENCRYPT_DES(iv_text VARCHAR2, iv_key VARCHAR2)
    RETURN VARCHAR2
  AS
    lv_encrypted_text    VARCHAR2(1024);
    lrw_encrypt_text     RAW(2000) ;
    lrw_encrypt_key      RAW(32) ;
    lrw_encrypted_text   RAW(2000);
    lpi_encryption_type    PLS_INTEGER :=          -- total encryption type
                            DBMS_CRYPTO.ENCRYPT_AES256
                          + DBMS_CRYPTO.CHAIN_CBC
                          + DBMS_CRYPTO.PAD_PKCS5;
  BEGIN
    lrw_encrypt_text := UTL_I18N.STRING_TO_RAW (iv_text,  'AL32UTF8');
    lrw_encrypt_key  := UTL_I18N.STRING_TO_RAW (ZOEDEVOPS.ZOEFUN_CRYPTO_KEY()||iv_key,  'AL32UTF8');
    lrw_encrypted_text := DBMS_CRYPTO.ENCRYPT
      (
         src => lrw_encrypt_text,
         typ => lpi_encryption_type,
         key => lrw_encrypt_key
      );
    lv_encrypted_text := rawtohex(lrw_encrypted_text);
    --lv_encrypted_text :=  UTL_RAW.CAST_TO_VARCHAR2(lrw_encrypted_text);
    RETURN lv_encrypted_text;
  END ENCRYPT_DES;

  FUNCTION DECRYPT_DES(iv_encrypted_text VARCHAR2, iv_key VARCHAR2)
    RETURN VARCHAR2
  IS
    lv_decrypted_text VARCHAR2(256);
    lrw_encrypt_text     RAW(256) ;
    lrw_encrypt_key      RAW(256) ;
    lrw_decrypted_text   RAW(2000);
    lpi_encryption_type    PLS_INTEGER :=          -- total encryption type
                            DBMS_CRYPTO.ENCRYPT_AES256
                          + DBMS_CRYPTO.CHAIN_CBC
                          + DBMS_CRYPTO.PAD_PKCS5;
 BEGIN
    lrw_encrypt_key  := UTL_I18N.STRING_TO_RAW (ZOEDEVOPS.ZOEFUN_CRYPTO_KEY()||iv_key,  'AL32UTF8');
    lrw_encrypt_text := hextoraw(iv_encrypted_text);
    lrw_decrypted_text := DBMS_CRYPTO.DECRYPT
      (
         src => lrw_encrypt_text,
         typ => lpi_encryption_type,
         key => lrw_encrypt_key
      );
    lv_decrypted_text :=  UTL_I18N.RAW_TO_CHAR (lrw_decrypted_text, 'AL32UTF8');
    RETURN lv_decrypted_text;
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

