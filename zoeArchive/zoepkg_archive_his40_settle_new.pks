create or replace package ZHIS4_SGARCHIVE is
  --[后台]批量内部结算
  function op_judge_disp_prepay(as_sick_id in sick_basic_info.sick_id%type,
                                rs_mess    out varchar2) return integer;

  procedure op_disp_batch_settle;

  --门诊内部结算按病人
  procedure op_disp_settle_bysickid(as_sick_id    in varchar2,
                                    ad_start_date in date default null,
                                    ad_pre_date   in date default null,
                                    rl_return     out integer,
                                    rs_mess       out varchar2);
  /*procedure oo_get_sick_prepay_balance_all
  (as_sick_id in varcahr2,
  */
  procedure op_cancel_disp_settle_bysickid(as_sick_id in varchar2,
                                           rl_return  out integer,
                                           rs_mess    out varchar2);

end ZHIS4_SGARCHIVE;
/