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

create table sgarchive.APPLY_SHEET_O tablespace hisarch_tab as select * from COMM.APPLY_SHEET@rmyydb WHERE 0=1;
create table sgarchive.APPLY_SHEET_DETAIL_O tablespace hisarch_tab as select * from COMM.APPLY_SHEET_DETAIL@rmyydb WHERE 0=1;
create table sgarchive.PREPAYMENT_MONEY_O tablespace hisarch_tab as select * from COMM.PREPAYMENT_MONEY@rmyydb WHERE 0=1;
create table sgarchive.PRESCRIBE_RECORD_O tablespace hisarch_tab as select * from INPSICK.PRESCRIBE_RECORD@rmyydb WHERE 0=1;
create table sgarchive.RESIDENCE_SICK_PRICE_ITEM_O tablespace hisarch_tab as select * from INPSICK.RESIDENCE_SICK_PRICE_ITEM@rmyydb WHERE 0=1;
create table sgarchive.SICK_SETTLE_MASTER_O tablespace hisarch_tab as select * from INPSICK.SICK_SETTLE_MASTER@rmyydb WHERE 0=1;
create table sgarchive.SICK_SETTLE_DETAIL_O tablespace hisarch_tab as select * from INPSICK.SICK_SETTLE_DETAIL@rmyydb WHERE 0=1;
create table sgarchive.DISPENSARY_PRESCRIP_MASTER_O tablespace hisarch_tab as select * from OUTPSICK.DISPENSARY_PRESCRIP_MASTER@rmyydb WHERE 0=1;
create table sgarchive.DISPENSARY_PRESCRIBE_DETAIL_O tablespace hisarch_tab as select * from OUTPSICK.DISPENSARY_PRESCRIBE_DETAIL@rmyydb WHERE 0=1;
create table sgarchive.DISPENSARY_SICK_PRICE_ITEM_O tablespace hisarch_tab as select * from OUTPSICK.DISPENSARY_SICK_PRICE_ITEM@rmyydb WHERE 0=1;
create table sgarchive.LAY_PHYSIC_RECORDS_O tablespace hisarch_tab as select * from PHYSIC.LAY_PHYSIC_RECORDS@rmyydb WHERE 0=1;




