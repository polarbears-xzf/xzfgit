<link href="../zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../index.html)

###	运维管理基本规范
1. 操作系统目录命名规则
	*	Windows平台根目录：c:\zoedir
	*	Linux平台根目录：/home/oracle/zoedir
	*	二级目录：
        *	日志目录： log 权限： chmod 777 /home/oracle/zoedir/log
        *	数据目录： data
        *	脚本目录： scripts
        *	Oracle性能报告： orarpt
        *	自定义报告： zoerpt
2. 数据库性能报告命名规则
	*	命名： *报告类型* + *系统简称* + *项目简称* + *日期*
        >	例：2018年10月10日福建医科大学附属第一医院HIS系统AWR报告： awr_his_fjfy_20181010
	*	报告类型：
        >	Oracle AWR： awr
        >	Oracle ADDM： addm
        >	Oracle ASH： ash
        >	Oracle数据库健康巡检： zoeOradb
	*	系统简称
        >	HIS： his
        >	电子病历： emr
        >	健康档案： smjk
3. 远程管理DB LINK命名规则
    *	DB LINK命名：数据库名 + IP最后一位 + 连接用户名
        >	例：HIS50主数据库，IP：192.168.1.41，连接用户：zoeagent。命名：zoemdb41zoeagent
        >	create database link zoemdb41zoeagent connect to zoeagent identified by zoeY6FG0PL943Z8 using '192.168.1.41/zoemdb';
4. 部署脚本语言配置
    *	Windows平台下字符集为UTF8
        >	SQLPLUS 设置
            >	set NLS_LANG=SIMPLIFIED CHINESE_CHINA.AL32UTF8
        >	cmd设置
        >	    chcp 65001
        >	字体选择：lucida console 字号：14
    *	NOTEPAD++ 设置
        >	编码 - 以UTF8无BOM编码方式
    ######	注：cmd会自动查找bom，因此在cmd下如果使用utf8格式，需要用BOM方式保存。sqlplus执行BOM方式保存文件时，第一行会报错




[文档主页](../index.html)