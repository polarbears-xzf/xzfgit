--获取LONG类型字段，到导入中排除
select owner,table_name from dba_tab_columns
where DATA_TYPE='LONG' 
AND OWNER NOT IN ('SYS','SYSTEM','OUTLN','WMSYS','EXFSYS');

select current_scn from v$database;

impdp system/oracle parfile=/home/oracle/zoedir/scripts/impdp_sync.par


impdp_sync.par
full=y 
network_link=zoedblink_his
flashback_scn=&current_scn
exclude=PROCACT_INSTANCE, TABLE:"IN ('PLAN_TABLE')", 
SCHEMA:"IN ('HZMCASSET', 'HZMCBACKUP', 'HZMCCLIENT', 'HZMCMEMAUDIT','GGSADMIN','ZOEARCHIVE')"
REMAP_TABLE=COMM.APPLY_SHEET:COMM.APPLY_SHEET_O, 
COMM.APPLY_SHEET_DETAIL:COMM.APPLY_SHEET_DETAIL_O, 
COMM.PREPAYMENT_MONEY:COMM.PREPAYMENT_MONEY_O, 
INPSICK.PRESCRIBE_RECORD:INPSICK.PRESCRIBE_RECORD_O, 
INPSICK.RESIDENCE_SICK_PRICE_ITEM:INPSICK.RESIDENCE_SICK_PRICE_ITEM_O, 
INPSICK.SICK_SETTLE_DETAIL:INPSICK.SICK_SETTLE_DETAIL_O, 
INPSICK.SICK_SETTLE_MASTER:INPSICK.SICK_SETTLE_MASTER_O, 
OUTPSICK.DISPENSARY_PRESCRIBE_DETAIL:OUTPSICK.DISPENSARY_PRESCRIBE_DETAIL_O, 
OUTPSICK.DISPENSARY_PRESCRIP_MASTER:OUTPSICK.DISPENSARY_PRESCRIP_MASTER_O, 
OUTPSICK.DISPENSARY_SICK_PRICE_ITEM:OUTPSICK.DISPENSARY_SICK_PRICE_ITEM_O, 
PHYSIC.LAY_PHYSIC_RECORDS:PHYSIC.LAY_PHYSIC_RECORDS_O

