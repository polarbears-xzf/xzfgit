-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		create_archive_table_a.sql
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

create table zoearchive.APPLY_SHEET_a
partition by range (apply_time) 
 (partition apply_sheet_2010 values less than (TO_DATE(' 2011-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2010,
 partition apply_sheet_2011 values less than (TO_DATE(' 2012-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2011,
 partition apply_sheet_2012 values less than (TO_DATE(' 2013-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2012,
 partition apply_sheet_2013 values less than (TO_DATE(' 2014-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2013,
 partition apply_sheet_2014 values less than (TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2014,
 partition apply_sheet_2015 values less than (TO_DATE(' 2016-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2015,
 partition apply_sheet_2016 values less than (TO_DATE(' 2017-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2016,
 partition apply_sheet_2017 values less than (TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2017,
 partition apply_sheet_2018 values less than (TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2018,
 partition apply_sheet_2019 values less than (TO_DATE(' 2020-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2019,
 partition apply_sheet_2020 values less than (TO_DATE(' 2021-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2020)
as select * from APPLY_SHEET@zoedblink_his where 0=1;

create table zoearchive.apply_sheet_detail_a tablespace hisarch_tab
as select * from apply_sheet_detail@zoedblink_his where 0=1;


create table zoearchive.PREPAYMENT_MONEY_a
partition by range (OPERATION_DATE) 
 (partition prepayment_money_2010 values less than (TO_DATE(' 2011-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2010,
 partition prepayment_money_2011 values less than (TO_DATE(' 2012-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2011,
 partition prepayment_money_2012 values less than (TO_DATE(' 2013-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2012,
 partition prepayment_money_2013 values less than (TO_DATE(' 2014-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2013,
 partition prepayment_money_2014 values less than (TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2014,
 partition prepayment_money_2015 values less than (TO_DATE(' 2016-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2015,
 partition prepayment_money_2016 values less than (TO_DATE(' 2017-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2016,
 partition prepayment_money_2017 values less than (TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2017,
 partition prepayment_money_2018 values less than (TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2018,
 partition prepayment_money_2019 values less than (TO_DATE(' 2020-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2019,
 partition prepayment_money_2020 values less than (TO_DATE(' 2021-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2020)
as select * from prepayment_money@zoedblink_his where 0=1;



create table zoearchive.PRESCRIBE_RECORD_a
partition by range (PRESCRIBE_TIME) 
 (partition prescribe_record_2010 values less than (TO_DATE(' 2011-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2010,
 partition prescribe_record_2011 values less than (TO_DATE(' 2012-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2011,
 partition prescribe_record_2012 values less than (TO_DATE(' 2013-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2012,
 partition prescribe_record_2013 values less than (TO_DATE(' 2014-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2013,
 partition prescribe_record_2014 values less than (TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2014,
 partition prescribe_record_2015 values less than (TO_DATE(' 2016-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2015,
 partition prescribe_record_2016 values less than (TO_DATE(' 2017-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2016,
 partition prescribe_record_2017 values less than (TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2017,
 partition prescribe_record_2018 values less than (TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2018,
 partition prescribe_record_2019 values less than (TO_DATE(' 2020-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2019,
 partition prescribe_record_2020 values less than (TO_DATE(' 2021-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2020)
as select * from PRESCRIBE_RECORD@zoedblink_his where 0=1;





create table zoearchive.dispensary_sick_price_item_a
partition by range (operation_time) 
 (partition disp_sick_price_item_2010 values less than (TO_DATE(' 2011-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2010,
 partition disp_sick_price_item_2011 values less than (TO_DATE(' 2012-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2011,
 partition disp_sick_price_item_2012 values less than (TO_DATE(' 2013-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2012,
 partition disp_sick_price_item_2013 values less than (TO_DATE(' 2014-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2013,
 partition disp_sick_price_item_2014 values less than (TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2014,
 partition disp_sick_price_item_2015 values less than (TO_DATE(' 2016-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2015,
 partition disp_sick_price_item_2016 values less than (TO_DATE(' 2017-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2016,
 partition disp_sick_price_item_2017 values less than (TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2017,
 partition disp_sick_price_item_2018 values less than (TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2018,
 partition disp_sick_price_item_2019 values less than (TO_DATE(' 2020-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2019,
 partition disp_sick_price_item_2020 values less than (TO_DATE(' 2021-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2020)
as select * from dispensary_sick_price_item@zoedblink_his where 0=1;


create table zoearchive.RESIDENCE_SICK_PRICE_ITEM_a
partition by range (OPERATION_TIME) 
 (partition resi_sick_price_item_2010 values less than (TO_DATE(' 2011-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2010,
 partition resi_sick_price_item_2011 values less than (TO_DATE(' 2012-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2011,
 partition resi_sick_price_item_2012 values less than (TO_DATE(' 2013-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2012,
 partition resi_sick_price_item_2013 values less than (TO_DATE(' 2014-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2013,
 partition resi_sick_price_item_2014 values less than (TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2014,
 partition resi_sick_price_item_2015 values less than (TO_DATE(' 2016-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2015,
 partition resi_sick_price_item_2016 values less than (TO_DATE(' 2017-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2016,
 partition resi_sick_price_item_2017 values less than (TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2017,
 partition resi_sick_price_item_2018 values less than (TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2018,
 partition resi_sick_price_item_2019 values less than (TO_DATE(' 2020-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2019,
 partition resi_sick_price_item_2020 values less than (TO_DATE(' 2021-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2020)
as select * from RESIDENCE_SICK_PRICE_ITEM@zoedblink_his where 0=1;


create table zoearchive.SICK_SETTLE_MASTER_a
partition by range (SETTLE_DATE) 
 (partition sick_settle_master_2010 values less than (TO_DATE(' 2011-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2010,
 partition sick_settle_master_2011 values less than (TO_DATE(' 2012-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2011,
 partition sick_settle_master_2012 values less than (TO_DATE(' 2013-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2012,
 partition sick_settle_master_2013 values less than (TO_DATE(' 2014-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2013,
 partition sick_settle_master_2014 values less than (TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2014,
 partition sick_settle_master_2015 values less than (TO_DATE(' 2016-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2015,
 partition sick_settle_master_2016 values less than (TO_DATE(' 2017-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2016,
 partition sick_settle_master_2017 values less than (TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2017,
 partition sick_settle_master_2018 values less than (TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2018,
 partition sick_settle_master_2019 values less than (TO_DATE(' 2020-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2019,
 partition sick_settle_master_2020 values less than (TO_DATE(' 2021-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2020)
as select * from sick_settle_master@zoedblink_his where 0=1;

create table zoearchive.sick_settle_DETAIL_a tablespace hisarch_tab
as select * from sick_settle_DETAIL@zoedblink_his where 0=1;

create table zoearchive.DISPENSARY_PRESCRIP_MASTER_a
partition by range (WRITE_TIME) 
 (partition disp_prescrip_master_2010 values less than (TO_DATE(' 2011-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2010,
 partition disp_prescrip_master_2011 values less than (TO_DATE(' 2012-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2011,
 partition disp_prescrip_master_2012 values less than (TO_DATE(' 2013-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2012,
 partition disp_prescrip_master_2013 values less than (TO_DATE(' 2014-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2013,
 partition disp_prescrip_master_2014 values less than (TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2014,
 partition disp_prescrip_master_2015 values less than (TO_DATE(' 2016-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2015,
 partition disp_prescrip_master_2016 values less than (TO_DATE(' 2017-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2016,
 partition disp_prescrip_master_2017 values less than (TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2017,
 partition disp_prescrip_master_2018 values less than (TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2018,
 partition disp_prescrip_master_2019 values less than (TO_DATE(' 2020-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2019,
 partition disp_prescrip_master_2020 values less than (TO_DATE(' 2021-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2020)
as select * from DISPENSARY_PRESCRIP_MASTER@zoedblink_his where 0=1;

create table zoearchive.DISPENSARY_PRESCRIBE_DETAIL_a tablespace hisarch_tab
as select * from DISPENSARY_PRESCRIBE_DETAIL@zoedblink_his where 0=1;

create table zoearchive.LAY_PHYSIC_RECORDS_a
partition by range (MODIFY_TIME) 
 (partition lay_physic_records_2010 values less than (TO_DATE(' 2011-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2010,
 partition lay_physic_records_2011 values less than (TO_DATE(' 2012-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2011,
 partition lay_physic_records_2012 values less than (TO_DATE(' 2013-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2012,
 partition lay_physic_records_2013 values less than (TO_DATE(' 2014-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2013,
 partition lay_physic_records_2014 values less than (TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2014,
 partition lay_physic_records_2015 values less than (TO_DATE(' 2016-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2015,
 partition lay_physic_records_2016 values less than (TO_DATE(' 2017-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2016,
 partition lay_physic_records_2017 values less than (TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE hisarch_tab_2017,
 partition lay_physic_records_2018 values less than (TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2018,
 partition lay_physic_records_2019 values less than (TO_DATE(' 2020-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2019,
 partition lay_physic_records_2020 values less than (TO_DATE(' 2021-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE hisarch_tab_2020)
as select * from LAY_PHYSIC_RECORDS@zoedblink_his where 0=1;


create table zoearchive.dispensary_sick_cure_info_a tablespace hisarch_tab
as select * from dispensary_sick_cure_info@zoedblink_his where 0=1;


