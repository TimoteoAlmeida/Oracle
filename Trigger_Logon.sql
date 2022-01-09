CREATE OR REPLACE TRIGGER logon_trace_edwhxx
AFTER LOGON ON edwhxx.SCHEMA
DECLARE
      v_sysdate date;
 
BEGIN
 
            select sysdate into v_sysdate from dual;
 
            IF (TO_NUMBER(TO_CHAR(v_sysdate,'HH24MI')) NOT BETWEEN 1900 AND 2400) THEN
 
                   Raise_application_error(-20999,'Acesso não autorizado! Periodo de acesso: entre as 19:00 e as 00:00.');
                   EXECUTE IMMEDIATE 'DISCONNECT';
 
     END IF;
 
END;
/
