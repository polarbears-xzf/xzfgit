CREATE OR REPLACE PACKAGE ZOEPKG_SYNCHRONOUS_DATA AS
   PROCEDURE TEST(instr in varchar2,outstr out varchar2);
   
   procedure p_i18_synchronous(in_sequence_no in varchar2,
                               source_db_id in varchar2,
                               target_db_id in varchar2,
                               operator in varchar2,
                               return_code out number,
                               msg out varchar2);

   procedure p_data_structure_synchronous(in_sequence_no in varchar2,
                               source_db_id in varchar2,
                               operator in varchar2,
                               return_code out number,
                               msg out varchar2);
                              
  procedure p_synchronous(synchronization_type in varchar2,
                          in_sequence_no in varchar2,
                          source_db_id in varchar2,
                          target_db_id in varchar2,
                          operator in varchar2,
                          return_code out number,
                          msg out varchar2);
END ZOEPKG_SYNCHRONOUS_DATA; 
/
CREATE OR REPLACE PACKAGE BODY ZOEPKG_SYNCHRONOUS_DATA IS
  PROCEDURE TEST(instr in varchar2,outstr out varchar2)
  AS
  BEGIN
    outstr := instr;
  END TEST;
  
  procedure p_i18_synchronous(in_sequence_no in varchar2,
                              source_db_id in varchar2,
                              target_db_id in varchar2,
                              operator in varchar2,
                              return_code out number,
                              msg out varchar2)
  as
      lv_operator    varchar2(64);
      lv_source_db_link  varchar2(64);
      lv_target_db_link  varchar2(64);
      lv_sql             varchar2(4000);
      lv_sql_drop        varchar2(4000);
      ld_sysdate         date;
      ln_exists          number;
      lc_ref_cursor      sys_refcursor;
      ls_error_code      varchar2(4000);
      ls_error_msg       varchar2(4000);
  begin
    lv_operator := trim(operator);
    if source_db_id is null then
       return_code := -1;
       msg := 'Դ���ݿ�IDΪ��';
       return;
    end if;
    
    if target_db_id is null then
       return_code := -1;
       msg := 'Ŀ�����ݿ�IDΪ��';
       return;
    end if;
    
    if lv_operator is null then
       lv_operator := 'system';
    end if;
    
    begin
       select db_link_name 
         into lv_source_db_link 
         from zoedevops.dvp_proj_node_db_links 
        where db_id#=source_db_id;
    exception
      when no_data_found then
         return_code := -1;
         msg := '��ά���ݿ�δ����Դ���ݿ�id['||source_db_id||']��Ӧ��dblink';
         return;
    end;

    begin
       select db_link_name 
         into lv_target_db_link 
         from zoedevops.dvp_proj_node_db_links 
        where db_id#=target_db_id;
    exception
      when no_data_found then
         return_code := -1;
         msg := '��ά���ݿ�δ����Ŀ�����ݿ�id['||target_db_id||']��Ӧ��dblink';
         return;
    end;
    --����һ��Դ���ݿ��Ŀ�����ݿ��dblink�ܲ���ͨ
    lv_sql := 'select sysdate from dual@'||lv_source_db_link;
    begin
       execute immediate lv_sql;
    exception
      when others then
        rollback;
        return_code := -1;
         msg := '�������Դ���ݿ�id['||lv_source_db_link||']��ͨ���߳����쳣���޷�ͬ�����ݡ�';
         return;
    end;

    lv_sql := 'select sysdate from dual@'||lv_target_db_link;
    begin
       execute immediate lv_sql;
    exception
      when others then
        rollback;
        return_code := -1;
         msg := '�������Ŀ�����ݿ�id['||lv_target_db_link||']��ͨ���߳����쳣���޷�ͬ�����ݡ�';
         return;
    end;
    
    
    --���ݴ�Դ���ݿ��ȡ����ά���ݿ�
    ln_exists := 0;
    select count(1)
      into ln_exists
      from user_tables
     where table_name = 'COM_I18N_DICT_CLASS';
    if ln_exists > 0 then
      --������ʱ����ô���Ȱ���ʱ���ɾ����
      lv_sql_drop := 'drop table zoedevops.com_i18n_dict_class purge';
      execute immediate lv_sql_drop;
    end if;
    
    ln_exists := 0;
    select count(1)
      into ln_exists
      from user_tables
     where table_name = 'COM_I18N_DICT_CLASS_DIST';
    if ln_exists > 0 then
      --������ʱ����ô���Ȱ���ʱ���ɾ����
      lv_sql_drop := 'drop table zoedevops.com_i18n_dict_class_dist purge';
      execute immediate lv_sql_drop;
    end if;

    ln_exists := 0;
    select count(1)
      into ln_exists
      from user_tables
     where table_name = 'COM_I18N_DICT_INFO';
    if ln_exists > 0 then
      --������ʱ����ô���Ȱ���ʱ���ɾ����
      lv_sql_drop := 'drop table zoedevops.com_i18n_dict_info purge';
      execute immediate lv_sql_drop;
    end if;

    ln_exists := 0;
    select count(1)
      into ln_exists
      from user_tables
     where table_name = 'COM_I18N_DICT_LANG_INFO';
    if ln_exists > 0 then
      --������ʱ����ô���Ȱ���ʱ���ɾ����
      lv_sql_drop := 'drop table zoedevops.com_i18n_dict_lang_info purge';
      execute immediate lv_sql_drop;
    end if;
    
    lv_sql := 'create table zoedevops.com_i18n_dict_class as select * from zoecomm.com_i18n_dict_class@'||lv_source_db_link;
    execute immediate lv_sql;
    
    lv_sql := 'create table zoedevops.com_i18n_dict_class_dist as select * from zoecomm.com_i18n_dict_class_dist@'||lv_source_db_link;
    execute immediate lv_sql;

    lv_sql := 'create table zoedevops.com_i18n_dict_info as select * from zoecomm.com_i18n_dict_info@'||lv_source_db_link;
    execute immediate lv_sql;

    lv_sql := 'create table zoedevops.com_i18n_dict_lang_info as select * from zoecomm.com_i18n_dict_lang_info@'||lv_source_db_link;
    execute immediate lv_sql;
    --����ά�⵼Ŀ�����ݿ�,4�����ݱ�4����ʱ��һ��8����
    ln_exists := 0;
    
    --�������Զ�����ݿ����DDL�޸ģ�Ҳ���ǵ�һ��ͬ����ʱ��Ҫ�ֹ�ͬ��һ�Σ�ͬ��Ҳ������truncate����ֻ����delete
    --1.ZOETMP.COM_I18N_DICT_CLASS
    lv_sql := 'select count(1) from dba_tables@'||lv_target_db_link||' where owner=''ZOETMP'' and table_name = ''COM_I18N_DICT_CLASS''';
    open lc_ref_cursor for lv_sql;
    loop
      fetch lc_ref_cursor into ln_exists;
      exit when lc_ref_cursor%notfound;
      if ln_exists > 0 then
         lv_sql_drop := 'delete zoetmp.com_i18n_dict_class@'||lv_target_db_link;
         execute immediate lv_sql_drop;
         commit;
      end if;
    end loop;
    if ln_exists = 0 then
       --Ŀ�����ݿ�û���������ô��Ҫ�ֹ�������Զ�̲�֧��truncate��DDL
       rollback;
       return_code := -1;
       msg := 'Ŀ�����ݿ��в�����[ZOETMP.COM_I18N_DICT_CLASS],���ֹ�ִ�нű����й��ʻ�ͬ����';
       return;
    end if;
    
    --2.ZOETMP.COM_I18N_DICT_CLASS_DIST
    lv_sql := 'select count(1) from dba_tables@'||lv_target_db_link||' where owner=''ZOETMP'' and table_name = ''COM_I18N_DICT_CLASS_DIST''';
    open lc_ref_cursor for lv_sql;
    loop
      fetch lc_ref_cursor into ln_exists;
      exit when lc_ref_cursor%notfound;
      if ln_exists > 0 then
         lv_sql_drop := 'delete zoetmp.com_i18n_dict_class_dist@'||lv_target_db_link;
         execute immediate lv_sql_drop;
         commit;
      end if;
    end loop;
    if ln_exists = 0 then
       --Ŀ�����ݿ�û���������ô��Ҫ�ֹ�������Զ�̲�֧��truncate��DDL
       rollback;
       return_code := -1;
       msg := 'Ŀ�����ݿ��в�����[ZOETMP.COM_I18N_DICT_CLASS_DIST],���ֹ�ִ�нű����й��ʻ�ͬ����';
       return;
    end if;
    
    --3.ZOETMP.COM_I18N_DICT_INFO
    lv_sql := 'select count(1) from dba_tables@'||lv_target_db_link||' where owner=''ZOETMP'' and table_name = ''COM_I18N_DICT_INFO''';
    open lc_ref_cursor for lv_sql;
    loop
      fetch lc_ref_cursor into ln_exists;
      exit when lc_ref_cursor%notfound;
      if ln_exists > 0 then
         lv_sql_drop := 'delete zoetmp.com_i18n_dict_info@'||lv_target_db_link;
         execute immediate lv_sql_drop;
         commit;
      end if;
    end loop;
    if ln_exists = 0 then
       --Ŀ�����ݿ�û���������ô��Ҫ�ֹ�������Զ�̲�֧��truncate��DDL
       rollback;
       return_code := -1;
       msg := 'Ŀ�����ݿ��в�����[ZOETMP.COM_I18N_DICT_INFO],���ֹ�ִ�нű����й��ʻ�ͬ����';
       return;
    end if;
    
    --4.ZOETMP.COM_I18N_DICT_LANG_INFO
    lv_sql := 'select count(1) from dba_tables@'||lv_target_db_link||' where owner=''ZOETMP'' and table_name = ''COM_I18N_DICT_LANG_INFO''';
    open lc_ref_cursor for lv_sql;
    loop
      fetch lc_ref_cursor into ln_exists;
      exit when lc_ref_cursor%notfound;
      if ln_exists > 0 then
         lv_sql_drop := 'delete zoetmp.com_i18n_dict_lang_info@'||lv_target_db_link;
         execute immediate lv_sql_drop;
         commit;
      end if;
    end loop;
    if ln_exists = 0 then
       --Ŀ�����ݿ�û���������ô��Ҫ�ֹ�������Զ�̲�֧��truncate��DDL
       rollback;
       return_code := -1;
       msg := 'Ŀ�����ݿ��в�����[ZOETMP.COM_I18N_DICT_LANG_INFO],���ֹ�ִ�нű����й��ʻ�ͬ����';
       return;
    end if;
    
    --5.ZOETMP.COM_I18N_DICT_CLASS_TMP
    lv_sql := 'select count(1) from dba_tables@'||lv_target_db_link||' where owner=''ZOETMP'' and table_name = ''COM_I18N_DICT_CLASS_TMP''';
    open lc_ref_cursor for lv_sql;
    loop
      fetch lc_ref_cursor into ln_exists;
      exit when lc_ref_cursor%notfound;
      if ln_exists > 0 then
         lv_sql_drop := 'delete zoetmp.com_i18n_dict_class_tmp@'||lv_target_db_link;
         execute immediate lv_sql_drop;
         commit;
      end if;
    end loop;
    if ln_exists = 0 then
       --Ŀ�����ݿ�û���������ô��Ҫ�ֹ�������Զ�̲�֧��truncate��DDL
       rollback;
       return_code := -1;
       msg := 'Ŀ�����ݿ��в�����[ZOETMP.COM_I18N_DICT_CLASS_TMP],���ֹ�ִ�нű����й��ʻ�ͬ����';
       return;
    end if;
    
    --6.ZOETMP.COM_I18N_DICT_CLASS_DIST_TMP
    lv_sql := 'select count(1) from dba_tables@'||lv_target_db_link||' where owner=''ZOETMP'' and table_name = ''COM_I18N_DICT_CLASS_DIST_TMP''';
    open lc_ref_cursor for lv_sql;
    loop
      fetch lc_ref_cursor into ln_exists;
      exit when lc_ref_cursor%notfound;
      if ln_exists > 0 then
         lv_sql_drop := 'delete zoetmp.com_i18n_dict_class_dist_tmp@'||lv_target_db_link;
         execute immediate lv_sql_drop;
         commit;
      end if;
    end loop;
    if ln_exists = 0 then
       --Ŀ�����ݿ�û���������ô��Ҫ�ֹ�������Զ�̲�֧��truncate��DDL
       rollback;
       return_code := -1;
       msg := 'Ŀ�����ݿ��в�����[ZOETMP.COM_I18N_DICT_CLASS_DIST_TMP],���ֹ�ִ�нű����й��ʻ�ͬ����';
       return;
    end if;
    
    --7.ZOETMP.COM_I18N_DICT_INFO_TMP
    lv_sql := 'select count(1) from dba_tables@'||lv_target_db_link||' where owner=''ZOETMP'' and table_name = ''COM_I18N_DICT_INFO_TMP''';
    open lc_ref_cursor for lv_sql;
    loop
      fetch lc_ref_cursor into ln_exists;
      exit when lc_ref_cursor%notfound;
      if ln_exists > 0 then
         lv_sql_drop := 'delete zoetmp.com_i18n_dict_info_tmp@'||lv_target_db_link;
         execute immediate lv_sql_drop;
         commit;
      end if;
    end loop;
    if ln_exists = 0 then
       --Ŀ�����ݿ�û���������ô��Ҫ�ֹ�������Զ�̲�֧��truncate��DDL
       rollback;
       return_code := -1;
       msg := 'Ŀ�����ݿ��в�����[ZOETMP.COM_I18N_DICT_INFO_TMP],���ֹ�ִ�нű����й��ʻ�ͬ����';
       return;
    end if;
    
    --8.ZOETMP.COM_I18N_DICT_LANG_INFO_TMP
    lv_sql := 'select count(1) from dba_tables@'||lv_target_db_link||' where owner=''ZOETMP'' and table_name = ''COM_I18N_DICT_LANG_INFO_TMP''';
    open lc_ref_cursor for lv_sql;
    loop
      fetch lc_ref_cursor into ln_exists;
      exit when lc_ref_cursor%notfound;
      if ln_exists > 0 then
         lv_sql_drop := 'delete zoetmp.com_i18n_dict_lang_info_tmp@'||lv_target_db_link;
         execute immediate lv_sql_drop;
         commit;
      end if;
    end loop;
    if ln_exists = 0 then
       --Ŀ�����ݿ�û���������ô��Ҫ�ֹ�������Զ�̲�֧��truncate��DDL
       rollback;
       return_code := -1;
       msg := 'Ŀ�����ݿ��в�����[ZOETMP.COM_I18N_DICT_LANG_INFO_TMP],���ֹ�ִ�нű����й��ʻ�ͬ����';
       return;
    end if;
    --����Ŀ�������
    lv_sql := 'insert into zoetmp.com_i18n_dict_class@'||lv_target_db_link||' select * from zoecomm.com_i18n_dict_class@'||lv_target_db_link;
    execute immediate lv_sql;
    commit;

    lv_sql := 'insert into zoetmp.com_i18n_dict_class_dist@'||lv_target_db_link||' select * from zoecomm.com_i18n_dict_class_dist@'||lv_target_db_link;
    execute immediate lv_sql;
    commit;
    
    lv_sql := 'insert into zoetmp.com_i18n_dict_info@'||lv_target_db_link||' select * from zoecomm.com_i18n_dict_info@'||lv_target_db_link;
    execute immediate lv_sql;
    commit;
    
    lv_sql := 'insert into zoetmp.com_i18n_dict_lang_info@'||lv_target_db_link||' select * from zoecomm.com_i18n_dict_lang_info@'||lv_target_db_link;
    execute immediate lv_sql;
    commit;  
    
    --����ά�����Ŀ����ʱ��
    lv_sql := 'insert into zoetmp.com_i18n_dict_class_tmp@'||lv_target_db_link||' select * from zoedevops.com_i18n_dict_class';
    execute immediate lv_sql;
    commit;
    
    lv_sql := 'insert into zoetmp.com_i18n_dict_class_dist_tmp@'||lv_target_db_link||' select * from zoedevops.com_i18n_dict_class_dist';
    execute immediate lv_sql;
    commit;
    
    lv_sql := 'insert into zoetmp.com_i18n_dict_info_tmp@'||lv_target_db_link||' select * from zoedevops.com_i18n_dict_info';
    execute immediate lv_sql;
    commit;
    
    lv_sql := 'insert into zoetmp.com_i18n_dict_lang_info_tmp@'||lv_target_db_link||' select * from zoedevops.com_i18n_dict_lang_info';
    execute immediate lv_sql;
    commit;
    --�ȸ��£��ٲ���
    lv_sql :=         'update zoecomm.com_i18n_dict_class@'||lv_target_db_link||' a';
    lv_sql := lv_sql||'  set (i18n_dict_class_name,parent_i18n_class_code,sort_no,memo,valid_flag,spell_code,wbzx_code,creator_code,created_time,modifier_code,modified_time) ';
    lv_sql := lv_sql||'     = (select b.i18n_dict_class_name,b.parent_i18n_class_code,b.sort_no,b.memo,b.valid_flag,b.spell_code,b.wbzx_code,b.creator_code,b.created_time,b.modifier_code,b.modified_time ';
    lv_sql := lv_sql||'          from zoetmp.com_i18n_dict_class_tmp@'||lv_target_db_link||' b';
    lv_sql := lv_sql||'         where b.i18n_dict_class_code = a.i18n_dict_class_code)';
    lv_sql := lv_sql||' where exists (select 1 ';
    lv_sql := lv_sql||'         from zoetmp.com_i18n_dict_class_tmp@'||lv_target_db_link||' b';
    lv_sql := lv_sql||'        where b.i18n_dict_class_code = a.i18n_dict_class_code)';
    execute immediate lv_sql;
    
    lv_sql :=         'update zoecomm.com_i18n_dict_class_dist@'||lv_target_db_link||' a'; 
    lv_sql := lv_sql||'   set (operator_code,operator_time) = (select b.operator_code,b.operator_time ';
    lv_sql := lv_sql||'                                          from zoetmp.com_i18n_dict_class_dist_tmp@'||lv_target_db_link||' b'; 
    lv_sql := lv_sql||'                                         where b.i18n_dict_class_code = a.i18n_dict_class_code'; 
    lv_sql := lv_sql||'                                           and b.i18n_item_code = a.i18n_item_code)'; 
    lv_sql := lv_sql||' where exists (select 1 '; 
    lv_sql := lv_sql||'                 from zoetmp.com_i18n_dict_class_dist_tmp@'||lv_target_db_link||' b';
    lv_sql := lv_sql||'                where b.i18n_dict_class_code = a.i18n_dict_class_code'; 
    lv_sql := lv_sql||'                  and b.i18n_item_code = a.i18n_item_code)'; 
    execute immediate lv_sql;
    
   
   lv_sql :=         'update zoecomm.com_i18n_dict_info@'||lv_target_db_link||' a'; 
   lv_sql := lv_sql||'   set (i18n_item_explain,sort_no,memo,valid_flag,spell_code,wbzx_code,creator_code,created_time,modifier_code,modified_time,not_sync)';
   lv_sql := lv_sql||'        = (select b.i18n_item_explain,b.sort_no,b.memo,b.valid_flag,b.spell_code,b.wbzx_code,b.creator_code,b.created_time,b.modifier_code,b.modified_time,b.not_sync';
   lv_sql := lv_sql||'             from zoetmp.com_i18n_dict_info_tmp@'||lv_target_db_link||' b';  
   lv_sql := lv_sql||'            where b.i18n_item_code = a.i18n_item_code)';
   lv_sql := lv_sql||'  where exists (select 1 ';
   lv_sql := lv_sql||'                  from zoetmp.com_i18n_dict_info_tmp@'||lv_target_db_link||' b'; 
   lv_sql := lv_sql||'                 where b.i18n_item_code = a.i18n_item_code)';
   lv_sql := lv_sql||'    and nvl(a.not_sync,''0'') = ''0''';
    execute immediate lv_sql; 
    
    
   lv_sql :=         'update zoecomm.com_i18n_dict_lang_info@'||lv_target_db_link||' a';  
   lv_sql := lv_sql||'    set (language_translation,sort_no,memo,modifier_code,modified_time,not_sync) ';
   lv_sql := lv_sql||'        = (select b.language_translation,b.sort_no,b.memo,b.modifier_code,b.modified_time,b.not_sync ';
   lv_sql := lv_sql||'             from zoetmp.com_i18n_dict_lang_info_tmp@'||lv_target_db_link||' b';  
   lv_sql := lv_sql||'            where b.i18n_item_code = a.i18n_item_code';
   lv_sql := lv_sql||'              and b.i18n_class = a.i18n_class)';
   lv_sql := lv_sql||'  where exists (select 1 ';
   lv_sql := lv_sql||'                  from zoetmp.com_i18n_dict_lang_info_tmp@'||lv_target_db_link||' b';  
   lv_sql := lv_sql||'                 where b.i18n_item_code = a.i18n_item_code';
   lv_sql := lv_sql||'                   and b.i18n_class = a.i18n_class)';
   lv_sql := lv_sql||'    and nvl(not_sync,''0'') = ''0''';
    execute immediate lv_sql; 
    
    
   lv_sql :=         'insert into zoecomm.com_i18n_dict_class@'||lv_target_db_link||' a '; 
   lv_sql := lv_sql||' select * from zoetmp.com_i18n_dict_class_tmp@'||lv_target_db_link||' b'; 
   lv_sql := lv_sql||'  where not exists (select 1 ';
   lv_sql := lv_sql||'                      from zoecomm.com_i18n_dict_class@'||lv_target_db_link||' a'; 
   lv_sql := lv_sql||'                     where b.i18n_dict_class_code = a.i18n_dict_class_code)';
    execute immediate lv_sql; 
    
    
    
    lv_sql :=         'insert into zoecomm.com_i18n_dict_class_dist@'||lv_target_db_link||' a '; 
    lv_sql := lv_sql||'select * from zoetmp.com_i18n_dict_class_dist_tmp@'||lv_target_db_link||' b'; 
    lv_sql := lv_sql||' where not exists (select 1 ';
    lv_sql := lv_sql||'                     from zoecomm.com_i18n_dict_class_dist@'||lv_target_db_link||' a'; 
    lv_sql := lv_sql||'                    where b.i18n_dict_class_code = a.i18n_dict_class_code';
    lv_sql := lv_sql||'                      and b.i18n_item_code = a.i18n_item_code)';
    execute immediate lv_sql;
    
    lv_sql :=         'insert into zoecomm.com_i18n_dict_info@'||lv_target_db_link||' a '; 
    lv_sql := lv_sql||'select * from zoetmp.com_i18n_dict_info_tmp@'||lv_target_db_link||' b '; 
    lv_sql := lv_sql||' where not exists (select 1 ';
    lv_sql := lv_sql||'                     from zoecomm.com_i18n_dict_info@'||lv_target_db_link||' a '; 
    lv_sql := lv_sql||'                    where b.i18n_item_code = a.i18n_item_code)';
    execute immediate lv_sql;
    
    
    lv_sql :=         'insert into zoecomm.com_i18n_dict_lang_info@'||lv_target_db_link||' a '; 
    lv_sql := lv_sql||'select * from zoetmp.com_i18n_dict_lang_info_tmp@'||lv_target_db_link||' b '; 
    lv_sql := lv_sql||' where not exists (select 1'; 
    lv_sql := lv_sql||'                     from zoecomm.com_i18n_dict_lang_info@'||lv_target_db_link||' a '; 
    lv_sql := lv_sql||'                    where a.i18n_item_code = b.i18n_item_code';
    lv_sql := lv_sql||'                      and a.i18n_class = b.i18n_class)';
    execute immediate lv_sql;   
                   
    --���һ���ύ
    ld_sysdate := sysdate;
    if in_sequence_no is not null then
       update zoedevops.dvp_synchronous_data_config 
          set last_synchronous_time = ld_sysdate,
              last_synchronous_operator = lv_operator
        where sequence_no = in_sequence_no;
    end if;
    
    commit;
    return_code := 0;
    msg := '����ͬ����ɡ�';
    return;
  exception
    when others then
         ls_error_code := to_char(sqlcode);
         ls_error_msg := trim(sqlerrm);
         rollback;
         return_code := -1;
         msg := '����ͬ��ʧ�ܣ�������룺'||ls_error_code||chr(13)||'������Ϣ��'||ls_error_msg;
         return;
  end;
  --���ݽṹͬ�����϶��Ǵ��������ݽṹͬ������ά�������
  procedure p_data_structure_synchronous(in_sequence_no in varchar2,
                                         source_db_id in varchar2,
                                         operator in varchar2,
                                         return_code out number,
                                         msg out varchar2)
  as
      lv_operator    varchar2(64);
      lv_source_db_link  varchar2(64);
      lv_sql             varchar2(4000);
      ld_sysdate         date;
      ls_error_code      varchar2(4000);
      ls_error_msg       varchar2(4000);
  begin
    lv_operator := trim(operator);
    if source_db_id is null then
       return_code := -1;
       msg := 'Դ���ݿ�IDΪ��';
       return;
    end if;
    
    if lv_operator is null then
       lv_operator := 'system';
    end if;
    
    begin
       select db_link_name 
         into lv_source_db_link 
         from zoedevops.dvp_proj_node_db_links 
        where db_id#=source_db_id;
    exception
      when no_data_found then
         return_code := -1;
         msg := '��ά���ݿ�δ����Դ���ݿ�id['||source_db_id||']��Ӧ��dblink';
         return;
    end;

    --����һ��Դ���ݿ��Ŀ�����ݿ��dblink�ܲ���ͨ
    lv_sql := 'select sysdate from dual@'||lv_source_db_link;
    begin
       execute immediate lv_sql;
    exception
      when others then
        rollback;
        return_code := -1;
         msg := '�������Դ���ݿ�id['||lv_source_db_link||']��ͨ���߳����쳣���޷�ͬ�����ݡ�';
         return;
    end;
    begin
         zoepkg_metadata_sync.increment_sync_all(in_db_id => source_db_id);
    exception
      when others then
           rollback;
           return_code := -1;
           msg := '�����쳣������ͬ�����ݽṹʧ�ܡ�';
           return;
    end;
    
    --���һ���ύ
    ld_sysdate := sysdate;
    if in_sequence_no is not null then
       update zoedevops.dvp_synchronous_data_config 
          set last_synchronous_time = ld_sysdate,
              last_synchronous_operator = lv_operator
        where sequence_no = in_sequence_no;
    end if;
    
    commit;
    return_code := 0;
    msg := '����ͬ����ɡ�';
    return;  
    
  exception
    when others then
         ls_error_code := to_char(sqlcode);
         ls_error_msg := trim(sqlerrm);
         rollback;
         return_code := -1;
         msg := '����ͬ��ʧ�ܣ�������룺'||ls_error_code||chr(13)||'������Ϣ��'||ls_error_msg;
         return;
  end;
  procedure p_synchronous(synchronization_type in varchar2,
                          in_sequence_no in varchar2,
                          source_db_id in varchar2,
                          target_db_id in varchar2,
                          operator in varchar2,
                          return_code out number,
                          msg out varchar2)
  as
  begin
    if synchronization_type is null then
         rollback;
         return_code := -1;
         msg := '�����ͬ������Ϊ�գ��޷�ͬ����';
         return;
     end if;
     
     case synchronization_type
       when '1' then
         p_i18_synchronous(in_sequence_no => in_sequence_no,
                           source_db_id => source_db_id,
                           target_db_id => target_db_id,
                           operator => operator,
                           return_code => return_code,
                           msg => msg);
         if return_code is null or return_code < 0 then
            rollback;
            return_code := return_code;
            msg :=  trim(msg);
            return;
         end if;
       when '2' then
         p_data_structure_synchronous(in_sequence_no => in_sequence_no,
                                      source_db_id => source_db_id,
                                      operator => operator,
                                      return_code => return_code,
                                      msg => msg);
         if return_code is null or return_code < 0 then
            rollback;
            return_code := return_code;
            msg :=  trim(msg);
            return;
         end if;
       else
         rollback;
         return_code := -1;
         msg := '�����ͬ��������Ч���޷�ͬ����';
         return; 
     end case;
  exception
     when others then
         rollback;
         return_code := -1;
         msg := '�����쳣������ͬ��ʧ�ܡ�';
         return;
  end;
END ZOEPKG_SYNCHRONOUS_DATA;
/
