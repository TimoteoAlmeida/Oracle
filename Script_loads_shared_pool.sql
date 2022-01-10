set lines 190
col owner for a30
col object for a40

select  OWNER,
 NAME||' - '||TYPE object,
 LOADS
from  v$db_object_cache
where  LOADS > 3 
and  type in ('PACKAGE','PACKAGE BODY','FUNCTION','PROCEDURE')
order  by LOADS;