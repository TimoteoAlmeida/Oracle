select a.tablespace_name, a.bt/1024/1024 mb_alocado,
a.bt/1024/1024-nvl(b.bt,0)/1024/1024 mb_usado,
nvl(b.bt,0)/1024/1024 mb_livre,
round((nvl(b.bt,0)/a.bt)*100,1) "livre%"
from
(
 select tablespace_name, sum(bytes) bt from dba _data_files
 group by tablespace_name ) a,
( select tablespace_name, sum(bytes) bt from dba _free_space
 group by tablespace_name ) b
where a.tablespace_name=b.tablespace_name(+)
--AND a.tablespace_name IN ('XYZ_TS_1','AUDIT_DATA')
order by round((nvl(b.bt,0)/a.bt)*100,1) asc ;
