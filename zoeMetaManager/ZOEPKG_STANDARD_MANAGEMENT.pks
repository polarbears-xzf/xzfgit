CREATE OR REPLACE PACKAGE ZOEMETA.ZOEPKG_STANDARD_MANAGEMENT AS 

  -- 从数据库中获取HIS5.0表与列对象，并将对象命名拆解成单个单词
  -- 将拆解结果输出到中间表ZOEMETA.
  -- 输出内容：标准单词、标准用语、用语注释、用语类型、对象所有者、对象名、对象注释
  PROCEDURE get_word_resolve_string_db; 
 
  --从表元数据管理信息中获取建表语句
  PROCEDURE get_create_table_sql;
  
  --临时功能
    --解析程序员助手中的字段中文中的内容，生成关联字典与中文注释
    --数据结构：SYSTEM.PBCATCOL.PBC_LABL to PBC_RELATION_DICT PBC_CMNT
    --解析规则：字段中文内容规则：字段说明#|关联字典#|中文注释；
    ----解析规则：将第一个#|之后的解析到关联字典，将第二个#|之后的解析到中文注释
    PROCEDURE update_pbcatcol_relation_cmnt; 
    --依据关联字典与中文注释，生成程序员助手中的字段中文中的内容
    --数据结构：SYSTEM.PBCATCOL.PBC_RELATION_DICT PBC_CMNT  to PBC_LABL
    --生成规则：字段中文内容规则：字段说明#|关联字典#|中文注释；
    ----生成规则：如果第一个#|之后为空，并且关联字典为不空，更新关联字典到第一个#|之后。
    ----生成规则：如果第二个#|之后为空，并且中文注释为不空，更新中文注释到第二个#|之后。
    PROCEDURE update_pbcatcol_labl;

END ZOEPKG_STANDARD_MANAGEMENT;