-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		create_ops_table.sql
--	Description:
-- 		创建运维相关表
--  Relation:
--      zoeUtility
--	Notes:
--		
--	修改 - （年-月-日） - 描述
--

/*==============================================================*/
/* Table: DVP_PROJECT_BASIC_INFO                                */
/*==============================================================*/
CREATE TABLE ZOEDEVOPS.DVP_PROJECT_BASIC_INFO 
(
   PROJECT_ID           VARCHAR2(64)         NOT NULL,
   PROJECT_NAME         VARCHAR2(255),
   CREATOR_CODE         VARCHAR2(64),
   CREATED_TIME         DATE,
   MODIFIER_CODE        VARCHAR2(64),
   MODIFIED_TIME        DATE,
   CONSTRAINT PK_DVP_PROJECT_BASIC_INFO PRIMARY KEY (PROJECT_ID)
);

COMMENT ON TABLE ZOEDEVOPS.DVP_PROJECT_BASIC_INFO IS
'项目基本信息';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJECT_BASIC_INFO.PROJECT_ID IS
'项目ID';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJECT_BASIC_INFO.PROJECT_NAME IS
'项目名称';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJECT_BASIC_INFO.CREATOR_CODE IS
'创建人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJECT_BASIC_INFO.CREATED_TIME IS
'创建时间';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJECT_BASIC_INFO.MODIFIER_CODE IS
'修改人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJECT_BASIC_INFO.MODIFIED_TIME IS
'修改时间';



