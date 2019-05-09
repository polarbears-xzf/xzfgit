create or replace package body ZHIS4_SGARCHIVE is
  e_parm_failure exception;

  function op_judge_disp_prepay(as_sick_id in sick_basic_info.sick_id%type,
                                rs_mess    out varchar2) return integer is
  
    ls_sick_id  dispensary_sick_price_item.sick_id%type;
    ldc_balance sick_prepay_balance.policlinic_cash_bala%type;
    ldc_prepay  prepayment_money.money%type;
    ldc_charges dispensary_sick_price_item.charges%type;
  
  begin
    ls_sick_id := as_sick_id;
    begin
      --获取未结算费用
      select sum(nvl(charges, 0))
        into ldc_charges
        from dispensary_sick_price_item
       where sick_id = ls_sick_id
         and settle_no is null;
    exception
      when no_data_found then
        ldc_charges := 0;
      
    end;
    if ldc_charges is null then
      ldc_charges := 0;
    end if;
  
    --未结算预交金
    begin
      select sum(nvl(a.money, 0))
        into ldc_prepay
        from prepayment_money a
       where a.sick_id = ls_sick_id
         and a.visit_number = 0
         and a.settle_date is null
         and a.operation_type <> '9';
    exception
      when no_data_found then
        ldc_prepay := 0;
      
    end;
    begin
      select nvl(policlinic_cash_bala, 0)
        into ldc_balance
        from sick_prepay_balance
       where sick_id = ls_sick_id;
    
    exception
      when no_data_found then
        ldc_balance := 0;
      
    end;
    if ldc_balance is null then
      ldc_balance := 0;
    end if;
  
    if ldc_prepay is null then
      ldc_prepay := 0;
    end if;
  
    if ldc_balance < 0 then
      rollback;
      rs_mess := '病人余额小于0';
      return - 1;
    end if;
  
    --预交金校验不符合
    if (ldc_prepay - ldc_charges <> ldc_balance) then
      rollback;
      rs_mess := '未结预交金校验不平';
      return - 1;
    else
      rs_mess := '';
      return 0;
    end if;
  exception
    when others then
      rollback;
      rs_mess := trim(sqlerrm);
      return - 1;
  end;

  procedure op_disp_batch_settle is
    ld_sys            date;
    ldc_nums          number;
    ldc_nums_diff     number;
    ls_now            varchar2(20);
    ldc_bgexec_log_no back_exec_log.back_exec_log_no%type;
    ls_sick_id        dispensary_sick_price_item.sick_id%type;
    ll_return         integer;
    ls_mess_info      varchar2(1000);
    ls_tips           varchar2(1000);
    ld_pre_date       date;
    ld_start_date     date;
    ll_count          number;
    ll_success        number;
    ll_fail           number;
    ls_before_year    sys_parm.value%type;
    ls_start_year     sys_parm.value%type;
    ll_before_year    number;
    ll_start_year     number;
  begin
    if zhis4_log.vf_bgexec_log_start(as_package_name   => 'zhis4_sgarchive',
                                     as_function_name  => 'op_disp_batch_settle',
                                     rdc_bgexec_log_no => ldc_bgexec_log_no) < 0 then
      return;
    end if;
    --到早上7点自动停止内部结算
    ld_sys        := trunc(sysdate);
    ldc_nums      := 0;
    ldc_nums_diff := 0;
  
    if zhis4_comm.vf_get_sys_parm('disp_sgarchive_settle_before_year',
                                  ls_before_year) < 0 then
      rollback;
      return;
    end if;
  
    if zhis4_comm.vf_get_sys_parm('disp_sgarchive_settle_start_year',
                                  ls_start_year) < 0 then
      rollback;
      return;
    end if;
  
    ll_before_year := to_number(ls_before_year);
    ll_start_year  := to_number(ls_start_year);
    if ll_before_year is null then
      --系统参数为配置默认3
      ll_before_year := 3;
    end if;
  
    if ll_start_year is null then
      --系统参数为配置默认1年多的时间380天
      ll_start_year := 380;
    end if;
  
    select add_months(trunc(sysdate), -12 * ll_before_year),
           add_months(trunc(sysdate), -12 * ll_before_year) - ll_start_year
      into ld_pre_date, ld_start_date
      from dual;
  
    ll_count   := 0;
    ll_success := 0;
    ll_fail    := 0;
  
    for cur_fee in (select distinct a.sick_id
                      from dispensary_sick_price_item a
                     where a.operation_time < ld_pre_date -- 时间要修改下
                       and a.operation_time >= ld_start_date
                       and a.settle_no is null
                     group by sick_id) loop
      ll_count := ll_count + 1;
      ls_now   := to_char(sysdate, 'hh24:mi:ss');
      if ls_now>='07:30:00' and ls_now<'19:00:00' then --到早上七点自动停
        rollback;
        return;
      end if;
      ls_sick_id := cur_fee.sick_id;
      --按病人内部结算
      zhis4_sgarchive.op_disp_settle_bysickid(as_sick_id    => ls_sick_id,
                                              ad_start_date => ld_start_date,
                                              ad_pre_date   => ld_pre_date,
                                              rl_return     => ll_return,
                                              rs_mess       => ls_mess_info);
      if ll_return < 0 or ls_mess_info is not null then
        rollback;
        ll_fail := ll_fail + 1;
      else
        ll_success := ll_success + 1;
      end if;
    end loop;
  
    ls_tips := '内部结算总病人数[' || to_char(ll_count) || ']成功数量[' ||
               to_char(ll_success) || '],出错数量[' || ll_fail || ']';
    -- 后台日志(结束)
    if zhis4_log.vf_bgexec_log_end(adc_bgexec_log_no   => ldc_bgexec_log_no,
                                   al_exec_return_code => 0,
                                   as_log_msg          => ls_tips) < 0 then
      return;
    end if;
  end;

  --门诊按病人内部结算 
  procedure op_disp_settle_bysickid(as_sick_id    in varchar2,
                                    ad_start_date in date default null,
                                    ad_pre_date   in date default null,
                                    rl_return     out integer,
                                    rs_mess       out varchar2) is
    ld_sys                   date;
    ldc_prepay               number(12, 2);
    ldc_balance              number(12, 2);
    ldc_charges              number(12, 2);
    ldc_cost                 number(12, 2);
    ldc_nums                 number;
    ldc_nums_diff            number;
    ls_now                   varchar2(8);
    ls_settle_no             sick_settle_master.settle_no%type;
    ldt_settle_date          date;
    ls_residence_no          dispensary_sick_price_item.residence_no%type;
    ls_dept_code             sick_settle_master.dept_code%type;
    ls_card_id               sick_basic_info.ic_card_id%type;
    ldc_prepay_balance       prepayment_money.money%type; --结存的预交金
    ldc_settle_charges       dispensary_sick_price_item.charges%type; --本次结算自付金额
    ldc_settle_prepay        prepayment_money.money%type; --本次结算的预交金金额
    ldc_settle_cost          dispensary_sick_price_item.cost%type; --本次结算费用
    ld_pre_date              prepayment_money.operation_date%type;
    ld_start_date            date;
    ls_sick_id               dispensary_sick_price_item.sick_id%type;
    ldc_settle_charges_after dispensary_sick_price_item.charges%type; --内部结算后自付金额
    ldc_settle_prepay_after  prepayment_money.money%type; --内部结算后未结算预交金
    ls_error_msg             varchar2(2000);
    ll_settle_count          number;
    ldc_bgexec_log_no        back_exec_log.back_exec_log_no%type;
    ls_before_year           sys_parm.value%type;
    ll_before_year           number;
  
  begin
  
    ls_sick_id := as_sick_id;
  
    if trim(ls_sick_id) is null or trim(ls_sick_id) = '' then
      rollback;
      rs_mess   := '病人id参数为空1';
      rl_return := -1;
      return;
    end if;
  
    if ad_pre_date is null then
      if zhis4_comm.vf_get_sys_parm('disp_sgarchive_settle_before_year',
                                    ls_before_year) < 0 then
        rollback;
        rs_mess   := '获取系统参数disp_sgarchive_settle_before_year出错';
        rl_return := -1;
        return;
      end if;
      ll_before_year := to_number(ls_before_year);
    
      if ll_before_year is null then
        --系统参数为配置默认3
        ll_before_year := 3;
      end if;
      select add_months(trunc(sysdate), -12 * ll_before_year)
        into ld_pre_date
        from dual;
    else
      ld_pre_date   := ad_pre_date;
      ld_start_date := ad_start_date;
    end if;
  
    --结算主表的操作科室、预交金记录表的操作科室代码都是写死的，记得替换
  
    ldc_prepay  := 0;
    ldc_balance := 0;
    ldc_charges := 0;
    ldc_cost    := 0;
    --1.1、统计未结算费用、预交金及余额并验证平衡关系
    select nvl(policlinic_cash_bala, 0)
      into ldc_balance
      from sick_prepay_balance
     where sick_id = ls_sick_id
       for update;
    if ldc_balance is null then
      ldc_balance := 0;
    end if;
    --余额小于0  不结算
    if ldc_balance < 0 then
      --rollback;
      rs_mess := '内部结算前病人余额小于0';
      raise e_parm_failure;
    end if;
    --获取未结算费用
    select sum(nvl(cost, 0)), sum(nvl(charges, 0)), max(residence_no)
      into ldc_cost, ldc_charges, ls_residence_no
      from dispensary_sick_price_item
     where sick_id = ls_sick_id
       and settle_no is null;
  
    if ldc_cost is null then
      ldc_cost := 0;
    end if;
    if ldc_charges is null then
      ldc_charges := 0;
    end if;
  
    --未结算预交金
    select sum(nvl(a.money, 0))
      into ldc_prepay
      from prepayment_money a
     where a.sick_id = ls_sick_id
       and a.visit_number = 0
       and a.settle_date is null
       and a.operation_type <> '9';
  
    if ldc_prepay is null then
      ldc_prepay := 0;
    end if;
    --预交金校验不符合
    if ldc_prepay - ldc_charges <> ldc_balance then
      rollback;
      rs_mess := '病人内部结算前余额校验不平';
      raise e_parm_failure;
    end if;
  
    if ls_residence_no is not null then
      begin
        select cure_dept
          into ls_dept_code
          from dispensary_sick_cure_info
         where nullah_number = to_number(ls_residence_no);
      exception
        when no_data_found then
          null;
      end;
    end if;
  
    begin
      select trim(ic_card_id)
        into ls_card_id
        from ic_used_status
       where sick_id = ls_sick_id
         and now_status = '1'; --正常卡
    exception
      when no_data_found then
        null;
    end;
  
    --本次内部结算自付金额
    begin
      select sum(charges), sum(cost)
        into ldc_settle_charges, ldc_settle_cost
        from dispensary_sick_price_item
       where sick_id = ls_sick_id
         and settle_no is null
         and operation_time >= ld_start_date
         and operation_time < ld_pre_date;
    exception
      when no_data_found then
        ldc_settle_charges := 0;
        ldc_settle_cost    := 0;
    end;
    if ldc_settle_charges is null then
      ldc_settle_charges := 0;
    end if;
    if ldc_settle_cost is null then
      ldc_settle_cost := 0;
    end if;
  
    if ldc_settle_cost = 0 then
      rollback;
      rs_mess := '在时间' || to_char(ld_pre_date, 'yyyy-mm-dd') ||
                 '之前没有未结算费用!';
      raise e_parm_failure;
    end if;
  
    select comm.settle_no_seq.nextval into ls_settle_no from dual;
    ldt_settle_date := sysdate;
  
    --更新结算表
    update dispensary_sick_price_item
       set settle_no = ls_settle_no
     where sick_id = ls_sick_id
       and settle_no is null
       and operation_time >= ld_start_date
       and operation_time < ld_pre_date;
    --更新预交金     
    update prepayment_money
       set settle_receipt_no = ls_settle_no,
           settle_date       = ldt_settle_date,
           settle_operator   = 'archive/settle'
     where sick_id = ls_sick_id
       and visit_number = 0
       and settle_date is null
       and operation_date >= ld_start_date
       and operation_date < ld_pre_date
       and operation_type <> '9';
  
    --本次结算的预交金金额    
    select sum(money)
      into ldc_settle_prepay
      from prepayment_money
     where sick_id = ls_sick_id
       and settle_receipt_no = ls_settle_no;
  
    if ldc_settle_prepay is null then
      ldc_settle_prepay := 0;
    end if;
    ldc_prepay_balance := ldc_settle_prepay - ldc_settle_charges; --结存金额=结算预交金金额 - 已结算费用     
  
    insert into sick_settle_master
      (settle_no,
       receipt_no,
       settle_type,
       out_ward_settle_type,
       settle_mode,
       sick_id,
       residence_no,
       dept_code,
       rate_type,
       settle_date,
       operator,
       payments /*预交款*/,
       cost,
       charges,
       cost_flag,
       insur_rush_flag,
       limit_flag,
       prepay_balance,
       sick_prepay_pay,
       ic_card_id,
       OPERATE_DEPT)
    values
      (ls_settle_no,
       'archive',
       '1',
       '1',
       '0',
       ls_sick_id,
       ls_residence_no,
       ls_dept_code,
       'S', --都按自费结
       ldt_settle_date,
       'archive/settle',
       ldc_prepay,
       ldc_settle_cost,
       ldc_settle_charges,
       'Y',
       '0',
       '0',
       ldc_balance,
       0,
       ls_card_id,
       '10051' /*门诊收费处*/);
    --产生结算细表
    insert into sick_settle_detail
      (settle_no, receipt_class, receipt_name, cost, charges)
      select ls_settle_no,
             nvl(c.code, '##') receipt_class,
             c.name receipt_name,
             sum(nvl(a.cost, 0)) cost,
             sum(nvl(a.charges, 0)) charges
        from dispensary_sick_price_item a, base_dict c
       where a.receipt_class = c.code(+)
         and c.dict_name(+) = 'data_receipt_item_dict'
         and a.settle_no = ls_settle_no
       group by nvl(c.code, '##'), c.name;
  
    --产生结算结存
    --if ldc_balance>0 then
    -- if ldc_prepay_balance>0 then 
    insert into prepayment_money b
      (prepay_no,
       receipt_no,
       sick_id,
       card_id,
       visit_number,
       money,
       pay_type,
       operation_type,
       operation_date,
       operator,
       OPERATE_DEPT)
    values
      (comm.prepay_no_seq.nextval,
       null,
       ls_sick_id,
       ls_card_id,
       0,
       ldc_prepay_balance,
       '1',
       '3',
       ldt_settle_date,
       'archive/settle',
       '10051' /*门诊收费处*/);
    --  end if;
  
    --结算后预交金再次交易下是否正确  
    begin
      -- 未结算预交金
      select sum(a.money)
        into ldc_settle_prepay_after
        from prepayment_money a
       where a.sick_id = ls_sick_id
         and a.visit_number = 0
         and a.settle_date is null
         and a.operation_type <> '9'; --不等于作废
    
      --未结算费用   
      select sum(b.charges)
        into ldc_settle_charges_after
        from dispensary_sick_price_item b
       where b.sick_id = ls_sick_id
         and b.visit_number = 0
         and b.archive is null
         and b.settle_no is null;
    exception
      when others then
        rs_mess := '获取病人预交金平衡出错' || sqlerrm;
        raise e_parm_failure;
    end;
    --  
    if ldc_settle_prepay_after - ldc_settle_charges_after <> ldc_balance then
      rs_mess := '内部结算后病人预交金不平' || sqlerrm;
      raise e_parm_failure;
    end if;
    --插入正常内部结算记录
  
    insert into archive_settle_log
      (log_no,
       operation_date,
       sick_id,
       error_type,
       money,
       cost,
       charges,
       balance,
       diff_balance,
       settle_no,
       mess_info)
    values
      (seq_balance_log_no.nextval,
       sysdate,
       ls_sick_id,
       '0',
       ldc_settle_prepay,
       ldc_settle_cost,
       ldc_settle_charges,
       ldc_balance,
       ldc_prepay_balance,
       ls_settle_no,
       '成功内部结算');
    commit; --提交
    rs_mess   := '';
    rl_return := 0;
    return;
  
  exception
    when e_parm_failure then
      rollback; --先回滚
      rl_return := -1;
      insert into archive_settle_log
        (log_no, operation_date, sick_id, error_type, balance, mess_info)
      values
        (seq_balance_log_no.nextval,
         sysdate,
         ls_sick_id,
         '1',
         ldc_balance,
         rs_mess);
      commit;
      return;
    when others then
      rollback;
      rl_return := -1;
      rs_mess   := trim(sqlerrm);
      insert into archive_settle_log
        (log_no, operation_date, sick_id, error_type, balance, mess_info)
      values
        (seq_balance_log_no.nextval,
         sysdate,
         ls_sick_id,
         '1',
         ldc_balance,
         rs_mess);
      commit;
      return;
  end op_disp_settle_bysickid;

  --门诊归档病人数据挪回
  procedure op_cancel_disp_settle_bysickid(as_sick_id in varchar2,
                                           rl_return  out integer,
                                           rs_mess    out varchar2) is
    ld_sys         date;
    ldc_nums       number;
    ldc_nums_diff  number;
    ls_now         varchar2(20);
    ld_settle_date date;
    ls_error_msg   varchar2(2000);
    ls_sick_name   sick_basic_info.name%type;
    ls_sick_id     sick_basic_info.sick_id%type;
    ls_mess        varchar2(1000);
    ldc_cost       dispensary_sick_price_item.cost%type;
    ldc_charges    dispensary_sick_price_item.charges%type;
    ldc_prepay     prepayment_money.money%type;
  begin
    --预留接口 还未编程
    ld_sys     := trunc(sysdate);
    ls_sick_id := as_sick_id;
    begin
      select name
        into ls_sick_name
        from sick_basic_info
       where sick_id = as_sick_id;
    exception
      when no_data_found then
        rollback;
        rl_return := -1;
        rs_mess   := '未找病人id' || as_sick_id || '的基本信息!';
        return;
      
    end;
  
    --挪回数据前，先校验先余额 
    if op_judge_disp_prepay(as_sick_id => ls_sick_id, rs_mess => ls_mess) < 0 then
      rollback;
      rl_return := '-1';
      rs_mess   := '数据移回前错误:' || ls_mess;
      return;
    end if;
  
    --开始移回数据
    --1.预交金
    --已结算预交金挪回，然后删除归档数据，where 条件要一致
    --1.1挪回预交金
    select sum(money)
      into ldc_prepay
      from ZOEARCHIVE.prepayment_money_a@fzfy_archi
     where sick_id = ls_sick_id
       and visit_number = 0
       and settle_receipt_no is not null;
  
    if ldc_prepay is null then
      ldc_prepay := 0;
    end if;
    insert into prepayment_money
      select *
        from ZOEARCHIVE.prepayment_money_a@fzfy_archi
       where sick_id = ls_sick_id
         and visit_number = 0
         and settle_receipt_no is not null;
    --1.2删除归档预交金（已结算）
    delete from ZOEARCHIVE.prepayment_money_a@fzfy_archi
     where sick_id = ls_sick_id
       and visit_number = 0
       and settle_receipt_no is not null;
  
    --2费用
    --2.1挪回费用
    select sum(cost), sum(charges)
      into ldc_cost, ldc_charges
      from ZOEARCHIVE.dispensary_sick_price_item_a@fzfy_archi
     where sick_id = ls_sick_id
       and visit_number = 0
       and settle_no is not null;
    if ldc_cost is null then
      ldc_cost := 0;
    end if;
    if ldc_charges is null then
      ldc_charges := 0;
    end if;
  
    insert into dispensary_sick_price_item
      select *
        from ZOEARCHIVE.dispensary_sick_price_item_a@fzfy_archi
       where sick_id = ls_sick_id
         and visit_number = 0
         and settle_no is not null;
  
    --2.2 删除归档的费用（已结算）
    delete from ZOEARCHIVE.dispensary_sick_price_item_a@fzfy_archi
     where sick_id = ls_sick_id
       and visit_number = 0
       and settle_no is not null;
  
    --3结算主细表
    --3.1挪回结算主细表
  
    insert into sick_settle_master
      select *
        from ZOEARCHIVE.sick_settle_master_a@fzfy_archi
       where sick_id = ls_sick_id
         and settle_mode = '0';
  
    insert into sick_settle_detail a
      select *
        from ZOEARCHIVE.sick_settle_detail_a@fzfy_archi b
       where b.settle_no in (select t.settle_no
                               from ZOEARCHIVE.sick_settle_master_a@fzfy_archi t
                              where t.sick_id = ls_sick_id
                                and t.settle_mode = '0');
  
    --3.2删除归档的结算记录（先删细表，再删主表)
    delete from ZOEARCHIVE.sick_settle_detail_a@fzfy_archi b
     where b.settle_no in (select t.settle_no
                             from ZOEARCHIVE.sick_settle_master_a@fzfy_archi t
                            where t.sick_id = ls_sick_id
                              and t.settle_mode = '0');
  
    delete from ZOEARCHIVE.sick_settle_master_a@fzfy_archi
     where sick_id = ls_sick_id
       and settle_mode = '0';
  
    --挪回数据后，校验余额 
    if op_judge_disp_prepay(as_sick_id => ls_sick_id, rs_mess => ls_mess) < 0 then
      rollback;
      rl_return := '-1';
      rs_mess   := '数据移回后错误:' || ls_mess;
      return;
    end if;
  
    --记录下日志，不新增表了，沿用内部结算记录表  
    begin
      insert into archive_settle_log
        (log_no,
         operation_date,
         sick_id,
         error_type,
         money,
         cost,
         charges,
         balance,
         diff_balance,
         settle_no,
         mess_info)
      values
        (seq_balance_log_no.nextval,
         sysdate,
         ls_sick_id,
         '0',
         ldc_prepay,
         ldc_cost,
         ldc_charges,
         null,
         null,
         '',
         '归档挪回数据');
    exception
      when others then
        rollback;
        rl_return := -1;
        rs_mess   := trim(sqlerrm);
        return;
      
    end;
  
    commit; --提交
    rs_mess   := '';
    rl_return := 0;
    return;
  
  exception
    when others then
      rollback;
      rl_return := -1;
      rs_mess   := trim(sqlerrm);
      return;
  end;

end ZHIS4_SGARCHIVE;
/