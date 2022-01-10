set lines 190

SELECT * FROM 
 (SELECT 
  sql_id, 
  child_number, 
  disk_reads, 
  executions,
  elapsed_time,
  first_load_time, 
  last_load_time 
 FROM    v$sql 
ORDER BY elapsed_time DESC) 
WHERE ROWNUM < 10;