--用于分割字符串
CREATE OR REPLACE TYPE ZOESYSMAN.zoetyp_utility_split_strings IS TABLE OF VARCHAR2 (4000);
/
--用于数据库对象
CREATE OR REPLACE TYPE ZOESYSMAN.zoetyp_db_object_list IS TABLE OF VARCHAR2(64);
/
