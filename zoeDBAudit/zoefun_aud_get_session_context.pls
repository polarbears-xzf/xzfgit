CREATE OR REPLACE FUNCTION zoefun_aud_get_session_context
(ot_session_context out zoetyp_aud_session_context)
RETURN INTEGER
AS
BEGIN
  ot_session_context := zoetyp_aud_session_context(null,null,null,null,null,null);
  ot_session_context.USERNAME         := SYS_CONTEXT('USERENV','SESSION_USER');
  ot_session_context.OS_USERNAME      := SYS_CONTEXT('USERENV','OS_USER');
  ot_session_context.HOST             := SYS_CONTEXT('USERENV','HOST');
  ot_session_context.TERMINAL         := SYS_CONTEXT('USERENV','TERMINAL');
  ot_session_context.IP_ADDRESS       := ORA_CLIENT_IP_ADDRESS;
--  lt_session_context.IP_ADDRESS       := SYS_CONTEXT('USERENV','IP_ADDRESS');
  ot_session_context.CURRENT_USER     := SYS_CONTEXT('USERENV','CURRENT_USER');	
  RETURN 0;
  EXCEPTION
	WHEN OTHERS THEN
  --DBMS_OUTPUT.PUT_LINE(SQLERRM);
		RETURN -1;
END zoefun_aud_get_session_context;