-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		create_archive_table_o.sql
--	Description:
-- 		在归档数据库创建数据库归档表,包含：
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

create table COMM.APPLY_SHEET_O tablespace COMM_LONG_TAB as select * from COMM.APPLY_SHEET@zoedblink_his WHERE 0=1;
create table COMM.APPLY_SHEET_DETAIL_O tablespace COMM_LONG_TAB as select * from COMM.APPLY_SHEET_DETAIL@zoedblink_his WHERE 0=1;
create table COMM.PREPAYMENT_MONEY_O tablespace COMM_tab as select * from COMM.PREPAYMENT_MONEY@zoedblink_his WHERE 0=1;
create table INPSICK.PRESCRIBE_RECORD_O tablespace INPSICK_PRICE_LONG_TAB as select * from INPSICK.PRESCRIBE_RECORD@zoedblink_his WHERE 0=1;
create table INPSICK.RESIDENCE_SICK_PRICE_ITEM_O tablespace INPSICK_PRICE_LONG_TAB as select * from INPSICK.RESIDENCE_SICK_PRICE_ITEM@zoedblink_his WHERE 0=1;
create table INPSICK.SICK_SETTLE_MASTER_O tablespace INPSICK_tab2 as select * from INPSICK.SICK_SETTLE_MASTER@zoedblink_his WHERE 0=1;
create table INPSICK.SICK_SETTLE_DETAIL_O tablespace INPSICK_tab2 as select * from INPSICK.SICK_SETTLE_DETAIL@zoedblink_his WHERE 0=1;
create table OUTPSICK.DISPENSARY_PRESCRIP_MASTER_O tablespace OUTPSICK_PRES_LONG_TAB as select * from OUTPSICK.DISPENSARY_PRESCRIP_MASTER@zoedblink_his WHERE 0=1;
create table OUTPSICK.DISPENSARY_PRESCRIBE_DETAIL_O tablespace OUTPSICK_PRES_LONG_TAB as select * from OUTPSICK.DISPENSARY_PRESCRIBE_DETAIL@zoedblink_his WHERE 0=1;
create table OUTPSICK.DISPENSARY_SICK_PRICE_ITEM_O tablespace OUTPSICK_PRES_LONG_TAB as select * from OUTPSICK.DISPENSARY_SICK_PRICE_ITEM@zoedblink_his WHERE 0=1;
create table PHYSIC.LAY_PHYSIC_RECORDS_O tablespace PHYSIC_LAY_LONG_TAB as select * from PHYSIC.LAY_PHYSIC_RECORDS@zoedblink_his WHERE 0=1;
CREATE TABLE ZOEARCHIVE.DISPENSARY_SICK_CURE_INFO_O TABLESPACE OUTPSICK_TAB AS SELECT * FROM OUTPSICK.DISPENSARY_SICK_CURE_INFO@ZOEDBLINK_HIS WHERE 0=1;




