-- ======================================================

COLUMN c_secret_key new_value c_secret_key
SELECT  DBMS_RANDOM.STRING('X',16) c_secret_key FROM  DUAL;

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
	lv_secret_key VARCHAR2(24) := '&c_secret_key';
    lv_key_id VARCHAR2(64);
    lv_sql VARCHAR2(2000);
BEGIN
    SELECT ZOEDEVOPS.ZOEPKG_OPS_DB_INFO.GET_DB_ID INTO lv_key_id FROM DUAL;
    IF lv_key_id <> 'B82C969F0D4114F40EB3452C5CEC92C2B78A19EB' THEN
    	RETURN lv_secret_key;
    ELSE
        lv_key_id := SYS_CONTEXT('ZOE_DEVOPS_CONTEXT', 'DB_KEY');
        IF lv_key_id IS NULL OR lv_key_id = 'B82C969F0D4114F40EB3452C5CEC92C2B78A19EB' THEN
            RETURN lv_secret_key;
        ELSE 
            lv_sql := 'SELECT KEY_VALUE FROM ZOEDEVOPS.DVP_PROJECT_SECRET_KEY WHERE KEY_ID#='''||lv_key_id||'''';
            EXECUTE IMMEDIATE lv_sql INTO lv_secret_key;
            RETURN SUBSTR(lv_secret_key,1,16);
        END IF;
    END IF;
END;
/


