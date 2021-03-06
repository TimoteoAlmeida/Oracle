-- SELECT * FROM V$BACKUP_PIECE_DETAILS
-- SELECT * FROM v$rman_status
-- SELECT * FROM V$BACKUP_SET

select
 j.session_recid, j.session_stamp,
 to_char(j.start_time, 'yyyy-mm-dd hh24:mi:ss') start_time,
 to_char(j.end_time, 'yyyy-mm-dd hh24:mi:ss') end_time,
 (j.output_bytes/1024/1024) output_mbytes, j.status, j.input_type,
 decode(to_char(j.start_time, 'd'), 1, 'Sunday', 2, 'Monday',
                                    3, 'Tuesday', 4, 'Wednesday',
                                    5, 'Thursday', 6, 'Friday',
                                    7, 'Saturday') dow,
 j.elapsed_seconds, j.time_taken_display,
 x.cf, x.df, x.i0, x.i1, x.l,
 ro.inst_id output_instance
from V$RMAN_BACKUP_JOB_DETAILS j
 left outer join (select
                    d.session_recid, d.session_stamp,
                    sum(case when d.controlfile_included = 'YES' then d.pieces else 0 end) CF,
                    sum(case when d.controlfile_included = 'NO'
                              and d.backup_type||d.incremental_level = 'D' then d.pieces else 0 end) DF,
                    sum(case when d.backup_type||d.incremental_level = 'D0' then d.pieces else 0 end) I0,
                    sum(case when d.backup_type||d.incremental_level = 'I1' then d.pieces else 0 end) I1,
                    sum(case when d.backup_type = 'L' then d.pieces else 0 end) L
                  from
                    V$BACKUP_SET_DETAILS d
                    join V$BACKUP_SET s on s.set_stamp = d.set_stamp and s.set_count = d.set_count
                  where s.input_file_scan_only = 'NO'
                  group by d.session_recid, d.session_stamp) x
   on x.session_recid = j.session_recid and x.session_stamp = j.session_stamp
 left outer join (select o.session_recid, o.session_stamp, min(inst_id) inst_id
                  from GV$RMAN_OUTPUT o
                  group by o.session_recid, o.session_stamp)
   ro on ro.session_recid = j.session_recid and ro.session_stamp = j.session_stamp
where j.start_time > trunc(sysdate)-10
order by j.start_time ;
