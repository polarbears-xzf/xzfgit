-- 北极熊创建于： 2019.05.23
-- 版权 2019 中国
-- 保留所有权利
--  文件名:
--    analyze_report_use.sql
--  描述:
--    用于收集HIS4报表使用情况的SQL
--   对象关联:
--      对象关联
--  注意事项:
--    基本注意事项
--  修改 - （年-月-日） - 描述
--
--

--	获取项目列表
	select listagg(''''||project_name||'''',',') within group (order by project_name)
	from (select distinct project_name from ZOEHIS4RPT.report_class)
	order by project_name;
--	获取报表分类每级类别数量
	select * from 
	(select class_level,project_name,class_code from ZOEHIS4RPT.report_class)
	pivot 
	(count(class_code) 
	for project_name in ('安溪县医院','长泰县医院','第一医院','福建省妇幼保健院','海沧医院','马尾医院','莆田市第一医院','厦门儿童医院','厦门二院','厦门妇幼','漳浦县医院','漳州市医院','漳州中医院')
	)
	order by class_level;
--	获取报表分类每级报表数量（半年内被使用的）
select * from 
	(select a.class_level,a.project_name,b.report_no 
		from ZOEHIS4RPT.report_class a, ZOEHIS4RPT.report_class_config b, ZOEHIS4RPT.report_used_1to6_month c
		where a.project_name = b.project_name and a.class_code = b.class_code     
			and b.project_name = c.project_name and b.report_no = c.report_no)
	pivot 
	(count(report_no) 
	for project_name in ('安溪县医院','长泰县医院','第一医院','福建省妇幼保健院','海沧医院','马尾医院','莆田市第一医院','厦门儿童医院','厦门二院','厦门妇幼','漳浦县医院','漳州市医院','漳州中医院')
	)
	order by class_level;
--	获取报表分类每级报表数量（半年到一年被使用的）
	select * from 
	(select a.class_level,a.project_name,b.report_no 
		from ZOEHIS4RPT.report_class a, ZOEHIS4RPT.report_class_config b, ZOEHIS4RPT.report_used_halfto1_year c
		where a.project_name = b.project_name and a.class_code = b.class_code     
			and b.project_name = c.project_name and b.report_no = c.report_no)
	pivot 
	(count(report_no) 
	for project_name in ('安溪县医院','长泰县医院','第一医院','福建省妇幼保健院','海沧医院','马尾医院','莆田市第一医院','厦门儿童医院','厦门二院','厦门妇幼','漳浦县医院','漳州市医院','漳州中医院')
	)
	order by class_level;
-- 获取报表使用频率（一月一次，一天一次）
	select * from 
	(select '日均一次' as "使用频率",project_name,report_name
        from ZOEHIS4RPT.report_used_count 
        where stat_cycle like '1 year%' and stat_count/12/30>1 and  project_name<>'第一医院'
        union all
        select '日均一次' as "使用频率"，project_name,report_name
        from ZOEHIS4RPT.report_used_count 
        where stat_cycle like '6 month%' and stat_count/6/30>1 and project_name='第一医院'
        union all
        select '月均一次' as "使用频率",project_name,report_name
        from ZOEHIS4RPT.report_used_count 
        where stat_cycle like '1 year%' and stat_count/12>1 and  project_name<>'第一医院'
        union all
        select '月均一次' as "使用频率"，project_name,report_name
        from ZOEHIS4RPT.report_used_count 
        where stat_cycle like '6 month%' and stat_count/6>1 and project_name='第一医院'
    )
	pivot 
	(count(report_name) 
	for project_name in ('安溪县医院','长泰县医院','第一医院','福建省妇幼保健院','海沧医院','马尾医院','莆田市第一医院','厦门儿童医院','厦门二院','厦门妇幼','漳浦县医院','漳州市医院','漳州中医院')
	) ;
-- 前6位相同报表重复情况
	select * from 
		(select project_name,substr(report_name,1,6) as report_name from ZOEHIS4RPT.report_used_1to6_month
	group by project_name,substr(report_name,1,6)
	having count(1)>1)
		pivot 
		(count(report_name) 
		for project_name in ('安溪县医院','长泰县医院','第一医院','福建省妇幼保健院','海沧医院','马尾医院','莆田市第一医院','厦门儿童医院','厦门二院','厦门妇幼','漳浦县医院','漳州市医院','漳州中医院')
		) ;
	