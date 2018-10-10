-- Created in 2018.06.03 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		load_data.sql
--	Description:
-- 		加载数据库归档系统相关表数据
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--

SET DEFINE OFF;
/*==============================================================*/
/* Table: ARC_APPLACTION_SYSTEM_DICT                            */
/*==============================================================*/
Insert into ZOEARCHIVE.ARC_APPLACTION_SYSTEM_DICT (SYSTEM_CODE,SYSTEM_NAME) values ('1','HIS');
Insert into ZOEARCHIVE.ARC_APPLACTION_SYSTEM_DICT (SYSTEM_CODE,SYSTEM_NAME) values ('2','电子病历');

/*==============================================================*/
/* Table: ARC_DATA_TYPE_DICT                                    */
/*==============================================================*/
Insert into ZOEARCHIVE.ARC_DATA_TYPE_DICT (DATE_TYPE_CODE,DATE_TYPE_NAME) values ('1','日志数据');
Insert into ZOEARCHIVE.ARC_DATA_TYPE_DICT (DATE_TYPE_CODE,DATE_TYPE_NAME) values ('2','业务数据');

/*==============================================================*/
/* Table: ARC_OBJECT_INFO                                       */
/*==============================================================*/
Insert into ZOEARCHIVE.ARC_OBJECT_INFO (OWNER,TABLE_NAME,TABLE_CHN_NAME,APPLICATION_SYSTEM_CODE,DATA_TYPE_CODE,PROOF_CODE) values ('ZEMR','ZEMR_EMR_CONTENT','电子病历表','2','2','255B884475BA6B71A5357D63064A5845D208AEDA');
Insert into ZOEARCHIVE.ARC_OBJECT_INFO (OWNER,TABLE_NAME,TABLE_CHN_NAME,APPLICATION_SYSTEM_CODE,DATA_TYPE_CODE,PROOF_CODE) values ('ZEMR','ZEMR_STD_PATIENT_INFO_DOMAIN','病人结构化信息自动域表','2','2','3A1C920EC5C3FC697EF79C6BE0A83F6E9E25CBDD');
Insert into ZOEARCHIVE.ARC_OBJECT_INFO (OWNER,TABLE_NAME,TABLE_CHN_NAME,APPLICATION_SYSTEM_CODE,DATA_TYPE_CODE,PROOF_CODE) values ('ZEMR','ZEMR_NURSE_MASTER','结构化护理记录信息表','2','2','B05EF2F5B5F25EF245C662547E09636FFF5DBBFD');
Insert into ZOEARCHIVE.ARC_OBJECT_INFO (OWNER,TABLE_NAME,TABLE_CHN_NAME,APPLICATION_SYSTEM_CODE,DATA_TYPE_CODE,PROOF_CODE) values ('ZEMR','ZEMR_NURSE_MASTER_ARCHIVE','结构化护理记录信息表-归档','2','2','D5B5ED62EB6A1854EFE69BCA35653C30AA547DEE');
Insert into ZOEARCHIVE.ARC_OBJECT_INFO (OWNER,TABLE_NAME,TABLE_CHN_NAME,APPLICATION_SYSTEM_CODE,DATA_TYPE_CODE,PROOF_CODE) values ('ZEMR','ZEMR_NURSE_DETAIL','护理记录细表','2','2','655218DA3292053867E1B9ED39A613884241C08E');
Insert into ZOEARCHIVE.ARC_OBJECT_INFO (OWNER,TABLE_NAME,TABLE_CHN_NAME,APPLICATION_SYSTEM_CODE,DATA_TYPE_CODE,PROOF_CODE) values ('ZEMR','ZEMR_NURSE_DETAIL_ARCHIVE','护理记录细表-归档','2','2','47C985409D76821F7D44B0B817B77175C3573263');
Insert into ZOEARCHIVE.ARC_OBJECT_INFO (OWNER,TABLE_NAME,TABLE_CHN_NAME,APPLICATION_SYSTEM_CODE,DATA_TYPE_CODE,PROOF_CODE) values ('ZEMR','ZEMR_EMR_PRINTLOG','打印日志表','2','2','657F8C2BBA0F6CCABC701C51A5929B9069B5D035');
Insert into ZOEARCHIVE.ARC_OBJECT_INFO (OWNER,TABLE_NAME,TABLE_CHN_NAME,APPLICATION_SYSTEM_CODE,DATA_TYPE_CODE,PROOF_CODE) values ('ZEMR','ZEMR_NURSE_TEMP_ARCHIVE','第三方护理记录生成中间表','2','2','3A2979905C19BAE0CFED159835CB9C3740739FFA');
Insert into ZOEARCHIVE.ARC_OBJECT_INFO (OWNER,TABLE_NAME,TABLE_CHN_NAME,APPLICATION_SYSTEM_CODE,DATA_TYPE_CODE,PROOF_CODE) values ('ZEMR','ZEMR_TEMPERATURE_POINT_RECORD','体温单点数据','2','2','00691557F986E766F8D918CE003DF4DF9643E349');
Insert into ZOEARCHIVE.ARC_OBJECT_INFO (OWNER,TABLE_NAME,TABLE_CHN_NAME,APPLICATION_SYSTEM_CODE,DATA_TYPE_CODE,PROOF_CODE) values ('ZEMR','ZEMR_TEMPERATURE_FEVER','病人发热记录表','2','2','1B43E6572E103279F541A19502077686C4C3DA12');
Insert into ZOEARCHIVE.ARC_OBJECT_INFO (OWNER,TABLE_NAME,TABLE_CHN_NAME,APPLICATION_SYSTEM_CODE,DATA_TYPE_CODE,PROOF_CODE) values ('ZEMR','ZEMR_TEMPERATURE_ENTIRE_RECORD',null,'2','2','549883B334692F03E8379163F33469B97E31E736');
Insert into ZOEARCHIVE.ARC_OBJECT_INFO (OWNER,TABLE_NAME,TABLE_CHN_NAME,APPLICATION_SYSTEM_CODE,DATA_TYPE_CODE,PROOF_CODE) values ('ZEMR','ZEMR_PATIENT_DIAGNOSIS','病人诊断信息表','2','2','F6F28DC26C6CF9AB4C8F9CF54CDCA5ECF6E09796');
Insert into ZOEARCHIVE.ARC_OBJECT_INFO (OWNER,TABLE_NAME,TABLE_CHN_NAME,APPLICATION_SYSTEM_CODE,DATA_TYPE_CODE,PROOF_CODE) values ('ZEMR','ZEMR_PATIENT_OPERATION','病人手术记录表','2','2','09073ECD8A32E2E8E76775F8CF3E5E30AC76F6E2');
Insert into ZOEARCHIVE.ARC_OBJECT_INFO (OWNER,TABLE_NAME,TABLE_CHN_NAME,APPLICATION_SYSTEM_CODE,DATA_TYPE_CODE,PROOF_CODE) values ('ZEMR','ZEMR_NURSESTAT_DETAIL','护理统计出入量细表','2','2','7ADB9B0C1F721BD43921DA731A0108FBC6704B94');
Insert into ZOEARCHIVE.ARC_OBJECT_INFO (OWNER,TABLE_NAME,TABLE_CHN_NAME,APPLICATION_SYSTEM_CODE,DATA_TYPE_CODE,PROOF_CODE) values ('ZEMR','ZEMR_NURSE_BABY_MASTER','婴儿护理记录表','2','2','3A1ECF2B45927A0CAEE38DFA58CE0CFF565AD409');
Insert into ZOEARCHIVE.ARC_OBJECT_INFO (OWNER,TABLE_NAME,TABLE_CHN_NAME,APPLICATION_SYSTEM_CODE,DATA_TYPE_CODE,PROOF_CODE) values ('ZEMR','ZEMR_NURSE_PATIENT_INFO','护理记录题头信息表','2','2','B7DCBE6C4B8F9C40CBE692E2EF9399B4D71C60F3');
Insert into ZOEARCHIVE.ARC_OBJECT_INFO (OWNER,TABLE_NAME,TABLE_CHN_NAME,APPLICATION_SYSTEM_CODE,DATA_TYPE_CODE,PROOF_CODE) values ('ZEMR','ZEMR_TEMPERATURE_DAY_RECORD','体温单天数据','2','2','5FDB88C6AA99EEB33D9B3E01762917818DE18BCF');
Insert into ZOEARCHIVE.ARC_OBJECT_INFO (OWNER,TABLE_NAME,TABLE_CHN_NAME,APPLICATION_SYSTEM_CODE,DATA_TYPE_CODE,PROOF_CODE) values ('ZEMR','ZEMR_TEMPERATURE_WEEK_EMR','体温单关联病历表','2','2','922F020222F08A3B0B7A29D2C1BFE01C37785BFA');
Insert into ZOEARCHIVE.ARC_OBJECT_INFO (OWNER,TABLE_NAME,TABLE_CHN_NAME,APPLICATION_SYSTEM_CODE,DATA_TYPE_CODE,PROOF_CODE) values ('ZEMR','ZEMR_BABYTP_RECORD','婴儿体温单数据表','2','2','9C1BF05F0F135F1F149EC5671005A7A667925D1E');
Insert into ZOEARCHIVE.ARC_OBJECT_INFO (OWNER,TABLE_NAME,TABLE_CHN_NAME,APPLICATION_SYSTEM_CODE,DATA_TYPE_CODE,PROOF_CODE) values ('ZEMR','ZQC_TIME_RULE_RECORD','超时质控规则执行记录信息','2','2','BF876AD37B63F5C756F409DB9D372CD080F1594D');
Insert into ZOEARCHIVE.ARC_OBJECT_INFO (OWNER,TABLE_NAME,TABLE_CHN_NAME,APPLICATION_SYSTEM_CODE,DATA_TYPE_CODE,PROOF_CODE) values ('ZEMR','ZEMR_REGISTER_EVENT_RECORD','时限质控事件登记表','2','2','6E236DC7DD849873A095F0F57B6ABDE013A6673B');


/*==============================================================*/
/* Table: ARC_PROCESS_TASK                                       */
/*==============================================================*/
Insert into ZOEARCHIVE.ARC_PROCESS_TASK (TASK_ID,TASK_NAME,TASK_DESC) values (4,'住院归档病历归档处理byPatientIDandEventNO',null);

/*==============================================================*/
/* Table: ARC_PROCESS_TASK_PARAM                                    */
/*==============================================================*/
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_PARAM (TASK_ID,PARAM_NAME,PARAM_VALUE,MEMO) values ('0','RUN_STOP_TIME',null,'运行停止时间');
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_PARAM (TASK_ID,PARAM_NAME,PARAM_VALUE,MEMO) values ('0','RUN_TIME_BEGIN','18:00:00','允许运行开始时间点');
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_PARAM (TASK_ID,PARAM_NAME,PARAM_VALUE,MEMO) values ('0','RUN_TIME_END','06:00:00','允许运行结束时间点');
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_PARAM (TASK_ID,PARAM_NAME,PARAM_VALUE,MEMO) values ('4','ARCHIVE_DATE','2016-01-01','归档日期');
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_PARAM (TASK_ID,PARAM_NAME,PARAM_VALUE,MEMO) values ('4','DB_LINK','zoedblink_emrarch','HIS归档数据库链路');
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_PARAM (TASK_ID,PARAM_NAME,PARAM_VALUE,MEMO) values ('4','LAUNCH_DATE','2009-04-30','EMR系统住院上线日期');

/*==============================================================*/
/* Table: ARC_PROCESS_TASK_DATA_KEY                                       */
/*==============================================================*/
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_DATA_KEY (TASK_ID,KEY_SEQ,KEY_NAME) values (4,'1','PATIENT_ID');
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_DATA_KEY (TASK_ID,KEY_SEQ,KEY_NAME) values (4,'2','EVENT_NO');

/*==============================================================*/
/* Table: ARC_PROCESS_TASK_CONFIG                                       */
/*==============================================================*/
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG (TASK_ID,TABLE_OWNER,TABLE_NAME,ARCHIVE_TABLE_OWNER,ARCHIVE_TABLE_NAME,DETAIL_TABLE_FLAG,RELATE_MASTER_TABLE_NAME,RELATE_MASTER_TABLE_COLUMN,RELATE_DETAIL_TABLE_COLUMN,ARCHIVE_DATE_COLUMN,ARCHIVE_CONDITION_C1,ARCHIVE_TABLE_C1,ARCHIVE_CONDITION_C2,ARCHIVE_TABLE_C2,PROCESS_ORDER) values (4,'ZEMR','ZEMR_EMR_CONTENT','ZOEARCHIVE','ZEMR_EMR_CONTENT_A',null,null,null,null,null,'PATIENT_ID','PATIENT_ID','EVENT_NO','EVENT_NO',1);
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG (TASK_ID,TABLE_OWNER,TABLE_NAME,ARCHIVE_TABLE_OWNER,ARCHIVE_TABLE_NAME,DETAIL_TABLE_FLAG,RELATE_MASTER_TABLE_NAME,RELATE_MASTER_TABLE_COLUMN,RELATE_DETAIL_TABLE_COLUMN,ARCHIVE_DATE_COLUMN,ARCHIVE_CONDITION_C1,ARCHIVE_TABLE_C1,ARCHIVE_CONDITION_C2,ARCHIVE_TABLE_C2,PROCESS_ORDER) values (4,'ZEMR','ZEMR_STD_PATIENT_INFO_DOMAIN','ZOEARCHIVE','ZEMR_STD_PATIENT_INFO_DOMAIN_A',null,null,null,null,null,'PATIENT_ID','PATIENT_ID','EVENT_NO','EVENT_NO',2);
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG (TASK_ID,TABLE_OWNER,TABLE_NAME,ARCHIVE_TABLE_OWNER,ARCHIVE_TABLE_NAME,DETAIL_TABLE_FLAG,RELATE_MASTER_TABLE_NAME,RELATE_MASTER_TABLE_COLUMN,RELATE_DETAIL_TABLE_COLUMN,ARCHIVE_DATE_COLUMN,ARCHIVE_CONDITION_C1,ARCHIVE_TABLE_C1,ARCHIVE_CONDITION_C2,ARCHIVE_TABLE_C2,PROCESS_ORDER) values (4,'ZEMR','ZEMR_NURSE_MASTER','ZOEARCHIVE','ZEMR_NURSE_MASTER_A',null,null,null,null,null,'PATIENT_ID','PATIENT_ID','EVENT_NO','EVENT_NO',3);
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG (TASK_ID,TABLE_OWNER,TABLE_NAME,ARCHIVE_TABLE_OWNER,ARCHIVE_TABLE_NAME,DETAIL_TABLE_FLAG,RELATE_MASTER_TABLE_NAME,RELATE_MASTER_TABLE_COLUMN,RELATE_DETAIL_TABLE_COLUMN,ARCHIVE_DATE_COLUMN,ARCHIVE_CONDITION_C1,ARCHIVE_TABLE_C1,ARCHIVE_CONDITION_C2,ARCHIVE_TABLE_C2,PROCESS_ORDER) values (4,'ZEMR','ZEMR_NURSE_MASTER_ARCHIVE','ZOEARCHIVE','ZEMR_NURSE_MASTER_ARCHIVE_A',null,null,null,null,null,'PATIENT_ID','PATIENT_ID','EVENT_NO','EVENT_NO',4);
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG (TASK_ID,TABLE_OWNER,TABLE_NAME,ARCHIVE_TABLE_OWNER,ARCHIVE_TABLE_NAME,DETAIL_TABLE_FLAG,RELATE_MASTER_TABLE_NAME,RELATE_MASTER_TABLE_COLUMN,RELATE_DETAIL_TABLE_COLUMN,ARCHIVE_DATE_COLUMN,ARCHIVE_CONDITION_C1,ARCHIVE_TABLE_C1,ARCHIVE_CONDITION_C2,ARCHIVE_TABLE_C2,PROCESS_ORDER) values (4,'ZEMR','ZEMR_NURSE_DETAIL','ZOEARCHIVE','ZEMR_NURSE_DETAIL_A',null,null,null,null,null,'PATIENT_ID','PATIENT_ID','EVENT_NO','EVENT_NO',5);
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG (TASK_ID,TABLE_OWNER,TABLE_NAME,ARCHIVE_TABLE_OWNER,ARCHIVE_TABLE_NAME,DETAIL_TABLE_FLAG,RELATE_MASTER_TABLE_NAME,RELATE_MASTER_TABLE_COLUMN,RELATE_DETAIL_TABLE_COLUMN,ARCHIVE_DATE_COLUMN,ARCHIVE_CONDITION_C1,ARCHIVE_TABLE_C1,ARCHIVE_CONDITION_C2,ARCHIVE_TABLE_C2,PROCESS_ORDER) values (4,'ZEMR','ZEMR_NURSE_DETAIL_ARCHIVE','ZOEARCHIVE','ZEMR_NURSE_DETAIL_ARCHIVE_A',null,null,null,null,null,'PATIENT_ID','PATIENT_ID','EVENT_NO','EVENT_NO',6);
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG (TASK_ID,TABLE_OWNER,TABLE_NAME,ARCHIVE_TABLE_OWNER,ARCHIVE_TABLE_NAME,DETAIL_TABLE_FLAG,RELATE_MASTER_TABLE_NAME,RELATE_MASTER_TABLE_COLUMN,RELATE_DETAIL_TABLE_COLUMN,ARCHIVE_DATE_COLUMN,ARCHIVE_CONDITION_C1,ARCHIVE_TABLE_C1,ARCHIVE_CONDITION_C2,ARCHIVE_TABLE_C2,PROCESS_ORDER) values (4,'ZEMR','ZEMR_EMR_PRINTLOG','ZOEARCHIVE','ZEMR_EMR_PRINTLOG_A',null,null,null,null,null,'PATIENT_ID','PATIENT_ID','EVENT_NO','EVENT_NO',7);
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG (TASK_ID,TABLE_OWNER,TABLE_NAME,ARCHIVE_TABLE_OWNER,ARCHIVE_TABLE_NAME,DETAIL_TABLE_FLAG,RELATE_MASTER_TABLE_NAME,RELATE_MASTER_TABLE_COLUMN,RELATE_DETAIL_TABLE_COLUMN,ARCHIVE_DATE_COLUMN,ARCHIVE_CONDITION_C1,ARCHIVE_TABLE_C1,ARCHIVE_CONDITION_C2,ARCHIVE_TABLE_C2,PROCESS_ORDER) values (4,'ZEMR','ZEMR_NURSE_TEMP_ARCHIVE','ZOEARCHIVE','ZEMR_NURSE_TEMP_ARCHIVE_A',null,null,null,null,null,'PATIENT_ID','PATIENT_ID','EVENT_NO','EVENT_NO',8);
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG (TASK_ID,TABLE_OWNER,TABLE_NAME,ARCHIVE_TABLE_OWNER,ARCHIVE_TABLE_NAME,DETAIL_TABLE_FLAG,RELATE_MASTER_TABLE_NAME,RELATE_MASTER_TABLE_COLUMN,RELATE_DETAIL_TABLE_COLUMN,ARCHIVE_DATE_COLUMN,ARCHIVE_CONDITION_C1,ARCHIVE_TABLE_C1,ARCHIVE_CONDITION_C2,ARCHIVE_TABLE_C2,PROCESS_ORDER) values (4,'ZEMR','ZEMR_TEMPERATURE_POINT_RECORD','ZOEARCHIVE','ZEMR_TEMPERATURE_POINT_RECORD_A',null,null,null,null,null,'PATIENT_ID','PATIENT_ID','EVENT_NO','EVENT_NO',9);
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG (TASK_ID,TABLE_OWNER,TABLE_NAME,ARCHIVE_TABLE_OWNER,ARCHIVE_TABLE_NAME,DETAIL_TABLE_FLAG,RELATE_MASTER_TABLE_NAME,RELATE_MASTER_TABLE_COLUMN,RELATE_DETAIL_TABLE_COLUMN,ARCHIVE_DATE_COLUMN,ARCHIVE_CONDITION_C1,ARCHIVE_TABLE_C1,ARCHIVE_CONDITION_C2,ARCHIVE_TABLE_C2,PROCESS_ORDER) values (4,'ZEMR','ZEMR_TEMPERATURE_FEVER','ZOEARCHIVE','ZEMR_TEMPERATURE_FEVER_A',null,null,null,null,null,'PATIENT_ID','PATIENT_ID','EVENT_NO','EVENT_NO',10);
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG (TASK_ID,TABLE_OWNER,TABLE_NAME,ARCHIVE_TABLE_OWNER,ARCHIVE_TABLE_NAME,DETAIL_TABLE_FLAG,RELATE_MASTER_TABLE_NAME,RELATE_MASTER_TABLE_COLUMN,RELATE_DETAIL_TABLE_COLUMN,ARCHIVE_DATE_COLUMN,ARCHIVE_CONDITION_C1,ARCHIVE_TABLE_C1,ARCHIVE_CONDITION_C2,ARCHIVE_TABLE_C2,PROCESS_ORDER) values (4,'ZEMR','ZEMR_TEMPERATURE_ENTIRE_RECORD','ZOEARCHIVE','ZEMR_TEMPERATURE_ENTIRE_RECORD_A',null,null,null,null,null,'PATIENT_ID','PATIENT_ID','EVENT_NO','EVENT_NO',11);
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG (TASK_ID,TABLE_OWNER,TABLE_NAME,ARCHIVE_TABLE_OWNER,ARCHIVE_TABLE_NAME,DETAIL_TABLE_FLAG,RELATE_MASTER_TABLE_NAME,RELATE_MASTER_TABLE_COLUMN,RELATE_DETAIL_TABLE_COLUMN,ARCHIVE_DATE_COLUMN,ARCHIVE_CONDITION_C1,ARCHIVE_TABLE_C1,ARCHIVE_CONDITION_C2,ARCHIVE_TABLE_C2,PROCESS_ORDER) values (4,'ZEMR','ZEMR_PATIENT_DIAGNOSIS','ZOEARCHIVE','ZEMR_PATIENT_DIAGNOSIS_A',null,null,null,null,null,'PATIENT_ID','PATIENT_ID','EVENT_NO','EVENT_NO',12);
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG (TASK_ID,TABLE_OWNER,TABLE_NAME,ARCHIVE_TABLE_OWNER,ARCHIVE_TABLE_NAME,DETAIL_TABLE_FLAG,RELATE_MASTER_TABLE_NAME,RELATE_MASTER_TABLE_COLUMN,RELATE_DETAIL_TABLE_COLUMN,ARCHIVE_DATE_COLUMN,ARCHIVE_CONDITION_C1,ARCHIVE_TABLE_C1,ARCHIVE_CONDITION_C2,ARCHIVE_TABLE_C2,PROCESS_ORDER) values (4,'ZEMR','ZEMR_PATIENT_OPERATION','ZOEARCHIVE','ZEMR_PATIENT_OPERATION_A',null,null,null,null,null,'PATIENT_ID','PATIENT_ID','EVENT_NO','EVENT_NO',13);
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG (TASK_ID,TABLE_OWNER,TABLE_NAME,ARCHIVE_TABLE_OWNER,ARCHIVE_TABLE_NAME,DETAIL_TABLE_FLAG,RELATE_MASTER_TABLE_NAME,RELATE_MASTER_TABLE_COLUMN,RELATE_DETAIL_TABLE_COLUMN,ARCHIVE_DATE_COLUMN,ARCHIVE_CONDITION_C1,ARCHIVE_TABLE_C1,ARCHIVE_CONDITION_C2,ARCHIVE_TABLE_C2,PROCESS_ORDER) values (4,'ZEMR','ZEMR_NURSESTAT_DETAIL','ZOEARCHIVE','ZEMR_NURSESTAT_DETAIL_A',null,null,null,null,null,'PATIENT_ID','PATIENTID','EVENT_NO','EVENTNO',14);
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG (TASK_ID,TABLE_OWNER,TABLE_NAME,ARCHIVE_TABLE_OWNER,ARCHIVE_TABLE_NAME,DETAIL_TABLE_FLAG,RELATE_MASTER_TABLE_NAME,RELATE_MASTER_TABLE_COLUMN,RELATE_DETAIL_TABLE_COLUMN,ARCHIVE_DATE_COLUMN,ARCHIVE_CONDITION_C1,ARCHIVE_TABLE_C1,ARCHIVE_CONDITION_C2,ARCHIVE_TABLE_C2,PROCESS_ORDER) values (4,'ZEMR','ZEMR_NURSE_BABY_MASTER','ZOEARCHIVE','ZEMR_NURSE_BABY_MASTER_A',null,null,null,null,null,'PATIENT_ID','PATIENT_ID','EVENT_NO','EVENT_NO',15);
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG (TASK_ID,TABLE_OWNER,TABLE_NAME,ARCHIVE_TABLE_OWNER,ARCHIVE_TABLE_NAME,DETAIL_TABLE_FLAG,RELATE_MASTER_TABLE_NAME,RELATE_MASTER_TABLE_COLUMN,RELATE_DETAIL_TABLE_COLUMN,ARCHIVE_DATE_COLUMN,ARCHIVE_CONDITION_C1,ARCHIVE_TABLE_C1,ARCHIVE_CONDITION_C2,ARCHIVE_TABLE_C2,PROCESS_ORDER) values (4,'ZEMR','ZEMR_NURSE_PATIENT_INFO','ZOEARCHIVE','ZEMR_NURSE_PATIENT_INFO_A',null,null,null,null,null,'PATIENT_ID','PATIENT_ID','EVENT_NO','EVENT_NO',16);
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG (TASK_ID,TABLE_OWNER,TABLE_NAME,ARCHIVE_TABLE_OWNER,ARCHIVE_TABLE_NAME,DETAIL_TABLE_FLAG,RELATE_MASTER_TABLE_NAME,RELATE_MASTER_TABLE_COLUMN,RELATE_DETAIL_TABLE_COLUMN,ARCHIVE_DATE_COLUMN,ARCHIVE_CONDITION_C1,ARCHIVE_TABLE_C1,ARCHIVE_CONDITION_C2,ARCHIVE_TABLE_C2,PROCESS_ORDER) values (4,'ZEMR','ZEMR_TEMPERATURE_DAY_RECORD','ZOEARCHIVE','ZEMR_TEMPERATURE_DAY_RECORD_A',null,null,null,null,null,'PATIENT_ID','PATIENT_ID','EVENT_NO','EVENT_NO',17);
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG (TASK_ID,TABLE_OWNER,TABLE_NAME,ARCHIVE_TABLE_OWNER,ARCHIVE_TABLE_NAME,DETAIL_TABLE_FLAG,RELATE_MASTER_TABLE_NAME,RELATE_MASTER_TABLE_COLUMN,RELATE_DETAIL_TABLE_COLUMN,ARCHIVE_DATE_COLUMN,ARCHIVE_CONDITION_C1,ARCHIVE_TABLE_C1,ARCHIVE_CONDITION_C2,ARCHIVE_TABLE_C2,PROCESS_ORDER) values (4,'ZEMR','ZEMR_TEMPERATURE_WEEK_EMR','ZOEARCHIVE','ZEMR_TEMPERATURE_WEEK_EMR_A',null,null,null,null,null,'PATIENT_ID','PATIENT_ID','EVENT_NO','EVENT_NO',18);
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG (TASK_ID,TABLE_OWNER,TABLE_NAME,ARCHIVE_TABLE_OWNER,ARCHIVE_TABLE_NAME,DETAIL_TABLE_FLAG,RELATE_MASTER_TABLE_NAME,RELATE_MASTER_TABLE_COLUMN,RELATE_DETAIL_TABLE_COLUMN,ARCHIVE_DATE_COLUMN,ARCHIVE_CONDITION_C1,ARCHIVE_TABLE_C1,ARCHIVE_CONDITION_C2,ARCHIVE_TABLE_C2,PROCESS_ORDER) values (4,'ZEMR','ZEMR_BABYTP_RECORD','ZOEARCHIVE','ZEMR_BABYTP_RECORD_A',null,null,null,null,null,'PATIENT_ID','PATIENT_ID','EVENT_NO','EVENT_NO',19);
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG (TASK_ID,TABLE_OWNER,TABLE_NAME,ARCHIVE_TABLE_OWNER,ARCHIVE_TABLE_NAME,DETAIL_TABLE_FLAG,RELATE_MASTER_TABLE_NAME,RELATE_MASTER_TABLE_COLUMN,RELATE_DETAIL_TABLE_COLUMN,ARCHIVE_DATE_COLUMN,ARCHIVE_CONDITION_C1,ARCHIVE_TABLE_C1,ARCHIVE_CONDITION_C2,ARCHIVE_TABLE_C2,PROCESS_ORDER) values (4,'ZEMR','ZQC_TIME_RULE_RECORD','ZOEARCHIVE','ZQC_TIME_RULE_RECORD_A',null,null,null,null,null,'PATIENT_ID','PATIENT_ID','EVENT_NO','EVENT_NO',20);
Insert into ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG (TASK_ID,TABLE_OWNER,TABLE_NAME,ARCHIVE_TABLE_OWNER,ARCHIVE_TABLE_NAME,DETAIL_TABLE_FLAG,RELATE_MASTER_TABLE_NAME,RELATE_MASTER_TABLE_COLUMN,RELATE_DETAIL_TABLE_COLUMN,ARCHIVE_DATE_COLUMN,ARCHIVE_CONDITION_C1,ARCHIVE_TABLE_C1,ARCHIVE_CONDITION_C2,ARCHIVE_TABLE_C2,PROCESS_ORDER) values (4,'ZEMR','ZEMR_REGISTER_EVENT_RECORD','ZOEARCHIVE','ZEMR_REGISTER_EVENT_RECORD_A',null,null,null,null,null,'PATIENT_ID','PATIENT_ID','EVENT_NO','EVENT_NO',21);

COMMIT;
