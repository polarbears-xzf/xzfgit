CREATE OR REPLACE PACKAGE ZOEARCHIVE.ZOEPKG_ARCHIVE_PROCESS AS
-- Created in 2017.10.10 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoepkg_archive_porcess
--	Description:
-- 		数据库归档处理
--  Relation:
--      zoepkg_archive_comm
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--
type gr_arc_proc_task_config_data
IS
  record
  (
    ARCHIVE_DB_LINK            VARCHAR(128),     --归档数据库链路
    TASK_ID                    NUMBER,          --归档任务，关联ZOEARCHIVE.ARC_PROCESS_TASK
    TABLE_OWNER                VARCHAR2(64),    --归档源表所有者
    TABLE_NAME                 VARCHAR2(64),    --归档源表名
    ARCHIVE_TABLE_OWNER        VARCHAR2(64),    --归档目标表所有者
    ARCHIVE_TABLE_NAME         VARCHAR2(64),    --归档目标表名
    DETAIL_TABLE_FLAG          VARCHAR2(1),     --是否细表
    RELATE_MASTER_TABLE_NAME   VARCHAR2(64),  --关联主表名
    RELATE_MASTER_TABLE_COLUMN VARCHAR2(64),  --主表关联列
    RELATE_DETAIL_TABLE_COLUMN VARCHAR2(64),  --细表表关联列
    ARCHIVE_DATE_COLUMN        VARCHAR2(64),  --归档日期列
    ARCHIVE_DATE_VALUE         DATE,          --归档日期值
    ARCHIVE_CONDITION_C1       VARCHAR2(64),      --归档条件列1
    ARCHIVE_TABLE_C1           VARCHAR2(64),      --归档表对应列1
    ARCHIVE_CONDITION_VALUE1       VARCHAR2(64),  --归档条件值1
    ARCHIVE_CONDITION_C2           VARCHAR2(64),  --归档条件列2
    ARCHIVE_TABLE_C2           VARCHAR2(64),      --归档表对应列2
    ARCHIVE_CONDITION_VALUE2       VARCHAR2(64)   --归档条件值2
  );

 type gt_arc_process_task_config
  IS
    TABLE OF  ZOEARCHIVE.ARC_PROCESS_TASK_CONFIG%rowtype INDEX BY binary_integer; 
    


-- ===================================================
-- 归档处理
-- ===================================================
    --in_task_id          传入参数-数字型，执行归档任务
      --ZOEARVHIVE.ARC_PROCESS_TASK
      --1,'门诊已结算病人归档处理' ；2,'住院正常出院结算病人归档处理'
		--in_simulation_flag  传入参数-数字型，模拟执行标志
      --1,'' ； 2,''
		--in_system_code 传入参数-字符型，业务系统代码
      -- 1 HIS ； 2 EMR
		--in_data_type   传入参数-字符型，数据类型代码
      -- 1 日志数据 ； 2 业务数据
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
  FUNCTION arc_process_task_exec(in_task_id IN NUMBER, in_exec_flag IN NUMBER DEFAULT NULL)
    RETURN VARCHAR2;

  FUNCTION get_arc_process_task_condition(in_task_id NUMBER,ot_arc_process_task_condition OUT NOCOPY gt_arc_process_task_config)
  RETURN NUMBER;

  FUNCTION get_archive_sql(ir_task_condition IN gr_arc_proc_task_config_data,ov_insert_sql OUT NOCOPY VARCHAR2,ov_delete_sql OUT NOCOPY VARCHAR2)
    RETURN NUMBER;
		
END ZOEPKG_ARCHIVE_PROCESS;
/
