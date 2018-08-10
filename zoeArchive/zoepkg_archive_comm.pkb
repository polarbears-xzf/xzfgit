CREATE OR REPLACE PACKAGE BODY zoearchive.zoepkg_archive_comm AS
  e_parm_notvalid EXCEPTION;
  e_process_error EXCEPTION;
  --定义数组
-- ===================================================
-- 组合校验对象数据
-- ===================================================
    --in_owner       传入参数-字符型，表所有者
		--in_table_name  传入参数-字符型，表名
		--in_system_code 传入参数-字符型，业务系统代码
		--in_data_type   传入参数-字符型，数据类型代码
    --返回值：
      /* 
      {returnValue: [
        {
          "data": "组合后的字符串",
        },
      */
  FUNCTION combo_verify_object_data(in_owner in varchar2,in_table_name in varchar2,in_system_code in varchar2,in_data_type in varchar2)
    RETURN VARCHAR2
    AS
      lv_string varchar2(260);
    BEGIN
      lv_string := in_owner || ':' ||in_table_name || ':' ||in_system_code || ':' ||in_data_type;
      RETURN lv_string;
    END;
    
  
  
 -- ===================================================
-- 生成校验码
-- ===================================================
    --iv_proof_strings：传入参数-字符型，待校验字符串
    --ov_proof_code：   传出参数-字符型，校验码
    -- 返回值：
      /* 
      {returnValue: [
        {
          "code": "-1",
          "message": "失败"
        },
        {
          "code": "1",
          "message": "成功"
        }
        ]
      }
      */
FUNCTION generate_proof_code(
    iv_proof_strings IN VARCHAR2,
    ov_proof_code OUT nocopy VARCHAR2)
  RETURN NUMBER
AS
  lv_key     VARCHAR2(24);
  lv_proof_strings VARCHAR2(200);
BEGIN
  lv_key     := 'jhwfjewigib0g24i2r42foin';
  lv_proof_strings := iv_proof_strings||lv_key;
  ov_proof_code := dbms_crypto.HASH(SYS.UTL_I18N.STRING_TO_RAW(lv_proof_strings, 'AL32UTF8'),dbms_crypto.HASH_SH1);
  RETURN 0;
END generate_proof_code;  

-- ===================================================
-- 检查校验码合法性
-- ===================================================
    --iv_proof_strings：传入参数-字符型，待校验字符串
    --iv_proof_code：   传入参数-字符型，校验码
    --返回值：
      /* 
      {returnValue: [
        {
          "code": "-1",
          "message": "失败"
        },
        {
          "code": "1",
          "message": "成功"
        }
        ]
      }
      */
FUNCTION verify_proof_code(
    iv_proof_strings VARCHAR2,
    iv_proof_code    VARCHAR2)
  RETURN NUMBER
AS
  lv_key           VARCHAR2(24);
  lv_proof_strings VARCHAR2(120);
  lv_proof_code    VARCHAR2(40);
BEGIN
  lv_key           := 'jhwfjewigib0g24i2r42foin';
  lv_proof_strings := iv_proof_strings||lv_key;
  lv_proof_code    := sys.dbms_crypto.HASH(SYS.UTL_I18N.STRING_TO_RAW(lv_proof_strings, 'AL32UTF8'),dbms_crypto.HASH_SH1);
  IF lv_proof_code=iv_proof_code THEN
    RETURN 0;
  END IF;
  RETURN -1;
EXCEPTION
WHEN OTHERS THEN
  RAISE;
END verify_proof_code;

-- ===================================================
-- 添加归档表
-- ===================================================
  FUNCTION add_archive_table(in_owner in varchar2,in_table_name in varchar2,in_system_code in varchar2,in_data_type in varchar2)
    RETURN VARCHAR2
  AS
    lv_proof_strings VARCHAR2(260) ;
    lv_proof_code    VARCHAR2(64)  ;
    ln_return        NUMBER;
  BEGIN
    lv_proof_strings  := '';
    lv_proof_code     := '';
    lv_proof_strings :=  combo_verify_object_data(in_owner,in_table_name,in_system_code,in_data_type);
    ln_return := generate_proof_code(lv_proof_strings,lv_proof_code);
    INSERT INTO ZOEARCHIVE.ARC_OBJECT_INFO 
      (OWNER,TABLE_NAME,APPLICATION_SYSTEM_CODE,DATA_TYPE_CODE,PROOF_CODE) 
      VALUES 
      (in_owner,in_table_name,in_system_code,in_data_type,lv_proof_code) ;
    COMMIT;
    return ln_return;
    EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
      RETURN SQLERRM;
      
  END add_archive_table;


  
FUNCTION archive_date_limit(
    id_archive_date DATE )
  RETURN NUMBER
AS
  ld_sysdate DATE;
BEGIN
  ld_sysdate        := TRUNC(add_months(sysdate,-12),'yyyy');
  IF id_archive_date > ld_sysdate THEN
    RETURN -1;
  END IF;
  RETURN 0;
END archive_date_limit;

END zoepkg_archive_comm;
/

