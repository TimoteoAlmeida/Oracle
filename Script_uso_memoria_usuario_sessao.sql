break on username 
compute avg maximum minimum of mem_used_in_kb  on username

select
--   sid,
   username,
   round(total_user_mem/1024,2) mem_used_in_kb,
   round(100 * total_user_mem/total_mem,2) mem_percent
from
   (select
--      b.sid sid,
      nvl(b.username,p.name) username,
      sum(value) total_user_mem
   from
      sys.v_$statname c,
      sys.v_$sesstat a,
      sys.v_$session b,
      sys.v_$bgprocess p
   where
      a.statistic#=c.statistic# and
      p.paddr (+) = b.paddr and
      b.sid=a.sid and
      c.name in ('session pga memory','session uga memory')
   group by
      b.sid, nvl(b.username,p.name)),
   (select
      sum(value) total_mem
   from
      sys.v_$statname c,
      sys.v_$sesstat a
   where
      a.statistic#=c.statistic# and
      c.name in ('session pga memory','session uga memory'))
order by 1,2 desc;