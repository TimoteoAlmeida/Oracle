-- Valida Backup RMAN
-- Formatação...
SET PAGES 1000
SET LINES 210
COL STATUS FORMAT A30
COL HRS FORMAT 999.99

-- Backups Completos
SELECT
INPUT_TYPE, STATUS,
TO_CHAR(START_TIME,'DD/MM/YYYY HH24:MI') START_TIME,
TO_CHAR(END_TIME,'DD/MM/YYYY HH24:MI') END_TIME,
ELAPSED_SECONDS/3600 HRS
FROM V$RMAN_BACKUP_JOB_DETAILS
WHERE INPUT_TYPE='DB FULL'
ORDER BY SESSION_KEY;

-- Backups de Archived Redo Logs
SELECT
INPUT_TYPE, STATUS,
TO_CHAR(START_TIME,'DD/MM/YYYY HH24:MI') START_TIME,
TO_CHAR(END_TIME,'DD/MM/YYYY HH24:MI') END_TIME,
ELAPSED_SECONDS/3600 HRS
FROM V$RMAN_BACKUP_JOB_DETAILS
WHERE INPUT_TYPE='ARCHIVELOG'
ORDER BY SESSION_KEY;
