--审计日志记录
create table ZOESECURITY.AUDIT_LOG 
(
   LOG_ID               VARCHAR2(36)         default SYS_GUID() not null,
   USERNAME             VARCHAR2(128),
   OS_USERNAME          VARCHAR2(255),
   HOST                 VARCHAR2(255),
   TERMINAL             VARCHAR2(255),
   IP_ADDRESS           VARCHAR2(64),
   CURRENT_USER         VARCHAR2(64),
   OBJECT_OWNER         VARCHAR2(128),
   OBJECT_NAME          VARCHAR2(128),
   OBJECT_TYPE          VARCHAR2(64),
   NEW_OBJECT_OWNER     VARCHAR2(128),
   NEW_OBJECT_NAME      VARCHAR2(128),
   OPERATION_TYPE       VARCHAR2(64),
   OPERATION_TIME       DATE                 default SYSDATE,
   RETURNCODE           NUMBER,
   SQL_ID               VARCHAR2(64),
   SQL_TEXT             CLOB
);

comment on table ZOESECURITY.AUDIT_LOG is
'审计日志#|';

comment on column ZOESECURITY.AUDIT_LOG.LOG_ID is
'日志流水号';

comment on column ZOESECURITY.AUDIT_LOG.USERNAME is
'数据库用户名';

comment on column ZOESECURITY.AUDIT_LOG.OS_USERNAME is
'操作系统用户名';

comment on column ZOESECURITY.AUDIT_LOG.HOST is
'客户端主机名';

comment on column ZOESECURITY.AUDIT_LOG.TERMINAL is
'客户端操作系统终端名';

comment on column ZOESECURITY.AUDIT_LOG.IP_ADDRESS is
'客户端IP地址';

comment on column ZOESECURITY.AUDIT_LOG.CURRENT_USER is
'当前用户#|#|当前SESSION拥有权限的用户的名称（例如：当前SESSION用户是SYS,但是正在执行system.myproc，那么current_user就是system）''';

comment on column ZOESECURITY.AUDIT_LOG.OBJECT_OWNER is
'对象所有者';

comment on column ZOESECURITY.AUDIT_LOG.OBJECT_NAME is
'对象名';

comment on column ZOESECURITY.AUDIT_LOG.OBJECT_TYPE is
'对象类型';

comment on column ZOESECURITY.AUDIT_LOG.NEW_OBJECT_OWNER is
'新对象所有者';

comment on column ZOESECURITY.AUDIT_LOG.NEW_OBJECT_NAME is
'新对象名';

comment on column ZOESECURITY.AUDIT_LOG.OPERATION_TYPE is
'操作类型';

comment on column ZOESECURITY.AUDIT_LOG.OPERATION_TIME is
'操作时间';

comment on column ZOESECURITY.AUDIT_LOG.RETURNCODE is
'返回代码';

comment on column ZOESECURITY.AUDIT_LOG.SQL_ID is
'SQL_ID';

comment on column ZOESECURITY.AUDIT_LOG.SQL_TEXT is
'SQL文本';

alter table ZOESECURITY.AUDIT_LOG
   add constraint PK_AUDIT_LOG primary key (LOG_ID);
