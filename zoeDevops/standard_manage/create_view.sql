/*==============================================================*/
/* View: V_ZOESOFT_USER                                         */
/*==============================================================*/
create or replace view ZOESTD.V_ZOESOFT_USER as
SELECT USER_ID  AS  "USER_ID",
    USERNAME    AS  "USERNAME",
    USER_ABBR   AS  "USER_ABBR",
    USER_CHN_NAME  AS "USER_CHN_NAME"
FROM ZOESTD.META_USER$
WHERE USER_SOURCE='ZOESOFT'
with read only;

 comment on table ZOESTD.V_ZOESOFT_USER is
'智业软件用户视图';

comment on column ZOESTD.V_ZOESOFT_USER.USER_ID is
'用户ID';

comment on column ZOESTD.V_ZOESOFT_USER.USERNAME is
'用户名';

comment on column ZOESTD.V_ZOESOFT_USER.USER_ABBR is
'用户名缩写';

comment on column ZOESTD.V_ZOESOFT_USER.USER_CHN_NAME is
'用户中文名';

/*==============================================================*/
/* View: V_ZOESOFT_OBJECT                                       */
/*==============================================================*/
create or replace view ZOESTD.V_ZOESOFT_OBJECT as
SELECT
   MO.OBJ_ID AS "OBJ_ID",
   MU.USERNAME AS "OWNER",
   MO.OBJ_NAME AS "OBJ_NAME",
   MOT.TYPE_NAME AS "OBJ_TYPE_NAME",
   MO.MEMO   AS  "MEMO",
   MO.SPELL_CODE AS "SPELL_CODE"
FROM
   ZOESTD.META_USER$ MU,
   ZOESTD.META_OBJ$ MO,
   ZOESTD.META_OBJ_TYPE$ MOT
WHERE
   MU.USER_ID = MO.USER_ID#
   AND MO.OBJ_TYPE_ID# = MOT.TYPE_ID
   AND MU.USER_SOURCE = 'ZOESOFT'
with read only;

 comment on table ZOESTD.V_ZOESOFT_OBJECT is
'智业软件对象视图';

comment on column ZOESTD.V_ZOESOFT_OBJECT.OBJ_ID is
'对象ID';

comment on column ZOESTD.V_ZOESOFT_OBJECT.OWNER is
'用户名';

comment on column ZOESTD.V_ZOESOFT_OBJECT.OBJ_NAME is
'对象名称';

comment on column ZOESTD.V_ZOESOFT_OBJECT.OBJ_TYPE_NAME is
'对象类型名称';

comment on column ZOESTD.V_ZOESOFT_OBJECT.MEMO is
'对象备注';

comment on column ZOESTD.V_ZOESOFT_OBJECT.SPELL_CODE is
'拼音码';

/*==============================================================*/
/* View: V_ZOESOFT_TABLE                                        */
/*==============================================================*/
create or replace view ZOESTD.V_ZOESOFT_TABLE as
select
   mt.OBJ_ID# as "OBJ_ID",
   mu.username as "OWNER",
   mt.tab_name as "TABLE_NAME",
   mt.tab_chn_name as "TABLE_CHN_NAME",
   mt.memo as "MEMO",
   mt.spell_code as "SPELL_CODE"
from
   ZOESTD.META_USER$ mu,
   ZOESTD.META_TAB$ mt
where
   mu.USER_ID = mt.USER_ID#
   and mu.user_source = 'ZOESOFT'
with read only;

 comment on table ZOESTD.V_ZOESOFT_TABLE is
'智业软件表视图';

comment on column ZOESTD.V_ZOESOFT_TABLE.OBJ_ID is
'表对象ID';

comment on column ZOESTD.V_ZOESOFT_TABLE.OWNER is
'用户名';

comment on column ZOESTD.V_ZOESOFT_TABLE.TABLE_NAME is
'表名';

comment on column ZOESTD.V_ZOESOFT_TABLE.TABLE_CHN_NAME is
'表中文名';

comment on column ZOESTD.V_ZOESOFT_TABLE.MEMO is
'备注';

comment on column ZOESTD.V_ZOESOFT_TABLE.SPELL_CODE is
'拼音码';

/*==============================================================*/
/* View: V_ZOESOFT_TAB_COLUMN                                   */
/*==============================================================*/
create or replace view ZOESTD.V_ZOESOFT_TAB_COLUMN as
select
   mc.OBJ_ID# as "OBJ_ID",
   mc.col_id as "COLUMN_ID",
   vt.owner as "OWNER",
   vt.table_name as "TABLE_NAME",
   mc.col_name as "COLUMN_NAME",
   mc.col_chn_name as "COLUMN_CHN_NAME",
   mc.data_type as "DATA_TYPE",
   mc.data_length as "DATA_LENGTH",
   mc.data_precision as "DATA_PRECISION",
   mc.data_scale as "DATA_SCALE",
   mc.memo as "MEMO",
   mc.spell_code as "SPELL_CODE",
   mc.nullable as "NULLABLE",
   mc.pk_flag as "PK_FLAG"
   
from
   ZOESTD.META_COL$ mc,
   ZOESTD.V_ZOESOFT_TABLE vt
where
   mc.OBJ_ID# = vt.obj_id

with read only;

 comment on table ZOESTD.V_ZOESOFT_TAB_COLUMN is
'智业软件表列视图';

comment on column ZOESTD.V_ZOESOFT_TAB_COLUMN.OBJ_ID is
'对象ID#|自增序列';

comment on column ZOESTD.V_ZOESOFT_TAB_COLUMN.COLUMN_ID is
'列ID';

comment on column ZOESTD.V_ZOESOFT_TAB_COLUMN.OWNER is
'用户名';

comment on column ZOESTD.V_ZOESOFT_TAB_COLUMN.TABLE_NAME is
'表名';

comment on column ZOESTD.V_ZOESOFT_TAB_COLUMN.COLUMN_NAME is
'列名称';

comment on column ZOESTD.V_ZOESOFT_TAB_COLUMN.COLUMN_CHN_NAME is
'列中文名';

comment on column ZOESTD.V_ZOESOFT_TAB_COLUMN.DATA_TYPE is
'数据类型';

comment on column ZOESTD.V_ZOESOFT_TAB_COLUMN.DATA_LENGTH is
'数据长度';

comment on column ZOESTD.V_ZOESOFT_TAB_COLUMN.DATA_PRECISION is
'数据精度';

comment on column ZOESTD.V_ZOESOFT_TAB_COLUMN.DATA_SCALE is
'数据小数位';

comment on column ZOESTD.V_ZOESOFT_TAB_COLUMN.MEMO is
'列备注';

comment on column ZOESTD.V_ZOESOFT_TAB_COLUMN.SPELL_CODE is
'拼音码';

comment on column ZOESTD.V_ZOESOFT_TAB_COLUMN.NULLABLE is
'是否为空#|Y:允许为空,N:不允许为空';

comment on column ZOESTD.V_ZOESOFT_TAB_COLUMN.PK_FLAG is
'主键标志#|1 主键';
