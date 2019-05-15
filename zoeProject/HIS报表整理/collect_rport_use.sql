-- 北极熊创建于： 2019.05.15
-- 版权 2019 中国
-- 保留所有权利
--	文件名:
-- 		collect_report_use.sql
--	描述:
-- 		用于收集HIS4报表使用情况的SQL
--   对象关联:
--      对象关联
--	注意事项:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--
--

--	收集报表使用分类
select level as "level", LPAD(' ',2*(LEVEL-1))||a.class_name as "class_name",a.class_code as "class_code"
from COMM.general_class_dict a
start with a.super_class = '##' and a.class_type = 'A'
connect by prior a.class_code = a.super_class;

--	收集报表使用分类归属
with report_class as
(select level , LPAD(' ',2*(LEVEL-1))||a.class_name as class_name,a.class_code 
from COMM.general_class_dict a
start with a.super_class = '##' and a.class_type = 'A'
connect by prior a.class_code = a.super_class)
select a.class_code,a.class_name,b.report_id,b.report_name
from report_class a, REPORT.qr_report b
where a.class_code = b.class_code; 

--	收集报表使用频率
--统计报表日使用频率
select operate_data1 as report_id, b.report_name, to_char(a.operation_time,'yyyy-mm-dd') as stat_date, COUNT(1) as count 
from COMM.DATA_OPERATE_LOG a, REPORT.qr_report b
where a.operation_time > sysdate -90 and a.operate_data1 = b.report_id
GROUP BY a.operate_data1, b.report_name, to_char(a.operation_time,'yyyy-mm-dd')
order by a.operate_data1, to_char(a.operation_time,'yyyy-mm-dd');


-- 统计HIS4报表近1个月，6个月，1年内被使用的报表数量
select '1 month ' as rpt_cycle, count(1) as count from 
    (select '1 month ' as rpt_cycle, operate_data1,count(1) from COMM.DATA_OPERATE_LOG b
    where b.operation_time > sysdate -30
    group by b.operate_data1)
union all
select '6 month ', count(1) from 
    (select '6 month ' as rpt_cycle, operate_data1,count(1)  from COMM.DATA_OPERATE_LOG b
    where b.operation_time > sysdate -180
    group by b.operate_data1)
union all
select '1 year', count(1) from 
    (select '1 year ' as rpt_cycle, operate_data1,count(1)  from COMM.DATA_OPERATE_LOG b
    where b.operation_time > sysdate -365
    group by b.operate_data1);
	
--统计HIS4报表近1个月，6个月，1年内使用计数
    (select '1 month ' as rpt_cycle, operate_data1 as report_no, b.report_name,count(1)  as count 
    from COMM.DATA_OPERATE_LOG a, REPORT.qr_report b
    where a.operation_time > sysdate -30 and a.operate_data1 = b.report_id
    group by a.operate_data1, b.report_name)
union all
    (select '6 month ' as rpt_cycle, operate_data1, b.report_name,count(1)  
    from COMM.DATA_OPERATE_LOG a, REPORT.qr_report b
    where a.operation_time > sysdate -180 and a.operate_data1 = b.report_id
    group by a.operate_data1, b.report_name)
union all
    (select '1 year ' as rpt_cycle, operate_data1, b.report_name, count(1)  
    from COMM.DATA_OPERATE_LOG a, REPORT.qr_report b
    where a.operation_time > sysdate -365 and a.operate_data1 = b.report_id
    group by a.operate_data1, b.report_name);
	
--列举HIS4报表近1个月内使用过的报表
	with report_use as 
    (select operate_data1 as report_id,max(operation_time) as operation_time ,count(1) as executes
     from COMM.DATA_OPERATE_LOG 
     where operation_time > sysdate - 180
     group by operate_data1)
	select b.report_id, b.report_type, b.class_code, b.report_name, 
		a.operation_time, a.executes, b.modify_time,b.memo
	from report_use a , COMM.qr_report b
	WHERE a.report_id = b.report_id
	order by b.report_id;

--列举HIS4报表近1年到半年区间内使用过的报表
with report_use as 
    (select operate_data1 as report_id,max(operation_time) as operation_time
     from COMM.DATA_OPERATE_LOG a
     where operation_time > sysdate - 360
        and not exists (select null 
                        from (select operate_data1 from COMM.DATA_OPERATE_LOG where operation_time > sysdate - 180 group by operate_data1) b 
                        where a.operate_data1=b.operate_data1)
     group by operate_data1)
select b.report_id, b.report_type, b.class_code, b.report_name, 
    a.operation_time, b.modify_time,b.memo
from report_use a , COMM.qr_report b
WHERE a.report_id = b.report_id
order by b.report_id;