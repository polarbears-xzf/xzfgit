<link href="zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../../index.html)
[上一页](../zabbix_install_index.html)

>	_Created in 2019.08.06 by natsume_  
>	_Copyright (c) 20xx, CHINA and/or affiliates._  
 
##	 oracle监控用orabbix插件来进行监控，zabbix自带的没有oracle监控项，需要自行安装设置
####1.	下载zabbix，安装包找我拿，网上下的orabbix1.2.3在zabbix4.2上用不了，要去下个编译版的重新编译，我这里已经编译好包了。
####2.	安装jdk1.7或者1.8，安装很简单这里就不说了
####3.	安装orabbix
	* mkdir -p /opt/orabbix ，把安装包放到这个目录
	* unzip orabbix1.2.3.zip
	* chmod -R a+x orabbix/ 
	* cd /opt/orabbix/conf/ 
	* cp config.props.sample config.props 
	*  vim config.props 配置文件参数如下:连接数据库的信息
	     ZabbixServerList=zabbixserver
         zabbixserver.Address=192.168.1.44
         zabbixserver.Port=10051
         DatabaseList=test192.168.1.144
         DatabaseList.MaxWait=100
         DatabaseList.MaxIdle=1
         test192.168.1.144.Url=jdbc:oracle:thin:@192.168.1.144:1521/zoepub
         test192.168.1.144.User=zabbix
         test192.168.1.144.Password=zabbix_144
         test192.168.1.144.MaxActive=10
         test192.168.1.144.MaxWait=100
         test192.168.1.144.MaxIdle=1
         test192.168.1.144.QueryListFile=./conf/query.props
        其中query.props文件是监控脚本，后续有需要增加数据库监控可在这里增加脚本语句。
####4.	在oracle数据库创建zabbix用户并赋予权限
	* CREATE     USER     zabbix  
        IDENTIFIED    BY     zabbix  
        DEFAULT     TABLESPACE SYSTEM  
        TEMPORARY     TABLESPACE    TEMP  
        PROFILE    DEFAULT  ;  
        GRANT     CONNECT     TO     ZABBIX;  
        GRANT     RESOURCE    TO     ZABBIX;  
		GRANT SELECT ANY TABLE TO ZABBIX;
		GRANT CREATE SESSION TO ZABBIX;
		GRANT SELECT ANY DICTIONARY TO ZABBIX;
		GRANT UNLIMITED TABLESPACE TO ZABBIX;
		GRANT SELECT ANY DICTIONARY TO ZABBIX;
————————————————
版权声明：本文为CSDN博主「未来IT大牛@」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/weixin_44655414/article/details/88360398
####5.	启动orabbix
    * cp init.d/orabbix /etc/init.d/ 
    * /etc/init.d/orabbix start 
    * chkconfig --add orabbix 
    * systemctl start orabbix
    * chkconfig orabbix on
####6.	开放acl访问控制
    * exec     dbms_network_acl_admin.create_acl(acl =>    'resolve.xml'   ,description =>    'resolve acl'   , principal =>   'ZABBIX'   , is_grant =>    true   , privilege =>    'resolve'   );  
    * exec     dbms_network_acl_admin.assign_acl(acl =>    'resolve.xml'   , host =>   '*'   ); 
    * commit；
####7.	导入模板
    * 模版放置在/opt/orabbix/template下，有个Orabbix_export_full.xml 的模板
    * 打开zabbix网页端-->点击配置--->模板--->导入--->选择xml模板--->完成导入
####8.	总结
    * 模板导入完成后就能看到oracle的监控项、触发器、图形等等，可以打开每个配置项去修改，并应用到对应的主机或群组里，相关设置可参考zabbix监控配置。

[文档主页](../../index.html)
[上一页](../zabbix_install_index.html)
