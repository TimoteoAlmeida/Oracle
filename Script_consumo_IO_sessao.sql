set lines 190
col name for a30
col module for a20
col program for a30
col username for a20

select a.sid, b.name, a.value, c.module, c.program, c.username
   from v$sesstat a, v$statname b, v$session c
  where a.STATISTIC# = b.STATISTIC#
    and b.STAT_ID in (1190468109, 2263124246)
    and a.sid = c.sid
    and type <> 'BACKGROUND'
  order by a.value;