-- Created in 2018.10.11 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		content_project_info.sql
--	Description:
-- 		基本说明
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--

set markup html off


prompt  <H3 class='zoecomm'>  <center> 项目基本信息 </center> </H3> <br>

column banner  NEW_VALUE db_version noprint
select banner as "banner" from v$version where banner like 'Oracle Database%';

prompt  <center> <table WIDTH=600 BORDER=1> 

	prompt  <tr>
			prompt <th> 属性 </th>
			prompt <th> 属性值 </th>
	prompt  </tr>
	prompt  <tr>
		prompt  <td> 数据库版本 </td>
		prompt  <td> &db_version  </td>
	prompt  </tr>
	prompt </table>  </center> <br> <br>

