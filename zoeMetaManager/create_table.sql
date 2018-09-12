--创建数据库用户表
create table ZOESTD.META_USER$ 
(
   USER#                NUMBER        DEFAULT SEQ_META_USER$.NEXTVAL       not null  ,
   USERNAME             VARCHAR2(128)        not null,
   USER_CHN_NAME        VARCHAR2(64),
   USER_ABBR            VARCHAR2(128),
   USER_SOURCE          VARCHAR2(128),
   USER_TYPE#           VARCHAR2(3),
   ORACLE_MAINTAINED_FLAG VARCHAR2(1),
   MEMO                 VARCHAR2(400),
   SPELL_CODE           VARCHAR2(255),
   WBZX_CODE            VARCHAR2(255),
   CREATED_TIME         DATE,
   CREATOR              VARCHAR2(128),
   MODIFIED_TIME        DATE,
   MODIFIER             VARCHAR2(128), 
   CONSTRAINT "PK_META_USER$" PRIMARY KEY ("USER#") USING INDEX , 
   CONSTRAINT "UNIQ_META_USER$" UNIQUE ("USERNAME") USING INDEX );

comment on table ZOESTD.META_USER$ is '数据库用户字典';
comment on column ZOESTD.META_USER$.USER# is '用户ID';
comment on column ZOESTD.META_USER$.USERNAME is '用户名';
comment on column ZOESTD.META_USER$.USER_CHN_NAME is '用户中文名';
comment on column ZOESTD.META_USER$.USER_ABBR is '用户名缩写';
comment on column ZOESTD.META_USER$.USER_SOURCE is '用户来源#|{"RELATION_TABLE":"DATA_LIST","RELATION_DATA":[{"CODE":"1","NAME":"ZOESOFT"},{"CODE":"2","NAME":"ORACLE"}],"MEMO":"当前主要用于区分Oracle用户"}';
comment on column ZOESTD.META_USER$.USER_TYPE# is '用户类型#|META_USER_TYPE$#|{"1":"SCHEMA","2":"APPLICATION","3":"MAINTENANCE"}}';
comment on column ZOESTD.META_USER$.ORACLE_MAINTAINED_FLAG is 'ORACLE维护标志';
comment on column ZOESTD.META_USER$.MEMO is '用户备注';
comment on column ZOESTD.META_USER$.SPELL_CODE is '拼音码';
comment on column ZOESTD.META_USER$.WBZX_CODE is '五笔码';
comment on column ZOESTD.META_USER$.CREATED_TIME is '创建时间';
comment on column ZOESTD.META_USER$.CREATOR is '创建用户';
comment on column ZOESTD.META_USER$.MODIFIED_TIME is '获取时间';
comment on column ZOESTD.META_USER$.MODIFIER is '修改用户';

create table ZOESTD.META_OBJ$ 
(
   OBJ#                 NUMBER               not null,
   USER#                NUMBER               not null,
   OBJ_NAME             VARCHAR2(128),
   OBJ_TYPE#            NUMBER,
   MEMO                 VARCHAR2(4000),
   SPELL_CODE           VARCHAR2(255),
   WBZX_CODE            VARCHAR2(255),
   CREATED_TIME         DATE,
   CREATOR              VARCHAR2(128),
   MODIFIED_TIME        DATE,
   MODIFIER             VARCHAR2(128), 
   CONSTRAINT "PK_META_OBJ$" PRIMARY KEY ("OBJ#") USING INDEX
);

comment on table ZOESTD.META_OBJ$ is '数据库对象字典';
comment on column ZOESTD.META_OBJ$.OBJ# is '对象ID';
comment on column ZOESTD.META_OBJ$.USER# is '所有者ID';
comment on column ZOESTD.META_OBJ$.OBJ_NAME is '对象名称';
comment on column ZOESTD.META_OBJ$.OBJ_TYPE# is '对象类型#|META_OBJ_TYPE$#|{"1":"TABLE","2":"VIEW","3":"SEQUENCE"}}';
comment on column ZOESTD.META_OBJ$.MEMO is '对象备注';
comment on column ZOESTD.META_OBJ$.SPELL_CODE is '拼音码';
comment on column ZOESTD.META_OBJ$.WBZX_CODE is '五笔码';
comment on column ZOESTD.META_OBJ$.CREATED_TIME is '创建时间';
comment on column ZOESTD.META_OBJ$.CREATOR is '创建用户';
comment on column ZOESTD.META_OBJ$.MODIFIED_TIME is '修改时间';
comment on column ZOESTD.META_OBJ$.MODIFIER is '修改用户';

create table ZOESTD.META_TAB$ 
(
   OBJ#                 NUMBER               not null,
   USER#                NUMBER,
   TABLE_NAME           VARCHAR2(128),
   TABLE_CHECKSUM       VARCHAR2(128),
   SPELL_CODE           VARCHAR2(255),
   MODIFIED_TIME        DATE,
   MODIFIER             VARCHAR2(128), 
   CONSTRAINT "PK_META_TAB$" PRIMARY KEY ("OBJ#") USING INDEX
);

comment on table ZOESTD.META_TAB$ is '数据库表';
comment on column ZOESTD.META_TAB$.OBJ# is '表对象ID';
comment on column ZOESTD.META_TAB$.USER# is '所有者ID';
comment on column ZOESTD.META_TAB$.TABLE_NAME is '表名';
comment on column ZOESTD.META_TAB$.TABLE_CHECKSUM is '表校验和';
comment on column ZOESTD.META_TAB$.SPELL_CODE is '拼音码';
comment on column ZOESTD.META_TAB$.MODIFIED_TIME is '获取时间';
comment on column ZOESTD.META_TAB$.MODIFIER is '修改用户';

create table ZOESTD.META_COL$ 
(
   OBJ#                 NUMBER               not null,
   COL_ID               NUMBER               ,
   COL_NAME             VARCHAR2(128),
   COL_CHN_NAME         VARCHAR2(64),
   DATA_TYPE            VARCHAR2(64),
   DATA_LENGTH          NUMBER,
   DATA_PRECESION       NUMBER,
   DATA_SCALE           NUMBER,
   DATA_DEFAULT         CLOB,
   MEMO                 VARCHAR2(2000),
   SPELL_CODE           VARCHAR2(255),
   CREATED_TIME         DATE,
   CREATOR              VARCHAR2(128),
   MODIFIED_TIME        DATE,
   MODIFIER             VARCHAR2(128), 
   CONSTRAINT "PK_META_COL$" PRIMARY KEY (OBJ#,COL_ID) USING INDEX
);

comment on table ZOESTD.META_COL$ is '数据库列';
comment on column ZOESTD.META_COL$.OBJ# is '对象ID#|自增序列';
comment on column ZOESTD.META_COL$.COL_ID is '列ID';
comment on column ZOESTD.META_COL$.COL_NAME is '列名称';
comment on column ZOESTD.META_COL$.COL_CHN_NAME is '列中文名';
comment on column ZOESTD.META_COL$.DATA_TYPE is '数据类型';
comment on column ZOESTD.META_COL$.DATA_LENGTH is '数据长度';
comment on column ZOESTD.META_COL$.DATA_PRECESION is '数据精度';
comment on column ZOESTD.META_COL$.DATA_SCALE is '数据小数位';
comment on column ZOESTD.META_COL$.DATA_DEFAULT is '默认值表达式';
comment on column ZOESTD.META_COL$.MEMO is '列备注';
comment on column ZOESTD.META_COL$.SPELL_CODE is '拼音码';
comment on column ZOESTD.META_COL$.CREATED_TIME is '创建时间';
comment on column ZOESTD.META_COL$.CREATOR is '创建用户';
comment on column ZOESTD.META_COL$.MODIFIED_TIME is '获取时间';
comment on column ZOESTD.META_COL$.MODIFIER is '修改用户';

