-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		create_archive_tablespace.sql
--	Description:
-- 		在归档数据库创建数据库归档表空间，表空间按年创建。
--  Relation:
--      对象关联
--	Notes:
--		分区表创建本地索引
--	修改 - （年-月-日） - 描述
--

create tablespace hisarch_tab 
datafile '/oracle/database/dyyyarch/hisarch_tab01.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab02.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab03.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab04.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab05.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab06.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab07.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab08.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab09.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab10.ora' size 10m autoextend on next 10m maxsize 30000m
segment space management auto extent management local;

create tablespace hisarch_idx 
datafile '/oracle/database/dyyyarch/hisarch_idx01.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_idx02.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_idx03.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_idx04.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_idx05.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_idx06.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_idx07.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_idx08.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_idx09.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_idx10.ora' size 10m autoextend on next 10m maxsize 30000m
segment space management auto extent management local;


create tablespace hisarch_tab_2003 
datafile '/oracle/database/dyyyarch/hisarch_tab_2003_1.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2003_2.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2003_3.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2003_4.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2003_5.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2003_6.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2003_7.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2003_8.ora' size 10m autoextend on next 10m maxsize 30000m
segment space management auto extent management local;

create tablespace hisarch_tab_2010
datafile '/oracle/database/dyyyarch/hisarch_tab_2010_1.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2010_2.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2010_3.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2010_4.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2010_5.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2010_6.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2010_7.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2010_8.ora' size 10m autoextend on next 10m maxsize 30000m
segment space management auto extent management local;

create tablespace hisarch_tab_2011
datafile '/oracle/database/dyyyarch/hisarch_tab_2011_1.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2011_2.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2011_3.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2011_4.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2011_5.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2011_6.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2011_7.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2011_8.ora' size 10m autoextend on next 10m maxsize 30000m
segment space management auto extent management local;

create tablespace hisarch_tab_2012
datafile '/oracle/database/dyyyarch/hisarch_tab_2012_1.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2012_2.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2012_3.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2012_4.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2012_5.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2012_6.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2012_7.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2012_8.ora' size 10m autoextend on next 10m maxsize 30000m
segment space management auto extent management local;

create tablespace hisarch_tab_2013
datafile '/oracle/database/dyyyarch/hisarch_tab_2013_1.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2013_2.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2013_3.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2013_4.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2013_5.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2013_6.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2013_7.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2013_8.ora' size 10m autoextend on next 10m maxsize 30000m
segment space management auto extent management local;

create tablespace hisarch_tab_2014
datafile '/oracle/database/dyyyarch/hisarch_tab_2014_1.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2014_2.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2014_3.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2014_4.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2014_5.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2014_6.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2014_7.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2014_8.ora' size 10m autoextend on next 10m maxsize 30000m
segment space management auto extent management local;

create tablespace hisarch_tab_2015
datafile '/oracle/database/dyyyarch/hisarch_tab_2015_1.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2015_2.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2015_3.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2015_4.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2015_5.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2015_6.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2015_7.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2015_8.ora' size 10m autoextend on next 10m maxsize 30000m
segment space management auto extent management local;

create tablespace hisarch_tab_2016 
datafile '/oracle/database/dyyyarch/hisarch_tab_2016_1.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2016_2.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2016_3.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2016_4.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2016_5.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2016_6.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2016_7.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2016_8.ora' size 10m autoextend on next 10m maxsize 30000m
segment space management auto extent management local;

create tablespace hisarch_tab_2017
datafile '/oracle/database/dyyyarch/hisarch_tab_2017_1.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2017_2.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2017_3.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2017_4.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2017_5.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2017_6.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2017_7.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2017_8.ora' size 10m autoextend on next 10m maxsize 30000m
segment space management auto extent management local;

create tablespace hisarch_tab_2018
datafile '/oracle/database/dyyyarch/hisarch_tab_2018_1.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2018_2.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2018_3.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2018_4.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2018_5.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2018_6.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2018_7.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2018_8.ora' size 10m autoextend on next 10m maxsize 30000m
segment space management auto extent management local;

create tablespace hisarch_tab_2019
datafile '/oracle/database/dyyyarch/hisarch_tab_2019_1.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2019_2.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2019_3.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2019_4.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2019_5.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2019_6.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2019_7.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2019_8.ora' size 10m autoextend on next 10m maxsize 30000m
segment space management auto extent management local;

create tablespace hisarch_tab_2020
datafile '/oracle/database/dyyyarch/hisarch_tab_2020_1.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2020_2.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2020_3.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2020_4.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2020_5.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2020_6.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2020_7.ora' size 10m autoextend on next 10m maxsize 30000m,
'/oracle/database/dyyyarch/hisarch_tab_2020_8.ora' size 10m autoextend on next 10m maxsize 30000m
segment space management auto extent management local;




alter tablespace hisarch_tab_2010 nologging;
alter tablespace hisarch_tab_2011 nologging;
alter tablespace hisarch_tab_2012 nologging;
alter tablespace hisarch_tab_2013 nologging;
alter tablespace hisarch_tab_2014 nologging;
alter tablespace hisarch_tab_2015 nologging;
alter tablespace hisarch_tab_2016 nologging;
alter tablespace hisarch_tab_2017 nologging;
alter tablespace hisarch_tab_2018 nologging;
alter tablespace hisarch_tab_2019 nologging;
alter tablespace hisarch_tab_2020 nologging;
