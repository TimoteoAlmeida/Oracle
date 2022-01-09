-- Mostra todas as constraints de uma tabela
select * from
       all_constraints where
            r_constraint_name in
                 (select  constraint_name from all_constraints
                  where table_name= 'nome_da_sua_tabela');  
