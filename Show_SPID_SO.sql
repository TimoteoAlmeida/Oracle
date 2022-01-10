-- OS_PROCESS_ID é o PID do unix:
Select SID,SERIAL# 
from v$session where paddr in (select addr from v$process where spid='OS_PROCESS_ID');

-- Com esses valores, você consegue matar
alter system kill session '<SID>,<SERIAL#>';

-- Agora, pode matar no SO usando
kill -9 <pid>
Mas você não deve matar o processo no SO sem antes matar no Oracle
