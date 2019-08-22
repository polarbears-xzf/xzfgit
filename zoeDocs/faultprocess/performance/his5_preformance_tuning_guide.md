<link href="../../zoe_docs.css" rel="stylesheet" type="text/css" />


[上一页](../faultprocess_index.html)


1.	ElasticSearch日志分析模式
	*	t_log_req：以API为主索引记录API执行情况，包含一下属性域：
		*	requestId：
		*	ipAndPort:
		*	runTime:
		*	createTime:
		*	finishTime:
		*	requestUri:
	*	t_log_sql：以sql为主索引记录API执行情况，包含一下属性域：
		*	requestId：
		*	ipAndPort:
		*	runTime:
		*	createTime:
		*	finishTime:
		*	requestUri:
	
1.	从ElasticSearch日志记录中分析API请求与SQL执行情况  
	**脚本路径：zoescript/elasticsearch**
	2.	频繁执行的SQL分析：从t_log_sql索引中以最大执行次数、平均执行时间、最小执行时间、最大执行时间四个维度获取SQL语句
		*	



[上一页](../faultprocess_index.html)
