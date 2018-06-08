-- Created in 2018.04.24 by polarbears
-- Copyright (c) 20xx, CHINA and/or affiliates.
-- All rights reserved.
-- Name
--   zoefun_encrypt_string - package to metadata synchronize
-- Description
--   使用Oracle 加密函数获取字符串校验和
-- Notes
--  创建用户需要DBA权限
--
--    修改 - （年-月-日） - 描述
--
CREATE OR REPLACE FUNCTION zoestd.zoefun_string_checksum(
    iv_string IN VARCHAR2)
  RETURN VARCHAR2
IS
  --获取24byte随机数
  --select dbms_crypto.randombytes(24) from dual;
  --lr_key_raw RAW(48)       := UTL_RAW.CAST_TO_RAW('49C8D43C8F0AEDFADC5C11BE57730B023541206DB9D41468');
  lr_string_raw RAW(32767) := UTL_RAW.CAST_TO_RAW(iv_string);
  lh_checksum_raw RAW(128);
  lh_checksum_string varchar2(128);
BEGIN
  --使用HASH算法
  lh_checksum_string := dbms_crypto.HASH(lr_string_raw,dbms_crypto.HASH_SH1);
  --使用加密算法
  --lh_checksum_string := dbms_crypto.encrypt(lr_string_raw,dbms_crypto.DES_CBC_PKCS5,lr_key_raw);
  RETURN lh_checksum_string;
END zoefun_string_checksum;
/