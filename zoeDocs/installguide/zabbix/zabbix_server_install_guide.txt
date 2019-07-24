<link href="zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../../index.html)
[上一页](../zabbix_install_index.html)

>	_Created in 2019.07.19 by natsume_  
>	_Copyright (c) 20xx, CHINA and/or affiliates._  
>	_docname basic_datanode_install_guide_  
##	 首先要安装好LAMP的环境
####1.	下载mysql的yum配置并安装
	* wget -P /opt/ https://dev.mysql.com/get/mysql80-community-release-el6-1.noarch.rpm
	* rpm -ivh  /opt/ https://dev.mysql.com/get/mysql80-community-release-el6-1.noarch.rpm #mysql的yum配置里的enabled=0要改成1（里面有很多个版本，选择要安装的版本去修改）
####2.	安装mysql
	* yum -y install mysql-community-server 
	* yum -y install mysql-connector-odbc mysql-devel libdbi-dbd-mysql
####3.	安装php的YUM源并安装PHP以及一些组件
	* rpm -ivh  http://mirror.webtatic.com/yum/el6/latest.rpm
	* yum -y install php71w php71w-bcmath php71w-bcmatch php71w-cli 
	* yum -y install php71w-fpm php71w-common php71w-gd php71w-mbstring php71w-mysql php71w-pdo php71w-xml php71w-ldap
	* yum -y install php71w-pear php71w-xmlrpc php71w-devel
####4.	安装Web环境,以下rpm包在光盘里有
	* yum -y install httpd httpd-manual mod_ssl mod_perl mod_auth_mysql 
	* service php-fpm start
	* service mysqld  start 
####5.	安装zabbix的yum配置并安装zabbix
    * rpm -i https://repo.zabbix.com/zabbix/4.2/rhel/6/x86_64/zabbix-release-4.2-1.el6.noarch.rpm
    * yum -y install zabbix-server-mysql zabbix-web-mysql zabbix-agent  zabbix-get zabbix-sender zabbix-proxy-mysql
####6.	安装好后修改下mysql密码以及修改密码规则
      grep password /var/log/mysqld.log   --获得临时密码
      mysql -u root -p                    --用临时密码登陆
      set global validate_password.policy=0;
      set global validate_password.length=1;  ----修改密码策略，看着改吧
      alter user 'root'@'localhost' identified by 'zabbix';  修改密码
      ALTER USER 'root'@'localhost' IDENTIFIED BY 'zabbix' PASSWORD EXPIRE NEVER; 
      ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'zabbix';
      ALTER USER 'zabbix'@'localhost' IDENTIFIED BY 'zabbix' PASSWORD EXPIRE NEVER; 
      ALTER USER 'zabbix'@'localhost' IDENTIFIED WITH mysql_native_password BY 'zabbix';
####7.	创建zabbix数据库、用户、授权、导数据
    * create database zabbix character set utf8 collate utf8_general_ci;
    * create user 'zabbix'@'%' identified by 'zabbix';
    * grant all privileges on *.* to zabbix@'%';
    * flush privileges;
    * zcat  /usr/share/doc/zabbix-server-mysql-4.2.4/create.sql.gz | mysql -u zabbix -p zabbix(这是库名)
####8.	配置zabbix的server端数据连接 
     [root@localhost ~]# vim /etc/zabbix/zabbix_server.conf
     ListenPort=10051
     DBHost=127.0.0.1
     DBName=zabbix
     DBUser=zabbix
     DBPassword=zabbix
     DBSocket=/tmp/mysql.sock
     DBPort=3306
     [root@test ~]# service zabbix-server restart
####9.	修改zabbix agentd 的配置文件以及php的配置并重启
     vi  /etc/zabbix/zabbix_agentd.conf
     Server=127.0.0.1  #被动模式，允许哪台服务区连接agent,多个服务器逗号隔开
     ListenPort=10050
     ListenIP=0.0.0.0
     ServerActive=127.0.0.1 #主动模式，允许向哪台服务器传送监控数据,多个服务器逗号隔开
     service zabbix-agent restart
     
     vim /etc/php.ini
     date.timezone = Asia/Shanghai
     post_max_size = 16M
     max_execution_time = 300
     max_input_time = 300
     ;mbstring.func_overload=2
     always_populate_raw_post_data = -1
     service httpd restart
####10.  配置zabbix的web访问并自动启动
     [root@localhost ~]# cp -R /usr/share/zabbix /var/www/html/
     [root@localhost ~]# chown apache:apache -R /var/www/html/zabbix
     [root@localhost ~]# service httpd restart
     chkconfig zabbix-server on
     chkconfig zabbix-agent on
     chkconfig httpd on
     chkconfig php-fpm on
####11.  打开zabbix网页端，测试，并进行最后配置
    * http://127.0.0.1/zabbix 打开网页检查安装要求，确保所有条件都ok,其他配置按要求配置，比如输密码和数据库ip。

[文档主页](../../index.html)
[上一页](../zabbix_install_index.html)
