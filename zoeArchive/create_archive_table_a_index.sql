-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		create_archive_table_a_index.sql
--	Description:
-- 		在归档数据库创建数据库归档表索引,包含：
--      --单据表、单据细表、
--      --预交金表、医嘱表、门诊费用明细、住院费用明细
--      --结算主表、结算细表
--      --门诊处方主表、门诊处方细表
--  Relation:
--      对象关联
--	Notes:
--		分区表创建本地索引
--	修改 - （年-月-日） - 描述
--

alter table ZOEARCHIVE.APPLY_SHEET_A add constraint PK_APPLY_SHEET_A primary key (APPLY_NO)
  using index tablespace hisarch_idx ; 

create index ZOEARCHIVE.IDX_APPLY_SHEET_SICK_A on ZOEARCHIVE.APPLY_SHEET_A (SICK_ID, VISIT_NUMBER)
  tablespace hisarch_idx ;

create index ZOEARCHIVE.PK_APPLY_SHEET_APPLY_TIME_A on ZOEARCHIVE.APPLY_SHEET_A (APPLY_TIME)
  tablespace hisarch_idx ; 

create index ZOEARCHIVE.IDX_APPLY_SHEET_SETTLE_A on ZOEARCHIVE.APPLY_SHEET_A (SETTLE_NO)
  tablespace hisarch_idx ;

alter table ZOEARCHIVE.APPLY_SHEET_DETAIL_A add constraint PK_APPLY_SHEET_DETAIL_A primary key (APPLY_NO, ITEM_SEQUENCE)
  using index tablespace hisarch_idx ; 

alter table ZOEARCHIVE.PREPAYMENT_MONEY_A add constraint PK_PREPAYMENT_MONEY_A primary key (PREPAY_NO)
  using index   tablespace hisarch_idx ;

create index ZOEARCHIVE.IDX_PREPAYMENT_MONEY_SI_VN_A on ZOEARCHIVE.PREPAYMENT_MONEY_A (SICK_ID, VISIT_NUMBER)
  tablespace hisarch_idx ;

create index ZOEARCHIVE.IDX_PREPAYMENT_MONEY_TIME_A on ZOEARCHIVE.PREPAYMENT_MONEY_A (OPERATION_DATE)
  tablespace hisarch_idx ;

create index ZOEARCHIVE.IDX_PREPAYMENT_SETTLE_NO_A on ZOEARCHIVE.PREPAYMENT_MONEY_A (SETTLE_RECEIPT_NO)
  tablespace hisarch_idx ;

alter table ZOEARCHIVE.PRESCRIBE_RECORD_A add constraint PK_PRESCRIBE_RECORD_A primary key (PRESCRIBE_NUMBER, PRESCRIBE_SUB_NUMBER)
  using index tablespace hisarch_idx ;

create index ZOEARCHIVE.IDX_PRESCRIBE_RECORD_SICK_A on ZOEARCHIVE.PRESCRIBE_RECORD_A (SICK_ID, VISIT_NUMBER)
  tablespace hisarch_idx ;

create index ZOEARCHIVE.IDX_PRESCRIBE_RECORD_PT_A on ZOEARCHIVE.PRESCRIBE_RECORD_A (PRESCRIBE_TIME)
  tablespace hisarch_idx ;

alter table ZOEARCHIVE.RESIDENCE_SICK_PRICE_ITEM_A add constraint PK_RESI_SICK_PRICE_ITEM_A primary key (SEQUENCE_NO)
  using index tablespace hisarch_idx ;

create index ZOEARCHIVE.IDX_RESI_SICK_PRICE_TIME_A on ZOEARCHIVE.RESIDENCE_SICK_PRICE_ITEM_A (OPERATION_TIME)
  tablespace hisarch_idx ;

create index ZOEARCHIVE.IDX_RESI_SICK_PRICE_SICK_A on ZOEARCHIVE.RESIDENCE_SICK_PRICE_ITEM_A (SICK_ID)
  tablespace hisarch_idx ;

create index ZOEARCHIVE.IDX_RESI_SICK_PRICE_SN_A on ZOEARCHIVE.RESIDENCE_SICK_PRICE_ITEM_A (SETTLE_NO)
  tablespace hisarch_idx ;

alter table ZOEARCHIVE.SICK_SETTLE_MASTER_A add constraint PK_SICK_SETTLE_MASTER_A primary key (SETTLE_NO)
  using index tablespace hisarch_idx ;

create index ZOEARCHIVE.IDX_SICK_SETTLE_MASTER_SICK_A on ZOEARCHIVE.SICK_SETTLE_MASTER_A (SICK_ID)
  tablespace hisarch_idx ;

create index ZOEARCHIVE.IDX_SICK_SETTLE_MASTER_DATE_A on ZOEARCHIVE.SICK_SETTLE_MASTER_A (SETTLE_DATE)
  tablespace hisarch_idx ;

alter table ZOEARCHIVE.SICK_SETTLE_DETAIL_A add constraint PK_SICK_SETTLE_DETAIL_A primary key (SETTLE_NO, RECEIPT_CLASS)
  using index tablespace hisarch_idx ;

alter table ZOEARCHIVE.DISPENSARY_PRESCRIP_MASTER_A add constraint PK_DISP_PRESCRIP_MASTER_A primary key (PRESCRIPTION_NUMBER)
  using index tablespace hisarch_idx ;

create index ZOEARCHIVE.IDX_DISP_PRESCRIP_SICK_A on ZOEARCHIVE.DISPENSARY_PRESCRIP_MASTER_A (SICK_ID)
  tablespace hisarch_idx ;

create index ZOEARCHIVE.IDX_DISP_PRESCRIP_MASTER_WT_A on ZOEARCHIVE.DISPENSARY_PRESCRIP_MASTER_A (WRITE_TIME)
  tablespace hisarch_idx ;

alter table ZOEARCHIVE.DISPENSARY_PRESCRIBE_DETAIL_A add constraint PK_DISP_PRESCRIBE_DETAIL_A primary key (PRESCRIPTION_NUMBER, SEQUENCE_NUMBER)
  using index tablespace hisarch_idx ;

alter table ZOEARCHIVE.DISPENSARY_SICK_PRICE_ITEM_A add constraint PK_DISP_SICK_PRICE_ITEM_A primary key (SEQUENCE_NO)
  using index tablespace hisarch_idx ;

create index ZOEARCHIVE.IDX_DISP_SICK_PRICE_SICK_A on ZOEARCHIVE.DISPENSARY_SICK_PRICE_ITEM_A (SICK_ID)
  tablespace hisarch_idx ;

create index ZOEARCHIVE.IDX_DISP_SICK_PRICE_SN_A on ZOEARCHIVE.DISPENSARY_SICK_PRICE_ITEM_A (SETTLE_NO)
  tablespace hisarch_idx ;

create index ZOEARCHIVE.IDX_DISP_SICK_PRICE_TIME_A on ZOEARCHIVE.DISPENSARY_SICK_PRICE_ITEM_A (OPERATION_TIME)
  tablespace hisarch_idx ;

alter table ZOEARCHIVE.LAY_PHYSIC_RECORDS_A add constraint PK_LAY_PHYSIC_RECORDS_A primary key (APPLY_NO, APPLY_SUB_NO)
  using index tablespace hisarch_idx ;

create index ZOEARCHIVE.IDX_LAY_PHYSIC_RECORDS_SICK_A on ZOEARCHIVE.LAY_PHYSIC_RECORDS_A (SICK_ID, VISIT_NUMBER)
  tablespace hisarch_idx ;

create index ZOEARCHIVE.IDX_LAY_PHY_REC_LAYTIME_A on ZOEARCHIVE.LAY_PHYSIC_RECORDS_A (LAY_PHYSIC_TIME)
  tablespace hisarch_idx ;