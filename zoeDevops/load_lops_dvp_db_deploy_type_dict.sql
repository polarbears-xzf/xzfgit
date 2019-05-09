--------------------------------------------------------
--  文件已创建 - 星期二-十月-16-2018   
--------------------------------------------------------
REM INSERTING into ZOEDEVOPS.DVP_DB_DEPLOY_TYPE_DICT
SET DEFINE OFF;
Insert into ZOEDEVOPS.DVP_DB_DEPLOY_TYPE_DICT (TYPE_ID,TYPE_NAME,CREATOR_CODE,CREATED_TIME,MODIFIER_CODE,MODIFIED_TIME) values ('1','正式库','xzf',to_date('2018-09-11 10:02:49','yyyy-mm-dd hh24:mi:ss'),null,null);
Insert into ZOEDEVOPS.DVP_DB_DEPLOY_TYPE_DICT (TYPE_ID,TYPE_NAME,CREATOR_CODE,CREATED_TIME,MODIFIER_CODE,MODIFIED_TIME) values ('2','测试库','xzf',to_date('2018-09-11 10:02:52','yyyy-mm-dd hh24:mi:ss'),null,null);
Insert into ZOEDEVOPS.DVP_DB_DEPLOY_TYPE_DICT (TYPE_ID,TYPE_NAME,CREATOR_CODE,CREATED_TIME,MODIFIER_CODE,MODIFIED_TIME) values ('3','开发库','xzf',to_date('2018-09-11 10:02:55','yyyy-mm-dd hh24:mi:ss'),null,null);
Insert into ZOEDEVOPS.DVP_DB_DEPLOY_TYPE_DICT (TYPE_ID,TYPE_NAME,CREATOR_CODE,CREATED_TIME,MODIFIER_CODE,MODIFIED_TIME) values ('4','数据维护库','xzf',to_date('2018-09-11 10:02:58','yyyy-mm-dd hh24:mi:ss'),null,null);
COMMIT;
SET DEFINE ON;

