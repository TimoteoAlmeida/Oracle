-- Jobs em execucao no RAC Oracle
-- Os campos retornados incluem:
--
-- ID da instância onde o job está em execução
-- Nome do job
-- ID da sessão
-- Instância onde o job está rodando
-- Tempo decorrido
-- CPU utilizada
-- Data/hora de início formatada
-- Número da sessão
-- PID do processo escravo
-- ID do processo no sistema operacional
-- Programa associado
SELECT 
    j.instance_id,
    j.job_name,
    j.session_id,
    j.running_instance,
    j.elapsed_time,
    j.cpu_used,
    TO_CHAR(j.start_date, 'DD-MON-YYYY HH24:MI:SS') as start_time,
    j.session_num,
    j.slave_pid,
    j.slave_os_process_id,
    p.program
FROM 
    gv$scheduler_running_jobs j
JOIN 
    gv$session s ON (j.session_id = s.sid AND j.instance_id = s.inst_id)
JOIN 
    gv$process p ON (s.paddr = p.addr AND s.inst_id = p.inst_id)
ORDER BY 
    j.start_date;
