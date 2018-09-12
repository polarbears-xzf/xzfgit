CREATE OR REPLACE TRIGGER ZOESECURITY.ZOETRG_AUD_DDL_BEFORE 
BEFORE DDL 
ON DATABASE DISABLE
-- Created in 2017.12.15 by polarbears
-- Copyright (c) 2018, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoetri_aud_ddl_before.pls
--	Description:
-- 		审计和控制DDL操作
--  Relation:
--    包： ZOEPKG_AUDIT_SET_CONTEXT.SET_AUDIT_CONTEXT
--    函数： ZOEFUN_AUD_GET_SQL,ZOEFUN_AUD_FIREWALL,ZOEFUN_AUD_GET_SESSION_CONTEXT
--    自定义类型： ZOETYP_AUDIT_LOG,ZOETYP_AUD_SESSION_CONTEXT
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
DECLARE 
  lt_audit_ddl_log                   ZOETYP_AUD_LOG;            --审计DDL日志记录数据结构
  lt_aud_session_context             ZOETYP_AUD_SESSION_CONTEXT;      --会话上下文数据结构
  lt_zoetyp_aud_firewall             ZOETYP_AUD_FIREWALL;              --访问控制元素
  ln_aud_session_context             number;                          --会话上下文函数返回值，0：成功
  ln_zoefun_aud_ins_aud_ddl_record    number;                          --记录DDL审计日志函数返回值，0：成功
  ln_zoefun_aud_firewall             number;                          --DDL访问控制函数返回值，0：成功
  ln_zoefun_aud_upd_aud_ddl_record    number;                          --更新DDL审计日志函数返回值，0：成功
  lv_returncode          NUMBER;
  DDL_EXCEPTION EXCEPTION;
  PRAGMA EXCEPTION_INIT(DDL_EXCEPTION, -20001);
BEGIN 
  --初始化对象类型 
  lt_audit_ddl_log := ZOETYP_AUD_LOG(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
  lt_aud_session_context := ZOETYP_AUD_SESSION_CONTEXT(null,null,null,null,null,null);
  --获取会话上下文
  ln_aud_session_context := ZOEFUN_AUD_GET_SESSION_CONTEXT(lt_aud_session_context);
  --设置DDL记录值
  lt_audit_ddl_log.LOG_ID           := 'AUDDDL#|'||SYS_GUID();                             --审计日志表主键
  --使用上下文记录审计日志ID
  ZOEPKG_AUD_SET_CONTEXT.SET_AUD_CONTEXT('AUDIT_DDL_LOG_ID',lt_audit_ddl_log.LOG_ID);   
  lt_audit_ddl_log.SQL_TEXT         := zoefun_aud_get_sql();                   --获取DDL语句文本
  lt_audit_ddl_log.USERNAME         := lt_aud_session_context.USERNAME;        --数据库登录用户名
  lt_audit_ddl_log.OS_USERNAME      := lt_aud_session_context.OS_USERNAME;     --操作系统登录用户名
  lt_audit_ddl_log.HOST             := lt_aud_session_context.HOST;            --操作系统主机名
  lt_audit_ddl_log.TERMINAL         := lt_aud_session_context.TERMINAL;        --登录终端
  lt_audit_ddl_log.IP_ADDRESS       := lt_aud_session_context.IP_ADDRESS;      --操作系统IP地址
  lt_audit_ddl_log.CURRENT_USER     := lt_aud_session_context.CURRENT_USER;    --数据库当前SCHEME
  lt_audit_ddl_log.OBJECT_OWNER     := ora_dict_obj_owner;                     --数据库对象所有者
  lt_audit_ddl_log.OBJECT_NAME      := ora_dict_obj_name;                      --数据库对象名称
  lt_audit_ddl_log.OBJECT_TYPE      := ora_dict_obj_type;                      --数据库对象类型
  lt_audit_ddl_log.OPERATION_TYPE   := ora_sysevent;                           --DDL操作类型
  lt_audit_ddl_log.OPERATION_TIME   := SYSDATE;                                --操作时间
  IF lt_audit_ddl_log.SQL_TEXT='ERR.zoefun_aud_get_sql' THEN                   --操作状态
    lt_audit_ddl_log.RETURNCODE     := -1;
  ELSE
    lt_audit_ddl_log.RETURNCODE     := SQLCODE;
  END IF;
  --记录审计DDL日志，排除TRUNCATE审计日志表本身，防止死锁。
  IF lt_audit_ddl_log.OPERATION_TYPE = 'TRUNCATE' AND lt_audit_ddl_log.OBJECT_NAME = 'AUD_DDL_RECORD' THEN
    RAISE_APPLICATION_ERROR(-20001, 'TRUNCATE审计记录表被拒绝');
  ELSE 
    ln_zoefun_aud_ins_aud_ddl_record := zoefun_aud_ins_aud_ddl_record(lt_audit_ddl_log);
  END IF ;
  --DDL访问控制
  ln_zoefun_aud_firewall := zoefun_aud_firewall(lt_zoetyp_aud_firewall);
  --根据访问控制返回值更新DDL操作状态
  IF ln_zoefun_aud_firewall = 0 THEN
    NULL;
  ELSE
    ln_zoefun_aud_upd_aud_ddl_record := ZOEFUN_AUD_UPD_AUD_DDL_RECORD(lt_audit_ddl_log.LOG_ID,ln_zoefun_aud_firewall);
  END IF;
EXCEPTION 
WHEN DDL_EXCEPTION THEN
  DBMS_OUTPUT.PUT_LINE('ZOESECURITY.ZOETRG_AUD_DDL_BEFORE:'||SQLERRM);
  RAISE;
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('ZOESECURITY.ZOETRG_AUD_DDL_BEFORE:'||SQLERRM);
  NULL;
END;