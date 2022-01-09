-- Tamanho da tabela
--
select sum(bytes/1024/1024) Mb
from dba _segments
where segment_name = 'NOME_DA_TABELA' ;
