set serverout on
--创建记录表
create table system.lob_corrupt_record(lob_rowid varchar2(64),error_message varchar(4000));
--获取corrupt lob记录
declare
  page    number;
  len    number;
  c      varchar2(10);
  charpp number := 8132/2;
  lv_errmsg VARCHAR2(4000);
  cursor lc_lob is select rowid rid, dbms_lob.getlength (FULL_TEXT) lena,dbms_lob.getlength (XML) lenb,dbms_lob.getlength (CONTENT) lenc 
            from  ZEMR.ZEMR_EMR_CONTENT 
			where  create_date >= to_date('2014-06-01','yyyy-mm-dd') and create_date < to_date('2015-01-01','yyyy-mm-dd');
begin
  for r in lc_lob loop
    if r.lena is not null then
      for page in 0..r.lena/charpp loop
        begin
          select dbms_lob.substr (FULL_TEXT, 1, 1+ (page * charpp))
          into   c
          from   ZEMR.ZEMR_EMR_CONTENT
          where  rowid = r.rid;
        exception
          when others then
			lv_errmsg := substr('error_column:FULL_TEXT;page:'||page||';'||sqlerrm,1,4000);
			insert into system.lob_corrupt_record (lob_rowid,error_message) values (r.rid,lv_errmsg);
			--dbms_output.put_line(lv_errmsg);
			commit;
        end;
     end loop;
    end if;
    if r.lenb is not null then
      for page in 0..r.lenb/charpp loop
        begin
          select dbms_lob.substr (XML, 1, 1+ (page * charpp))
          into   c
          from   ZEMR.ZEMR_EMR_CONTENT
          where  rowid = r.rid;
        exception
          when others then
			lv_errmsg := substr('error_column:FULL_TEXT;page:'||page||';'||sqlerrm,1,4000);
			insert into system.lob_corrupt_record (lob_rowid,error_message) values (r.rid,lv_errmsg);
			--dbms_output.put_line(lv_errmsg);
        end;
     end loop;
    end if;
    if r.lenc is not null then
      for page in 0..r.lenc/charpp loop
        begin
          select dbms_lob.substr (CONTENT, 1, 1+ (page * charpp))
          into   c
          from   ZEMR.ZEMR_EMR_CONTENT
          where  rowid = r.rid;
        exception
          when others then
			lv_errmsg := substr('error_column:FULL_TEXT;page:'||page||';'||sqlerrm,1,4000);
			insert into system.lob_corrupt_record (lob_rowid,error_message) values (r.rid,lv_errmsg);
			--dbms_output.put_line(lv_errmsg);
       end;
     end loop;
    end if;
  end loop;
end;
/
--处理corrupt记录
update zeme.zemr_emr_content set content = EMPTY_BLOB() where rowid in (select lob_rowid from system.lob_corrupt_record);

附： 查看扫描进度
select * from gv$session where program like '%sqlplus%';
select * from v$sql_bind_capture where sql_id='5kfzg5kg1yav9' and position=3;
select create_date from zemr.zemr_emr_content where rowid in (select value_string from v$sql_bind_capture where sql_id='5kfzg5kg1yav9' and position=3);
附：病历内容表时间条件，每次半年
QUERY=zemr.zemr_emr_content:"WHERE create_date < to_date('2013-06-01','yyyy-mm-dd')"
QUERY=zemr.zemr_emr_content:"WHERE create_date >= to_date('2013-06-01','yyyy-mm-dd') and create_date < to_date('2014-01-01','yyyy-mm-dd')"
QUERY=zemr.zemr_emr_content:"WHERE create_date >= to_date('2014-01-01','yyyy-mm-dd') and create_date < to_date('2014-06-01','yyyy-mm-dd')"
QUERY=zemr.zemr_emr_content:"WHERE create_date >= to_date('2014-06-01','yyyy-mm-dd') and create_date < to_date('2015-01-01','yyyy-mm-dd')"
QUERY=zemr.zemr_emr_content:"WHERE create_date >= to_date('2015-01-01','yyyy-mm-dd') and create_date < to_date('2015-06-01','yyyy-mm-dd')"
QUERY=zemr.zemr_emr_content:"WHERE create_date >= to_date('2015-06-01','yyyy-mm-dd') and create_date < to_date('2016-01-01','yyyy-mm-dd')"
QUERY=zemr.zemr_emr_content:"WHERE create_date >= to_date('2016-01-01','yyyy-mm-dd') and create_date < to_date('2016-06-01','yyyy-mm-dd')"
QUERY=zemr.zemr_emr_content:"WHERE create_date >= to_date('2016-06-01','yyyy-mm-dd') and create_date < to_date('2017-01-01','yyyy-mm-dd')"
QUERY=zemr.zemr_emr_content:"WHERE create_date >= to_date('2017-01-01','yyyy-mm-dd') and create_date < to_date('2017-06-01','yyyy-mm-dd')"
QUERY=zemr.zemr_emr_content:"WHERE create_date >= to_date('2017-06-01','yyyy-mm-dd') and create_date < to_date('2018-01-01','yyyy-mm-dd')"
QUERY=zemr.zemr_emr_content:"WHERE create_date >= to_date('2018-01-01','yyyy-mm-dd') and create_date < to_date('2018-06-01','yyyy-mm-dd')"
QUERY=zemr.zemr_emr_content:"WHERE create_date >= to_date('2018-06-01','yyyy-mm-dd') and create_date < to_date('2019-01-01','yyyy-mm-dd')"
QUERY=zemr.zemr_emr_content:"WHERE create_date >= to_date('2019-01-01','yyyy-mm-dd')"