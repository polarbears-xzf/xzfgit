CREATE OR REPLACE FUNCTION zoefun_aud_get_sql
RETURN VARCHAR2
AS
	ln_sql_n  NUMBER;
	lt_sql_text ora_name_list_t;
	lv_sql_text VARCHAR2(32767);
BEGIN
	ln_sql_n := ora_sql_txt(lt_sql_text);
	FOR i IN 1..ln_sql_n LOOP
		lv_sql_text := lv_sql_text||lt_sql_text(i);
	END LOOP;
  RETURN lv_sql_text;
	EXCEPTION
	WHEN OTHERS THEN
    --DBMS_OUTPUT.PUT_LINE(SQLERRM);
		RETURN 'ERR.zoefun_aud_get_sql';
END zoefun_aud_get_sql;
/