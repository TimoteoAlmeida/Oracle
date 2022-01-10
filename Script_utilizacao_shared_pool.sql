set serveroutput on;  
  
declare
  object_mem     number;
  shared_sql     number;
  cursor_mem     number;
  mts_mem        number;
  used_pool_size number;
  free_mem       number;
  pool_size      varchar2(512); -- same as V$PARAMETER.VALUE  
begin

  select sum(sharable_mem) into object_mem from v$db_object_cache;

  select sum(250 * users_opening) into cursor_mem from v$sqlarea;

  select sum(value)
    into mts_mem
    from v$sesstat s, v$statname n
   where s.statistic# = n.statistic#
     and n.name = 'session uga memory max';

  select bytes
    into free_mem
    from v$sgastat
   where name = 'free memory'
     and pool = 'shared pool';

  used_pool_size := round(1.3 * (object_mem + cursor_mem));

  select value
    into pool_size
    from v$parameter
   where name = 'shared_pool_size';

  -- Display results  
  dbms_output.put_line('Object mem:    ' || to_char(object_mem) ||
                       ' bytes');
  dbms_output.put_line('Cursors:       ' || to_char(cursor_mem) ||
                       ' bytes');
  -- dbms_output.put_line ('MTS session:   '||to_char (mts_mem) || ' bytes');  
  dbms_output.put_line('Free memory:   ' || to_char(free_mem) || ' bytes ' || '(' ||
                       to_char(round(free_mem / 1024 / 1024, 2)) || 'MB)');
  dbms_output.put_line('Shared pool utilization (total):  ' ||
                       to_char(used_pool_size) || ' bytes ' || '(' ||
                       to_char(round(used_pool_size / 1024 / 1024, 2)) ||
                       'MB)');
  dbms_output.put_line('Shared pool allocation (actual):  ' || pool_size ||
                       ' bytes ' || '(' ||
                       to_char(round(pool_size / 1024 / 1024, 2)) || 'MB)');
  dbms_output.put_line('Percentage Utilized:  ' ||
                       to_char(round(used_pool_size / pool_size * 100)) || '%');
end;
/