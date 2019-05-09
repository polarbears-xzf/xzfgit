--
CREATE OR REPLACE FUNCTION ZOEDEVOPS.DECRYPT_USER(iv_username VARCHAR2, iv_password VARCHAR2)
    RETURN VARCHAR2
  AS
    lv_password           VARCHAR2(128);
    lv_decrypted_text     VARCHAR2(128);
  BEGIN
    IF iv_username IS NULL OR iv_password IS NULL THEN
      RETURN NULL;
    END IF;
    lv_decrypted_text := ZOEDEVOPS.ZOEPKG_SECURITY.DECRYPT_DES(iv_password);
    lv_password := substr(lv_decrypted_text,length(iv_username)+1);
    RETURN lv_password;
  END DECRYPT_USER;
  /
  