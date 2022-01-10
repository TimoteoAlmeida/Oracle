column c1     heading 'Target(M)'
column c2     heading 'Estimated|Extra rw'
column c3     heading 'Estimated|Cache Hit %'
column c4     heading 'Estimated|Over-Alloc.'

 
SELECT
   ROUND(pga_target_for_estimate /(1024*1024)) c1,
   ROUND(estd_extra_bytes_rw/(1024*1024))      c2,
   estd_pga_cache_hit_percentage         c3,
   estd_overalloc_count                  c4
FROM
   v$pga_target_advice;