-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		create_archive_table_a.sql
--	Description:
-- 		在归档数据库创建数据库归档表,包含：
--      --
--      --
--      --
--      --
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--

create table zoearchive.ZEMR_EMR_CONTENT_A
partition by range (CREATE_DATE) 
 (partition ZEMR_EMR_CONTENT_2010 values less than (TO_DATE(' 2011-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2010,
 partition ZEMR_EMR_CONTENT_2011 values less than (TO_DATE(' 2012-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2011,
 partition ZEMR_EMR_CONTENT_2012 values less than (TO_DATE(' 2013-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2012,
 partition ZEMR_EMR_CONTENT_2013 values less than (TO_DATE(' 2014-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2013,
 partition ZEMR_EMR_CONTENT_2014 values less than (TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2014,
 partition ZEMR_EMR_CONTENT_2015 values less than (TO_DATE(' 2016-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2015,
 partition ZEMR_EMR_CONTENT_2016 values less than (TO_DATE(' 2017-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2016,
 partition ZEMR_EMR_CONTENT_2017 values less than (TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2017,
 partition ZEMR_EMR_CONTENT_2018 values less than (TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2018,
 partition ZEMR_EMR_CONTENT_2019 values less than (TO_DATE(' 2020-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2019,
 partition ZEMR_EMR_CONTENT_2020 values less than (TO_DATE(' 2021-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2020)
as select * from ZEMR.ZEMR_EMR_CONTENT@zoedblink_emr where 0=1;

create table zoearchive.ZEMR_STD_PATIENT_INFO_DOMAIN_A
partition by range (CREATE_TIME) 
 (partition ZEMR_STD_PATIENT_DOMAIN_2010 values less than (TO_DATE(' 2011-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2010,
 partition ZEMR_STD_PATIENT_DOMAIN_2011 values less than (TO_DATE(' 2012-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2011,
 partition ZEMR_STD_PATIENT_DOMAIN_2012 values less than (TO_DATE(' 2013-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2012,
 partition ZEMR_STD_PATIENT_DOMAIN_2013 values less than (TO_DATE(' 2014-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2013,
 partition ZEMR_STD_PATIEN_DOMAIN_2014 values less than (TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2014,
 partition ZEMR_STD_PATIENT_DOMAIN_2015 values less than (TO_DATE(' 2016-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2015,
 partition ZEMR_STD_PATIENT_DOMAIN_2016 values less than (TO_DATE(' 2017-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2016,
 partition ZEMR_STD_PATIENT_DOMAIN_2017 values less than (TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2017,
 partition ZEMR_STD_PATIENT_DOMAIN_2018 values less than (TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2018,
 partition ZEMR_STD_PATIENT_DOMAIN_2019 values less than (TO_DATE(' 2020-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2019,
 partition ZEMR_STD_PATIENT_DOMAIN_2020 values less than (TO_DATE(' 2021-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2020)
as select * from ZEMR.ZEMR_STD_PATIENT_INFO_DOMAIN@zoedblink_emr where 0=1;

create table zoearchive.ZEMR_NURSE_MASTER_A
partition by range (NURSE_TIME) 
 (partition ZEMR_NURSE_MASTER_2010 values less than (TO_DATE(' 2011-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2010,
 partition ZEMR_NURSE_MASTER_2011 values less than (TO_DATE(' 2012-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2011,
 partition ZEMR_NURSE_MASTER_2012 values less than (TO_DATE(' 2013-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2012,
 partition ZEMR_NURSE_MASTER_2013 values less than (TO_DATE(' 2014-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2013,
 partition ZEMR_NURSE_MASTER_2014 values less than (TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2014,
 partition ZEMR_NURSE_MASTER_2015 values less than (TO_DATE(' 2016-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2015,
 partition ZEMR_NURSE_MASTER_2016 values less than (TO_DATE(' 2017-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2016,
 partition ZEMR_NURSE_MASTER_2017 values less than (TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2017,
 partition ZEMR_NURSE_MASTER_2018 values less than (TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2018,
 partition ZEMR_NURSE_MASTER_2019 values less than (TO_DATE(' 2020-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2019,
 partition ZEMR_NURSE_MASTER_2020 values less than (TO_DATE(' 2021-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2020)
as select * from ZEMR.ZEMR_NURSE_MASTER@zoedblink_emr where 0=1;

create table zoearchive.ZEMR_NURSE_MASTER_ARCHIVE_A
partition by range (NURSE_TIME) 
 (partition ZEMR_NURSE_MASTER_ARC_2010 values less than (TO_DATE(' 2011-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2010,
 partition ZEMR_NURSE_MASTER_ARC_2011 values less than (TO_DATE(' 2012-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2011,
 partition ZEMR_NURSE_MASTER_ARC_2012 values less than (TO_DATE(' 2013-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2012,
 partition ZEMR_NURSE_MASTER_ARC_2013 values less than (TO_DATE(' 2014-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2013,
 partition ZEMR_NURSE_MASTER_ARC_2014 values less than (TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2014,
 partition ZEMR_NURSE_MASTER_ARC_2015 values less than (TO_DATE(' 2016-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2015,
 partition ZEMR_NURSE_MASTER_ARC_2016 values less than (TO_DATE(' 2017-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2016,
 partition ZEMR_NURSE_MASTER_ARC_2017 values less than (TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2017,
 partition ZEMR_NURSE_MASTER_ARC_2018 values less than (TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2018,
 partition ZEMR_NURSE_MASTER_ARC_2019 values less than (TO_DATE(' 2020-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2019,
 partition ZEMR_NURSE_MASTER_ARC_2020 values less than (TO_DATE(' 2021-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2020)
as select * from ZEMR.ZEMR_NURSE_MASTER_ARCHIVE@zoedblink_emr where 0=1;


create table zoearchive.ZEMR_NURSE_DETAIL_A
partition by range (NURSE_TIME) 
 (partition ZEMR_NURSE_DETAIL_2010 values less than (TO_DATE(' 2011-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2010,
 partition ZEMR_NURSE_DETAIL_2011 values less than (TO_DATE(' 2012-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2011,
 partition ZEMR_NURSE_DETAIL_2012 values less than (TO_DATE(' 2013-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2012,
 partition ZEMR_NURSE_DETAIL_2013 values less than (TO_DATE(' 2014-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2013,
 partition ZEMR_NURSE_DETAIL_2014 values less than (TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2014,
 partition ZEMR_NURSE_DETAIL_2015 values less than (TO_DATE(' 2016-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2015,
 partition ZEMR_NURSE_DETAIL_2016 values less than (TO_DATE(' 2017-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2016,
 partition ZEMR_NURSE_DETAIL_2017 values less than (TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2017,
 partition ZEMR_NURSE_DETAIL_2018 values less than (TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2018,
 partition ZEMR_NURSE_DETAIL_2019 values less than (TO_DATE(' 2020-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2019,
 partition ZEMR_NURSE_DETAIL_2020 values less than (TO_DATE(' 2021-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2020)
as select * from ZEMR.ZEMR_NURSE_DETAIL@zoedblink_emr where 0=1;

create table zoearchive.ZEMR_NURSE_DETAIL_ARCHIVE_A
partition by range (NURSE_TIME) 
 (partition ZEMR_NURSE_DETAIL_ARC_2010 values less than (TO_DATE(' 2011-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2010,
 partition ZEMR_NURSE_DETAIL_ARC_2011 values less than (TO_DATE(' 2012-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2011,
 partition ZEMR_NURSE_DETAIL_ARC_2012 values less than (TO_DATE(' 2013-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2012,
 partition ZEMR_NURSE_DETAIL_ARC_2013 values less than (TO_DATE(' 2014-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2013,
 partition ZEMR_NURSE_DETAIL_ARC_2014 values less than (TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2014,
 partition ZEMR_NURSE_DETAIL_ARC_2015 values less than (TO_DATE(' 2016-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2015,
 partition ZEMR_NURSE_DETAIL_ARC_2016 values less than (TO_DATE(' 2017-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2016,
 partition ZEMR_NURSE_DETAIL_ARC_2017 values less than (TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2017,
 partition ZEMR_NURSE_DETAIL_ARC_2018 values less than (TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2018,
 partition ZEMR_NURSE_DETAIL_ARC_2019 values less than (TO_DATE(' 2020-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2019,
 partition ZEMR_NURSE_DETAIL_ARC_2020 values less than (TO_DATE(' 2021-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2020)
as select * from ZEMR.ZEMR_NURSE_DETAIL_ARCHIVE@zoedblink_emr where 0=1;


create table zoearchive.ZEMR_EMR_PRINTLOG_A
partition by range (PRINT_TIME) 
 (partition ZEMR_EMR_PRINTLOG_2010 values less than (TO_DATE(' 2011-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2010,
 partition ZEMR_EMR_PRINTLOG_2011 values less than (TO_DATE(' 2012-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2011,
 partition ZEMR_EMR_PRINTLOG_2012 values less than (TO_DATE(' 2013-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2012,
 partition ZEMR_EMR_PRINTLOG_2013 values less than (TO_DATE(' 2014-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2013,
 partition ZEMR_EMR_PRINTLOG_2014 values less than (TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2014,
 partition ZEMR_EMR_PRINTLOG_2015 values less than (TO_DATE(' 2016-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2015,
 partition ZEMR_EMR_PRINTLOG_2016 values less than (TO_DATE(' 2017-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2016,
 partition ZEMR_EMR_PRINTLOG_2017 values less than (TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2017,
 partition ZEMR_EMR_PRINTLOG_2018 values less than (TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2018,
 partition ZEMR_EMR_PRINTLOG_2019 values less than (TO_DATE(' 2020-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2019,
 partition ZEMR_EMR_PRINTLOG_2020 values less than (TO_DATE(' 2021-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2020)
as select * from ZEMR.ZEMR_EMR_PRINTLOG@zoedblink_emr where 0=1;


create table zoearchive.ZEMR_EMR_SIGNATURE_A
partition by range (SIGN_DATE) 
 (partition ZEMR_EMR_SIGNATURE_2010 values less than (TO_DATE(' 2011-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2010,
 partition ZEMR_EMR_SIGNATURE_2011 values less than (TO_DATE(' 2012-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2011,
 partition ZEMR_EMR_SIGNATURE_2012 values less than (TO_DATE(' 2013-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2012,
 partition ZEMR_EMR_SIGNATURE_2013 values less than (TO_DATE(' 2014-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2013,
 partition ZEMR_EMR_SIGNATURE_2014 values less than (TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2014,
 partition ZEMR_EMR_SIGNATURE_2015 values less than (TO_DATE(' 2016-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2015,
 partition ZEMR_EMR_SIGNATURE_2016 values less than (TO_DATE(' 2017-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2016,
 partition ZEMR_EMR_SIGNATURE_2017 values less than (TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2017,
 partition ZEMR_EMR_SIGNATURE_2018 values less than (TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2018,
 partition ZEMR_EMR_SIGNATURE_2019 values less than (TO_DATE(' 2020-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2019,
 partition ZEMR_EMR_SIGNATURE_2020 values less than (TO_DATE(' 2021-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2020)
as select * from ZEMR.ZEMR_EMR_SIGNATURE@zoedblink_emr where 0=1;

create table zoearchive.ZEMR_NURSE_TEMP_ARCHIVE_A
partition by range (CREATE_TIME) 
 (partition ZEMR_NURSE_TEMP_ARCHIVE_2010 values less than (TO_DATE(' 2011-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2010,
 partition ZEMR_NURSE_TEMP_ARCHIVE_2011 values less than (TO_DATE(' 2012-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2011,
 partition ZEMR_NURSE_TEMP_ARCHIVE_2012 values less than (TO_DATE(' 2013-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2012,
 partition ZEMR_NURSE_TEMP_ARCHIVE_2013 values less than (TO_DATE(' 2014-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2013,
 partition ZEMR_NURSE_TEMP_ARCHIVE_2014 values less than (TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2014,
 partition ZEMR_NURSE_TEMP_ARCHIVE_2015 values less than (TO_DATE(' 2016-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2015,
 partition ZEMR_NURSE_TEMP_ARCHIVE_2016 values less than (TO_DATE(' 2017-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2016,
 partition ZEMR_NURSE_TEMP_ARCHIVE_2017 values less than (TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2017,
 partition ZEMR_NURSE_TEMP_ARCHIVE_2018 values less than (TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2018,
 partition ZEMR_NURSE_TEMP_ARCHIVE_2019 values less than (TO_DATE(' 2020-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2019,
 partition ZEMR_NURSE_TEMP_ARCHIVE_2020 values less than (TO_DATE(' 2021-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2020)
as select * from ZEMR.ZEMR_NURSE_TEMP_ARCHIVE@zoedblink_emr where 0=1;

create table zoearchive.ZEMR_TEMP_POINT_RECORD_A
partition by range (DATE_TIME) 
 (partition ZEMR_TEMP_POINT_RECORD_2010 values less than (TO_DATE(' 2011-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2010,
 partition ZEMR_TEMP_POINT_RECORD_2011 values less than (TO_DATE(' 2012-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2011,
 partition ZEMR_TEMP_POINT_RECORD_2012 values less than (TO_DATE(' 2013-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2012,
 partition ZEMR_TEMP_POINT_RECORD_2013 values less than (TO_DATE(' 2014-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2013,
 partition ZEMR_TEMP_POINT_RECORD_2014 values less than (TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2014,
 partition ZEMR_TEMP_POINT_RECORD_2015 values less than (TO_DATE(' 2016-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2015,
 partition ZEMR_TEMP_POINT_RECORD_2016 values less than (TO_DATE(' 2017-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2016,
 partition ZEMR_TEMP_POINT_RECORD_2017 values less than (TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2017,
 partition ZEMR_TEMP_POINT_RECORD_2018 values less than (TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2018,
 partition ZEMR_TEMP_POINT_RECORD_2019 values less than (TO_DATE(' 2020-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2019,
 partition ZEMR_TEMP_POINT_RECORD_2020 values less than (TO_DATE(' 2021-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2020)
as select * from ZEMR.ZEMR_TEMPERATURE_POINT_RECORD@zoedblink_emr where 0=1;

create table zoearchive.ZEMR_TEMPERATURE_FEVER_A
partition by range (FEVER_DATE) 
 (partition ZEMR_TEMPERATURE_FEVER_2010 values less than (TO_DATE(' 2011-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2010,
 partition ZEMR_TEMPERATURE_FEVER_2011 values less than (TO_DATE(' 2012-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2011,
 partition ZEMR_TEMPERATURE_FEVER_2012 values less than (TO_DATE(' 2013-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2012,
 partition ZEMR_TEMPERATURE_FEVER_2013 values less than (TO_DATE(' 2014-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2013,
 partition ZEMR_TEMPERATURE_FEVER_2014 values less than (TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2014,
 partition ZEMR_TEMPERATURE_FEVER_2015 values less than (TO_DATE(' 2016-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2015,
 partition ZEMR_TEMPERATURE_FEVER_2016 values less than (TO_DATE(' 2017-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2016,
 partition ZEMR_TEMPERATURE_FEVER_2017 values less than (TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2017,
 partition ZEMR_TEMPERATURE_FEVER_2018 values less than (TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2018,
 partition ZEMR_TEMPERATURE_FEVER_2019 values less than (TO_DATE(' 2020-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2019,
 partition ZEMR_TEMPERATURE_FEVER_2020 values less than (TO_DATE(' 2021-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2020)
as select * from ZEMR.ZEMR_TEMPERATURE_FEVER@zoedblink_emr where 0=1;

create table zoearchive.ZEMR_TEMP_ENTIRE_RECORD_A
partition by range (IN_TIME) 
 (partition ZEMR_TEMP_ENTIRE_RECORD_2010 values less than (TO_DATE(' 2011-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2010,
 partition ZEMR_TEMP_ENTIRE_RECORD_2011 values less than (TO_DATE(' 2012-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2011,
 partition ZEMR_TEMP_ENTIRE_RECORD_2012 values less than (TO_DATE(' 2013-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2012,
 partition ZEMR_TEMP_ENTIRE_RECORD_2013 values less than (TO_DATE(' 2014-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2013,
 partition ZEMR_TEMP_ENTIRE_RECORD_2014 values less than (TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2014,
 partition ZEMR_TEMP_ENTIRE_RECORD_2015 values less than (TO_DATE(' 2016-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2015,
 partition ZEMR_TEMP_ENTIRE_RECORD_2016 values less than (TO_DATE(' 2017-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2016,
 partition ZEMR_TEMP_ENTIRE_RECORD_2017 values less than (TO_DATE(' 2018-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS')) 
           TABLESPACE emrarch_tab_2017,
 partition ZEMR_TEMP_ENTIRE_RECORD_2018 values less than (TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2018,
 partition ZEMR_TEMP_ENTIRE_RECORD_2019 values less than (TO_DATE(' 2020-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2019,
 partition ZEMR_TEMP_ENTIRE_RECORD_2020 values less than (TO_DATE(' 2021-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS'))
           TABLESPACE emrarch_tab_2020)
as select * from ZEMR.ZEMR_TEMPERATURE_ENTIRE_RECORD@zoedblink_emr where 0=1;

create table zoearchive.ZEMR_PATIENT_DIAGNOSIS_A tablespace emrarch_tab
as select * from ZEMR.ZEMR_PATIENT_DIAGNOSIS@zoedblink_emr where 0=1;

create table zoearchive.ZEMR_PATIENT_OPERATION_A tablespace emrarch_tab
as select * from ZEMR.ZEMR_PATIENT_OPERATION@zoedblink_emr where 0=1;

create table zoearchive.ZEMR_NURSESTAT_DETAIL_A tablespace emrarch_tab
as select * from ZEMR.ZEMR_NURSESTAT_DETAIL@zoedblink_emr where 0=1;

create table zoearchive.ZEMR_NURSE_BABY_MASTER_A tablespace emrarch_tab
as select * from ZEMR.ZEMR_NURSE_BABY_MASTER@zoedblink_emr where 0=1;

create table zoearchive.ZEMR_NURSE_PATIENT_INFO_A tablespace emrarch_tab
as select * from ZEMR.ZEMR_NURSE_PATIENT_INFO@zoedblink_emr where 0=1;

create table zoearchive.ZEMR_TEMPERATURE_DAY_RECORD_A tablespace emrarch_tab
as select * from ZEMR.ZEMR_TEMPERATURE_DAY_RECORD@zoedblink_emr where 0=1;

create table zoearchive.ZEMR_TEMPERATURE_WEEK_EMR_A tablespace emrarch_tab
as select * from ZEMR.ZEMR_TEMPERATURE_WEEK_EMR@zoedblink_emr where 0=1;

create table zoearchive.ZEMR_BABYTP_RECORD_A tablespace emrarch_tab
as select * from ZEMR.ZEMR_BABYTP_RECORD@zoedblink_emr where 0=1;

create table zoearchive.ZQC_TIME_RULE_RECORD_A tablespace emrarch_tab
as select * from ZEMR.ZQC_TIME_RULE_RECORD@zoedblink_emr where 0=1;

create table zoearchive.ZEMR_REGISTER_EVENT_RECORD_A tablespace emrarch_tab
as select * from ZEMR.ZEMR_REGISTER_EVENT_RECORD@zoedblink_emr where 0=1;






