# Created in 2018.06.03 by polarbears
# Copyright (c) 20xx, CHINA and/or affiliates.
# All rights reserved.
#	Name:
# 		collect_project_data.sh
#	Description:
# 		加载数据到主运维库
#  Relation:
#      对象关联
#	Notes:
#		基本注意事项
#	修改 - （年-月-日） - 描述
#

# 加载数据到主运维库
#	进入脚本目录
cd c:\zoedir\scripts
#	连接数据库，删除旧数据
sqlplus zoedba/password@ip_address/service_name
delete from zoedevops.DVP_PROJ_DB_BASIC_INFO        where project_id#=4;
delete from zoedevops.DVP_PROJ_DB_USER_ADMIN_INFO   where project_id#=4;
delete from zoedevops.DVP_PROJ_SERVER_BASIC_INFO    where project_id#=4;
delete from zoedevops.DVP_PROJ_SERVER_ADMIN_INFO    where project_id#=4;
commit;
#	加载数据
sqlldr zoedba/password@ip_address/service_name loadDVP_PROJ_DB_BASIC_INFO.ctl
sqlldr zoedba/password@ip_address/service_name loadDVP_PROJ_DB_USER_ADMIN_INFO.ctl
sqlldr zoedba/password@ip_address/service_name loadDVP_PROJ_SERVER_BASIC_INFO.ctl
sqlldr zoedba/password@ip_address/service_name loadDVP_PROJ_SERVER_ADMIN_INFO.ctl
