set pages 100
set lines 100

column "col1"  format a45      heading "Nome do Data File"  word_wrapped
column "col2"  format 999,999,990     heading "Blocos      |Fisicos     "
column "col3"  format 999,999,990     heading "Leituras    |Fisicas     "
column "col4"  format 999,999,990     heading "Gravacoes   |Fisicas     "
column "col5"  format 999,999,990     heading "Total       |de I/O      "

select 
 a.name         "col1" ,  
 b.phyblkrd              "col2" ,  
 b.phyrds               "col3" ,  
 b.phywrts        "col4" , 
 b.phyrds+b.phywrts       "col5"  
from
 v$datafile a,
 v$filestat b
where
 a.file#=b.file#
order by 3;