<link href="../../zoe_docs.css" rel="stylesheet" type="text/css" />


[上一页](../faultprocess_index.html)


1.	ElasticSearch日志分析模式
	*	t_log_req：以API为主索引记录API执行情况，包含以下属性域：
		*	requestId： 一次API请求唯一标识
		*	ipAndPort:  请求服务入口API地址
		*	createTime: 请求服务时间
		*	finishTime: 请求服务完成时间
		*	runTime:    请求服务运行时间
		*	requestUri: 请求服务入口API
	*	t_log_sql：以sql为主索引记录API执行情况，包含以下属性域：
		*	requestId： 一次API请求唯一标识
		*	createTime: 请求服务时间
		*	finishTime: 请求服务完成时间
		*	runTime:
		*	sqlHash:
		*	sql:
	*	t_log_warn：以warn为主索引记录执行时间告警情况，包含以下属性域
		*	requestId:一次API请求唯一标识
		*	type:
		*	createTime:
		*	runTime:
		*	taskHash:
		*	taskContent:
	
2.	从Oracle SQL执行记录中分析SQL执行情况  
	**脚本路径：zoescript/elasticsearch**
	1.	频繁执行的SQL分析：从t_log_sql索引中以最大执行次数、平均执行时间、最小执行时间、最大执行时间四个维度获取SQL语句
		*	

3.	OracleSQL执行记录分析模式
	*	gv$sql_monitor，包含以下属性：
		*	sql_id: 
	*	gv$sql_stats，包含以下属性：
		*	sql_id: 
	
4.	从ElasticSearch日志记录中分析API请求与SQL执行情况  
	**脚本路径：zoescript/elasticsearch**
	1.	单个API执行情况分析
		*	获取req索引指定API指定时间按日/小时分组以日期为降序，统计平均执行时间，最大执行时间，最小执行时间及标准方差。以分析执行API执行稳定性
		*	获取req索引中指定API指定时间范围内按运行时间排序，以分析指定API异常执行时间情况
	2.	API总体执行情况分析
		*	获取指定某日按执行时间分组以最大执行时间为降序的API统计，以分析不同时间分布消耗时间最高API情况
		*	获取req索引dict/drug/getDrugList按日分组以平均执行时间降序，以通过执行频繁最高的API分析日性能稳定性


[上一页](../faultprocess_index.html)
