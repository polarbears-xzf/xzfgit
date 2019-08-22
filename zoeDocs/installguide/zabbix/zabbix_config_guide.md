<link href="zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../../index.html)
[上一页](../zabbix_install_index.html)

>	_Created in 2019.08.05 by natsume_  
>	_Copyright (c) 20xx, CHINA and/or affiliates._  
 
##	 服务端和客户端安装好后进入zabbix页面进行监控配置
####1.	zabbix的ip地址
	* http://127.0.0.1/zabbix
	* 用户名admin  密码 zabbix
####2.	语言配置
	* 右上角用户标志-->可设置中文界面显示
	上传windows自带的中文字体宋体到/usr/share/zabbix/assets/fonts目录里
    rm -f /etc/alternatives/zabbix-web-font
    ln -s /usr/share/zabbix/assets/fonts/simkai.ttf /etc/alternatives/zabbix-web-font
    以上步骤是防止图形显示时中文乱码的问题
####3.	zabbix的菜单结构
	* 监测：仪表盘，问题，概览，web监测，最新数据，图形，聚合图形，拓扑图，自动发现，服务（主要是查看监控数据、数据图形、发现的问题）
	* 资产记录：概览，主机（主要是登记服务器硬件信息的）
	* 报表：系统信息，可用性报表，触发器，Top 100，审计，动作日志，警报
	* 配置：主机群组，模板，主机，维护，动作，关联项事件，自动发现，服务（主要是配置监控模板、触发器、群组、主机的相关设置都在这里）
	* 管理：一般,agent代理程序,认证,用户群组,用户,报警媒介类型,脚本,队列(管理zabbix应用的相关设置)
####4.	监控配置
	* 配置-->主机-->创建主机-->填写安装过zabbix客户端的主机ip和端口，主机名要和zabbix客户端安装时的主机名一致（这个步骤也可以通过配置里的自动发现和动作去设置自动发现主机的规则来自动创建主机，配置方式可以去查看我的配置信息，看了就懂不难）
	* 配置-->主机群组-->创建linux群组-->把添加的主机拉到linux群组里,做好分类
	* 配置-->模板-->创建linux监控模板-->把linux监控模板拉到linux群组里,这样以后再linux群组里的主机都对应linux监控模板
	* 点开linux监控模板-->点击监控项-->新建监控项
	* 这里来创建一个监控剩余内存大小的监控:填写监控名称,监控类型,键值,单位,更新间隔,数据保留时间,归属于哪个应用集.(这里的键值是vm.memory.size[available],这个命令用来监控内存剩余大小,可在zabbix服务器上测试zabbix_get -s 192.168.1.144 -k vm.memory.size[available] 是否有监控到数值)
####5.	配置触发器
    * 配置-->模板-->linux监控模板-->触发器-->创建触发器
    * 触发器可以设置一个阈值,当超过这个阈值zabbix就会警报.填入名称,严重程度,表达式(表达式这里我监控的是内存剩余小于20M就告警,{Template OS Linux:vm.memory.size[available].last(0)}<20M 格式是模板名称:键值.最后一条监控到的信息值<20M)
####6.	配置监控图形
    * 配置-->模板-->linux监控模板-->图形-->创建图形
    * 输入图形名称,图形大小,图形类别,选择监控项
####7.	总结
    * 到此就配置了一个简单的内存可用大小的监控,其他的配置以此类推,zabbix也提供了很多默认的模板可以供我们参考,提供的模板也很全,改一改就可以用了,基本的监控信息都有,我们可以登录上去看一下各个配置,就知道怎么配置了.

[文档主页](../../index.html)
[上一页](../zabbix_install_index.html)
