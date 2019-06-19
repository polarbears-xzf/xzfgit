-- ======================================================

COLUMN c_crypto_key1 new_value c_crypto_key1
SELECT  DBMS_RANDOM.STRING('X',24) c_crypto_key1 FROM  DUAL;

CREATE OR REPLACE FUNCTION ZOEDEVOPS.ZOEFUN_CRYPTO_KEY
	RETURN VARCHAR2
	
-- Created in 2019.06.18 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoefun_crypto_key.pls
--	Description:
-- 		基础安全包
--  Relation:
--      
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--

AS
	lv_crypto_key CONSTANT VARCHAR2(24) := '&c_crypto_key1';
BEGIN
	RETURN lv_crypto_key;
END;
/

SELECT DBMS_RANDOM.STRING('X',8) crypto_key2 FROM DUAL;
