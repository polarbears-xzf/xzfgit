-- =========================================================================================
CREATE OR REPLACE FUNCTION ZOEDEVOPS.ZOEFUN_DECRYPT_USER(iv_username VARCHAR2, iv_password VARCHAR2, iv_key VARCHAR2)

-- Created in 2019.06.18 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoefun_encrypt_user.sql
--	Description:
-- 		解密用户密码
--  Relation:
--      zoeUtility
--	Notes:
--		
--	修改 - （年-月-日） - 描述
--  

    RETURN VARCHAR2
  AS
    lv_password           VARCHAR2(128);
    lv_decrypted_text     VARCHAR2(128);
  BEGIN
    IF iv_username IS NULL OR iv_password IS NULL THEN
      RETURN NULL;
    END IF;
    lv_decrypted_text := ZOEDEVOPS.ZOEPKG_SECURITY.DECRYPT_DES(iv_password, iv_key);
    lv_password := substr(lv_decrypted_text,length(iv_username)+1);
    RETURN lv_password;
  END ZOEFUN_DECRYPT_USER;
  /
  