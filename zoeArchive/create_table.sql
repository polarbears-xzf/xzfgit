/*
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
*/
/*==============================================================*/
/* Table: ARC_APPLACTION_SYSTEM_DICT                            */
/*==============================================================*/
create table ZOEARCHIVE.ARC_APPLACTION_SYSTEM_DICT 
(
   SYSTEM_CODE          VARCHAR2(64)         not null,
   SYSTEM_NAME          VARCHAR2(64 CHAR),
   constraint PK_ARC_APPLACTION_SYSTEM_DICT primary key (SYSTEM_CODE)
         using index
);

comment on table ZOEARCHIVE.ARC_APPLACTION_SYSTEM_DICT is
'归档业务系统字典';

comment on column ZOEARCHIVE.ARC_APPLACTION_SYSTEM_DICT.SYSTEM_CODE is
'系统代码';

comment on column ZOEARCHIVE.ARC_APPLACTION_SYSTEM_DICT.SYSTEM_NAME is
'系统名称#|1 HIS 2 电子病历';


/*==============================================================*/
/* Table: ARC_OBJECT_INFO                                       */
/*==============================================================*/
create table ZOEARCHIVE.ARC_OBJECT_INFO 
(
   OWNER                VARCHAR2(64 CHAR)    not null,
   TABLE_NAME           VARCHAR2(64 CHAR)    not null,
   TABLE_CHN_NAME       VARCHAR2(64 CHAR),
   APPLICATION_SYSTEM_CODE VARCHAR2(64),
   DATA_TYPE_CODE       VARCHAR2(64)         not null,
   PROOF_CODE           VARCHAR2(64 CHAR),
   constraint PK_ARC_OBJECT_INFO primary key (OWNER, TABLE_NAME)
         using index
);

comment on table ZOEARCHIVE.ARC_OBJECT_INFO is
'归档对象信息';

comment on column ZOEARCHIVE.ARC_OBJECT_INFO.OWNER is
'对象所有者';

comment on column ZOEARCHIVE.ARC_OBJECT_INFO.TABLE_NAME is
'对象名称';

comment on column ZOEARCHIVE.ARC_OBJECT_INFO.TABLE_CHN_NAME is
'表中文名';

comment on column ZOEARCHIVE.ARC_OBJECT_INFO.APPLICATION_SYSTEM_CODE is
'业务系统代码#|ARC_APPLACTION_SYSTEM_DICT';

comment on column ZOEARCHIVE.ARC_OBJECT_INFO.DATA_TYPE_CODE is
'数据类型代码#|ARC_DATA_TYPE_DICT';

comment on column ZOEARCHIVE.ARC_OBJECT_INFO.PROOF_CODE is
'校验码';


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
/* Table: ARC_PROCESS_TASK                                      */
/*==============================================================*/
create table ZOEARCHIVE.ARC_PROCESS_TASK 
(
   TASK_ID              NUMBER               not null,
   TASK_NAME            VARCHAR2(64 CHAR),
   TASK_DESC            VARCHAR2(64 CHAR),
   constraint PK_ARC_PROCESS_TASK primary key (TASK_ID)
         using index
);

comment on table ZOEARCHIVE.ARC_PROCESS_TASK is
'归档处理任务';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK.TASK_ID is
'任务ID';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK.TASK_NAME is
'任务名称';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK.TASK_DESC is
'任务描述';

/*==============================================================*/
/* Table: ARC_PROCESS_TASK_PARAM                                */
/*==============================================================*/
create table ZOEARCHIVE.ARC_PROCESS_TASK_PARAM 
(
   TASK_ID              VARCHAR2(64 CHAR)    not null,
   PARAM_NAME           VARCHAR2(64 CHAR)    not null,
   PARAM_VALUE          VARCHAR2(64 CHAR),
   MEMO                 VARCHAR2(64 CHAR),
   constraint PK_ARC_PROCESS_TASK_PARAM primary key (TASK_ID, PARAM_NAME)
         using index
);

comment on table ZOEARCHIVE.ARC_PROCESS_TASK_PARAM is
'归档处理任务参数';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_PARAM.TASK_ID is
'任务ID';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_PARAM.PARAM_NAME is
'参数名';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_PARAM.PARAM_VALUE is
'参数值';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_PARAM.MEMO is
'备注';

/*==============================================================*/
/* Table: ARC_PROCESS_TASK_DATA_KEY                             */
/*==============================================================*/
create table ZOEARCHIVE.ARC_PROCESS_TASK_DATA_KEY 
(
   TASK_ID              NUMBER               not null,
   KEY_SEQ              VARCHAR2(64)         not null,
   KEY_NAME             VARCHAR2(64),
   constraint PK_ARC_PROCESS_TASK_DATA_KEY primary key (TASK_ID, KEY_SEQ)
         using index
);

comment on table ZOEARCHIVE.ARC_PROCESS_TASK_DATA_KEY is
'归档处理数据映射键';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_DATA_KEY.TASK_ID is
'任务ID';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_DATA_KEY.KEY_SEQ is
'键值序号';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_DATA_KEY.KEY_NAME is
'键值名';

/*==============================================================*/
/* Table: ARC_PROCESS_TASK_DATA_CACHE                           */
/*==============================================================*/
create table ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE 
(
   SEQ_NO               NUMBER               not null,
   TASK_ID              NUMBER               not null,
   ARCHIVE_DATE         DATE                 not null,
   ARCHIVE_CONDITION_VALUE1 VARCHAR2(64 CHAR)    not null,
   ARCHIVE_CONDITION_VALUE2 VARCHAR2(64 CHAR)    not null,
   ARCHIVE_CONDITION_VALUE3 VARCHAR2(64 CHAR),
   constraint PK_ARC_PROCESS_TASK_DATA_CACHE primary key (SEQ_NO)
         using index
);

comment on table ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE is
'归档处理任务数据缓存';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE.SEQ_NO is
'归档处理流水号';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE.TASK_ID is
'任务ID';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE.ARCHIVE_DATE is
'归档日期';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE.ARCHIVE_CONDITION_VALUE1 is
'归档条件值1';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE.ARCHIVE_CONDITION_VALUE2 is
'归档条件值2';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_DATA_CACHE.ARCHIVE_CONDITION_VALUE3 is
'归档条件值3';

/*==============================================================*/
/* Table: ARC_PROCESS_TASK_DATA_RECORD                          */
/*==============================================================*/
create table ZOEARCHIVE.ARC_PROCESS_TASK_DATA_RECORD 
(
   SEQ_NO               NUMBER               not null,
   TASK_ID              NUMBER               not null,
   ARCHIVE_DATE         DATE                 not null,
   ARCHIVE_CONDITION_VALUE1 VARCHAR2(64 CHAR)    not null,
   ARCHIVE_CONDITION_VALUE2 VARCHAR2(64 CHAR)    not null,
   ARCHIVE_CONDITION_VALUE3 VARCHAR2(64 CHAR),
   constraint PK_ARC_PROCESS_TASK_DATA_RECOR primary key (SEQ_NO)
         using index
);

comment on table ZOEARCHIVE.ARC_PROCESS_TASK_DATA_RECORD is
'归档处理任务数据记录';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_DATA_RECORD.SEQ_NO is
'归档处理流水号';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_DATA_RECORD.TASK_ID is
'任务ID';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_DATA_RECORD.ARCHIVE_DATE is
'归档日期';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_DATA_RECORD.ARCHIVE_CONDITION_VALUE1 is
'归档条件值1';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_DATA_RECORD.ARCHIVE_CONDITION_VALUE2 is
'归档条件值2';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_DATA_RECORD.ARCHIVE_CONDITION_VALUE3 is
'归档条件值3';

/*==============================================================*/
/* Table: ARC_PROCESS_TASK_RECORD                               */
/*==============================================================*/
create table ZOEARCHIVE.ARC_PROCESS_TASK_RECORD 
(
   TASK_ID              NUMBER               not null,
   ARCHIVE_DATE         DATE                 not null,
   PROCESS_ORDER        NUMBER               not null,
   TABLE_OWNER          VARCHAR2(64),
   TABLE_NAME           VARCHAR2(64),
   INSERT_START_TIME    DATE,
   INSERT_END_TIME      DATE,
   INSERT_COUNT         NUMBER,
   INSERT_COMPLETED_FLAG VARCHAR2(1),
   DELETE_START_TIME    DATE,
   DELETE_END_TIME      DATE,
   DELETE_COUNT         NUMBER,
   DELETE_COMPLETED_FLAG VARCHAR2(1),
   INSERT_SQL           VARCHAR2(4000),
   DELETE_SQL           VARCHAR2(4000),
   constraint PK_ARC_PROCESS_TASK_RECORD primary key (TASK_ID, ARCHIVE_DATE, PROCESS_ORDER)
         using index
);

comment on table ZOEARCHIVE.ARC_PROCESS_TASK_RECORD is
'归档处理任务记录';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_RECORD.TASK_ID is
'任务ID';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_RECORD.ARCHIVE_DATE is
'归档日期';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_RECORD.PROCESS_ORDER is
'归档处理次序';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_RECORD.TABLE_OWNER is
'归档表所有者';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_RECORD.TABLE_NAME is
'归档表名';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_RECORD.INSERT_START_TIME is
'抽取开始时间';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_RECORD.INSERT_END_TIME is
'抽取结束时间';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_RECORD.INSERT_COUNT is
'抽取处理记录数';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_RECORD.INSERT_COMPLETED_FLAG is
'抽取完成标志';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_RECORD.DELETE_START_TIME is
'删除开始时间';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_RECORD.DELETE_END_TIME is
'删除结束时间';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_RECORD.DELETE_COUNT is
'删除处理记录数';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_RECORD.DELETE_COMPLETED_FLAG is
'删除完成标志';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_RECORD.INSERT_SQL is
'抽取SQL';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_RECORD.DELETE_SQL is
'删除SQL';


/*==============================================================*/
/* Table: ARC_PROCESS_TASK_CONFIG                               */
/*==============================================================*/
create table ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG 
(
   TASK_ID              NUMBER               not null,
   TABLE_OWNER          VARCHAR2(64)         not null,
   TABLE_NAME           VARCHAR2(64)         not null,
   ARCHIVE_TABLE_OWNER  VARCHAR2(64),
   ARCHIVE_TABLE_NAME   VARCHAR2(64),
   ARCHIVE_DB_LINK      VARCHAR2(64),
   DETAIL_TABLE_FLAG    VARCHAR2(1),
   RELATE_MASTER_TABLE_NAME VARCHAR2(64),
   RELATE_MASTER_TABLE_COLUMN VARCHAR2(64),
   RELATE_DETAIL_TABLE_COLUMN VARCHAR2(64),
   ARCHIVE_DATE_COLUMN  VARCHAR2(64),
   ARCHIVE_CONDITION_C1 VARCHAR2(64),
   ARCHIVE_TABLE_C1     VARCHAR2(64),
   ARCHIVE_CONDITION_C2 VARCHAR2(64),
   ARCHIVE_TABLE_C2     VARCHAR2(64),
   PROCESS_ORDER        NUMBER,
   constraint PK_ARC_PROCESS_TASK_CONFIG primary key (TASK_ID, TABLE_OWNER, TABLE_NAME)
         using index
);

comment on table ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG is
'归档处理任务配置';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG.TASK_ID is
'任务ID';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG.TABLE_OWNER is
'归档源表所有者';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG.TABLE_NAME is
'归档源表名';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG.ARCHIVE_TABLE_OWNER is
'归档目标表所有者';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG.ARCHIVE_TABLE_NAME is
'归档目标表名';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG.ARCHIVE_DB_LINK is
'归档目标数据库链路';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG.DETAIL_TABLE_FLAG is
'细表标志';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG.RELATE_MASTER_TABLE_NAME is
'关联主表名';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG.RELATE_MASTER_TABLE_COLUMN is
'主表关联列';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG.RELATE_DETAIL_TABLE_COLUMN is
'细表表关联列';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG.ARCHIVE_DATE_COLUMN is
'归档日期列';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG.ARCHIVE_CONDITION_C1 is
'归档条件列1';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG.ARCHIVE_TABLE_C1 is
'归档表对应列1';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG.ARCHIVE_CONDITION_C2 is
'归档条件列2';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG.ARCHIVE_TABLE_C2 is
'归档表对应列2';

comment on column ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG.PROCESS_ORDER is
'处理顺序';


