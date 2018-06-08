CREATE OR REPLACE TRIGGER zoesecurity.ZOETRG_AUD_DDL_AFTER
AFTER DDL
ON DATABASE
-- Created in 2017.12.15 by polarbears
-- Copyright (c) 2018, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoetri_aud_ddl_after.pls
--	Description:
-- 		审计和控制DDL操作
--  Relation:
--    函数：zoefun_aud_get_sql,zoefun_aud_get_context
--    自定义类型：zoetyp_audit_ddl_log,zoetyp_aud_session_context
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
DECLARE 
  --声明自治事务
  PRAGMA AUTONOMOUS_TRANSACTION;
  lv_audit_ddl_log_id    VARCHAR2(36);
  lv_returncode          NUMBER;
BEGIN
  lv_returncode       := SQLCODE;
  lv_audit_ddl_log_id := SYS_CONTEXT('ZOE_AUDIT_CONTEXT','AUDIT_DDL_LOG_ID');
  DBMS_OUTPUT.PUT_LINE('3'||SQLERRM);
  IF lv_returncode = 0 THEN
    NULL;
  ELSE 
    UPDATE audit_ddl_log SET RETURNCODE=lv_returncode WHERE LOG_ID=lv_audit_ddl_log_id;
    COMMIT;
  END IF;
EXCEPTION 
WHEN OTHERS THEN
  ROLLBACK;
  NULL;
END;