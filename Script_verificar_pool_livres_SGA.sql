col mb_free for 999,999,999.999

select initcap(pool) pool, bytes / 1024 / 1024 mb_free
  from v$sgastat
 where name = 'free memory';