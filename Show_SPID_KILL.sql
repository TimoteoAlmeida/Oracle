-- https://oracle-base.com/articles/misc/killing-oracle-sessions

ALTER SYSTEM KILL SESSION 'sid,serial#';

ALTER SYSTEM KILL SESSION 'sid,serial#,@inst_id';

ALTER SYSTEM KILL SESSION 'sid,serial#' IMMEDIATE;

-- % ps -ef | grep ora
-- % kill -9 spid

-- Identify the Session to be Killed

SET LINESIZE 100
COLUMN spid FORMAT A10
COLUMN username FORMAT A10
COLUMN program FORMAT A45

SELECT s.inst_id,
       s.sid,
       s.serial#,
       --s.sql_id,
       p.spid,
       s.username,
       s.program
FROM   gv$session s
       JOIN gv$process p ON p.addr = s.paddr AND p.inst_id = s.inst_id
WHERE  s.type != 'BACKGROUND';

--   INST_ID        SID    SERIAL# SPID       USERNAME   PROGRAM
------------ ---------- ---------- ---------- ---------- ---------------------------------------------
--         1         30         15 3859       TEST       sqlplus@oel5-11gr2.localdomain (TNS V1-V3)
--         1         23        287 3834       SYS        sqlplus@oel5-11gr2.localdomain (TNS V1-V3)
--         1         40        387 4663                  oracle@oel5-11gr2.localdomain (J000)
--         1         38        125 4665                  oracle@oel5-11gr2.localdomain (J001)

--SQL>

