CREATE OR REPLACE FUNCTION ZOE_LONG_LIKE(iv_sql IN VARCHAR2, iv_like VARCHAR2) 
RETURN NUMBER 
AS
-- 北极熊创建于： 2019.03.15
-- 版权 2019 中国
-- 保留所有权利
--	文件名:
-- 		func_zoe_long_like
--	描述:
-- 		用于查询long字段时使用like匹配
--   对象关联:
--      对象关联
--	注意事项:
--		基本注意事项
--	修改 - （年-月-日） - 描述
--
---- 函数功能说明
-- ===================================================
--	参数：传入参数及说明：
	--iv_sql   传入long查询语句
	--iv_like  传入匹配字符
	--返回值：1 表示存在匹配字符串
--	用法示例：查询视图语法中带@的，以找出database link 使用
--	select owner,view_name,text from dba_views 
--	where owner like 'ZHIYDBA%' 
--	AND ZOE_LONG_LIKE('SELECT TEXT FROM DBA_VIEWS WHERE OWNER='''||OWNER||''' AND VIEW_NAME='''||VIEW_NAME||'''','@')=1;
ln_cursor_id    NUMBER := dbms_sql.open_cursor;
lv_text         VARCHAR2(32765 CHAR) := '';
lv_buffer       VARCHAR2(4000 CHAR);
ln_buffer_len   NUMBER;
ln_text_length  NUMBER;
ln_pos          NUMBER := 0;
BEGIN
  DBMS_SQL.PARSE(ln_cursor_id,iv_sql,DBMS_SQL.NATIVE);
  DBMS_SQL.DEFINE_COLUMN_LONG(ln_cursor_id,1);
  IF DBMS_SQL.EXECUTE_AND_FETCH(ln_cursor_id)>0 THEN
    LOOP
        DBMS_SQL.COLUMN_VALUE_LONG(ln_cursor_id,1,4000,ln_pos,lv_buffer,ln_buffer_len);
        ln_pos := ln_pos + 4000;
        lv_text := lv_text || lv_buffer;
        IF ln_buffer_len < 4000 THEN
            EXIT;
        END IF;
    END LOOP;
  END IF;
  DBMS_SQL.CLOSE_CURSOR(ln_cursor_id);
  IF instr(lv_text,iv_like) > 0 THEN
    RETURN 1;
  ELSE 
    RETURN 0;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_SQL.CLOSE_CURSOR(ln_cursor_id);
    RAISE;
END;
