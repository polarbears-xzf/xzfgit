/*==============================================================*/
/* Table: DVP_PROVINCE$                                         */
/*==============================================================*/
CREATE TABLE ZOEDEVOPS.DVP_PROVINCE$ 
(
   PROVINCE_CODE        VARCHAR2(64)         NOT NULL,
   PROVINCE_NAME        VARCHAR2(255 CHAR),
   PRIORITY             VARCHAR2(64),
   SPELL_CODE           VARCHAR2(255 CHAR),
   WBZX_CODE            VARCHAR2(255 CHAR),
   CREATOR_CODE         VARCHAR2(64),
   CREATED_TIME         DATE,
   MODIFIER_CODE        VARCHAR2(64),
   MODIFIED_TIME        DATE,
   MEMO                 VARCHAR2(255 CHAR),
   CONSTRAINT PK_DVP_PROVINCE$ PRIMARY KEY (PROVINCE_CODE)
         USING INDEX
);

COMMENT ON TABLE ZOEDEVOPS.DVP_PROVINCE$ IS
'省份字典';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROVINCE$.PROVINCE_CODE IS
'省份代码';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROVINCE$.PROVINCE_NAME IS
'省份名称';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROVINCE$.PRIORITY IS
'级别';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROVINCE$.SPELL_CODE IS
'拼音码';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROVINCE$.WBZX_CODE IS
'五笔码';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROVINCE$.CREATOR_CODE IS
'创建人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROVINCE$.CREATED_TIME IS
'创建时间';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROVINCE$.MODIFIER_CODE IS
'修改人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROVINCE$.MODIFIED_TIME IS
'修改时间';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROVINCE$.MEMO IS
'备注';

/*==============================================================*/
/* Table: DVP_DB_ROLE$                                          */
/*==============================================================*/
CREATE TABLE ZOEDEVOPS.DVP_DB_ROLE$ 
(
   ROLE_ID              VARCHAR2(64)         NOT NULL,
   ROLE_NAME            VARCHAR2(255),
   CREATOR_CODE         VARCHAR2(64),
   CREATED_TIME         DATE,
   MODIFIER_CODE        VARCHAR2(64),
   MODIFIED_TIME        DATE,
   CONSTRAINT PK_DVP_DB_ROLE$ PRIMARY KEY (ROLE_ID)
         USING INDEX
);

COMMENT ON TABLE ZOEDEVOPS.DVP_DB_ROLE$ IS
'数据库角色字典';

COMMENT ON COLUMN ZOEDEVOPS.DVP_DB_ROLE$.ROLE_ID IS
'角色ID';

COMMENT ON COLUMN ZOEDEVOPS.DVP_DB_ROLE$.ROLE_NAME IS
'角色名称';

COMMENT ON COLUMN ZOEDEVOPS.DVP_DB_ROLE$.CREATOR_CODE IS
'创建人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_DB_ROLE$.CREATED_TIME IS
'创建时间';

COMMENT ON COLUMN ZOEDEVOPS.DVP_DB_ROLE$.MODIFIER_CODE IS
'修改人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_DB_ROLE$.MODIFIED_TIME IS
'修改时间';


/*==============================================================*/
/* Table: DVP_DB_DEPLOY_TYPE$                                   */
/*==============================================================*/
CREATE TABLE ZOEDEVOPS.DVP_DB_DEPLOY_TYPE$ 
(
   TYPE_ID              VARCHAR2(64)         NOT NULL,
   TYPE_NAME            VARCHAR2(255),
   CREATOR_CODE         VARCHAR2(64),
   CREATED_TIME         DATE,
   MODIFIER_CODE        VARCHAR2(64),
   MODIFIED_TIME        DATE,
   CONSTRAINT PK_DVP_DB_DEPLOY_TYPE$ PRIMARY KEY (TYPE_ID)
         USING INDEX
);

COMMENT ON TABLE ZOEDEVOPS.DVP_DB_DEPLOY_TYPE$ IS
'数据库部署类型字典';

COMMENT ON COLUMN ZOEDEVOPS.DVP_DB_DEPLOY_TYPE$.TYPE_ID IS
'部署类型ID';

COMMENT ON COLUMN ZOEDEVOPS.DVP_DB_DEPLOY_TYPE$.TYPE_NAME IS
'部署类型名称';

COMMENT ON COLUMN ZOEDEVOPS.DVP_DB_DEPLOY_TYPE$.CREATOR_CODE IS
'创建人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_DB_DEPLOY_TYPE$.CREATED_TIME IS
'创建时间';

COMMENT ON COLUMN ZOEDEVOPS.DVP_DB_DEPLOY_TYPE$.MODIFIER_CODE IS
'修改人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_DB_DEPLOY_TYPE$.MODIFIED_TIME IS
'修改时间';


/*==============================================================*/
/* Table: DVP_PROJ_BASIC_INFO                                   */
/*==============================================================*/
CREATE TABLE ZOEDEVOPS.DVP_PROJ_BASIC_INFO 
(
   PROJECT_ID           VARCHAR2(64)         NOT NULL,
   PROJECT_NAME         VARCHAR2(255 CHAR),
   PROVINCE_CODE#       VARCHAR2(64),
   CITY_CODE#           VARCHAR2(64),
   CREATOR_CODE         VARCHAR2(64),
   CREATED_TIME         DATE,
   MODIFIER_CODE        VARCHAR2(64),
   MODIFIED_TIME        DATE,
   CONSTRAINT PK_DVP_PROJ_BASIC_INFO PRIMARY KEY (PROJECT_ID)
         USING INDEX
);

COMMENT ON TABLE ZOEDEVOPS.DVP_PROJ_BASIC_INFO IS
'项目基本信息';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_BASIC_INFO.PROJECT_ID IS
'项目ID';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_BASIC_INFO.PROJECT_NAME IS
'项目名称';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_BASIC_INFO.PROVINCE_CODE# IS
'省#|DVP_PROVINCE_DICT';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_BASIC_INFO.CITY_CODE# IS
'市#|DVP_PROVINCE_DICT';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_BASIC_INFO.CREATOR_CODE IS
'创建人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_BASIC_INFO.CREATED_TIME IS
'创建时间';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_BASIC_INFO.MODIFIER_CODE IS
'修改人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_BASIC_INFO.MODIFIED_TIME IS
'修改时间';


/*==============================================================*/
/* Table: DVP_USER_BASIC_INFO                                   */
/*==============================================================*/
CREATE TABLE ZOEDEVOPS.DVP_USER_BASIC_INFO 
(
   PROJECT_ID#          VARCHAR2(64)         NOT NULL,
   USER_ID              VARCHAR2(64)         NOT NULL,
   USER_NAME            VARCHAR2(255 CHAR),
   USER_PASSWORD        VARCHAR2(64),
   ACCOUNT_STATUS       VARCHAR2(3),
   CREATOR_CODE         VARCHAR2(64),
   CREATED_TIME         DATE,
   MODIFIER_CODE        VARCHAR2(64),
   MODIFIED_TIME        DATE,
   CONSTRAINT PK_DVP_USER_BASIC_INFO PRIMARY KEY (PROJECT_ID#, USER_ID)
         USING INDEX
);

COMMENT ON TABLE ZOEDEVOPS.DVP_USER_BASIC_INFO IS
'用户基本信息';

COMMENT ON COLUMN ZOEDEVOPS.DVP_USER_BASIC_INFO.PROJECT_ID# IS
'项目ID';

COMMENT ON COLUMN ZOEDEVOPS.DVP_USER_BASIC_INFO.USER_ID IS
'用户ID';

COMMENT ON COLUMN ZOEDEVOPS.DVP_USER_BASIC_INFO.USER_NAME IS
'用户姓名';

COMMENT ON COLUMN ZOEDEVOPS.DVP_USER_BASIC_INFO.USER_PASSWORD IS
'用户密码';

COMMENT ON COLUMN ZOEDEVOPS.DVP_USER_BASIC_INFO.ACCOUNT_STATUS IS
'账号状态';

COMMENT ON COLUMN ZOEDEVOPS.DVP_USER_BASIC_INFO.CREATOR_CODE IS
'创建人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_USER_BASIC_INFO.CREATED_TIME IS
'创建时间';

COMMENT ON COLUMN ZOEDEVOPS.DVP_USER_BASIC_INFO.MODIFIER_CODE IS
'修改人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_USER_BASIC_INFO.MODIFIED_TIME IS
'修改时间';


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


/*==============================================================*/
/* Table: DVP_PROJ_SERVER_BASIC_INFO                            */
/*==============================================================*/
CREATE TABLE ZOEDEVOPS.DVP_PROJ_SERVER_BASIC_INFO 
(
   PROJECT_ID#          VARCHAR2(64)         NOT NULL,
   SERVER_IP_ADDRESS    VARCHAR2(64)         NOT NULL,
   SERVER_NAME          VARCHAR2(64),
   SERVER_CHN_NAME      VARCHAR2(255 CHAR),
   OS_NAME              VARCHAR2(64),
   OS_VERSION           VARCHAR2(64),
   CREATOR_CODE         VARCHAR2(64),
   CREATED_TIME         DATE,
   MODIFIER_CODE        VARCHAR2(64),
   MODIFIED_TIME        DATE,
   CONSTRAINT PK_DVP_PROJ_SERVER_BASIC_INFO PRIMARY KEY (PROJECT_ID#, SERVER_IP_ADDRESS)
         USING INDEX
);

COMMENT ON TABLE ZOEDEVOPS.DVP_PROJ_SERVER_BASIC_INFO IS
'项目服务器基本信息';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_SERVER_BASIC_INFO.PROJECT_ID# IS
'项目ID';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_SERVER_BASIC_INFO.SERVER_IP_ADDRESS IS
'服务器IP地址';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_SERVER_BASIC_INFO.SERVER_NAME IS
'服务器名称';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_SERVER_BASIC_INFO.SERVER_CHN_NAME IS
'服务器中文名称';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_SERVER_BASIC_INFO.OS_NAME IS
'操作系统产品名';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_SERVER_BASIC_INFO.OS_VERSION IS
'操作系统版本';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_SERVER_BASIC_INFO.CREATOR_CODE IS
'创建人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_SERVER_BASIC_INFO.CREATED_TIME IS
'创建时间';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_SERVER_BASIC_INFO.MODIFIER_CODE IS
'修改人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_SERVER_BASIC_INFO.MODIFIED_TIME IS
'修改时间';


/*==============================================================*/
/* Table: DVP_PROJ_CONTRACT_BASIC_INFO                          */
/*==============================================================*/
CREATE TABLE ZOEDEVOPS.DVP_PROJ_CONTRACT_BASIC_INFO 
(
   PROJECT_ID#          VARCHAR2(64)         NOT NULL,
   CONTRACT_ID          VARCHAR2(64)         NOT NULL,
   CONTRACT_NAME        VARCHAR2(255 CHAR),
   CONTRACT_TYPE        VARCHAR2(255 CHAR),
   SIGNING_DATE         DATE,
   SIGNER               VARCHAR2(64),
   CONTRACT_AMOUNT      NUMBER(15,4),
   DB_SERVICE_AMOUNT    NUMBER(15,4),
   SERVICE_BEGIN_DATE   DATE,
   SERVICE_END_DATE     DATE,
   SERVICE_CONTENT      VARCHAR2(400 CHAR),
   CREATOR_CODE         VARCHAR2(64),
   CREATED_TIME         DATE,
   MODIFIER_CODE        VARCHAR2(64),
   MODIFIED_TIME        DATE,
   CONSTRAINT PK_DVP_PROJ_CONTRACT_BASIC_INF PRIMARY KEY (PROJECT_ID#, CONTRACT_ID)
         USING INDEX
);

COMMENT ON TABLE ZOEDEVOPS.DVP_PROJ_CONTRACT_BASIC_INFO IS
'项目服务器合同基本信息';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_BASIC_INFO.PROJECT_ID# IS
'项目ID';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_BASIC_INFO.CONTRACT_ID IS
'合同ID';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_BASIC_INFO.CONTRACT_NAME IS
'合同名称';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_BASIC_INFO.CONTRACT_TYPE IS
'合同类型#|数据库服务';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_BASIC_INFO.SIGNING_DATE IS
'签约时间';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_BASIC_INFO.SIGNER IS
'签约人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_BASIC_INFO.CONTRACT_AMOUNT IS
'合同金额';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_BASIC_INFO.DB_SERVICE_AMOUNT IS
'数据库服务金额';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_BASIC_INFO.SERVICE_BEGIN_DATE IS
'服务开始日期';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_BASIC_INFO.SERVICE_END_DATE IS
'服务截止日期';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_BASIC_INFO.SERVICE_CONTENT IS
'服务内容';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_BASIC_INFO.CREATOR_CODE IS
'创建人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_BASIC_INFO.CREATED_TIME IS
'创建时间';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_BASIC_INFO.MODIFIER_CODE IS
'修改人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_BASIC_INFO.MODIFIED_TIME IS
'修改时间';


/*==============================================================*/
/* Table: DVP_PROJECT_KEY                                       */
/*==============================================================*/
CREATE TABLE ZOEDEVOPS.DVP_PROJECT_KEY 
(
   PROJECT_ID#          VARCHAR2(64)         NOT NULL,
   KEY_TYPE             VARCHAR2(64)         NOT NULL,
   KEY_VALUE            VARCHAR2(255 CHAR),
   CREATOR_CODE         VARCHAR2(64),
   CREATED_TIME         DATE,
   MODIFIER_CODE        VARCHAR2(64),
   MODIFIED_TIME        DATE,
   CONSTRAINT PK_DVP_PROJECT_KEY PRIMARY KEY (PROJECT_ID#, KEY_TYPE)
         USING INDEX
);

COMMENT ON TABLE ZOEDEVOPS.DVP_PROJECT_KEY IS
'项目密钥';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJECT_KEY.PROJECT_ID# IS
'项目ID';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJECT_KEY.KEY_TYPE IS
'密钥类型';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJECT_KEY.KEY_VALUE IS
'密钥值';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJECT_KEY.CREATOR_CODE IS
'创建人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJECT_KEY.CREATED_TIME IS
'创建时间';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJECT_KEY.MODIFIER_CODE IS
'修改人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJECT_KEY.MODIFIED_TIME IS
'修改时间';


/*==============================================================*/
/* Table: DVP_PROJ_REMOTE_ADMIN_INFO                            */
/*==============================================================*/
CREATE TABLE ZOEDEVOPS.DVP_PROJ_REMOTE_ADMIN_INFO 
(
   PROJECT_ID#          VARCHAR2(64)         NOT NULL,
   REMOTE_SEQ           NUMBER               NOT NULL,
   REMOTE_MODE          VARCHAR2(64),
   REMOTE_TOOL          VARCHAR2(64),
   REMOTE_ID            VARCHAR2(64),
   REMOTE_USER          VARCHAR2(64),
   REMOTE_PASSWORD      VARCHAR2(64),
   CREATOR_CODE         VARCHAR2(64),
   CREATED_TIME         DATE,
   MODIFIER_CODE        VARCHAR2(64),
   MODIFIED_TIME        DATE,
   MEMO                 VARCHAR2(255 CHAR),
   CONSTRAINT PK_DVP_PROJ_REMOTE_ADMIN_INFO PRIMARY KEY (PROJECT_ID#, REMOTE_SEQ)
         USING INDEX
);

COMMENT ON TABLE ZOEDEVOPS.DVP_PROJ_REMOTE_ADMIN_INFO IS
'项目远程管理信息';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_REMOTE_ADMIN_INFO.PROJECT_ID# IS
'项目ID';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_REMOTE_ADMIN_INFO.REMOTE_SEQ IS
'远程管理路径';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_REMOTE_ADMIN_INFO.REMOTE_MODE IS
'远程模式#|VPN，远程协作，远程桌面，堡垒机';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_REMOTE_ADMIN_INFO.REMOTE_TOOL IS
'远程工具';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_REMOTE_ADMIN_INFO.REMOTE_ID IS
'远程ID';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_REMOTE_ADMIN_INFO.REMOTE_USER IS
'远程管理用户';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_REMOTE_ADMIN_INFO.REMOTE_PASSWORD IS
'远程管理密码';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_REMOTE_ADMIN_INFO.CREATOR_CODE IS
'创建人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_REMOTE_ADMIN_INFO.CREATED_TIME IS
'创建时间';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_REMOTE_ADMIN_INFO.MODIFIER_CODE IS
'修改人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_REMOTE_ADMIN_INFO.MODIFIED_TIME IS
'修改时间';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_REMOTE_ADMIN_INFO.MEMO IS
'备注';


/*==============================================================*/
/* Table: DVP_PROJ_DB_USER_ADMIN_INFO                           */
/*==============================================================*/
CREATE TABLE ZOEDEVOPS.DVP_PROJ_DB_USER_ADMIN_INFO 
(
   PROJECT_ID#          VARCHAR2(64)         NOT NULL,
   DB_ID#               VARCHAR2(64)         NOT NULL,
   USERNAME             VARCHAR2(64)         NOT NULL,
   USER_PASSWORD        VARCHAR2(64),
   CREATOR_CODE         VARCHAR2(64),
   CREATED_TIME         DATE,
   MODIFIER_CODE        VARCHAR2(64),
   MODIFIED_TIME        DATE,
   MEMO                 VARCHAR2(255 CHAR),
   CONSTRAINT PK_DVP_PROJ_DB_USER_ADMIN_INFO PRIMARY KEY (PROJECT_ID#, DB_ID#, USERNAME)
         USING INDEX
);

COMMENT ON TABLE ZOEDEVOPS.DVP_PROJ_DB_USER_ADMIN_INFO IS
'数据库用户信息';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_USER_ADMIN_INFO.PROJECT_ID# IS
'项目ID';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_USER_ADMIN_INFO.DB_ID# IS
'DB_ID';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_USER_ADMIN_INFO.USERNAME IS
'用户名';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_USER_ADMIN_INFO.USER_PASSWORD IS
'用户密码';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_USER_ADMIN_INFO.CREATOR_CODE IS
'创建人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_USER_ADMIN_INFO.CREATED_TIME IS
'创建时间';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_USER_ADMIN_INFO.MODIFIER_CODE IS
'修改人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_USER_ADMIN_INFO.MODIFIED_TIME IS
'修改时间';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_DB_USER_ADMIN_INFO.MEMO IS
'备注';

/*==============================================================*/
/* Table: DVP_PROJ_SERVER_ADMIN_INFO                            */
/*==============================================================*/
CREATE TABLE ZOEDEVOPS.DVP_PROJ_SERVER_ADMIN_INFO 
(
   PROJECT_ID#          VARCHAR2(64)         NOT NULL,
   SERVER_IP_ADDRESS    VARCHAR2(64)         NOT NULL,
   ADMIN_USER           VARCHAR2(64)         NOT NULL,
   ADMIN_PASSWORD       VARCHAR2(64),
   ADMIN_TOOL           VARCHAR2(64),
   CREATOR_CODE         VARCHAR2(64),
   CREATED_TIME         DATE,
   MODIFIER_CODE        VARCHAR2(64),
   MODIFIED_TIME        DATE,
   CONSTRAINT PK_DVP_PROJ_SERVER_ADMIN_INFO PRIMARY KEY (PROJECT_ID#, SERVER_IP_ADDRESS, ADMIN_USER)
         USING INDEX
);

COMMENT ON TABLE ZOEDEVOPS.DVP_PROJ_SERVER_ADMIN_INFO IS
'项目服务器管理信息';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_SERVER_ADMIN_INFO.PROJECT_ID# IS
'项目ID';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_SERVER_ADMIN_INFO.SERVER_IP_ADDRESS IS
'服务器IP地址';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_SERVER_ADMIN_INFO.ADMIN_USER IS
'管理用户';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_SERVER_ADMIN_INFO.ADMIN_PASSWORD IS
'管理密码';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_SERVER_ADMIN_INFO.ADMIN_TOOL IS
'管理工具#|MSDTC，SSH';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_SERVER_ADMIN_INFO.CREATOR_CODE IS
'创建人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_SERVER_ADMIN_INFO.CREATED_TIME IS
'创建时间';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_SERVER_ADMIN_INFO.MODIFIER_CODE IS
'修改人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_SERVER_ADMIN_INFO.MODIFIED_TIME IS
'修改时间';


/*==============================================================*/
/* Table: DVP_PROJ_NODE_DB_LINKS                                */
/*==============================================================*/
CREATE TABLE ZOEDEVOPS.DVP_PROJ_NODE_DB_LINKS 
(
   PROJECT_ID#          VARCHAR2(64)         NOT NULL,
   DB_ID#               VARCHAR2(64)         NOT NULL,
   DB_LINK_NAME         VARCHAR2(64)         NOT NULL,
   CONNECT_TO_USER      VARCHAR2(64),
   CREATOR_CODE         VARCHAR2(64),
   CREATED_TIME         DATE,
   MODIFIER_CODE        VARCHAR2(64),
   MODIFIED_TIME        DATE,
   CONSTRAINT PK_DVP_PROJ_NODE_DB_LINKS PRIMARY KEY (PROJECT_ID#, DB_ID#, DB_LINK_NAME)
         USING INDEX
);

COMMENT ON TABLE ZOEDEVOPS.DVP_PROJ_NODE_DB_LINKS IS
'项目节点数据库链路信息';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_NODE_DB_LINKS.PROJECT_ID# IS
'项目ID';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_NODE_DB_LINKS.DB_ID# IS
'数据库ID';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_NODE_DB_LINKS.DB_LINK_NAME IS
'数据库链路名';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_NODE_DB_LINKS.CONNECT_TO_USER IS
'连接用户';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_NODE_DB_LINKS.CREATOR_CODE IS
'创建人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_NODE_DB_LINKS.CREATED_TIME IS
'创建时间';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_NODE_DB_LINKS.MODIFIER_CODE IS
'修改人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_NODE_DB_LINKS.MODIFIED_TIME IS
'修改时间';


/*==============================================================*/
/* Table: DVP_PROJ_CONTRACT_PAYBACK                             */
/*==============================================================*/
CREATE TABLE ZOEDEVOPS.DVP_PROJ_CONTRACT_PAYBACK 
(
   PROJECT_ID#          VARCHAR2(64)         NOT NULL,
   CONTRACT_ID#         VARCHAR2(64)         NOT NULL,
   PAYBACK_NO           NUMBER               NOT NULL,
   CONTRACT_PAYBACK_DATE DATE,
   PAYBACK_DEPT         VARCHAR2(64),
   PAYBACK_OWNER        VARCHAR2(64),
   PAYBACK_AMOUNT       NUMBER,
   PAYBACK_CONDITION    VARCHAR2(400 CHAR),
   MARK_INVIOCE_FLAG    VARCHAR2(1),
   PAYBACK_DATE         DATE,
   CREATOR_CODE         VARCHAR2(64),
   CREATED_TIME         DATE,
   MODIFIER_CODE        VARCHAR2(64),
   MODIFIED_TIME        DATE,
   CONSTRAINT PK_DVP_PROJ_CONTRACT_PAYBACK PRIMARY KEY (PROJECT_ID#, CONTRACT_ID#, PAYBACK_NO)
         USING INDEX
);

COMMENT ON TABLE ZOEDEVOPS.DVP_PROJ_CONTRACT_PAYBACK IS
'项目服务器合同回款记录';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_PAYBACK.PROJECT_ID# IS
'项目ID';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_PAYBACK.CONTRACT_ID# IS
'合同ID';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_PAYBACK.PAYBACK_NO IS
'回款序号';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_PAYBACK.CONTRACT_PAYBACK_DATE IS
'回款日期';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_PAYBACK.PAYBACK_DEPT IS
'回款部门';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_PAYBACK.PAYBACK_OWNER IS
'回款负责人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_PAYBACK.PAYBACK_AMOUNT IS
'回款金额';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_PAYBACK.PAYBACK_CONDITION IS
'回款条款';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_PAYBACK.MARK_INVIOCE_FLAG IS
'开票标志';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_PAYBACK.PAYBACK_DATE IS
'回款日期';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_PAYBACK.CREATOR_CODE IS
'创建人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_PAYBACK.CREATED_TIME IS
'创建时间';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_PAYBACK.MODIFIER_CODE IS
'修改人';

COMMENT ON COLUMN ZOEDEVOPS.DVP_PROJ_CONTRACT_PAYBACK.MODIFIED_TIME IS
'修改时间';

