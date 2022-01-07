--Através da consulta abaixo podemos ter as 100 consultas que estão mais demoradas no banco de dados Oracle
--
select * from (select sql_text, elapsed_time/1000000 elapsed_sec, executions, disk_reads, buffer_gets from v$sqlarea
order by elapsed_time desc) where rownum <= 100;
