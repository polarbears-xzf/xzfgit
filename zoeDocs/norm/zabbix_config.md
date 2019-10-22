<link href="../zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../index.html)

### Zabbix Server配置规范
*	安装规范
	*	mysql数据库my.cnf配置参数
		*	数据库名： 	zabbix
		*	数据库用户：zabbix
		*	数据库密码：具备一定长度和复杂度
		*	服务端口：	3306
	*	zabbix_server.conf配置参数
		*	ListenPort=10051	   # 监听端口
		*	DBHost=192.168.1.11	   # mysql数据库IP地址
		*	DBName=zabbix	       # mysql数据库名
		*	DBUser=zabbix	       # mysql数据库用户
		*	DBPassword=具备一定长度和复杂度
		*	DBPort=3306	           # mysql数据库服务端口
*	配置规范
	*	代理
		*	菜单：管理-agent代理
		*	参数
			*	agent代理程序名称：zoezbxproxy  # 代理安装规范中的Hostname
			*	系统代理程序模式：主动式        # 代理安装规范中的ProxyMode
			*	代理地址：192.168.1.12          # 代理服务器地址
	*	主机群组
		*	
	*	模版
	*	主机
###	Zabbix proxy配置规范
*	安装规范
	*	mysql数据库my.cnf配置参数
		*	数据库名： 	zabbixproxy
		*	数据库用户：zabbixproxy
		*	数据库密码：具备一定长度和复杂度
		*	服务端口：	3306
	*	zabbix_proxy.conf配置参数
		*	ProxyMode=0            # 优先配置0（主动模式），安全条件不允许情况下配置1（被动模式）
		*	Server=192.168.1.11    # 管理服务器地址（注2），主动模式时为代理发送数据的管理服务器地址服务器地址，被动模式下为允许连接到代理的管理服务器地址服务器地址列表
		*	ServerPort=10051       # Zabbix Server服务器端口
		*	Hostname=zoezbxproxy   # Zabbix proxy名称（注1）。zabbix服务器识别代理的唯一标识，
		*	ListenPort=10052       # Zabbix proxy端口
		*	SourceIP=192.168.1.12  # Zabbix proxy外联IP地址
		*	DBHost=192.168.1.12	   # mysql数据库IP地址
		*	DBName=zabbixproxy	   # mysql数据库名
		*	DBUser=zabbixproxy	   # mysql数据库用户
		*	DBPassword=具备一定长度和复杂度
		*	DBPort=3306	           # mysql数据库服务端口
		*	ConfigFrequency=600    # 代理向服务器检索配置信息的频率，单位秒
		*	DataSenderFrequency=1  # 代理向服务器发送采集数据的频率，单位秒
###	Zabbix agent配置规范
*	安装规范
	*	zabbix_agented.conf配置参数
		*	Server=192.168.1.12       # 被动模式（注3），允许哪台服务器连接agent,多个服务器逗号隔开
		*	SourceIP=192.168.1.13     # Zabbix agent外联IP地址
		*	ListenPort=10050          # 客户端监听端口
		*	ListenIP=0.0.0.0          # 客户端监听IP
		*	Hostname=zoezbxserver     # 客户端名称（注1）
		*	ServerActive=192.168.1.11 # 主动模式（注4），允许向哪台服务器传送监控数据,多个服务器逗号隔开
###	注1：命名规则
*	zabbix Server客户端名称：“项目名称” + “zbxserver”
*	Zabbix proxy名称：“项目名称” + “zbxproxy”
*	被管服务器客户端：“项目名称” + “_ostype” + “_hostname” + “_ipaddress”
*	被管数据库：“项目名称” + “_dbtype” + “_dbname” + “_ipaddress”
###	注2：管理服务器地址
*	配置公司统一管理服务器地址，使用DNS
###	注3：被动模式
*	被动模式配置Zabbix proxy地址，用于向公司统一管理服务器发送数据
###	注4：主动模式
*	主动模式配置本地Zabbix Server地址，用于本地监控服务
	
	
	
[文档主页](../index.html)
	