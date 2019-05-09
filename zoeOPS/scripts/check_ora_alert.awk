#!/usr/bin/awk -f

#  Created in 2017.10.10 by polarbears
#  Copyright (c) 20xx, CHINA and/or affiliates.
#  All rights reserved.
# 	Name
#  		check_ora_alert - check and analyze Oracle Alert log
# 	Description
#  		用于项目数据库服务巡检时，自动获取Oracle Alert日志中的错误及启动信息
#	Bug
#		ORA-12012错误信息显示不完整，在下一个版本中改进
# 	Notes
# 		AWK程序脚本
#       脚本执行方式：awk -f check_ora_alert.awk  alert_orcl.log
#		详细Ora错误说明请查阅文档：《xxxxxx》
#     修改      -   （年-月-日）   -   描述
#     polarbears     2017.11.08        none
# 


# ============================================
# 使用BEGIN设置仅在开始时执行一次的语句 
# ============================================
# 设置内置分隔符变量FS，默认为空格；设置缓存数组最大保留记录数100，最小保留记录数10；
BEGIN { FS=" " ; ln_cache_max = 100 ;ln_cache_min = 10 ; ln_loop_start = 1 }

# 对la_rowData数组赋值
{	{ln_rows=NR ; la_rowData[NR]=$0 ; getline lv_next_rowData ; ln_next_rows=NR ; la_rowData[NR]=lv_next_rowData}

# 获取实例启动记录
	if (la_rowData[ln_rows] ~/Starting ORACLE instance/)
		{
			print f_output_info(la_rowData , NR , -1 , 2) > "./StartingInstance.log"
		}
	else if (la_rowData[ln_next_rows] ~/Starting ORACLE instance/)
		{
			print f_output_info(la_rowData , NR , 0 , 2) > "./StartingInstance.log"
		}
# 获取IPC超时记录
	else if (la_rowData[ln_rows] ~/IPC Send timeout/)
		{
			print f_output_info(la_rowData , NR , -1 , 2) > "./IPCSendtimeout.log"
		}	
	else if (la_rowData[ln_next_rows] ~/IPC Send timeout/)
		{
			print f_output_info(la_rowData , NR , 0 , 2) > "./IPCSendtimeout.log"
		}	
# 获取dead节点，RAC集群重配置记录
	else if (la_rowData[ln_rows] ~/My inst [0-9]  /)
		{
			print f_output_info(la_rowData , NR , -1 , 7) > "./ReconfigDeadInstance.log"
		}	
	else if (la_rowData[ln_next_rows] ~/My inst [0-9]  /)
		{
			print f_output_info(la_rowData , NR , -0 , 7) > "./ReconfigDeadInstance.log"
		}	
# 获取启动节点，RAC集群重配置记录
	else if (la_rowData[ln_rows] ~/My inst [0-9] \(/)
		{
			print f_output_info(la_rowData , NR , -1 , 7) > "./ReconfigNewInstance.log"
		}	
	else if (la_rowData[ln_next_rows] ~/My inst [0-9] \(/)
		{
			print f_output_info(la_rowData , NR , 0 , 7) > "./ReconfigNewInstance.log"
		}	
# 开始处理ORA-开头的错误日志信息
	else if (la_rowData[ln_rows] ~/ORA-/ && la_rowData[ln_next_rows] !~/ORA-/)
		{
			f_output_ora(la_rowData , ln_rows)
		}
	else if (la_rowData[ln_rows] !~/ORA-/ && la_rowData[ln_rows-1] ~/ORA-/ )
		{
			f_output_ora(la_rowData , ln_rows - 1)
		}
	
   
# 根据ln_cache_max，ln_cache_min设置，清理缓存数组，防止消耗过多的内存空间
	if (NR - ln_loop_start + 1 > ln_cache_max)
		{ln_rows = length(la_rowData) ; ln_loop_start = NR ;
			for ( i=1 ; i < ln_rows - ln_cache_min + 1; i++ ) { delete la_rowData[NR-ln_rows+i] } ;
		}
}	
# ============================================
# 使用END设置仅在结束时执行一次的语句
# ============================================	


# 定义函数
	function f_output_info(ia_rowData , in_current_rowno , in_pos , in_process_rows)
	{
		lv_output_info = ""
		for (i = 1 ; i <=in_process_rows ; i++)
		{
			if (in_pos == -1 )
			{
				lv_output_info = lv_output_info "" ia_rowData[in_current_rowno + in_pos - in_process_rows + i] "\n"
			}
			else if (in_pos == 0 )
			{
				lv_output_info = lv_output_info "" ia_rowData[in_current_rowno + in_pos - in_process_rows + i] "\n"
			}
		}
		return lv_output_info
	}
	function f_output_ora(ia_rowData , in_current_rowno)
	{
		if (ia_rowData[in_current_rowno] ~/ORA-27303/)
		{
			print f_output_info(ia_rowData , in_current_rowno , 0 , 8) > "./ORA-27303.log"
		}
		else if (ia_rowData[in_current_rowno] ~/ORA-12751/)
		{
			print f_output_info(ia_rowData , in_current_rowno , 0 , 3) > "./ORA-12751.log"
		}
		else if (ia_rowData[in_current_rowno] ~/ORA-12154/)
		{
			print f_output_info(ia_rowData , in_current_rowno , 0 , 2) > "./ORA-12154.log"
		}
		else if (ia_rowData[in_current_rowno] ~/ORA-12012/)
		{
			print f_output_info(ia_rowData , in_current_rowno , 0 , 2) > "./ORA-12012.log"
		}
		else if (ia_rowData[in_current_rowno] ~/ORA-1089/)
		{
			print f_output_info(ia_rowData , in_current_rowno , 0 , 2) > "./ORA-1092.log"
		}
		else if (ia_rowData[in_current_rowno] ~/ORA-1092/)
		{
			print f_output_info(ia_rowData , in_current_rowno , 0 , 2) > "./ORA-1092.log"
		}
		else if (ia_rowData[in_current_rowno] ~/ORA-609/)
		{
			print f_output_info(ia_rowData , in_current_rowno , 0 , 2) > "./ORA-609.log"
		}
		else if (ia_rowData[in_current_rowno] ~/ORA-28/)
		{
			print f_output_info(ia_rowData , in_current_rowno , 0 , 2) > "./ORA-28.log"
		}
		else if (ia_rowData[in_current_rowno] ~/ORA-603/)
		{
			print f_output_info(ia_rowData , in_current_rowno , 0 , 2) > "./ORA-603.log"
		}
		else if (ia_rowData[in_current_rowno] ~/ORA-02063/)
		{
			print f_output_info(ia_rowData , in_current_rowno , 0 , 5) > "./ORA-02063.log"
		}
		else if (ia_rowData[in_current_rowno] ~/ORA-1653/)
		{
			print f_output_info(ia_rowData , in_current_rowno , 0 , 3) > "./ORA-1653.log"
		}
		else if (ia_rowData[in_current_rowno] ~/ORA-1654/)
		{
			print f_output_info(ia_rowData , in_current_rowno , 0 , 3) > "./ORA-1654.log"
		}
		else if (ia_rowData[in_current_rowno] ~/ORA-1691/)
		{
			print f_output_info(ia_rowData , in_current_rowno , 0 , 5) > "./ORA-1691.log"
		}
		else if (ia_rowData[in_current_rowno] ~/ORA-27040/)
		{
			print f_output_info(ia_rowData , in_current_rowno , 0 , 5) > "./ORA-27040.log"
		}
		else if (ia_rowData[in_current_rowno] ~/ORA-03113/)
		{
			print f_output_info(ia_rowData , in_current_rowno , 0 , 3) > "./ORA-03113.log"
		}
		else if (ia_rowData[in_current_rowno] ~/ORA-3136/)
		{
			print f_output_info(ia_rowData , in_current_rowno , 0 , 3) > "./ORA-3136.log"
		}
		else if (ia_rowData[in_current_rowno] ~/ORA-16055/)
		{
			print f_output_info(ia_rowData , in_current_rowno , 0 , 3) > "./ORA-16055.log"
		}
		else if (ia_rowData[in_current_rowno] ~/ORA-00481/)
		{
			print f_output_info(ia_rowData , in_current_rowno , 0 , 3) > "./ORA-00481.log"
		}
		else if (ia_rowData[in_current_rowno] ~/ORA-/)
		{
			print f_output_info(ia_rowData , in_current_rowno , 0 , 2) > "./Ora-xxxxx.log"
		}

	}
	
