-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		create_dblink.sql
--	Description:
-- 		创建数据库链路
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--

alter session set current_schema=zoecheckup;

--创建运维管理数据库到检查目标库的数据库链路
	--链路命名规则：zoelink_ + 服务名 + ip后两位
create database link zoedblink_hisarch connect to zoearchive identified by zoe$2017arch using '192.168.1.1/hisarch';
create database link zoedblink_his connect to zoearchive identified by zoe$2017arch using '192.168.1.1/his';
