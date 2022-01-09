-- Processo para validar o standby database
-- Verificar se está funcionando:
-- Abrir o arquivo do alert nos servidores ( ver no favoritos o diretório TRACE) nos dois servidores.
--
-- Fazer um alter system switch logfile no servidor primário e observar se o arquivo do archive foi transferido para o secundário.
alter system switch logfile ;
--
-- E executar a query para garantir o processo.
select thread#,dest_id,sequence#,first_time,next_time from v$archived_log where resetlogs_change# = (select resetlogs_change# from v$database) order by thread#, sequence#, dest_id;
--
--
-- Verificar se foi aplicado os arhives no banco
select dest_id, sequence#, applied from v$archive_log
where desct_id =2
and sequence# > ( select max(sequence#) - 10 from v$archived_log )
order by sequence# ;
--
--
-- Verificar o status dos Bancos, Primário e Secundario
select name, db_unique_name, database_role,switchover_status from gv$database;
--
-- 
-- switchover_status deve ficar assim:
-- A resposta para o primario é  : TO STANDBY  ou ACTIVE SESSION
-- A resposta para o secundario é: NOT ALLOWED
