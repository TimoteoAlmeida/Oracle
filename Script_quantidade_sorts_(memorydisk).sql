set lines 80

column "col1" format a70 

select 
 initcap(rpad(name,30,' ')||' = '||
 rpad(to_char(value,'999,999,999,990'),30,' ')) "col1"
from
 v$sysstat
where
 name in ('sorts (memory)','sorts (disk)');