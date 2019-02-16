--获取LONG类型字段，到导入中排除
select owner,table_name from dba_tab_columns
where DATA_TYPE='LONG' 
AND OWNER NOT IN ('SYS','SYSTEM','OUTLN','WMSYS','EXFSYS','ZEMR');

select current_scn from v$database;

impdp system/oracle parfile=/home/oracle/zoedir/scripts/impdp_sync.par


# impdp_sync.par
full=y 
network_link=zoedblink_emr
flashback_scn=&current_scn
exclude=PROCACT_INSTANCE, TABLE:"IN ('PLAN_TABLE')", 
SCHEMA:"IN ('ZEMR')"
# REMAP_TABLE=COMM.APPLY_SHEET:COMM.APPLY_SHEET_O, 


