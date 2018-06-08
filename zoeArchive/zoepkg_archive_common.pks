CREATE OR REPLACE PACKAGE zoearchive.zoepkg_archive_comm AS
-- Created in 2017.10.10 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoepkg_archive_comm.pks
--	Description:
-- 		数据库归档公共组件包
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--


-- =======================================
-- 全局变量声明
-- =======================================
--    
/*type gt_his_log_process_config
  IS
    TABLE OF  SGARCHIVE.HIS_LOG_PROCESS_CONFIG%rowtype INDEX BY binary_integer;*/
    
type gr_archive_condition
IS
  record
  (
    ONLINE_TABLE_NAME         VARCHAR2(61),  --归档源表名
    ARCHIVE_TYPE              CHAR(1),       --归档类型，1 门诊，2住院，3 其它
    ARCHIVE_TABLE_NAME        VARCHAR2(61),  --归档目标表名
    ARCHIVE_DB_LINK           VARCHAR2(128), --归档目标数据库链路
    DETAIL_TABLE_FLAG         CHAR(1),       --是否细表
    ASSOCIATION_MASTER_TABLE  VARCHAR2(61),  --关联主表
    ASSOCIATION_MASTER_COLUMN VARCHAR2(30),  --关联主表列
    ASSOCIATION_DETAIL_COLUMN VARCHAR2(30),  --关联细表列
    ARCHIVE_DATE_COLUMN       VARCHAR2(30),  --归档日期列
    ARCHIVE_CONDITION_C1      VARCHAR2(30),  --归档条件列
    ARCHIVE_CONDITION_V1      VARCHAR2(30),  --归档条件值
    ARCHIVE_CONDITION_C2      VARCHAR2(30),  --归档条件列
    ARCHIVE_CONDITION_V2      VARCHAR2(30),  --归档条件值
    ADDITION_CONDITION        VARCHAR2(200)  --归档附加条件
  );
  
type gt_archive_condition
IS
  TABLE OF gr_archive_condition INDEX BY binary_integer;
	
-- ===================================================
-- 添加归档表
-- ===================================================
    --in_owner       传入参数-字符型，表所有者
		--in_table_name  传入参数-字符型，表名
		--in_system_code 传入参数-字符型，业务系统代码
		--in_data_type   传入参数-字符型，数据类型代码
    -- 返回值：
      /* 
      {returnValue: [
        {
          "code": "-1",
          "message": "失败"
        },
        {
          "code": "1",
          "message": "成功"
        }
        ]
      }
      */
  FUNCTION add_archive_table(in_owner in varchar2,in_table_name in varchar2,in_system_code in varchar2,in_data_type in varchar2)
    RETURN VARCHAR2;
	
  
END zoepkg_archive_comm;


