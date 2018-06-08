-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		load_data.sql
--	Description:
-- 		加载数据库归档系统相关表数据
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--

/*==============================================================*/
/* Table: ARC_APPLACTION_SYSTEM_DICT                            */
/*==============================================================*/
Insert into ARC_APPLACTION_SYSTEM_DICT (SYSTEM_CODE,SYSTEM_NAME) values ('1','HIS');
Insert into ARC_APPLACTION_SYSTEM_DICT (SYSTEM_CODE,SYSTEM_NAME) values ('2','电子病历');

/*==============================================================*/
/* Table: ARC_DATA_TYPE_DICT                                    */
/*==============================================================*/
Insert into ARC_DATA_TYPE_DICT (DATE_TYPE_CODE,DATE_TYPE_NAME) values ('1','日志数据');
Insert into ARC_DATA_TYPE_DICT (DATE_TYPE_CODE,DATE_TYPE_NAME) values ('2','业务数据');

/*==============================================================*/
/* Table: ARC_OBJECT_PROCESS_CONFIG                             */
/*==============================================================*/


