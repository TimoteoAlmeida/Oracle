-- Buscando consumidor de CPU
-- RAC
SELECT s.inst_id, s.sid, s.serial#, p.spid as “OS PID”,s.username, s.module, st.value/100 as “CPU sec”
FROM gv$sesstat st, gv$statname sn, gv$session s, gv$process p
WHERE sn.name = ‘CPU used by this session’ --  CPU
AND st.statistic# = sn.statistic#
AND st.sid = s.sid
AND s.paddr = p.addr
and s.inst_id = st.inst_id
and st.inst_id = p.inst_id
and s.inst_id = sn.inst_id
AND s.last_call_et < 1800 -- ativas nos últimos 30 minutos (em segundos)
AND s.logon_time > (SYSDATE – 240/1440) --  sessões logadas a mais de 4 horas
ORDER BY st.value desc;

-- Não RAC
SELECT s.sid, s.serial#, p.spid as “OS PID”,s.username, s.module, st.value/100 as “CPU sec”
FROM v$sesstat st, v$statname sn, v$session s, v$process p
WHERE sn.name = 'CPU used by this session' --CPU
AND st.statistic# = sn.statistic#
AND st.sid = s.sid
AND s.paddr = p.addr
AND s.last_call_et < 1800  --ativas nos últimos 30 minutos (em segundos)
AND s.logon_time > (SYSDATE – 240/1440) --sessões logadas a mais de 4 horas
ORDER BY st.value desc;
