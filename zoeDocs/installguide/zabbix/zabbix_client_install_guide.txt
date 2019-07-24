<link href="zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../../index.html)
[上一页](../zabbix_install_index.html)

>	_Created in 2019.07.23 by natsume_  
>	_Copyright (c) 20xx, CHINA and/or affiliates._  
##	 linux下的客户端安装
####1.	安装zabbix的yum配置并安装
	* rpm -i https://repo.zabbix.com/zabbix/4.2/rhel/6/x86_64/zabbix-release-4.2-1.el6.noarch.rpm
	* yum -y install zabbix zabbix-agent 
####2.	修改zabbix agentd 的配置文件
	/etc/zabbix/zabbix_agentd.conf
    Server=127.0.0.1  #被动模式，允许哪台服务区连接agent,多个服务器逗号隔开
    ListenPort=10050
    ListenIP=0.0.0.0
    hostname=127.0.0.1  #名字是标识符，zabbix网页配置里面的名字要和这个一致
    ServerActive=127.0.0.1 #主动模式，允许向哪台服务器传送监控数据,多个服务器逗号隔开
    启动zabbix agent端
    service zabbix-agent restart
    chkconfig zabbix-agent on
##	 windows下的客户端安装
####1.	下载并安装
	https://www.zabbix.com/download_agents 下载Windows版本
    zabbix_agentd.win.conf里的配置和linux的一样
    cmd里输入以下命令启动zabbix客户端服务和开启自启动
    cd D:\zabbix_agents\bin\win64
    Zabbix_agentd.exe -c D:\zabbix_agents\conf\zabbix_agentd.win.conf –i
    Zabbix_agentd.exe -c D:\zabbix_agents\conf\zabbix_agentd.win.conf –s
####2.在服务端可以输入下面命令来测试客户端是否安装成功
    zabbix_get -s 192.168.2.233 -k system.uname 

[文档主页](../../index.html)
[上一页](../zabbix_install_index.html)
