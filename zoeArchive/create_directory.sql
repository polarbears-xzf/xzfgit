-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		create_directory.sql
--	Description:
-- 		创建数据库归档表空间、用户并授权
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--

alter session set current_schema=zoearchive;

--在生产数据库和归档数据库创建数据库目录
create directory zoearchivedir as "PATH" ;