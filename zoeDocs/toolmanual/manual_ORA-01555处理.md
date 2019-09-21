<link href="../zoe_docs.css" rel="stylesheet" type="text/css" />

[文档主页](../index.html)


###	expdp导出报ORA-01555快照过旧处理
1.	undo_retention设置过小
	*	ALTER SYSTEM SET undo_retention=18000 SCOPE=BOTH;
	*	ALTER TABLE "ZEMR"."ZEMR_EMR_CONTENT" MODIFY LOB(CONTENT) (retention);
2.	undo表空间太小
	*	select file_name from dba_data_files t  where t.tablespace_name='UNDOTBS1';
	*	alter  tablespace UNDOTBS1 add datafile '+DATA/zyhdc/datafile/bdresi_fee_tab05.ora' size 100M AUTOEXTEND ON NEXT 100M MAXSIZE 30G;
3.	设置pctversion
	*	ALTER TABLE "ZEMR"."ZEMR_EMR_CONTENT" MODIFY LOB(CONTENT) (PCTVERSION 25);
4.	大表分批次导出
	*	expdp system/oracle tables=ZEMR.ZEMR_EMR_CONTENT CONTENT=METADATA_ONLY directory=expdpdir dumpfile=zyzemrdata_12.dmp logfile=zyzemrexpdata.log  exclude=STATISTICS   flashback_scn= 21932341059 
	*	expdp system/oracle tables=ZEMR.ZEMR_EMR_CONTENT QUERY=zemr.zemr_emr_content:"WHERE create_date < to_date('2014-01-01','yyyy-mm-dd')"  CONTENT=DATA_ONLY directory=expdpdir dumpfile=zyzemrdata_13.dmp logfile=zyzemrexpdata.log  exclude=STATISTICS   flashback_scn= 21932341059
	*	expdp system/oracle tables=ZEMR.ZEMR_EMR_CONTENT QUERY=zemr.zemr_emr_content:"WHERE create_date >= to_date('2014-01-01','yyyy-mm-dd') and create_date < to_date('2015-01-01','yyyy-mm-dd')"  CONTENT=DATA_ONLY directory=expdpdir dumpfile=zyzemrdata_14.dmp logfile=zyzemrexpdata.log  exclude=STATISTICS   flashback_scn= 21932341059
5.	检查表是否存在坏块
	*	创建记录表：create table system.lob_corrupt_record(lob_rowid varchar2(64),error_message varchar(4000));
	*	获取corrupt lob记录：
declare
  page    number;
  len    number;
  c      varchar2(10);
  charpp number := 8132/2;
  lv_errmsg VARCHAR2(4000);
  cursor lc_lob is select rowid rid, dbms_lob.getlength (INSPECT_CONTENT) lena
            from  ZEMR.ZEMR_EMR_CONTENT;
begin
  for r in lc_lob loop
    if r.lena is not null then
      for page in 0..r.lena/charpp loop
        begin
          select dbms_lob.substr (INSPECT_CONTENT, 1, 1+ (page * charpp))
          into   c
          from   ZEMR.ZEMR_EMR_CONTENT
          where  rowid = r.rid;
        exception
          when others then
			lv_errmsg := substr('error_column:INSPECT_CONTENT;page:'||page||';'||sqlerrm,1,4000);
			insert into system.lob_corrupt_record (lob_rowid,error_message) values (r.rid,lv_errmsg);
			--dbms_output.put_line(lv_errmsg);
			commit;
        end;
     end loop;
    end if;
  end loop;
end;
	


[文档主页](../index.html)