<link href="../zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../index.html)


###	Oracle rac 单网卡改双网卡绑定
1.	关闭集群服务

	* srvctl stop database -d dyyy
	* srvctl stop asm -n hisrac1
	* srvctl stop asm -n hisrac2
	* srvctl stop nodeapps -n hisrac1
	* srvctl stop nodeapps -n hisrac2

2.	修改网crs网卡设备信息

	查看设备名信息

	[root@hisrac1 bin]# ./oifcfg getif

	eth0  192.0.1.0  global  public

	eth2  192.168.123.0  global  cluster_interconnect

	增加新设备名信息

	[root@hisrac1 bin]# ./oifcfg setif -global bond0/192.0.1.0:public

	[root@hisrac1 bin]# ./oifcfg setif -global bond1/192.168.123.0:cluster_interconnect

	删除旧设备名信息

	[root@hisrac1 bin]# ./oifcfg delif -global eth0

	[root@hisrac1 bin]# ./oifcfg delif -global eth2

	
3.	修改VIP配置信息

   	查看VIP配置信息

	[root@hisrac1 bin]# ./srvctl config nodeapps -n hisrac1 -a

	VIP exists.: /hisrac1-vip/192.0.1.85/255.255.255.0/eth0

	[root@hisrac1 bin]# ./srvctl config nodeapps -n hisrac2 -a

	VIP exists.: /hisrac1-vip/192.0.1.18/255.255.255.0/eth0

	修改VIP配置信息

	[root@hisrac1 bin]# ./srvctl modify nodeapps -n hisrac1 -A 192.0.1.85/255.255.255.0/bond0

	[root@hisrac1 bin]# ./srvctl modify nodeapps -n hisrac2 -A 192.0.1.18/255.255.255.0/bond0


4.	关闭crs服务

	hisrac1:

	[root@hisrac1 bin]# ./crsctl stop crs

	hisrac2:

	[root@hisrac2 bin]# ./crsctl stop crs


5.	网卡绑定配置


    [root@hisrac1 ~]# vi  /etc/modprobe.conf，添加以下几行：

    alias bond0 bonding

    alias bond1 bonding

    options bonding  max_bonds=2


    [root@hisrac1 ~]# vi /etc/sysconfig/network-scripts/ifconfig-bond0

     DEVICE=bond0
     
     ONBOOT=yes

     BOOTPROTO=static

     IPADDR=192.0.1.12

     NETMASK=255.255.255.0

     USERCTL=no
   
     TYPE=Ethernet

     BONGING=OPTS="mode=1 miimon=100"

   
     [root@hisrac1 ~]# vi /etc/sysconfig/network-scripts/ifconfig-eth0

     DEVICE=eth0
     
     ONBOOT=yes

     BOOTPROTO=none

     USERCTL=no
   
     TYPE=Ethernet
    
     MASTER=bond0

     SLAVE=yes


	[root@hisrac1 ~]# vi /etc/sysconfig/network-scripts/ifconfig-eth1


     DEVICE=eth1
     
     ONBOOT=yes

     BOOTPROTO=none

     USERCTL=no
   
     TYPE=Ethernet
    
     MASTER=bond0

     SLAVE=yes

    
     BOND1配置除了ip改下其他按照bond0一样设置，bond1网卡要对应eth2，eth3

	网络重启

	[root@hisrac1 ~]# service network restart 

	查看bond0状态

	[root@hisrac1 ~]# cat /proc/net/bonding/bond0
 
	查看bond1状态

	[root@hisrac1 ~]# cat /proc/net/bonding/bond1


     另一台服务器hisrac2也按以上步骤设置网卡绑定，ip要设置对，网卡也要对应。

6.	启动crs服务


   	hisrac1:

	[root@hisrac1 bin]# ./crsctl start crs

	hisrac2:

	[root@hisrac2 bin]# ./crsctl start crs

	由于没有修改IP，因此hosts和监听文件不需要调整。


[文档主页](../index.html)