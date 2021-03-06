/*==============================================================*/
/* Table: DVP_PROJ_DB_BASIC_INFO                                */
/*==============================================================*/
CREATE TABLE ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO 
(
   PROJECT_ID#          VARCHAR2(64)         NOT NULL,
   DB_ID                VARCHAR2(64)         NOT NULL,
   DB_NAME              VARCHAR2(64),
   DB_CHN_NAME          VARCHAR2(255 CHAR),
   SERVICE_NAME         VARCHAR2(64),
   IP_ADDRESS           VARCHAR2(64),
   PORT_NO              NUMBER,
   SERVER_NAME          VARCHAR2(64),
   SERVER_IP_ADDRESS#   VARCHAR2(64),
   DB_ROLE_ID#          VARCHAR2(64),
   DB_ROLE_NAME         VARCHAR2(255 CHAR),
   DB_DEPLOY_TYPE_ID#   VARCHAR2(64),
   DB_DEPLOY_TYPE_NAME  VARCHAR2(255 CHAR),
   DB_CREATED_TIME      DATE,
   DB_VERSION           VARCHAR2(128 CHAR),
   CREATOR_CODE         VARCHAR2(64),
   MEMO                 VARCHAR2(255 CHAR),
   CREATED_TIME         DATE,
   MODIFIER_CODE        VARCHAR2(64),
   MODIFIED_TIME        DATE,
   DISCARD_FLAG         VARCHAR2(1),
   CONSTRAINT PK_DVP_PROJ_DB_BASIC_INFO PRIMARY KEY (PROJECT_ID#, DB_ID)
         USING INDEX
);

COMMENT ON TABLE ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO IS
'项目数据库基本信息';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO.PROJECT_ID# IS
'项目ID';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO.DB_ID IS
'数据库ID';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO.DB_NAME IS
'数据库名';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO.DB_CHN_NAME IS
'数据库中文名';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO.SERVICE_NAME IS
'服务名';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO.IP_ADDRESS IS
'IP地址';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO.PORT_NO IS
'端口号';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO.SERVER_NAME IS
'系统服务器名';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO.SERVER_IP_ADDRESS# IS
'系统IP地址';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO.DB_ROLE_ID# IS
'数据库角色ID';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO.DB_ROLE_NAME IS
'数据库角色名称';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO.DB_DEPLOY_TYPE_ID# IS
'数据库部署类型ID';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO.DB_DEPLOY_TYPE_NAME IS
'数据库部署类型名称';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO.DB_CREATED_TIME IS
'数据库创建时间';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO.DB_VERSION IS
'数据库软件版本';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO.CREATOR_CODE IS
'创建人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO.MEMO IS
'备注';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO.CREATED_TIME IS
'创建时间';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO.MODIFIER_CODE IS
'修改人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO.MODIFIED_TIME IS
'修改时间';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_BASIC_INFO.DISCARD_FLAG IS
'丢弃标志#|{code:1,name:已停用}';
