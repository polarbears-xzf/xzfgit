OPTIONS (skip=1,rows=32)
LOAD DATA
INFILE 'c:\zoedir\data\table_name.csv'
APPEND
INTO TABLE table_owner.table_name
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(column_name01,column_name02,column_name03,column_name04 char(20000))
