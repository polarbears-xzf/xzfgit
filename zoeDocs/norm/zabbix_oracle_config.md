<link href="../zoe_docs.css" rel="stylesheet" type="text/css" />

###	orabix 配置规范
*	安装规范
*	配置规范
	*	config.props配置
		*	ZabbixServerList=zabbixserver
		*	zabbixserver.Address=192.168.1.44
		*	zabbixserver.Port=10051
		*	DatabaseList=
		*	Url=jdbc:oracle:thin:@ipaddress:1521/orcl  # 配置数据库连接地址
		*	User=zabbix                                # 配置数据库连接用户
		*	Password=zabbix
		*	MaxActive=10
		*	MaxWait=100
		*	MaxIdle=1
		*	QueryListFile=./conf/query.props           # 监控脚本，数据库查询语法
	*	query.props配置
		*	DefaultQueryPeriod=2                          # 默认采集周期，单位分钟
		*	QueryList=collectmetric1,collectmetric2       # 采集指标列表，必须和采集指标语法对应
		*	collectmetric1.RaceConditionQuery=select语句  # 采集执行前置条件语法
		*	collectmetric1.RaceConditionValue=TRUC/FALSE  # 采集执行前置条件值
		*	collectmetric1.Period=30                      # 定制采集周期，单位分钟
		*	collectmetric1.NoDataFound=none               # 无数据返回值
		*	collectmetric1.Query=select sysdate from dual # 采集指标语法