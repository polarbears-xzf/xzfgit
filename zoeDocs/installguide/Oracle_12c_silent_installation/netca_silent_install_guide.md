<link href="../../zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../../../index.html)
[上一页](../Oracle_12c_silent_installation_index.html)


###	静默创建Oracle监听 

1.	静默创建Oracle监听(Oracle用户)
	>
		netca -silent -responsefile /home/oracle/database/response/netca.rsp
2.	注意事项
	1.	找不到netca命令
		*	需配置环境变量中ORACLE_HOME变量
	2.	客户端无法连接
		*	需配置hosts将IP与hostname关联
	
[文档主页](../../../index.html)
[上一页](../Oracle_12c_silent_installation_index.html)
