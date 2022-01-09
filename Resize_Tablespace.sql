-- Lista todos os datafiles das tablesapces
select 
a.tablespace_name, 
b.file_name 
from dba_tablespaces a 
join dba_data_files b on (a.tablespace_name = b.tablespace_name) 
-- a.tablespace_name = 'coloque aqui o nome da tablespace'
order by a.tablespace_name;
 
-- Finalmente aumentando nossa tablespace
alter database datafile '/home/u01/app/oracle/oradata/databasename/tbls_1.dbf' resize 750m; 

-- Ou dicionando Datafile ao Tablespace 
alter tablespace fred
add datafile '/u01/oracle/oradata/booktst_users_02.dbf' size 150M 
autoextend off;

----------------------------------------------------------------
-- Resize em RAC

--  check DB_CREATE_FILE_DEST parameter. if it is set then you are using OMF (Oracle Managed Files) for datafiles
--  https://docs.oracle.com/cd/E11882_01/server.112/e25494/omf.htm#ADMIN11487
-- Parameters:
-- DB_CREATE_FILE_DEST             --> database creates data files or temp files when no file specification is given in the create operation
-- DB_CREATE_ONLINE_LOG_DEST_n     --> for redo log files and control file creation when no file specification is given in the create operation
-- DB_RECOVERY_FILE_DEST           --> Defines the location of the Fast Recovery Area


-- Vamos alterar o tamanaho de um datafile da System Tablespace
select file_name,bytes/1024/1024 mb from dba_data_files where tablespace_name = 'SYSTEM' order by file_name;

-- FILE_NAME                                        MB
-- +CWBAU/sritam01/datafile/system.260.932399649   30000

alter database datafile ‘+DBA/sritam01/datafile/system.260.932399649’ RESIZE 30001M;

select file_name,bytes/1024/1024 mb from dba_data_files where tablespace_name = ‘SYSTEM’ order by file_name;

-- FILE_NAME                                        MB
-- +DBA/sritam01/datafile/system.260.932399649     30001


----------------------------------------------------------------
-- resize Temp tablespace in asm rac
-----------

set pages 999
set lines 400
col FILE_NAME format a75
select d.TABLESPACE_NAME, d.FILE_NAME, d.BYTES/1024/1024 SIZE_MB, d.AUTOEXTENSIBLE, d.MAXBYTES/1024/1024 MAXSIZE_MB, d.INCREMENT_BY*(v.BLOCK_SIZE/1024)/1024 INCREMENT_BY_MB
from dba_temp_files d,
 v$tempfile v
where d.FILE_ID = v.FILE#
order by d.TABLESPACE_NAME, d.FILE_NAME;

--  TABLESPACE_NAME             FILE_NAME                                                                   SIZE_MB   AUT MAXSIZE_MB INCREMENT_BY_MB
------------------------------ --------------------------------------------------------------------------- ---------- --- ---------- ---------------
TEMP                            +DATAC1/VERS/TEMPFILE/temp.451.891367325                                    32767     YES 32767       1024

-- Add Temp Datafile to Temp Tablespace
-- To add a temp datafile to ‘TEMP‘ to be initially 10G, auto extendable by 1G to maxsize of 32Gb:
ALTER TABLESPACE TEMP ADD TEMPFILE '+DATAC1' SIZE 10G AUTOEXTEND ON NEXT 1G MAXSIZE 32767M;

-- is it ASM with OMF?
alter database add tempfile '+ASMDB';
-----------

-- Fazendo resize do datafile da TEMP 
select file_name, tablespace_name from dba_temp_files;

-- +ASMDB/gcprod/tempfile/temp.263.661355157 --->file_name,
-- TEMP --->tablespace_name

ALTER DATABASE TEMPFILE '+ASMDB/gcprod/tempfile/temp.263.661355157' RESIZE 1000M;

-----------
-- ou ainda
-----------

select file_name, tablespace_name,bytes/1024/1024 from dba_temp_files;

--FILE_NAME TABLESPACE BYTES/1024/1024
------------------------------------------------------------ ---------- ---------------
-- +/oracle/oradata/11g/demo92/temp04.dbf TEMP 100+

SQL> select file_id, file_name, tablespace_name, bytes/1024/1024 from dba_temp_files;

--FILE_ID    FILE_NAME                                 TABLESPACE         BYTES/1024/1024
-- +4        /oracle/oradata/11g/demo92/temp04.dbf     TEMP               100+

alter database tempfile 4 resize 200m;+

select file_id, file_name, tablespace_name, bytes/1024/1024 from dba_temp_files;

--FILE_ID     FILE_NAME                                TABLESPACE         BYTES/1024/1024
-- +4         /oracle/oradata/11g/demo92/temp04.dbf    TEMP               200+

----------------------------------------------------------------
