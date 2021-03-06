<link href="../zoe_docs.css" rel="stylesheet" type="text/css" />


[文档主页](../index.html)

###	sqlloader使用说明
>	sqlloader用于将文本文件数据加载到Oracle表中  
>	实例脚本：zoescript/sqlloader
1.	sqlloader使用方式
	>	通过sqlldr命令连接数据库，使用.ctl控制文件申明的内容，将文本文件数据加载到Oracle表中
2.	sqlloader命令
	>	sqlldr ZOEADMIN/zoe$2017a@192.168.1.41/zoenew loadtable.ctl	
3.	sqlloader命令参数说明
	*	userid -- Oracle 的 username/password[@servicename]
	*	control -- 控制文件，可能包含表的数据
	*	log -- 记录导入时的日志文件，默认为 控制文件(去除扩展名).log
    *	bad -- 坏数据文件，默认为 控制文件(去除扩展名).bad
    *	data -- 数据文件，一般在控制文件中指定。用参数控制文件中不指定数据文件更适于自动操作
    *	errors -- 允许的错误记录数，可以用他来控制一条记录都不能错
    *	rows -- 多少条记录提交一次，默认为 64
    *	skip -- 跳过的行数，比如导出的数据文件前面几行是表头或其他描述
4.	sqlloader控制文件参数说明
	*	OPTIONS (skip=1,rows=128) --skip=1 跳过数据中的第一行，128行提交一次
    *	LOAD DATA --控制文件标识 
    *	INFILE 'test.txt' --指定外部数据文件，可以写多个 INFILE "another_data_file.csv" 指定多个数据文件
    *	BADFILE 'test.bad' --指定错误数据输出文件
    *	DISCARDFILE 'test.dsc' --指定错误记录文件
    *	APPEND --操作类型
		*	INSERT，为缺省方式，在数据装载开始时要求表为空 
        *	APPEND，在表中追加新记录 
        *	REPLACE，删除旧记录，替换成新装载的记录 
        *	TRUNCATE，同上
	*	INTO TABLE test WHEN user_name<>'system'--向表test中添加记录，还可以用 WHEN 子句选择导入符合条件的记录
    *	FIELDS TERMINATED BY ',' --数据中每行记录用 "," 分隔
    *	OPTIONALLY ENCLOSED BY '"' --数据中每个字段用 '"' 框起，比如字段中有 "," 分隔符时
    *	TRAILING NULLCOLS --表的字段没有对应的值时允许为空
    *	(VIRTUAL_COLUMN FILLER, --这是一个虚拟字段，用来跳过由 PL/SQL Developer 生成的第一列序号 
            user_id "user_seq.nextval", --这一列直接取序列的下一值，而不用数据中提供的值 
            user_name "'Hi '||upper(:user_name)", --能用SQL函数或运算对数据进行加工处理
            login_times terminated by",", NULLIF(login_times='NULL') --可为列单独指定分隔符 
            last_login DATE"YYYY-MM-DD HH24:MI:SS" --指定接受日期的格式，相当用 to_date() 函数转换
            user_sort NUMBER, --字段可以指定类型，否则认为是 CHARACTER 类型, log 文件中有显示 
        ) 
    *	CHARACTERSET --字符集
5.	sqlloader性能与其它说明
	*	ROWS 的默认值为 64，可以根据实际指定更合适的 ROWS 参数来指定每次提交记录数。
    *	常规导入可以通过使用 INSERT语句来导入数据。
		>	Direct导入可以跳过数据库的相关逻辑(DIRECT=TRUE)，而直接将数据导入到数据文件中，可以提高导入数据的性能。
        有些情况下，不能使用此参数(如果主键重复的话会使索引的状态变成UNUSABLE!)。
    *	通过指定 UNRECOVERABLE选项，可以关闭数据库的日志，这个选项只能和 direct 一起使用。
		>	同时执行：SQL>ALTER TABLE test nologging;
    *	使用多个控制文件运行多个导入任务.
		*	sqlldr userid=/ control=result1.ctl direct=true parallel=true 
		*	sqlldr userid=/ control=result2.ctl direct=true parallel=true 
		*	sqlldr userid=/ control=result3.ctl direct=true parallel=true 
    *	使用bind array提升性能，bind array大小评估为，rows*行长度。OPTIONS (bindsize=512000)
            （注意：一般只能用ASCII码形式，切记要转换编码，不然导入数据为空）(ftp上传csv文件的传输类型选择ascii)
	
	
	
[文档主页](../index.html)