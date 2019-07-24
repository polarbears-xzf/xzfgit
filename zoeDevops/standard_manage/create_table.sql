/*==============================================================*/
/* Table: META_USER$                                            */
/*==============================================================*/
create table ZOESTD.META_USER$ 
(
   DB_ID#               VARCHAR2(64)         not null,
   USER_ID              VARCHAR2(64)         default SYS_GUID() not null,
   USERNAME             VARCHAR2(64)         not null,
   DB_USER#             NUMBER,
   USER_CHN_NAME        VARCHAR2(64),
   USER_ABBR            VARCHAR2(64),
   USER_SOURCE          VARCHAR2(64),
   USER_TYPE#           VARCHAR2(3),
   ORACLE_MAINTAINED_FLAG VARCHAR2(1),
   MEMO                 VARCHAR2(400 CHAR),
   SPELL_CODE           VARCHAR2(255),
   CREATED_TIME         DATE,
   CREATOR              VARCHAR2(64),
   MODIFIED_TIME        DATE,
   MODIFIER             VARCHAR2(64),
   constraint PK_META_USER$ primary key (DB_ID#, USER_ID)
         using index
);

comment on table ZOESTD.META_USER$ is
'数据库用户字典';

comment on column ZOESTD.META_USER$.DB_ID# is
'数据库ID';

comment on column ZOESTD.META_USER$.USER_ID is
'用户ID';

comment on column ZOESTD.META_USER$.USERNAME is
'用户名';

comment on column ZOESTD.META_USER$.DB_USER# is
'数据库用户ID';

comment on column ZOESTD.META_USER$.USER_CHN_NAME is
'用户中文名';

comment on column ZOESTD.META_USER$.USER_ABBR is
'用户名缩写';

comment on column ZOESTD.META_USER$.USER_SOURCE is
'用户来源#|{"RELATION_TABLE":"DATA_LIST","RELATION_DATA":[{"CODE":"1","NAME":"ZOESOFT"},{"CODE":"2","NAME":"ORACLE"}],"MEMO":"当前主要用于区分Oracle用户"}';

comment on column ZOESTD.META_USER$.USER_TYPE# is
'用户类型#|META_USER_TYPE$#|{"1":"SCHEMA","2":"APPLICATION","3":"MAINTENANCE"}}';

comment on column ZOESTD.META_USER$.ORACLE_MAINTAINED_FLAG is
'ORACLE维护标志';

comment on column ZOESTD.META_USER$.MEMO is
'用户备注';

comment on column ZOESTD.META_USER$.SPELL_CODE is
'拼音码';

comment on column ZOESTD.META_USER$.CREATED_TIME is
'创建时间';

comment on column ZOESTD.META_USER$.CREATOR is
'创建用户';

comment on column ZOESTD.META_USER$.MODIFIED_TIME is
'获取时间';

comment on column ZOESTD.META_USER$.MODIFIER is
'修改用户';

/*==============================================================*/
/* Table: META_USER_TYPE$                                       */
/*==============================================================*/
create table META_USER_TYPE$ 
(
   TYPE_ID              NUMBER               not null,
   TYPE_NAME            VARCHAR2(64),
   CREATED_TIME         DATE,
   CREATOR              VARCHAR2(64),
   MODIFIED_TIME        DATE,
   MODIFIER             VARCHAR2(64),
   constraint PK_META_USER_TYPE$ primary key (TYPE_ID)
         using index
);

comment on table META_USER_TYPE$ is
'数据库用户类型';

comment on column META_USER_TYPE$.TYPE_ID is
'用户类型ID';

comment on column META_USER_TYPE$.TYPE_NAME is
'用户类型名称';

comment on column META_USER_TYPE$.CREATED_TIME is
'创建时间';

comment on column META_USER_TYPE$.CREATOR is
'创建用户';

comment on column META_USER_TYPE$.MODIFIED_TIME is
'获取时间';

comment on column META_USER_TYPE$.MODIFIER is
'修改用户';

/*==============================================================*/
/* Table: META_OBJ_TYPE$                                        */
/*==============================================================*/
create table META_OBJ_TYPE$ 
(
   TYPE_ID              NUMBER               not null,
   TYPE_NAME            VARCHAR2(64),
   CREATED_TIME         DATE,
   CREATOR              VARCHAR2(64),
   MODIFIED_TIME        DATE,
   MODIFIER             VARCHAR2(64),
   constraint PK_META_OBJ_TYPE$ primary key (TYPE_ID)
         using index
);

comment on table META_OBJ_TYPE$ is
'数据库对象类型';

comment on column META_OBJ_TYPE$.TYPE_ID is
'对象类型ID';

comment on column META_OBJ_TYPE$.TYPE_NAME is
'对象类型名称';

comment on column META_OBJ_TYPE$.CREATED_TIME is
'创建时间';

comment on column META_OBJ_TYPE$.CREATOR is
'创建用户';

comment on column META_OBJ_TYPE$.MODIFIED_TIME is
'获取时间';

comment on column META_OBJ_TYPE$.MODIFIER is
'修改用户';

/*==============================================================*/
/* Table: META_OBJ$                                             */
/*==============================================================*/
create table ZOESTD.META_OBJ$ 
(
   DB_ID#               VARCHAR2(64)         not null,
   OBJ_ID               VARCHAR2(64)         not null,
   USER_ID#             VARCHAR2(64),
   DB_OBJ_ID#           NUMBER,
   OBJ_NAME             VARCHAR2(64),
   OBJ_TYPE_ID#         NUMBER,
   MEMO                 VARCHAR2(400 CHAR),
   SPELL_CODE           VARCHAR2(255),
   CREATED_TIME         DATE,
   CREATOR              VARCHAR2(64),
   MODIFIED_TIME        DATE,
   MODIFIER             VARCHAR2(64),
   constraint PK_META_OBJ$ primary key (DB_ID#, OBJ_ID)
         using index
);

comment on table ZOESTD.META_OBJ$ is
'数据库对象字典';

comment on column ZOESTD.META_OBJ$.DB_ID# is
'数据库ID';

comment on column ZOESTD.META_OBJ$.OBJ_ID is
'对象ID';

comment on column ZOESTD.META_OBJ$.USER_ID# is
'用户ID';

comment on column ZOESTD.META_OBJ$.DB_OBJ_ID# is
'数据库对象ID';

comment on column ZOESTD.META_OBJ$.OBJ_NAME is
'对象名称';

comment on column ZOESTD.META_OBJ$.OBJ_TYPE_ID# is
'对象类型#|META_OBJ_TYPE$#|{"1":"TABLE","2":"VIEW","3":"SEQUENCE"}}';

comment on column ZOESTD.META_OBJ$.MEMO is
'对象备注';

comment on column ZOESTD.META_OBJ$.SPELL_CODE is
'拼音码';

comment on column ZOESTD.META_OBJ$.CREATED_TIME is
'创建时间';

comment on column ZOESTD.META_OBJ$.CREATOR is
'创建用户';

comment on column ZOESTD.META_OBJ$.MODIFIED_TIME is
'获取时间';

comment on column ZOESTD.META_OBJ$.MODIFIER is
'修改用户';

/*==============================================================*/
/* Table: META_TAB$                                             */
/*==============================================================*/
create table ZOESTD.META_TAB$ 
(
   DB_ID#               VARCHAR2(64)         not null,
   OBJ_ID#              VARCHAR2(64)         not null,
   USER_ID#             VARCHAR2(64),
   TAB_NAME             VARCHAR2(64),
   TAB_CHN_NAME         VARCHAR2(128),
   TAB_CHECKSUM         VARCHAR2(128),
   MEMO                 VARCHAR2(2000),
   SPELL_CODE           VARCHAR2(255),
   CREATED_TIME         DATE,
   CREATOR              VARCHAR2(64),
   MODIFIED_TIME        DATE,
   MODIFIER             VARCHAR2(64),
   constraint PK_META_TAB$ primary key (DB_ID#, OBJ_ID#)
         using index
);

comment on table ZOESTD.META_TAB$ is
'数据库表';

comment on column ZOESTD.META_TAB$.DB_ID# is
'数据库ID';

comment on column ZOESTD.META_TAB$.OBJ_ID# is
'表对象ID';

comment on column ZOESTD.META_TAB$.USER_ID# is
'所有者ID';

comment on column ZOESTD.META_TAB$.TAB_NAME is
'表名';

comment on column ZOESTD.META_TAB$.TAB_CHN_NAME is
'表中文名';

comment on column ZOESTD.META_TAB$.TAB_CHECKSUM is
'表校验和';

comment on column ZOESTD.META_TAB$.MEMO is
'备注';

comment on column ZOESTD.META_TAB$.SPELL_CODE is
'拼音码';

comment on column ZOESTD.META_TAB$.CREATED_TIME is
'创建时间';

comment on column ZOESTD.META_TAB$.CREATOR is
'创建用户';

comment on column ZOESTD.META_TAB$.MODIFIED_TIME is
'获取时间';

comment on column ZOESTD.META_TAB$.MODIFIER is
'修改用户';


drop index ZOESTD.TIME_META_COL$_MODIFIED;

/*==============================================================*/
/* Table: META_COL$                                             */
/*==============================================================*/
create table ZOESTD.META_COL$ 
(
   DB_ID#               VARCHAR2(64)         not null,
   OBJ_ID#              VARCHAR2(64)         not null,
   COL_ID               NUMBER               not null,
   COL_NAME             VARCHAR2(64),
   COL_CHN_NAME         VARCHAR2(255),
   DATA_TYPE            VARCHAR2(64),
   DATA_LENGTH          NUMBER,
   DATA_PRECISION       NUMBER,
   DATA_SCALE           NUMBER,
   NULLABLE             VARCHAR2(3),
   PK_FLAG              VARCHAR2(3),
   DATA_DEFAULT         CLOB,
   MEMO                 VARCHAR2(2000),
   SPELL_CODE           VARCHAR2(255),
   CREATED_TIME         DATE,
   CREATOR              VARCHAR2(64),
   MODIFIED_TIME        DATE,
   MODIFIER             VARCHAR2(64),
   constraint PK_META_COL$ primary key (DB_ID#, OBJ_ID#, COL_ID)
         using index
);

comment on table ZOESTD.META_COL$ is
'数据库列';

comment on column ZOESTD.META_COL$.DB_ID# is
'数据库ID';

comment on column ZOESTD.META_COL$.OBJ_ID# is
'对象ID#|自增序列';

comment on column ZOESTD.META_COL$.COL_ID is
'列ID';

comment on column ZOESTD.META_COL$.COL_NAME is
'列名称';

comment on column ZOESTD.META_COL$.COL_CHN_NAME is
'列中文名';

comment on column ZOESTD.META_COL$.DATA_TYPE is
'数据类型';

comment on column ZOESTD.META_COL$.DATA_LENGTH is
'数据长度';

comment on column ZOESTD.META_COL$.DATA_PRECISION is
'数据精度';

comment on column ZOESTD.META_COL$.DATA_SCALE is
'数据小数位';

comment on column ZOESTD.META_COL$.NULLABLE is
'是否为空#|Y:允许为空,N:不允许为空';

comment on column ZOESTD.META_COL$.PK_FLAG is
'主键标志#|1 主键';

comment on column ZOESTD.META_COL$.DATA_DEFAULT is
'默认值表达式';

comment on column ZOESTD.META_COL$.MEMO is
'列备注';

comment on column ZOESTD.META_COL$.SPELL_CODE is
'拼音码';

comment on column ZOESTD.META_COL$.CREATED_TIME is
'创建时间';

comment on column ZOESTD.META_COL$.CREATOR is
'创建用户';

comment on column ZOESTD.META_COL$.MODIFIED_TIME is
'获取时间';

comment on column ZOESTD.META_COL$.MODIFIER is
'修改用户';

/*==============================================================*/
/* Index: TIME_META_COL$_MODIFIED                               */
/*==============================================================*/
create index ZOESTD.TIME_META_COL$_MODIFIED on ZOESTD.META_COL$ (
   MODIFIED_TIME ASC
);


