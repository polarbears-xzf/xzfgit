-- =====================================================

CREATE OR REPLACE PACKAGE ZOEDEVOPS.ZOEPKG_SECURITY 

-- Created in 2019.06.18 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoepkg_security.pks
--	Description:
-- 		基础安全包
--  Relation:
--      
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--

AS

-- ===================================================
-- 加密字符串
-- ===================================================
--	参数：传入参数及类型：
	FUNCTION ENCRYPT_DES(iv_text VARCHAR2, iv_key VARCHAR2)
		RETURN VARCHAR2;
-- ===================================================
-- 解密字符串
-- ===================================================
--	参数：传入参数及类型：
	FUNCTION DECRYPT_DES(iv_encrypted_text VARCHAR2, iv_key VARCHAR2)
		RETURN VARCHAR2;

-- ===================================================
-- 文本校验，SH1校验
-- ===================================================
--	参数：传入参数及类型：
  FUNCTION VERIFY_SH1(iv_text IN VARCHAR2)
    RETURN VARCHAR2;



END ZOEPKG_SECURITY;
/

