--
CREATE OR REPLACE FUNCTION ZOEDEVOPS.ENCRYPT_USER(iv_username VARCHAR2, iv_password VARCHAR2)
    RETURN VARCHAR2
  AS
    lv_text               VARCHAR2(128);
    lv_encrypted_text     VARCHAR2(128);
  BEGIN
    lv_text    := iv_username||iv_password;
    lv_encrypted_text := ZOEDEVOPS.ZOEPKG_SECURITY.ENCRYPT_DES(lv_text);
    RETURN lv_encrypted_text;
  END ENCRYPT_USER;
/

