-- Created in 2018.10.11 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
--	Name:
-- 		content_init_parameter.sql
--	Description:
-- 		基本说明
--  Relation:
--      对象关联
--	Notes:
--		基本注意事项
--	修改 - （年-月-日） - 描述


---- =======================================
-- Oracle非默认初始化参数设置
-- =======================================
set markup html off
prompt  <H3 class='zoecomm'>  <center><a name="00006"></a>非默认初始化参数</center>  </H3>
set markup html on entmap off

column column1  format A80  heading '参数名'
column column2  format A255 heading '参数值'
column column3  format 99   heading '实例号'

set markup html off
prompt  <center>
set markup html on entmap off

set markup html on table "WIDTH=600 BORDER=1"
-- select '<A HREF="http://oracle.com/'||name||'.html">'||name||'</A>' "column1",value "column2"
select * from (
select inst_id as "column3",name as "column1",value as "column2"
from gv$system_parameter
where ISDEFAULT = 'FALSE'
order by inst_id , name)
union all
select to_number(''),'合计',to_char(count(*))
from gv$system_parameter
where ISDEFAULT = 'FALSE';


prompt  <a  href="#top">Back to Top </a></center>
