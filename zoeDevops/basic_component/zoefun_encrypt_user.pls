-- ==============================================================================================

CREATE OR REPLACE FUNCTION ZOEDEVOPS.ZOEFUN_ENCRYPT_USER(iv_username VARCHAR2, iv_password VARCHAR2, iv_key VARCHAR2)
    RETURN VARCHAR2
	
-- Created in 2019.06.18 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoefun_encrypt_user.sql
--	Description:
-- 		创建运维相关表
--  Relation:
--      zoeUtility
--	Notes:
--		
--	修改 - （年-月-日） - 描述
--  

AS
    lv_text               VARCHAR2(128);
    lv_encrypted_text     VARCHAR2(128);
  BEGIN
    lv_text    := iv_username||iv_password;
    lv_encrypted_text := ZOEDEVOPS.ZOEPKG_SECURITY.ENCRYPT_DES(lv_text,iv_key);
    RETURN lv_encrypted_text;
  END ZOEFUN_ENCRYPT_USER;
/

