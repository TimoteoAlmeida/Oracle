--Mostra quem esta bloqueando quem
select a.username ||'@'||a.machine || ' session id = ' ||a.sid || ' esta bloqueando '
|| b.username ||'@'||b.machine || 'session id = '||b.sid
from gv$lock c,
gv$session a,
gv$lock d,
gv$session b
where a.sid=c.sid
and b.sid=d.sid
and c.block=1
and d.request > 0
and c.id1 = d.id1
and d.id2 = d.id2 ;
