SELECT SE.INST_ID IID
     ,DECODE(EVENT
            ,'jobq slave wait'
            ,'zIJQ'
            ,DECODE(SE.STATUS
                   ,'ACTIVE'
                   ,'ACT'
                   ,'INACTIVE'
                   ,'INA'
                   ,SE.STATUS)) STA
     ,REPLACE(TO_CHAR(FLOOR(LAST_CALL_ET / 3600)
                     ,'00') || ':' ||
              TO_CHAR(FLOOR(MOD(LAST_CALL_ET
                               ,3600) / 60)
                     ,'00') || ':' ||
              TO_CHAR(MOD(MOD(LAST_CALL_ET
                             ,3600)
                         ,60)
                     ,'00')
             ,' '
             ,NULL) L_S
     ,NVL(SE.USERNAME
         ,PR.PROGRAM) USERNAME
     ,OSUSER
     , 'alter system kill session '|| '''' || SE.SID || ',' || SE.SERIAL# || ',@' || SE.INST_ID|| '''' || ' immediate;' SID_SERIAL
     ,PR.SPID || ' (' || PR.PROGRAM || ')' SPID_PROGRAM
     ,HASH_VALUE SQL_HSH
     ,SQ.SQL_ID
     -- ,SQ.CHILD_NUMBER CN
     ,EXECUTIONS SQL_EXE
     ,ROUND(((ELAPSED_TIME + CPU_TIME) /
      DECODE(EXECUTIONS
             ,0
             ,1
             ,EXECUTIONS) / 1000000),5) SQL_ELA
     ,SQL_PROFILE
     ,SQL_PLAN_BASELINE
     ,PLAN_HASH_VALUE
     ,SQL_TEXT
     ,SE.PREV_SQL_ID
     ,(SELECT MAX('(' || LON.OPNAME || ') (' || LON.SOFAR || '->' ||
                  LON.TOTALWORK || ') : ' || LON.TARGET)
         FROM V$SESSION_LONGOPS LON
        WHERE LON.SID = SE.SID
              AND LON.SQL_HASH_VALUE = SE.SQL_HASH_VALUE
              AND SOFAR < TOTALWORK) LO
     ,' (#W : ' || RPAD(SEQ#
                       ,5) || ' | ST : ' ||
      DECODE(WAIT_TIME
            ,0
            ,'WAIT'
            ,-1
            ,'FAST'
            ,-2
            ,'UNKN'
            ,WAIT_TIME) || ') ' || EVENT W
     ,SE.BLOCKING_SESSION
     ,SE.SECONDS_IN_WAIT
     ,SE.TERMINAL
     ,SE.OSUSER
     ,SE.MACHINE
     ,SE.LOGON_TIME
     ,SE.PROGRAM
     ,SE.FAILED_OVER
     ,SE.SERVER
     ,SE.SERVICE_NAME
     ,(SELECT SQL_FULLTEXT
         FROM V$SQLAREA
        WHERE SQL_ID = SE.SQL_ID) SQL_FULLTEXT
/*
     ,(SELECT OWNER || '.' || OBJECT_NAME || '(' || OBJECT_TYPE || ') - ' ||
              SQ.PROGRAM_ID || '(' || SQ.PROGRAM_LINE# || ')'
         FROM DBA_OBJECTS OB
             ,V$SQL      SQ
        WHERE HASH_VALUE = SE.SQL_HASH_VALUE
          AND INST_ID = SE.INST_ID
          AND CHILD_NUMBER = SE.SQL_CHILD_NUMBER
          AND OB.OBJECT_ID = SQ.PROGRAM_ID) PRG_O
*/
 FROM GV$SESSION SE
     ,GV$PROCESS PR
     ,GV$SQLAREA     SQ
WHERE SE.INST_ID = PR.INST_ID
      AND SE.INST_ID = SQ.INST_ID (+)
      AND SE.PADDR = PR.ADDR(+)
      AND SE.SQL_ID = SQ.SQL_ID(+)
      AND SE.TYPE = 'USER'
--       AND SE.USERNAME NOT IN ('SYS', 'DBSNMP')
--       AND SE.USERNAME NOT IN ('QIOR_SOAINFRA')
-- AND SE.STATUS IN ('ACTIVE', 'KILLED', 'PSEUDO')
-- AND SE.SID NOT IN (SELECT SID
--                        FROM V$MYSTAT)
-- AND SE.USERNAME IN ('CSGAUSER')
-- AND SE.MACHINE LIKE '%uretanos%'
-- AND SID = 201
ORDER BY STA
        ,L_S
        ,SE.USERNAME
        ,SID_SERIAL ;
