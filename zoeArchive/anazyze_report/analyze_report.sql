-- 北极熊创建于： 2019.04.19
-- 版权 2019 中国
-- 保留所有权利
--	文件名:
-- 		analyze_report.sql
--	描述:
-- 		分析HIS4报表使用语法
--   对象关联:
--      对象关联
--	注意事项:
--		基本注意事项
--	修改 - （年-月-日） - 描述

--统计报表日使用频率
select operate_data1 as report_no, to_char(operation_time,'yyyy-mm-dd') as stat_date, COUNT(1) as count  from ZOEHIS4RPT.DATA_OPERATE_LOG
where operation_time > sysdate -30
GROUP BY operate_data1, to_char(operation_time,'yyyy-mm-dd');


-- 统计HIS4报表近1个月，6个月，1年内是否被使用
select '1 month ' as rpt_cycle, count(1) as count from 
    (select '1 month ' as rpt_cycle, operate_data1,count(1) from ZOEHIS4RPT.DATA_OPERATE_LOG b
    where b.operation_time > sysdate -30
    group by b.operate_data1)
union all
select '6 month ', count(1) from 
    (select '6 month ' as rpt_cycle, operate_data1,count(1)  from ZOEHIS4RPT.DATA_OPERATE_LOG b
    where b.operation_time > sysdate -180
    group by b.operate_data1)
union all
select '1 year', count(1) from 
    (select '1 year ' as rpt_cycle, operate_data1,count(1)  from ZOEHIS4RPT.DATA_OPERATE_LOG b
    where b.operation_time > sysdate -365
    group by b.operate_data1);
	
--统计HIS4报表近1个月，6个月，1年内使用计数
    (select '1 month ' as rpt_cycle, operate_data1 as report_no,count(1)  as count from ZOEHIS4RPT.DATA_OPERATE_LOG b
    where b.operation_time > sysdate -30
    group by b.operate_data1)
union all
    (select '6 month ' as rpt_cycle, operate_data1,count(1)  from ZOEHIS4RPT.DATA_OPERATE_LOG b
    where b.operation_time > sysdate -180
    group by b.operate_data1)
union all
    (select '1 year ' as rpt_cycle, operate_data1,count(1)  from ZOEHIS4RPT.DATA_OPERATE_LOG b
    where b.operation_time > sysdate -365
    group by b.operate_data1);
	
--列举HIS4报表近1个月内使用过的报表
	with report_use as 
    (select operate_data1 as report_id,max(operation_time) as operation_time ,count(1) as executes
     from ZOEHIS4RPT.DATA_OPERATE_LOG 
     where operation_time > sysdate - 180
     group by operate_data1)
	select b.report_id, b.report_type, b.class_code, b.report_name, 
		a.operation_time, a.executes, b.modify_time,b.memo
	from report_use a , ZOEHIS4RPT.qr_report b
	WHERE a.report_id = b.report_id
	order by b.report_id;

--列举HIS4报表近1年到半年区间内使用过的报表
with report_use as 
    (select operate_data1 as report_id,max(operation_time) as operation_time
     from ZOEHIS4RPT.DATA_OPERATE_LOG a
     where operation_time > sysdate - 360
        and not exists (select null 
                        from (select operate_data1 from ZOEHIS4RPT.DATA_OPERATE_LOG where operation_time > sysdate - 180 group by operate_data1) b 
                        where a.operate_data1=b.operate_data1)
     group by operate_data1)
select b.report_id, b.report_type, b.class_code, b.report_name, 
    a.operation_time, b.modify_time,b.memo
from report_use a , ZOEHIS4RPT.qr_report b
WHERE a.report_id = b.report_id
order by b.report_id;

