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