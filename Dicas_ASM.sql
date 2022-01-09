--ASM

--espaço livre
select GROUP_NUMBER,NAME,TOTAL_MB,FREE_MB from V$ASM_DISKGROUP;

--ver espaço livre nos discos    
select disk_number "Disk #", free_mb
from v$asm_disk
where group_number = 1
order by 2;

--ver discos candidatos
set lines 500
col path for a40
select HEADER_STATUS,MODE_STATUS,NAME,PATH from v$asm_disk where HEADER_STATUS='CANDIDATE';

--ver o balanceamento dos discos
set lines 132 pages 1000 trimspool on
column path format a30
select NAME, PATH, TOTAL_MB, FREE_MB, TOTAL_MB-FREE_MB as UTIL_MB,
round(((TOTAL_MB-FREE_MB)/TOTAL_MB)*100,2) PCTUTIL
from v$asm_disk order by name;

--- Adicionar novos discos
alter diskgroup DATA add disk
'/dev/rdisk/oradata1' rebalance power 5;

alter diskgroup DATA01 add disk
'/dev/rdisk/oradata2',
'/dev/rdisk/oradata3'
 rebalance power 5;

--estimativa de termino do rebalance
set lines 132 pages 1000 trimspool on
column path format a30
select vao.group_number, vadg.name, vao.operation, vao.state, vao.est_work,
vao.est_rate, vao.est_minutes, vao.power, vao.actual actual_power
from v$asm_operation vao, v$asm_diskgroup vadg
where vao.group_number = vadg.group_number;

--ver os discos do asm
set lines 300
col disco for a60
SELECT dg.name AS diskgroup, SUBSTR(d.name,1,16) AS asmdisk, d.path as disco
     FROM V$ASM_DISKGROUP dg, V$ASM_DISK d
     WHERE dg.group_number = d.group_number;
    
--ver compatibilidade
SELECT dg.name AS diskgroup, SUBSTR(d.name,1,16) AS asmdisk,
     SUBSTR(dg.compatibility,1,12) AS asm_compat,
     SUBSTR(dg.database_compatibility,1,12) AS db_compat
     FROM V$ASM_DISKGROUP dg, V$ASM_DISK d
     WHERE dg.group_number = d.group_number;
    
