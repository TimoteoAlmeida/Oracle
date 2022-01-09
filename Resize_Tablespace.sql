-- Lista todos os datafiles das tablesapces
select 
a.tablespace_name, 
b.file_name 
from dba_tablespaces a 
join dba_data_files b on (a.tablespace_name = b.tablespace_name) 
-- a.tablespace_name = 'coloque aqui o nome da tablespace'
order by a.tablespace_name;
 
-- Finalmente aumentando nossa tablespace
alter database datafile ‘/home/u01/app/oracle/oradata/databasename/tbls_1.dbf’ resize 750m; 
