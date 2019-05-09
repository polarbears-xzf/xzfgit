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
	
-- ===================================================
-- 添加归档表
-- ===================================================
    --in_owner       传入参数-字符型，表所有者
		--in_table_name  传入参数-字符型，表名
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
  FUNCTION add_archive_table(in_owner in varchar2,in_table_name in varchar2,in_system_code in varchar2,in_data_type in varchar2)
    RETURN VARCHAR2;
-- ===================================================
-- 归档日期限制
  --强制限制一年内数据不允许归档
-- ===================================================
	FUNCTION archive_date_limit(id_archive_date DATE ) RETURN NUMBER;

  
END zoepkg_archive_comm;
/

