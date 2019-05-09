/*==============================================================*/
/* Table: CHK_DB_INFO                                           */
/*==============================================================*/
create table ZOECHECKUP.CHK_DB_INFO 
(
   DB_ID                VARCHAR2(36)         not null,
   DB_NAME              VARCHAR2(64),
   SERVICE_NAME         VARCHAR2(64),
   IP_ADDRESS           VARCHAR2(64),
   PORT_NO              NUMBER,
   CONNECT_USER         VARCHAR2(64),
   CONNECT_PASSWORD     VARCHAR2(64),
   constraint PK_CHK_DB_INFO primary key (DB_ID)
);

comment on table ZOECHECKUP.CHK_DB_INFO is
'数据库信息';

comment on column ZOECHECKUP.CHK_DB_INFO.DB_ID is
'DB_ID';

comment on column ZOECHECKUP.CHK_DB_INFO.DB_NAME is
'数据库名';

comment on column ZOECHECKUP.CHK_DB_INFO.SERVICE_NAME is
'服务名';

comment on column ZOECHECKUP.CHK_DB_INFO.IP_ADDRESS is
'IP地址';

comment on column ZOECHECKUP.CHK_DB_INFO.PORT_NO is
'端口号';

comment on column ZOECHECKUP.CHK_DB_INFO.CONNECT_USER is
'连接用户';

comment on column ZOECHECKUP.CHK_DB_INFO.CONNECT_PASSWORD is
'连接密码';
