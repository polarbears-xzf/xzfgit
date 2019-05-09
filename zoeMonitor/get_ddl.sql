--移动数据文件
select b.con_id,b.name,A.FILE_NAME,
'alter database move datafile '''||A.FILE_NAME||''' to ''/data/database/zoecdb/'||lower(name)||'/'||substr(A.FILE_NAME,instr(A.FILE_NAME,'/',-1)+1)||''';'
from cdb_data_files a,v$pdbs b 
where file_name like '/oracle%'
and A.CON_ID=b.con_id;