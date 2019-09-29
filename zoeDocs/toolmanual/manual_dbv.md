<link href="../zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../index.html)


##	DBV工具的介绍与使用
----------

 DBV(DBVERIFY)是Oracle提供的一个命令行工具，它可以对数据文件物理和逻辑两种一致性检查。DBV只能检查可缓存管理的块(数据块)，所以只能用于数据文件，不支持控制文件和重做日志文件的块检查。DBV使用于offline或者online的数据文件，也可也验证备份文件，但是备份文件只能是rman的copy命令或者操作系统的cp(win下是copy)命令备份的数据文件。

----------
特点：
-
1. 以只读的方式打开数据文件，在检查过程中不会修改数据文件的内容。

2. 可以在线检查数据文件，而不需要关闭数据库。

3. 不能检查控制文件和日志文件，只能检查数据文件。

4. 这个工具可以检查ASM文件，但数据库必须Open状态，并且需要通过USERID指定用户，比如：dbv file=+DG1/ORCL/datafile/system01.dbf userid=system/sys

5. 在许多UNIX平台下，DBV要求数据文件有扩展名，如果没有可以通过建立链接的方法，然后对链接的方法，然后对链接文件进行操作，比如：ls -n /dev/rdsk/mydevice /tmp/mydevice.dbf
 
6. 某些平台，DBV工具不能检查超过2GB的文件，如果碰到DBV-100错误，请先检查文件大小，MOS Bug 710888对这个问题有描述。
 
7. DBV只会检查数据块的正确性，但不会关系数据块是否属于哪个对象。
 
8. 对于祼设备建议指定END参数，避免超出数据文件范围。比如：dbv FILE=/dev/rdsk/r1.dbf END=<last_block_number>。可以在v$datafile视图中用bytes字段除以块大小来获得END值。

----------
 参数：

| 参数       	| 含义           | 缺省值  |
| ------------- |:-------------:| -----:|
| FILE     | 要检查的数据文件名 | 没有缺省值 |
| START      | 检查起始数据块号      |   数据文件的第一个数据块 |
| END | 检查的最后一个数据块号     |    数据文件的最后一个数据块 |
| BLOCKSIZE     | 数据块大小，这个值要和数据库的DB_BLOCK_SIZE参数值一致 | 8192 |
| LOGFILE      | 检查结果日志文件      |   没有缺省值 |
| FEEDBAK | 显示进度     |    0 |
| PARFILE     | 参数文件名 | 没有缺省值 |
| USERID      | 用户名、密码      |   没有缺省值 |
| SEGMENT_ID | 段ID，参数格式<tsn.segfile.segblock>     |    没有缺省值 |


----------
使用示例：
-


	    C:\Users\Administrator>dbv file=D:\DATABASE\USER02.DBF
		DBVERIFY: Release 11.2.0.1.0 Production on 星期五 9月 27 16:26:05 2019
		Copyright (c) 1982, 2009, Oracle and/or its affiliates.  All rights reserved.
		DBVERIFY 开始验证: FILE = D:\DATABASE\USER02.DBF
		DBVERIFY 验证完成
		检查的页总数: 1280
		处理的页总数 (数据): 0
		失败的页总数 (数据): 0
		处理的页总数 (索引): 0
		失败的页总数 (索引): 0
		处理的页总数 (其他): 127
		处理的总页数 (段)  : 0
		失败的总页数 (段)  : 0
		空的页总数: 1153
		标记为损坏的总页数: 0
		流入的页总数: 0
		加密的总页数        : 0
		最高块 SCN            : 1002791 (0.1002791)

这个工具报告使用的是page作为单位，含义和data block相同。从上面的检查结果可以看出文件没有坏块。

除了检查数据文件，这个工具还允许检查单独的Segment，这时参数值的格式为<tsn.segfile.segblock>
查看对象的tsn,segfile,segblock属性：
	
```
create table T as select * from dba_data_files;

```
	select t.ts#, s.header_file, s.header_block from v$tablespace t, dba_segments s where s.segment_name = 'T' and t.name = s.tablespace_name;

		TS#  HEADER_FILE  HEADER_BLCK

		0			1			87392
从上面的查询结果可行参数值为**0.1.87392**。检查Segment：

		C:\Users\Administrator>dbv userid=system/oracle segment_id=0.1.87392
		DBVERIFY: Release 11.2.0.1.0 - Production on 星期五 9月 27 16:56:21 2019
		Copyright (c) 1982, 2009, Oracle and/or its affiliates.  All rights reserved.
		DBVERIFY - 开始验证: SEGMENT_ID = 0.1.87392
		DBVERIFY - 验证完成
		检查的页总数: 9
		处理的页总数 (数据): 0
		失败的页总数 (数据): 0
		处理的页总数 (索引): 0
		失败的页总数 (索引): 0
		处理的页总数 (其他): 1
		处理的总页数 (段)  : 2
		失败的总页数 (段)  : 0
		空的页总数: 6
		标记为损坏的总页数: 0
		流入的页总数: 0
		加密的总页数        : 0
		最高块 SCN            : 988504 (0.988504)


下面人为创造一个坏块，用dbv来检查。
	select tablespace_name from dba_segments s where s.segment_name = 'T';

		TABLESPACE_NAME

		SYSTEM
我们验证system的数据文件

	C:\Users\Administrator>dbv file=D:\APP\ADMINISTRATOR\ORADATA\TEST1\SYSTEM01.DBF
	DBVERIFY: Release 11.2.0.1.0 - Production on 星期五 9月 27 17:26:57 2019
	Copyright (c) 1982, 2009, Oracle and/or its affiliates.  All rights reserved.
	DBVERIFY - 开始验证: FILE = D:\APP\ADMINISTRATOR\ORADATA\TEST1\SYSTEM01.DBF
	DBVERIFY - 验证完成
	检查的页总数: 88320
	处理的页总数 (数据): 58440
	失败的页总数 (数据): 0
	处理的页总数 (索引): 12175
	失败的页总数 (索引): 0
	处理的页总数 (其他): 3362
	处理的总页数 (段)  : 1
	失败的总页数 (段)  : 0
	空的页总数: 14343
	标记为损坏的总页数: 0
	流入的页总数: 0
	加密的总页数        : 0
	最高块 SCN            : 1201615 (0.1201615)

当前数据文件没有坏块。

获取该表的数据块号block_id和数据文件file_id

	select dbms_rowid.rowid_object(rowid) object_id,
       dbms_rowid.rowid_block_number(rowid) block_id,
       dbms_rowid.rowid_relative_fno(rowid) file_id,
       dbms_rowid.rowid_row_number(rowid) num from T;

		object_id BLOCK_ID  FILE_ID  	NUM
		73699		87393		1		0
		73699		87393		1		1
		73699		87393		1		2
		73699		87393		1		3
		73699		87393		1		4
		73699		87393		1		5

进行人为破坏

	C:\Users\Administrator>rman target/

	恢复管理器: Release 11.2.0.1.0 - Production on 星期五 9月 27 17:54:55 2019
	
	Copyright (c) 1982, 2009, Oracle and/or its affiliates.  All rights reserved.
	
	连接到目标数据库: TEST1 (DBID=1390142278)
	
	RMAN> recover datafile 1 block 87393 clear;
	
	启动 recover 于 27-9月 -19
	使用目标数据库控制文件替代恢复目录
	分配的通道: ORA_DISK_1
	通道 ORA_DISK_1: SID=37 设备类型=DISK
	完成 recover 于 27-9月 -19

进行查询

	SQL> alter system flush buffer_cache; ---使用该方法强制Oracle重新执行物理读
	
	系统已更改。
	
	SQL> select * from system.T;
	select * from system.T
	                     *
	第 1 行出现错误:
	ORA-01578: ORACLE 数据块损坏 (文件号 1, 块号 87393)
	ORA-01110: 数据文件 1: 'D:\APP\ADMINISTRATOR\ORADATA\TEST1\SYSTEM01.DBF'

查询到坏块错误ORA-01578: ORACLE 数据块损坏 (文件号 1, 块号 87393)

下面用dbv验证一下

	C:\Users\Administrator>dbv file=D:\APP\ADMINISTRATOR\ORADATA\TEST1\SYSTEM01.DBF
	
	DBVERIFY: Release 11.2.0.1.0 - Production on 星期五 9月 27 17:59:14 2019
	
	Copyright (c) 1982, 2009, Oracle and/or its affiliates.  All rights reserved.
	
	DBVERIFY - 开始验证: FILE = D:\APP\ADMINISTRATOR\ORADATA\TEST1\SYSTEM01.DBF
	页 87393 标记为损坏
	Corrupt block relative dba: 0x00415561 (file 1, block 87393)
	Bad header found during dbv:
	Data in bad block:
	 type: 6 format: 2 rdba: 0x00415561
	 last change scn: 0x0000.0012524f seq: 0x2 flg: 0x04
	 spare1: 0xb3 spare2: 0x7a spare3: 0x0
	 consistency value in tail: 0x524f0602
	 check value in block header: 0xf53d
	 computed block checksum: 0x7ab3

	DBVERIFY - 验证完成
	
	检查的页总数: 88320
	处理的页总数 (数据): 58439
	失败的页总数 (数据): 0
	处理的页总数 (索引): 12175
	失败的页总数 (索引): 0
	处理的页总数 (其他): 3362
	处理的总页数 (段)  : 1
	失败的总页数 (段)  : 0
	空的页总数: 14343
	标记为损坏的总页数: 1
	流入的页总数: 0
	加密的总页数        : 0
	最高块 SCN            : 1202520 (0.1202520)

	
得到结果有一个坏块信息。
修复坏块信息的话，有rman备份的情况下可使用blockrecover命令修复，例如本例

	blockrecover datafile 1 block 87393;

若是使用dbv检查asm中的数据文件，需要指定userid参数

[文档主页](../index.html)