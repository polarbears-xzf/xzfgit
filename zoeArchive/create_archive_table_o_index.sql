-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		create_archive_table_o_index.sql
--	Description:
-- 		在归档数据库创建数据库归档表索引,包含：
--      --单据表、单据细表、
--      --预交金表、医嘱表、门诊费用明细、住院费用明细
--      --结算主表、结算细表
--      --门诊处方主表、门诊处方细表
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--

alter table SGARCHIVE.APPLY_SHEET_O add constraint PK_APPLY_SHEET_O primary key (APPLY_NO)
  using index tablespace hisarch_idx ; 

create index SGARCHIVE.IDX_APPLY_SHEET_SICK_O on SGARCHIVE.APPLY_SHEET_O (SICK_ID, VISIT_NUMBER)
  tablespace hisarch_idx ;

create index SGARCHIVE.PK_APPLY_SHEET_APPLY_TIME_O on SGARCHIVE.APPLY_SHEET_O (APPLY_TIME)
  tablespace hisarch_idx ; 

create index SGARCHIVE.IDX_APPLY_SHEET_SETTLE_O on SGARCHIVE.APPLY_SHEET_O (SETTLE_NO)
  tablespace hisarch_idx ;

alter table SGARCHIVE.APPLY_SHEET_DETAIL_O add constraint PK_APPLY_SHEET_DETAIL_O primary key (APPLY_NO, ITEM_SEQUENCE)
  using index tablespace hisarch_idx ; 

alter table SGARCHIVE.PREPAYMENT_MONEY_O add constraint PK_PREPAYMENT_MONEY_O primary key (PREPAY_NO)
  using index   tablespace hisarch_idx ;

create index SGARCHIVE.IDX_PREPAYMENT_MONEY_SI_VN_O on SGARCHIVE.PREPAYMENT_MONEY_O (SICK_ID, VISIT_NUMBER)
  tablespace hisarch_idx ;

create index SGARCHIVE.IDX_PREPAYMENT_MONEY_TIME_O on SGARCHIVE.PREPAYMENT_MONEY_O (OPERATION_DATE)
  tablespace hisarch_idx ;

create index SGARCHIVE.IDX_PREPAYMENT_SETTLE_NO_O on SGARCHIVE.PREPAYMENT_MONEY_O (SETTLE_RECEIPT_NO)
  tablespace hisarch_idx ;

alter table SGARCHIVE.PRESCRIBE_RECORD_O add constraint PK_PRESCRIBE_RECORD_O primary key (PRESCRIBE_NUMBER, PRESCRIBE_SUB_NUMBER)
  using index tablespace hisarch_idx ;

create index SGARCHIVE.IDX_PRESCRIBE_RECORD_SICK_O on SGARCHIVE.PRESCRIBE_RECORD_O (SICK_ID, VISIT_NUMBER)
  tablespace hisarch_idx ;

create index SGARCHIVE.IDX_PRESCRIBE_RECORD_PT_O on SGARCHIVE.PRESCRIBE_RECORD_O (PRESCRIBE_TIME)
  tablespace hisarch_idx ;

alter table SGARCHIVE.RESIDENCE_SICK_PRICE_ITEM_O add constraint PK_RESI_SICK_PRICE_ITEM_O primary key (SEQUENCE_NO)
  using index tablespace hisarch_idx ;
----SGARCHIVE.IDX_RESI_SICK_PRICE_ITEM_TIME_O 标示名太长
create index SGARCHIVE.IDX_RESI_SICK_PRICE_ITEM_TIM_O on SGARCHIVE.RESIDENCE_SICK_PRICE_ITEM_O (OPERATION_TIME)
  tablespace hisarch_idx ;
-----SGARCHIVE.IDX_RESI_SICK_PRICE_ITEM_SICK_O标示名太长
create index SGARCHIVE.IDX_RESI_SICK_PRICE_ITEM_SIC_O on SGARCHIVE.RESIDENCE_SICK_PRICE_ITEM_O (SICK_ID)
  tablespace hisarch_idx ;

create index SGARCHIVE.IDX_RESI_SICK_PRICE_ITEM_SN_O on SGARCHIVE.RESIDENCE_SICK_PRICE_ITEM_O (SETTLE_NO)
  tablespace hisarch_idx ;

alter table SGARCHIVE.SICK_SETTLE_MASTER_O add constraint PK_SICK_SETTLE_MASTER_O primary key (SETTLE_NO)
  using index tablespace hisarch_idx ;

create index SGARCHIVE.IDX_SICK_SETTLE_MASTER_SICK_O on SGARCHIVE.SICK_SETTLE_MASTER_O (SICK_ID)
  tablespace hisarch_idx ;

create index SGARCHIVE.IDX_SICK_SETTLE_MASTER_DATE_O on SGARCHIVE.SICK_SETTLE_MASTER_O (SETTLE_DATE)
  tablespace hisarch_idx ;

alter table SGARCHIVE.SICK_SETTLE_DETAIL_O add constraint PK_SICK_SETTLE_DETAIL_O primary key (SETTLE_NO, RECEIPT_CLASS)
  using index tablespace hisarch_idx ;

alter table SGARCHIVE.DISPENSARY_PRESCRIP_MASTER_O add constraint PK_DISP_PRESCRIP_MASTER_O primary key (PRESCRIPTION_NUMBER)
  using index tablespace hisarch_idx ;

create index SGARCHIVE.IDX_DISP_PRESCRIP_SICK_O on SGARCHIVE.DISPENSARY_PRESCRIP_MASTER_O (SICK_ID)
  tablespace hisarch_idx ;

create index SGARCHIVE.IDX_DISP_PRESCRIP_MASTER_WT_O on SGARCHIVE.DISPENSARY_PRESCRIP_MASTER_O (WRITE_TIME)
  tablespace hisarch_idx ;

alter table SGARCHIVE.DISPENSARY_PRESCRIBE_DETAIL_O add constraint PK_DISP_PRESCRIBE_DETAIL_O primary key (PRESCRIPTION_NUMBER, SEQUENCE_NUMBER)
  using index tablespace hisarch_idx ;

alter table SGARCHIVE.DISPENSARY_SICK_PRICE_ITEM_O add constraint PK_DISP_SICK_PRICE_ITEM_O primary key (SEQUENCE_NO)
  using index tablespace hisarch_idx ;
----SGARCHIVE.IDX_DISP_SICK_PRICE_ITEM_SICK_O
create index SGARCHIVE.IDX_DISP_SICK_PRICE_ITEM_SIC_O on SGARCHIVE.DISPENSARY_SICK_PRICE_ITEM_O (SICK_ID)
  tablespace hisarch_idx ;

create index SGARCHIVE.IDX_DISP_SICK_PRICE_ITEM_SN_O on SGARCHIVE.DISPENSARY_SICK_PRICE_ITEM_O (SETTLE_NO)
  tablespace hisarch_idx ;
----SGARCHIVE.IDX_DISP_SICK_PRICE_ITEM_TIME_O
create index SGARCHIVE.IDX_DISP_SICK_PRICE_ITEM_TIM_O on SGARCHIVE.DISPENSARY_SICK_PRICE_ITEM_O (OPERATION_TIME)
  tablespace hisarch_idx ;

alter table SGARCHIVE.LAY_PHYSIC_RECORDS_O add constraint PK_LAY_PHYSIC_RECORDS_O primary key (APPLY_NO, APPLY_SUB_NO)
  using index tablespace hisarch_idx ;

create index SGARCHIVE.IDX_LAY_PHYSIC_RECORDS_SICK_O on SGARCHIVE.LAY_PHYSIC_RECORDS_O (SICK_ID, VISIT_NUMBER)
  tablespace hisarch_idx ;
-----SGARCHIVE.IDX_LAY_PHYSIC_RECORDS_LAYTIME_O
create index SGARCHIVE.IDX_LAY_PHYSIC_RECORDS_LAYT_O on SGARCHIVE.LAY_PHYSIC_RECORDS_O (LAY_PHYSIC_TIME)
  tablespace hisarch_idx ;

