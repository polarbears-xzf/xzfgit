<link href="zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../../index.html)
[上一页](../zabbix_install_index.html)

>	_Created in 2019.08.06 by natsume_  
>	_Copyright (c) 20xx, CHINA and/or affiliates._  
 
##	 使用mailx来发送告警邮件
####1.	安装mailx
	* 在操作系统iso里有，直接rpm安装
####2.	配置邮件信息
	* 参数入下：这里的password不是邮箱密码，是smtp的认证码，要在相应的邮箱开通smtp功能才有，每个邮箱不一样，有的是自己设的密码，有的是随机码
	set from=zoesoft_zabbix@163.com
    set smtp=smtp.163.com
    set smtp-auth-user=zoesoft_zabbix@163.com
    set smtp-auth-password=zoesoft44
    set smtp-auth=login
####3.	在linux里测试邮件是否能正常发送
	* echo "test"|mail -s "zabbix" zoesoft_zabbix@163.com
####4.	创建zabbix发邮件脚本
	* cd /usr/lib/zabbix/alertscripts
	* vi sendmail.sh 内容如下：
	    #!/bin/bash
          contact=$1
          subject=$2
          body=$3
          body=`echo $body|tr '\r' '\n'`
          cat << EOF | mail -s "$subject" "$contact"
           $body
          EOF
####5.	打开zabbix网页端，设置报警媒介类型
    * 管理-->报警媒介类型-->新建-->输入名称、脚本、脚本名称sendmail.sh、脚本        
    * 脚本的三个参数：{ALERT.SENDTO}  {ALERT.SUBJECT}  {ALERT.MESSAGE}
####6.	给用户应用上对应的报警媒介
    * 管理-->用户-->admin-->报警媒介-->添加-->选择我们第五步创建的媒介类型、填写收件人、时间、邮件发送的类别
####7.	配置自动发送邮件规则
    * 配置-->动作-->创建动作-->动作-->输入名称、条件(条件按需求填,我这里填的是只要触发器的示警度大于等于警告就发送邮件)
    * 操作-->填入时间、标题、内容以及操作要发送给admin用户
    * 恢复操作和操作类似
####8.	总结
    以上步骤和配置参数可参考http://192.168.1.44/zabbix，看了就懂了

[文档主页](../../index.html)
[上一页](../zabbix_install_index.html)
