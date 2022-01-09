col username format a15
col event format a20
col PID format 99999
col SID format 9999
col spid format 99999
select s.username, p.addr, s.sid, p.pid, p.spid, s.logon_time, s.status, w.event, w.seconds_in_wait
from v$session s, v$process p, v$session_wait w
where s.paddr=p.addr and s.status='KILLED' and
      s.sid=w.sid
;

Prompt Sessoes penduradas

SELECT spid, pid, username, program, 'kill -9 '||spid
FROM v$process
WHERE NOT EXISTS ( SELECT 1
FROM v$session
WHERE paddr = addr ) and pid <> 1
order by program
;

