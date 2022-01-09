-- Verificando Consumo de Memória  Oracle 10g
-- Quando executar a query, você verá todas as sessions de background e de usuários ao mesmo tempo,
-- ordenadas pela coluna MEM_PERCENT.
-- Caso apareça uma session de usuário, com um consumo exagerado de memória, é bom focar sua atenção para ela,
-- procurando saber quais processos ela vêm executando para consumir tanta memória,
-- procure entender seus cursores, pois possivelmente você encontrará jobs que abrem e não estão fechando cursores.
 
-- Solucao para uma instancia
select
   sid,
   username,
   round(total_user_mem/1024,2) mem_used_in_kb,
   round(100 * total_user_mem/total_mem,2) mem_percent
from
   (select
      b.sid sid,
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
order by
   3 desc;
 
-- Solucao para RAC Oracle
select
   sid,
   username,
   round(total_user_mem/1024,2) mem_used_in_kb,
   round(100 * total_user_mem/total_mem,2) mem_percent
from
   (select
      b.sid sid,
      nvl(b.username,p.name) username,
      sum(value) total_user_mem
   from
      gv$statname c,
      gv$sesstat a,
      gv$session b,
      gv$bgprocess p
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
      gv$statname c,
      gv$sesstat a
   where
      a.statistic#=c.statistic# and
      c.name in ('session pga memory','session uga memory'))
order by
   3 desc;
