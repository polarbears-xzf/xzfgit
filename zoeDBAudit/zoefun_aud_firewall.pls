CREATE OR REPLACE FUNCTION zoefun_aud_firewall
(ot_aud_firewall in zoetyp_aud_firewall)
RETURN INTEGER
AS
  e_no_permit_user EXCEPTION;  
  e_no_permit_owner EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_no_permit_user, -20001);  
  PRAGMA EXCEPTION_INIT(e_no_permit_owner, -20002);
BEGIN
/*  IF lt_audit_ddl_log.USERNAME <> 'SYS' AND  lt_audit_ddl_log.USERNAME <> 'SYSTEM' 
    AND lt_audit_ddl_log.USERNAME <> 'ZOETMP' AND  lt_audit_ddl_log.USERNAME <> 'ZOEAUDIT'
  THEN
    RAISE_APPLICATION_ERROR(-20001, '用户'||lt_audit_ddl_log.USERNAME||'不被允许执行DDL');
  END IF;
  RETURN 0;
    IF lt_audit_ddl_log.USERNAME = 'ZOETMP' AND  lt_audit_ddl_log.OBJECT_OWNER <> 'ZOETMP'
  THEN
    BEGIN
      UPDATE ZOEAUDIT.AUDIT_DDL_LOG SET RETURNCODE=-20002 WHERE LOG_ID=lt_audit_ddl_log.LOG_ID;
      COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
    END;
    RAISE_APPLICATION_ERROR(-20002, '用户'||lt_audit_ddl_log.USERNAME||'仅能创建自有对象');
  END IF;

EXCEPTION
WHEN e_no_permit_user THEN 
  ROLLBACK;
    BEGIN
      UPDATE ZOEAUDIT.AUDIT_DDL_LOG SET RETURNCODE=-20001 WHERE LOG_ID=lt_audit_ddl_log.LOG_ID;
      COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
    END;
  RAISE;
WHEN e_no_permit_owner THEN 
  ROLLBACK;
    BEGIN
      UPDATE ZOEAUDIT.AUDIT_DDL_LOG SET RETURNCODE=-20002 WHERE LOG_ID=lt_audit_ddl_log.LOG_ID;
      COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
    END;
  RAISE;
WHEN OTHERS THEN
    BEGIN
      lt_audit_ddl_log.RETURNCODE := SQLCODE;
      UPDATE ZOEAUDIT.AUDIT_DDL_LOG SET RETURNCODE=lt_audit_ddl_log.RETURNCODE WHERE LOG_ID=lt_audit_ddl_log.LOG_ID;
      COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
    END;
    */
    RETURN 0;
END zoefun_aud_firewall;