CREATE OR REPLACE PACKAGE zoearchive.zoepkg_archive_his40_settle AS
-- Created in 2017.10.10 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		zoepkg_db_archive_his40.pks
--	Description:
-- 		HIS4.0数据库归档处理
--  Relation:
--      zoepkg_db_archive_common
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--


-- =======================================
-- 全局变量声明
-- =======================================
--    数组变量
    -- TYPE arrry_name IS TABLE OF VARCHAR2(30) INDEX BY BINARY_INTEGER;
	
-- ===================================================
-- 门诊病人内部结算（批量后台处理）
-- ===================================================
--  
	PROCEDURE op_disp_batch_settle;

-- ===================================================
-- 门诊病人内部结算（单病人）
-- ===================================================
--	as_sick_id： 输入参数-病人ID
--  ad_pre_date：输入参数-结算日期，结算小于输入日期的病人费用
--  rl_return：  输出参数-返回结算结果，0 成功 -1 失败
--  rs_mess：    输出参数-返回结算结果信息
	PROCEDURE op_disp_settle_bysickid
                  (as_sick_id in varchar2,
                   ad_pre_date in date default null,
                   rl_return  out integer,
                   rs_mess out varchar2);

-- ===================================================
-- 门诊病人取消内部结算（单病人）
-- ===================================================
--  as_settle_no-输入参数-结算号
--  rl_return：  输出参数-返回结算结果，0 成功 -1 失败
--  rs_mess：    输出参数-返回结算结果信息
	PROCEDURE op_cancel_disp_settle_bysickid
                  (as_settle_no in varchar2,
                   rl_return  out integer,
                   rs_mess out varchar2); 
				   
	
-- ===================================================
-- 函数功能说明
-- ===================================================
--	参数：传入参数及类型：
	--FUNCTION 函数名称(iv_str VARCHAR2,in_num INTEGER)
		--RETURN VARCHAR2;
		
END zoepkg_archive_his40_settle