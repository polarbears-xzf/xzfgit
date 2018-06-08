-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		create_table.sql
--	Description:
-- 		创建数据库归档系统相关表
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--

/*==============================================================*/
/* Table: ARC_APPLACTION_SYSTEM_DICT                            */
/*==============================================================*/
create table ZOEARCHIVE.ARC_APPLACTION_SYSTEM_DICT 
(
   SYSTEM_CODE          VARCHAR2(64),
   SYSTEM_NAME          VARCHAR2(64 CHAR)
);

comment on table ZOEARCHIVE.ARC_APPLACTION_SYSTEM_DICT is
'归档业务系统字典';

comment on column ZOEARCHIVE.ARC_APPLACTION_SYSTEM_DICT.SYSTEM_CODE is
'系统代码';

comment on column ZOEARCHIVE.ARC_APPLACTION_SYSTEM_DICT.SYSTEM_NAME is
'系统名称#|1 HIS 2 电子病历';

/*==============================================================*/
/* Table: ARC_DATA_TYPE_DICT                                    */
/*==============================================================*/
create table ZOEARCHIVE.ARC_DATA_TYPE_DICT 
(
   DATE_TYPE_CODE       VARCHAR2(64)         not null,
   DATE_TYPE_NAME       VARCHAR2(64 CHAR),
   constraint PK_ARC_DATA_TYPE_DICT primary key (DATE_TYPE_CODE)
         using index
);

comment on table ZOEARCHIVE.ARC_DATA_TYPE_DICT is
'归档数据类型字典';

comment on column ZOEARCHIVE.ARC_DATA_TYPE_DICT.DATE_TYPE_CODE is
'数据类型代码';

comment on column ZOEARCHIVE.ARC_DATA_TYPE_DICT.DATE_TYPE_NAME is
'数据类型名称#|1 日志数据 2 业务数据 ';

/*==============================================================*/
/* Table: ARC_OBJECT_INFO                                       */
/*==============================================================*/
create table ZOEARCHIVE.ARC_OBJECT_INFO 
(
   OWNER                VARCHAR2(64 CHAR)    not null,
   OBJECT_NAME          VARCHAR2(64 CHAR)    not null,
   APPLICATION_SYSTEM_CODE VARCHAR2(64),
   DATA_TYPE_CODE       VARCHAR2(64)         not null,
   PROOF_CODE           VARCHAR2(64 CHAR),
   constraint PK_ARC_OBJECT_INFO primary key (OWNER, OBJECT_NAME)
         using index
);

comment on table ZOEARCHIVE.ARC_OBJECT_INFO is
'归档对象信息';

comment on column ZOEARCHIVE.ARC_OBJECT_INFO.OWNER is
'对象所有者';

comment on column ZOEARCHIVE.ARC_OBJECT_INFO.OBJECT_NAME is
'对象名称';

comment on column ZOEARCHIVE.ARC_OBJECT_INFO.APPLICATION_SYSTEM_CODE is
'业务系统代码#|ARC_APPLACTION_SYSTEM_DICT';

comment on column ZOEARCHIVE.ARC_OBJECT_INFO.DATA_TYPE_CODE is
'数据类型代码#|ARC_DATA_TYPE_DICT';

comment on column ZOEARCHIVE.ARC_OBJECT_INFO.PROOF_CODE is
'校验码';


