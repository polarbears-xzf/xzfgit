<link href="../zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../index.html)


###	LVM使用方法
>	LVM介绍
1.	LVM(Logical Volume Manager)逻辑卷管理是在Linux2.4内核以上实现的磁盘管理技术。它是Linux环境下对磁盘分区进行管理的一种机制。LVM的工作原理：通过将底层的物理硬盘抽象的封装起来，然后以逻辑卷的方式呈现给上层应用。在传统的磁盘管理机制中，我们的上层应用是直接访问文件系统，从而对底层的物理硬盘进行读取，而在LVM中，其通过对底层的硬盘进行封装，当我们对底层的物理硬盘进行操作时，其不再是针对于分区进行操作，而是通过一个叫做逻辑卷的东西来对其进行底层的磁盘管理操作。
2.	LVM的组成
    *   PV(Physical Volume)：物理卷，处于LVM最底层，可以是物理硬盘或者分区。
    *   VG(Volume Group)：卷组，建立在PV之上，可以含有一个到多个PV。
    *   LV(Logical Volume)：逻辑卷，建立在VG之上，相当于原来分区的概念。不过大小可以动态改变。
3.	LVM的优缺点
    *   优点
        *   可以在系统运行的状态下动态的扩展文件系统的大小
        *   文件系统可以跨多个磁盘，因此文件系统大小不会受物理磁盘的限制
        *   可以增加新的磁盘到LVM的存储池中
    *   缺点
        *   当卷组中的一个磁盘损坏时，整个卷组都会受到影响
        *   存贮性能会有些微影响

>	LVM创建
1.	查看新增磁盘

	    [root@zydb144 ~]# fdisk -l
		Disk /dev/sdc: 322.1 GB, 322122547200 bytes
		255 heads, 63 sectors/track, 39162 cylinders
		Units = cylinders of 16065 * 512 = 8225280 bytes
		Sector size (logical/physical): 512 bytes / 512 bytes
		I/O size (minimum/optimal): 512 bytes / 512 bytes
		Disk identifier: 0x00000000
2.	磁盘分区

	    [root@zydb144 ~]# fdisk /dev/sdc
        1）输入：n（创建一个新的分区）
        2）输入：p（创建一个基本分区）
        3）选择分区编号，1~4，默认使用1，直接按回车即可。
        4）选择分区起始点，使用默认即可，直接按回车。
        5）选择分区终点，使用默认即可，直接按回车。
        6）输入：t（更改分区编号）
        7）输入：8e（Linux LVM的编号）
        8）输入：w（保存退出）
3.	创建pv、vg、lv

	    [root@zydb144 ~]# pvcreate /dev/sdc1
          Physical volume "/dev/sdc1" successfully created.
        [root@zydb144 ~]# vgcreate vgzoesoft /dev/sdc1
          Volume group "vgzoesoft" successfully created.
        [root@zydb144 ~]# vgdisplay
          --- Volume group ---
          VG Name               vgzoesoft
          System ID             
          Format                lvm2
          Metadata Areas        1
          Metadata Sequence No  4
          VG Access             read/write
          VG Status             resizable
          MAX LV                0
          Cur LV                3
          Open LV               3
          Max PV                0
          Cur PV                1
          Act PV                1
          VG Size               300.00 GiB
          PE Size               4.00 MiB
          Total PE              76799
          Alloc PE / Size       76799 / 300.00 GiB
          Free  PE / Size       0 / 0
          VG UUID               1bfbiv-mFqu-HJEk-FPhB-VHLF-nxzk-spWqHp
        [root@zydb144 ~]# lvcreate -L 300G -n lvzoesoft1 vgzoesoft
          Logical volume "lvzoesoft1" created.
4.	格式化lv

	    1）查看系统文件类型
        [root@zydb144 ~]# df -Th
        Filesystem                Type   Size  Used Avail Use% Mounted on
        /dev/mapper/vg_zy-lv_root ext4    50G  8.7G   38G  19% /
        tmpfs                     tmpfs  7.8G   32M  7.7G   1% /dev/shm
        /dev/sdc1                 ext4   300G  780M  299G   1% /zoedata
        
        2）文件类型为ext4，格式化lv
        [root@zydb144 ~]# mkfs.ext4 /dev/vgzoesoft/lvzoesoft1
5.	编辑/etc/fstab文件，使该磁盘开机自动挂载

        [root@zydb144 ~]# vi /etc/fstab
        /dev/vgzoesoft/lvzoesoft1  /zoedata            ext4     defaults  0 0
        [root@zydb144 ~]# mount -a
        [root@zydb144 ~]# df -Th
        Filesystem                       Type   Size  Used Avail Use% Mounted on
        /dev/mapper/vg_zy-lv_root        ext4    50G  8.7G   38G  19% /
        tmpfs                            tmpfs  7.8G   32M  7.7G   1% /dev/shm
        /dev/mapper/vgzoesoft-lvzoesoft1 ext4   300G  780M  299G   1% /zoedata
       
>	LVM扩容
1.	卷组还有可用空间，可直接扩容

	    [root@zydb144 ~]# lvextend -L +100G /dev/mapper/vgzoesoft-lvzoesoft1
          Extending logical volume lvm to 100.00 GiB
          Logical volume lvm successfully resized
		[root@zydb144 ~]# resize2fs /dev/mapper/vgzoesoft-lvzoesoft1
2.	新增一块硬盘sdd

	    [root@zydb144 ~]# pvcreate /dev/sdd
          Physical volume "/dev/sdd" successfully created
		[root@zydb144 ~]# vgextend vgzoesoft /dev/sdd
          Volume group "vgzoesoft" successfully extended
        [root@zydb144 ~]# lvextend -L +100G /dev/mapper/vgzoesoft-lvzoesoft1
          Extending logical volume lvm to 100.00 GiB
          Logical volume lvm successfully resized
        [root@zydb144 ~]# resize2fs /dev/mapper/vgzoesoft-lvzoesoft1
        [root@zydb144 ~]# df -Th
        Filesystem                       Type   Size  Used Avail Use% Mounted on
        /dev/mapper/vg_zy-lv_root        ext4    50G  8.7G   38G  19% /
        tmpfs                            tmpfs  7.8G   32M  7.7G   1% /dev/shm
        /dev/mapper/vgzoesoft-lvzoesoft1 ext4   400G  780M  399G   1% /zoedata

			
[文档主页](../index.html)