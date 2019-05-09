--------------------------------------------------------
--  文件已创建 - 星期二-十月-16-2018   
--------------------------------------------------------
REM INSERTING into ZOEDEVOPS.DVP_DB_ROLE_DICT
SET DEFINE OFF;
Insert into ZOEDEVOPS.DVP_DB_ROLE_DICT (ROLE_ID,ROLE_NAME,CREATOR_CODE,CREATED_TIME,MODIFIER_CODE,MODIFIED_TIME) values ('2','智慧医院主数据库','xzf',to_date('2018-09-11 10:04:02','yyyy-mm-dd hh24:mi:ss'),null,null);
Insert into ZOEDEVOPS.DVP_DB_ROLE_DICT (ROLE_ID,ROLE_NAME,CREATOR_CODE,CREATED_TIME,MODIFIER_CODE,MODIFIED_TIME) values ('3','智慧医院数据中心库','xzf',to_date('2018-09-11 10:04:05','yyyy-mm-dd hh24:mi:ss'),null,null);
Insert into ZOEDEVOPS.DVP_DB_ROLE_DICT (ROLE_ID,ROLE_NAME,CREATOR_CODE,CREATED_TIME,MODIFIER_CODE,MODIFIED_TIME) values ('1','运维管理数据库','xzf',to_date('2018-09-11 00:00:00','yyyy-mm-dd hh24:mi:ss'),null,null);
COMMIT;
SET DEFINE ON;
