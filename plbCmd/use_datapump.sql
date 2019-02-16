

--查看导出导入进度
select b.opname,b.totalwork,b.start_time,b.last_update_time,b.time_remaining,b.elapsed_seconds from gv$session a,gv$session_longops b 
where opname like 'SYS_IMPORT%'
and a.inst_id=b.inst_id and a.sid=b.sid and a.serial#=b.serial#;
--连接导出导入会话
expdp system/password attach=sys_impdp_full_01
impdp system/password attach=sys_impdp_full_01

