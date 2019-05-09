CREATE OR REPLACE TRIGGER zoesecurity.ZOETRG_AUD_SERVERERROR
AFTER SERVERERROR
ON DATABASE DISABLE
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
  lv_audit_ddl_log_id    VARCHAR2(64);
  lv_returncode          NUMBER;
BEGIN
-- 循环处理错误信息
  FOR i IN 1..ora_server_error_depth LOOP
    -- lv_errmsg := ora_server_error_msg(i);
    null;
  END LOOP;
-- 处理记录DDL错误号
  lv_returncode       :=  ORA_SERVER_ERROR(1);
  lv_audit_ddl_log_id := SYS_CONTEXT('ZOE_AUD_CONTEXT','AUDIT_DDL_LOG_ID');
  IF SUBSTR(lv_audit_ddl_log_id,1,8) = 'AUDDDL#|' THEN
    UPDATE ZOESECURITY.AUD_DDL_RECORD SET RETURNCODE=lv_returncode WHERE LOG_ID=lv_audit_ddl_log_id;
    COMMIT;
  END IF;
  
EXCEPTION 
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('zoesecurity.ZOETRG_AUD_DDL_AFTER:'||SQLERRM);
  ROLLBACK;
  NULL;
END;