<link href="../zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../index.html)


###	记一次病历保存慢的处理过程

1.	客户反馈病历保存慢，要10几秒，查看awr报告正常，没有什么明显的性能问题，负载也很低。

2.	抓取病历保存时的sql语句，分析sql语句，没有什么可以优化的，插入操作要5秒，这个insert在程序循环里，所以保存病历就更慢。
    
      INSERT INTO ZEMR_ NURSE_ DETAIL
      (PATIENT_ID,
       EVENT_NO,
       MASTER_ID,
       TEMPLATE_ID,
       EMR_TYPE,
        NURSE_TIME,
        BLOCK_NO,
        SEQUENCE,
       ROW_XML,
       STATUS)
      VALUES
      ('0003185533',
       '00228004002',
       '5F64FC21-CCBB-4FF0-A5F7-DDEFB3B9789C',
       4013,
       20,
       to_date('2019-09-10 16:19', 'YYYY-MM-DD HH24:MI:SS'),
       '100',
        1,
        sys.xmlType.createXML('xxx'),
       1)；

3.	跟踪insert语句执行过程
    *   alter session set events '10046 trace name context forever ,level 12' ;
    *   执行insert语句
    *   获取追踪trace文件 
    
         select
        d.value||'/'||lower(rtrim(i.instance, chr(0)))||'_ora_'||p.spid||'.trc' trace_file_name
         from
         ( select p.spid
        from sys.v$mystat m,sys.v$session s,sys.v$process p
         where m.statistic# = 1 and s.sid = m.sid and p.addr = s.paddr) p,
       ( select t.instance from sys.v$thread  t,sys.v$parameter  v
         where v.name = 'thread' and (v.value = 0 or t.thread# = to_number(v.value))) i,
         ( select value from sys.v$parameter where name = 'user_ dump_ dest') d;


    *   追踪文件里分析发现insert插入是很快的不到1秒，而其他时间都在执行oracle内部的东西，在查询DBA_ XML_ TABLES,在插入前都会做下面的查询语句，该语句的执行计划效率不高
    
        select o.obj# as TABLE_ NAME from DBA_ XML_ TABLES d, sys.obj$ o, sys.opqtype$ op, sys.user$ u where o.owner# =
        u.user# and d.table_name = o.name and d.owner = u.name and o.obj# = op.obj#
       and bitand(op.flags,32) = 32 and d.owner = :1 and op.schemaoid = :2
 
4.	分析DBA_ XML_ TABLES视图，对动态表和数据字典做一次统计信息收集
    *  exec dbms_ stats.gather_ fixed_ objects_ stats; 
    *  exec dbms_ stats.gather_ dictionary_ stats; 
	 


5.	执行统计信息完问题依旧，对DBA_ XML_ TABLES视图修改优化器，在select后面加个 /*+rule*/  ，重建视图，问题解决，病历保存1秒

 

			
[文档主页](../index.html)