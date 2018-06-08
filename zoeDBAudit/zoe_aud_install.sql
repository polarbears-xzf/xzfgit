-- Created in 2017.10.10 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoe_aud_install.sql
--	Description:
-- 		安装智业安全审计系统数据库部件
--  Relation:
--      
--	Notes:
--		使用zoesecurity用户连接创建
--	修改 - （年-月-日） - 描述
--  

--根据需要设置创建审计对象当前用户
--ALTER SESSION SET CURRENT_SCHEMA=ZOESECURITY;

--创建表
--审计日志记录
@@zoe_aud_create_table.sql

--创建自定义数据库类型
--类型：会话上下文记录信息   "zoetyp_aud_session_context"
--类型：DDL审计日志记录      "zoetyp_audit_log"
--类型：安全访问控制要素     "zoetyp_aud_firewall_factor"
@@zoe_aud_create_type.sql


--创建上下文
--上下文：审计相关           "ZOE_AUDIT_CONTEXT"
@@zoe_aud_create_context.sql

--创建上下文关联包
--关联包：审计相关
@@zoepkg_audit_set_context.pks
@@zoepkg_audit_set_context.pkb

--创建函数
--审计访问控制               "zoefun_aud_firewall"
@@zoefun_aud_firewall.pls
--获取会话上下文             "zoefun_aud_get_session_context"
@@zoefun_aud_get_session_context.pls
--获取当前执行SQL            "zoefun_aud_get_sql"
@@zoefun_aud_get_sql.pls
--记录审计日志
@@zoefun_aud_ins_audit_log.pls
--更新审计日志
@@zoefun_aud_upd_audit_log.pls


--创建触发器
--触发器：审计并控制DDL语句  "ZOETRG_AUD_DDL_BEFORE" 
@@zoetrg_aud_ddl_before.pls