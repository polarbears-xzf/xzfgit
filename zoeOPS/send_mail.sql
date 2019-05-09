CREATE OR REPLACE PROCEDURE send_mail(
        p_recipient VARCHAR2, -- 邮件接收人
        p_subject   VARCHAR2, -- 邮件标题
        p_message   VARCHAR2  -- 邮件正文
  )
  IS
   
       --下面四个变量请根据实际邮件服务器进行赋值
       v_mailhost  VARCHAR2(30) := 'smtp.exmail.qq.com';    --SMTP服务器地址
	   v_mailport  NUMBER       := 25;
       v_user      VARCHAR2(30) := 'xuzhifeng@zoesoft.com.cn';            --登录SMTP服务器的用户名
       v_pass      VARCHAR2(20) := 'Xzf7757$zm';             --登录SMTP服务器的密码
       v_sender    VARCHAR2(50) := 'xuzhifeng@zoesoft.com.cn';    --发送者邮箱，一般与 ps_user 对应
        
       v_conn  UTL_SMTP.connection ; --到邮件服务器的连接
       v_msg varchar2(4000);  --邮件内容
   
  BEGIN
       v_conn := UTL_SMTP.open_connection(v_mailhost, v_mailport);
       UTL_SMTP.ehlo(v_conn, v_mailhost); --是用 ehlo() 而不是 helo() 函数
       --否则会报：ORA-29279: SMTP 永久性错误: 503 5.5.2 Send hello first.
   
       UTL_SMTP.command(v_conn, 'AUTH LOGIN' );   -- smtp服务器登录校验
       UTL_SMTP.command(v_conn,UTL_RAW.cast_to_varchar2(UTL_ENCODE.base64_encode(UTL_RAW.cast_to_raw(v_user))));
       UTL_SMTP.command(v_conn,UTL_RAW.cast_to_varchar2(UTL_ENCODE.base64_encode(UTL_RAW.cast_to_raw(v_pass))));
   
       UTL_SMTP.mail(v_conn, v_sender);     --设置发件人
       UTL_SMTP.rcpt(v_conn, p_recipient);  --设置收件人
   
       -- 创建要发送的邮件内容 注意报头信息和邮件正文之间要空一行
       v_msg := 'Date:' || TO_CHAR(SYSDATE, 'dd mon yy hh24:mi:ss' )
           || UTL_TCP.CRLF || 'From: ' || '<' || v_sender || '>'
           || UTL_TCP.CRLF || 'To: ' || '<' || p_recipient || '>'
           || UTL_TCP.CRLF || 'Subject: ' || p_subject
           || UTL_TCP.CRLF || UTL_TCP.CRLF  -- 这前面是报头信息
           || p_message;    -- 这个是邮件正文
   
       UTL_SMTP.open_data(v_conn); --打开流
       UTL_SMTP.write_raw_data(v_conn, UTL_RAW.cast_to_raw(v_msg)); --这样写标题和内容都能用中文
       UTL_SMTP.close_data(v_conn); --关闭流
       UTL_SMTP.quit(v_conn); --关闭连接
        
  EXCEPTION
   
       WHEN OTHERS THEN
           DBMS_OUTPUT.put_line(DBMS_UTILITY.format_error_stack);
           DBMS_OUTPUT.put_line(DBMS_UTILITY.format_call_stack);
   
  END send_mail;