-- SQL específico para o cálculo de mensalidades.

-- De acordo com o enunciado, "os sócios jovens são ainda caracterizados pelo número de aulas por semana (mínimo de 1 aula)". 
-- Sabendo que um mês terá no mínimo 4 semanas, isto equivale a um valor mínimo de 100€ para o sócio jovem, valor igual ao valor actual de referência.
-- Citando o enunciado: "A mensalidade dos Jovens é calculada com base nas aulas semanais que frequentam, tendo como máximo o valor de referência"
-- e "os Menores têm um desconto de 20% sobre o valor calculado.", a nossa interpretação é a de que os sócios jovens menores pagariam sempre o valor 
-- de 100€ ao qual seria deduzido 20%, ou seja, 80€. 
-- Um cenário semelhante aconteceria com o sócio jovem adulto, mas neste caso não seria aplicado qualquer desconto, ou seja, pagaria sempre 100€.

-- Abaixo indicamos o sql que consideramos apto a lidar com possíveis mudanças no preço das aulas e no valor de referência mensal.

-- Cálculo da mensalidade dos sócios Jovens - Menores e Adultos

select least((select 
					(select c.precoaula*(select count(a.idAula) 
										 from Aula a
										 inner join presencasaula p on a.idAula = p.idAula
										 where a.dataAula between '2022-01-01' and '2022-01-31' 
										 and (p.idMembro=4 and p.idTipoSocio= 2))
					 from clube c)
		      *(1-ts.desconto) from tiposocio ts where ts.idtiposocio=2), (select ts.valorRefMensal*(1-ts.desconto)
																		   from tiposocio ts
																		   where ts.idtiposocio=2)) as 'valor menor';

-- O cálculo da mensalidade dos sócios séniores é diferente dos demais tipos de sócios,uma vez que varia com as décadas de idade do sócio específico. 
-- Como tal, não poderemos determinar um valor fixo de desconto (no atributo tiposocio.desconto) que se aplique a todos os sócios séniores.
-- Optamos por preencher o respectivo atributo com a constante sobre a qual multiplicaremos as décadas de idade (0.1).

-- Cálculo do desconto de um sócio sénior

 select ts.valorRefMensal*(1-(select (select(select timestampdiff(year,m.dataNascimento,s.dataRegSocio)
		from socio s
		inner join membro m on s.idmembro = m.idmembro
		where (s.idmembro=14 and s.idtiposocio=3)) div 10 as decadas)
       *ts.desconto as "Desconto Sénior"
       from tiposocio ts
        where ts.idtiposocio=3)) as 'cálculo'
 from tiposocio ts 
 where ts.idTipoSocio = 3;
 
 
 -- Exemplo de inserção de registos de mensalidade de um sócio sénior para o mês de Janeiro de 2022
 
 insert into mensalidade (valorMensal,dataMensalidade,isPaga,idMembro,idTipoSocio) values ((select ts.valorRefMensal*(1-(select (select(select timestampdiff(year,m.dataNascimento,s.dataRegSocio)
																						  from socio s
																						  inner join membro m on s.idmembro = m.idmembro
																						  where (s.idmembro=14 and s.idtiposocio=3)) div 10 as decadas)
																						   *ts.desconto as "Desconto Sénior"
																				   from tiposocio ts
																				   where ts.idtiposocio=3)) 
										      from tiposocio ts
											  where ts.idTipoSocio = 3),'2022-01-31', true,14,3);
                                              
-- Exemplo de inserção de registos de mensalidade de um sócio Júnior Adulto para o mês de Março de 2022

insert into mensalidade (valorMensal,dataMensalidade,isPaga,idMembro,idTipoSocio) values ((select least((select (select c.precoaula*(select count(a.idAula) 
																											 from Aula a
																											 inner join presencasaula p on a.idAula = p.idAula
																											 where a.dataAula between '2022-03-01' and '2022-03-31' 
																											 and (p.idMembro=4 and p.idTipoSocio= 2))
																						 from clube c)*(1-ts.desconto) from tiposocio ts where ts.idtiposocio=2), 
                                                                                  (select ts.valorRefMensal*(1-ts.desconto)
																					from tiposocio ts
																					where ts.idtiposocio=2)) as 'valor menor'),'2022-03-31', false,4,2);

-- Exemplo de inserção de registos de mensalidade de um sócio Júnior Menor para o mês de Fevereiro de 2022

insert into mensalidade (valorMensal,dataMensalidade,isPaga,idMembro,idTipoSocio) values ((select least((select (select c.precoaula*(select count(a.idAula) 
																											 from Aula a
																											 inner join presencasaula p on a.idAula = p.idAula
																											 where a.dataAula between '2022-02-01' and '2022-02-28' 
																											 and (p.idMembro=11 and p.idTipoSocio= 1))
																						 from clube c)*(1-ts.desconto) from tiposocio ts where ts.idtiposocio=1), 
                                                                                  (select ts.valorRefMensal*(1-ts.desconto)
																					from tiposocio ts
																					where ts.idtiposocio=1)) as 'valor menor'),'2022-02-28', false,11,1);

-- Query de lista de encarregados de educação com o nome dos encarregados, sócios menores a seu cargo e os seus respectivos nomes.

select m1.nomemembro as 'Encarregado', m2.nomemembro as 'Sócio Menor'
from encarregadoeducacao enc
inner join membro m1 on enc.IdMembroEncEd = m1.idmembro
inner join membro m2 on enc.IdMembroSocio = m2.idmembro;

