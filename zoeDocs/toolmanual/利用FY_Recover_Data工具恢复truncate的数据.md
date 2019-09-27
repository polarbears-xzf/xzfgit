<link href="../zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../index.html)

    
    ###	利用FY_Recover_Data工具恢复truncate的数据

> 模拟实验

----------

    一、模拟truncate操作：

----------

1. create table t as select * from dba_data_files;   -----随便创建个表
2. select * from t;
3. select count(*) from t;
  COUNT(*)
----
        5
4. truncate table t;

5. select count(*) from t;
  COUNT(*)
----
        0
> 二、恢复truncate表的数据

----------
原理:
TRUNCATE不会逐个清除用户数据块上的数据，而仅仅重置数据字典和元数据块上的元数据（如存储段头和扩展段图）。也就是说，此时，其基本数据并未被破坏，而是被系统回收、等待被重新分配————因此，要恢复被TRUNCATE的数据，需要及时备份其所在的数据文件。

----------

1.下载恢复工具到数据库服务器
Fy_Recover_Data是利用Oracle表扫描机制、数据嫁接机制恢复TRUNCATE或者损坏数据的工具包。由纯PLSQL编写

**(FY_Recover_Data.sql)**

----------

2.以下步操作均用sys用户执行
SQL> @D:\flashback\FY_Recover_Data.sql

这个脚本实际是在sys用户下创建了一个名为FY_Recover_Data的package

----------

3.使用sys用户找出存放truncate表的数据文件路径，下一步会用到这个文件路径

 select file_name from dba_data_files f, dba_tables t where t.owner='SYS' and t.table_name='T' and t.tablespace_name = f.tablespace_name;      
---用户名和表空间大写

查得结果是D:\APP\ADMINISTRATOR\ORADATA\TEST\SYSTEM01.DBF

----------


4.使用sys用户执行以下操作开始恢复：

----------

	declare
      tgtowner varchar2(30);
      tgttable varchar2(30);
      datapath varchar2(4000);
      datadir varchar2(30);
      rects varchar2(30);
      recfile varchar2(30);
      rstts varchar2(30);
      rstfile varchar2(30);
     blksz number;
     rectab varchar2(30);
     rsttab varchar2(30);
     copyfile varchar2(30);
    begin
     tgtowner := 'SYS'; ---用户
     tgttable := 'T';  ---表名
     datapath := 'D:\APP\ADMINISTRATOR\ORADATA\TEST\';    --表所在的数据文件的目录相同
     datadir := 'FY_DATA_DIR';       
     Fy_Recover_data.prepare_files(tgtowner, tgttable, datapath, datadir, rects, recfile, rstts, rstfile, blksz);
     Fy_Recover_data.fill_blocks(tgtowner, tgttable, datadir, rects, recfile, rstts, 8, tgtowner, tgtowner, rectab, rsttab, copyfile);
     Fy_Recover_data.recover_table(tgtowner, tgttable, tgtowner, rectab, tgtowner, rsttab, datadir, datadir, recfile,datadir, copyfile, blksz);
    end;
    /
   

----------

   注：执行上的SQL产生2个表空间FY_REC_DATA、FY_RST_DATA，还有1个copy文件。
执行多次上述语句，表不同的情况，则会产生多个表空间。

----------

5.使用sys用户把恢复的数据从sys.t$$中插回sys.t表

注：sys.t$$中是sys.t表truncate之前的数据,若是用户ogg，表test则生成ogg.test$$

 insert into sys.t select * from sys.t$$;

commit;

select count(*) from t;

  COUNT(*)
----------
        5
可以看到被truncate的数据已经恢复。

----------

6.使用sys用户删除恢复时产生的2个表空间及数据文件

drop tablespace fy_rec_data including contents and datafiles cascade constraint;

drop tablespace fy_rst_data including contents and datafiles cascade constraint;

以及删除包drop package FY_Recover_Data;

7、不足：无法同时恢复多张表


[文档主页](../index.html)