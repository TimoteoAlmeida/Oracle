--export ORACLE_HOME=/u01/11.2.0/grid
--export ORACLE_SID= ASM1
--cd /u01/11.2.0/grid/bin

asmcmd
ASMCMD> ls
 
sqlplus / as sysasm
show parameter instance_name;
SELECT * FROM GV$INSTANCE;

-- Verificar quais discos estão desmontados
SELECT INST_ID, NAME, STATE FROM gv$asm_diskgroup;


-- Para montar o disco. Pode ser necessário fazer nas duas instâncias
ALTER DISKGROUP DGCLUSTER MOUNT;
