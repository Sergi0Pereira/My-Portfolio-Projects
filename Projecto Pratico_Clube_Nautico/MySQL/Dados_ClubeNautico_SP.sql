-- Dados para inserção na base de dados.
-- 

use ClubeNautico_SP_JM;

insert into clube (nomeClube, nifClube, capitalSocial) values ('Clube Náutico SP & JM', 542555555,10000000);

insert into tiposocio (idadeMinima, desconto, precisaEncEd, valorRefMensal, designacaoTipo, idClube) values
(1, 0.2,TRUE, 100, 'SMenor', 1),
(18, 0, FALSE, 100, 'SAdulto',1),
(60, 0.1, FALSE, 150, 'SSenior',1);

insert into membro (nomeMembro, nifMembro, dataNascimento, isDirigente) values 
('Alberto Antunes', 241451515,'1957-10-11', false), -- sénior & sócio & enc.ed do membro 3 quando era menor
('Bruno Bernardes', 261561256, '1972-04-24', true), -- adulto & dirigente & enc.ed. do membro 16
('Carlos Carvalho', 245125125,'1981-07-21', true), -- adulto & sócio & dirigente & ex-sócio menor
('Diana Dias', 202456125,'1991-03-15', true), -- adulto & sócio & dirigente
('Eduarda Eustáquio', 278631221,'2010-04-12', false), -- menor & sócio
('Filipe Fernandes', 198234512,'1942-01-01', false), -- sénior & sócio
('Gustavo Gandra', 124141255,'1989-09-15', true), -- adulto & enc.ed. do membro 5 
('Helena Hammond', 215341343,'1974-06-21', false), -- adulto & enc.ed. do membro 11 e 12
('Igor Isidro', 213416212, '1956-04-12', false), -- sénior & sócio
('Jorge Jordão', 141521451, '1982-11-03', false), -- adulto & sócio & enc.ed. do membro 15
('Kelly Korben', 289123412, '2010-05-24', false), -- menor & sócio
('Laura Lopes', 263124512, '2008-03-12', false), -- menor & sócio
('Mário Montiel', 131451456,'1961-02-01', false), -- sénior & sócio
('Nádia Nespereira', 101231455, '1960-04-06',false), -- sénior & sócio
('Otávio Osborne', 264124671, '2014-07-11', false), -- menor & sócio
('Paulo Pereira',271312412, '2016-03-30', false); -- menor & sócio

-- Registos de sócios. 

-- Sócio 1
insert into socio (dataRegSocio, isActivo, idMembro, idTipoSocio) values 
(19900810, false, 3, (select (select max(ts.idTipoSocio) from tiposocio ts where timestampdiff(year, m.dataNascimento,19900810) > ts.idadeMinima) as tipo
						from membro m 
						where m.idmembro=3));

-- Para a criação do atributo "identificador", optamos por fazer uma concatenação entre dois atributos: a designação do tipo do sócio,calculada pela diferença entre a data de nascimento e a data de registo,
-- e a contagem do número de tipos de sócios com a mesma designação. O parâmetro "and s.identificador is null" foi incluído na query para garantir que não são geradas inconformidades na contagem
-- quando um membro se reinscrever como sócio de outro tipo (p.ex: Adulto para Sénior).

update socio s set s.identificador = (select concat((select ts.designacaoTipo from tiposocio ts where ts.idTiposocio = s.idTipoSocio)
													,(select count(s2.idTipoSocio) from socio s2 where s2.idTipoSocio = s.idTipoSocio)) 
													as T_Id) where s.idmembro=3 and s.identificador is null;
                                                    
-- Após o registo do sócio, o mesmo é introduzido na tabela correspondente aos Membros que são sócios.

insert into membrosocio (idMembro, idTipoSocio) values (3,(select max((select max(ts.idTipoSocio) 
																   from tiposocio ts 
																   where timestampdiff(year, m.dataNascimento, s.dataRegSocio) > ts.idadeMinima)) as tipo
														   from membro m 
														   inner join socio s on m.idmembro = s.idmembro
															where m.idmembro=3));

-- Sócio 2
insert into socio (dataRegSocio, isActivo, idMembro, idTipoSocio) values 
(20181019, true, 4, (select (select max(ts.idTipoSocio) from tiposocio ts where timestampdiff(year, m.dataNascimento,20181019) > ts.idadeMinima) as tipo
						from membro m 
						where m.idmembro=4));
update socio s set s.identificador = (select concat((select ts.designacaoTipo from tiposocio ts where ts.idTiposocio = s.idTipoSocio)
													,(select count(s2.idTipoSocio) from socio s2 where s2.idTipoSocio = s.idTipoSocio)) 
													as T_Id) where s.idmembro=4 and s.identificador is null;

insert into membrosocio (idMembro, idTipoSocio) values (4,(select max((select max(ts.idTipoSocio) 
																   from tiposocio ts 
																   where timestampdiff(year, m.dataNascimento, s.dataRegSocio) > ts.idadeMinima)) as tipo
														   from membro m 
														   inner join socio s on m.idmembro = s.idmembro
															where m.idmembro=4));
                                                    
-- Sócio 3
insert into socio (dataRegSocio, isActivo, idMembro, idTipoSocio) values 
(20181110, true, 1, (select (select max(ts.idTipoSocio) from tiposocio ts where timestampdiff(year, m.dataNascimento,20181110) > ts.idadeMinima) as tipo
						from membro m 
						where m.idmembro=1));
update socio s set s.identificador = (select concat((select ts.designacaoTipo from tiposocio ts where ts.idTiposocio = s.idTipoSocio)
													,(select count(s2.idTipoSocio) from socio s2 where s2.idTipoSocio = s.idTipoSocio)) 
													as T_Id) where s.idmembro=1 and s.identificador is null;

insert into membrosocio (idMembro, idTipoSocio) values (1,(select max((select max(ts.idTipoSocio) 
																   from tiposocio ts 
																   where timestampdiff(year, m.dataNascimento, s.dataRegSocio) > ts.idadeMinima)) as tipo
														   from membro m 
														   inner join socio s on m.idmembro = s.idmembro
															where m.idmembro=1));

-- Sócio 4
insert into socio (dataRegSocio, isActivo, idMembro, idTipoSocio) values 
(20191209, true, 3, (select (select max(ts.idTipoSocio) from tiposocio ts where timestampdiff(year, m.dataNascimento,20191209) > ts.idadeMinima) as tipo
						from membro m 
						where m.idmembro=3));
update socio s set s.identificador = (select concat((select ts.designacaoTipo from tiposocio ts where ts.idTiposocio = s.idTipoSocio)
													,(select count(s2.idTipoSocio) from socio s2 where s2.idTipoSocio = s.idTipoSocio)) 
													as T_Id) where s.idmembro=3 and s.identificador is null;

insert into membrosocio (idMembro, idTipoSocio) values (3,(select max((select max(ts.idTipoSocio) 
																   from tiposocio ts 
																   where timestampdiff(year, m.dataNascimento, s.dataRegSocio) > ts.idadeMinima)) as tipo
														   from membro m 
														   inner join socio s on m.idmembro = s.idmembro
															where m.idmembro=3));

-- Sócio 5
insert into socio (dataRegSocio, isActivo, idMembro, idTipoSocio) values 
(20200811, true, 5, (select (select max(ts.idTipoSocio) from tiposocio ts where timestampdiff(year, m.dataNascimento,20200811) > ts.idadeMinima) as tipo
						from membro m 
						where m.idmembro=5));
update socio s set s.identificador = (select concat((select ts.designacaoTipo from tiposocio ts where ts.idTiposocio = s.idTipoSocio)
													,(select count(s2.idTipoSocio) from socio s2 where s2.idTipoSocio = s.idTipoSocio)) 
													as T_Id) where s.idmembro=5 and s.identificador is null;

insert into membrosocio (idMembro, idTipoSocio) values (5,(select max((select max(ts.idTipoSocio) 
																   from tiposocio ts 
																   where timestampdiff(year, m.dataNascimento, s.dataRegSocio) > ts.idadeMinima)) as tipo
														   from membro m 
														   inner join socio s on m.idmembro = s.idmembro
															where m.idmembro=5));

-- Sócio 6
insert into socio (dataRegSocio, isActivo, idMembro, idTipoSocio) values 
(20210109, true, 6, (select (select max(ts.idTipoSocio) from tiposocio ts where timestampdiff(year, m.dataNascimento,20210109) > ts.idadeMinima) as tipo
						from membro m 
						where m.idmembro=6));
update socio s set s.identificador = (select concat((select ts.designacaoTipo from tiposocio ts where ts.idTiposocio = s.idTipoSocio)
													,(select count(s2.idTipoSocio) from socio s2 where s2.idTipoSocio = s.idTipoSocio)) 
													as T_Id) where s.idmembro=6 and s.identificador is null;

insert into membrosocio (idMembro, idTipoSocio) values (6,(select max((select max(ts.idTipoSocio) 
																   from tiposocio ts 
																   where timestampdiff(year, m.dataNascimento, s.dataRegSocio) > ts.idadeMinima)) as tipo
														   from membro m 
														   inner join socio s on m.idmembro = s.idmembro
															where m.idmembro=6));

-- Sócio 7
insert into socio (dataRegSocio, isActivo, idMembro, idTipoSocio) values 
(20210312, true, 9, (select (select max(ts.idTipoSocio) from tiposocio ts where timestampdiff(year, m.dataNascimento,20210312) > ts.idadeMinima) as tipo
						from membro m 
						where m.idmembro=9));
update socio s set s.identificador = (select concat((select ts.designacaoTipo from tiposocio ts where ts.idTiposocio = s.idTipoSocio)
													,(select count(s2.idTipoSocio) from socio s2 where s2.idTipoSocio = s.idTipoSocio)) 
													as T_Id) where s.idmembro=9 and s.identificador is null;

insert into membrosocio (idMembro, idTipoSocio) values (9,(select max((select max(ts.idTipoSocio) 
																   from tiposocio ts 
																   where timestampdiff(year, m.dataNascimento, s.dataRegSocio) > ts.idadeMinima)) as tipo
														   from membro m 
														   inner join socio s on m.idmembro = s.idmembro
															where m.idmembro=9));                                                    
                                                    
-- Sócio 8
insert into socio (dataRegSocio, isActivo, idMembro, idTipoSocio) values 
(20210318, true, 10, (select (select max(ts.idTipoSocio) from tiposocio ts where timestampdiff(year, m.dataNascimento,20210318) > ts.idadeMinima) as tipo
						from membro m 
						where m.idmembro=10));
update socio s set s.identificador = (select concat((select ts.designacaoTipo from tiposocio ts where ts.idTiposocio = s.idTipoSocio)
													,(select count(s2.idTipoSocio) from socio s2 where s2.idTipoSocio = s.idTipoSocio)) 
													as T_Id) where s.idmembro=10 and s.identificador is null;

insert into membrosocio (idMembro, idTipoSocio) values (10,(select max((select max(ts.idTipoSocio) 
																   from tiposocio ts 
																   where timestampdiff(year, m.dataNascimento, s.dataRegSocio) > ts.idadeMinima)) as tipo
														   from membro m 
														   inner join socio s on m.idmembro = s.idmembro
															where m.idmembro=10));

-- Sócio 9
insert into socio (dataRegSocio, isActivo, idMembro, idTipoSocio) values 
(20210318, true, 11, (select (select max(ts.idTipoSocio) from tiposocio ts where timestampdiff(year, m.dataNascimento,20210318) > ts.idadeMinima) as tipo
						from membro m 
						where m.idmembro=11));
update socio s set s.identificador = (select concat((select ts.designacaoTipo from tiposocio ts where ts.idTiposocio = s.idTipoSocio)
													,(select count(s2.idTipoSocio) from socio s2 where s2.idTipoSocio = s.idTipoSocio)) 
													as T_Id) where s.idmembro=11 and s.identificador is null;

insert into membrosocio (idMembro, idTipoSocio) values (11,(select max((select max(ts.idTipoSocio) 
																   from tiposocio ts 
																   where timestampdiff(year, m.dataNascimento, s.dataRegSocio) > ts.idadeMinima)) as tipo
														   from membro m 
														   inner join socio s on m.idmembro = s.idmembro
															where m.idmembro=11));

-- Sócio 10
insert into socio (dataRegSocio, isActivo, idMembro, idTipoSocio) values 
(20210318, true, 15, (select (select max(ts.idTipoSocio) from tiposocio ts where timestampdiff(year, m.dataNascimento,20210318) > ts.idadeMinima) as tipo
						from membro m 
						where m.idmembro=15));
update socio s set s.identificador = (select concat((select ts.designacaoTipo from tiposocio ts where ts.idTiposocio = s.idTipoSocio)
													,(select count(s2.idTipoSocio) from socio s2 where s2.idTipoSocio = s.idTipoSocio)) 
													as T_Id) where s.idmembro=15 and s.identificador is null;
 
 insert into membrosocio (idMembro, idTipoSocio) values (15,(select max((select max(ts.idTipoSocio) 
																   from tiposocio ts 
																   where timestampdiff(year, m.dataNascimento, s.dataRegSocio) > ts.idadeMinima)) as tipo
														   from membro m 
														   inner join socio s on m.idmembro = s.idmembro
															where m.idmembro=15));
 
-- Sócio 11
insert into socio (dataRegSocio, isActivo, idMembro, idTipoSocio) values 
(20210412, true, 12, (select (select max(ts.idTipoSocio) from tiposocio ts where timestampdiff(year, m.dataNascimento,20210412) > ts.idadeMinima) as tipo
						from membro m 
						where m.idmembro=12));
update socio s set s.identificador = (select concat((select ts.designacaoTipo from tiposocio ts where ts.idTiposocio = s.idTipoSocio)
													,(select count(s2.idTipoSocio) from socio s2 where s2.idTipoSocio = s.idTipoSocio)) 
													as T_Id) where s.idmembro=12 and s.identificador is null;

insert into membrosocio (idMembro, idTipoSocio) values (12,(select max((select max(ts.idTipoSocio) 
																   from tiposocio ts 
																   where timestampdiff(year, m.dataNascimento, s.dataRegSocio) > ts.idadeMinima)) as tipo
														   from membro m 
														   inner join socio s on m.idmembro = s.idmembro
															where m.idmembro=12));

-- Sócio 12
insert into socio (dataRegSocio, isActivo, idMembro, idTipoSocio) values 
(20210430, true, 16, (select (select max(ts.idTipoSocio) from tiposocio ts where timestampdiff(year, m.dataNascimento,20210430) > ts.idadeMinima) as tipo
						from membro m 
						where m.idmembro=16));
update socio s set s.identificador = (select concat((select ts.designacaoTipo from tiposocio ts where ts.idTiposocio = s.idTipoSocio)
													,(select count(s2.idTipoSocio) from socio s2 where s2.idTipoSocio = s.idTipoSocio)) 
													as T_Id) where s.idmembro=16 and s.identificador is null;

insert into membrosocio (idMembro, idTipoSocio) values (16,(select max((select max(ts.idTipoSocio) 
																   from tiposocio ts 
																   where timestampdiff(year, m.dataNascimento, s.dataRegSocio) > ts.idadeMinima)) as tipo
														   from membro m 
														   inner join socio s on m.idmembro = s.idmembro
															where m.idmembro=16));

-- Sócio 13
insert into socio (dataRegSocio, isActivo, idMembro, idTipoSocio) values 
(20210503, true, 14, (select (select max(ts.idTipoSocio) from tiposocio ts where timestampdiff(year, m.dataNascimento,20210503) > ts.idadeMinima) as tipo
						from membro m 
						where m.idmembro=14));
update socio s set s.identificador = (select concat((select ts.designacaoTipo from tiposocio ts where ts.idTiposocio = s.idTipoSocio)
													,(select count(s2.idTipoSocio) from socio s2 where s2.idTipoSocio = s.idTipoSocio)) 
													as T_Id) where s.idmembro=14 and s.identificador is null;

insert into membrosocio (idMembro, idTipoSocio) values (14,(select max((select max(ts.idTipoSocio) 
																   from tiposocio ts 
																   where timestampdiff(year, m.dataNascimento, s.dataRegSocio) > ts.idadeMinima)) as tipo
														   from membro m 
														   inner join socio s on m.idmembro = s.idmembro
															where m.idmembro=14));

-- Sócio 14
insert into socio (dataRegSocio, isActivo, idMembro, idTipoSocio) values 
(20210610, true, 13, (select (select max(ts.idTipoSocio) from tiposocio ts where timestampdiff(year, m.dataNascimento,20210610) > ts.idadeMinima) as tipo
						from membro m 
						where m.idmembro=13));
update socio s set s.identificador = (select concat((select ts.designacaoTipo from tiposocio ts where ts.idTiposocio = s.idTipoSocio)
													,(select count(s2.idTipoSocio) from socio s2 where s2.idTipoSocio = s.idTipoSocio)) 
													as T_Id) where s.idmembro=13 and s.identificador is null;
                                              
insert into membrosocio (idMembro, idTipoSocio) values (13,(select max((select max(ts.idTipoSocio) 
																   from tiposocio ts 
																   where timestampdiff(year, m.dataNascimento, s.dataRegSocio) > ts.idadeMinima)) as tipo
														   from membro m 
														   inner join socio s on m.idmembro = s.idmembro
															where m.idmembro=13));
                                                     
insert into aula (dataAula) values 
(20220112),(20220113),(20220119),(20220120),
(20220201),(20220202),(20220208),(20220209),(20220215),(20220216),(20220222),(20220223),
(20220309),(20220310),(20220316),(20220317),(20220323),(20220324),
(20220401),(20220402),(20220403),(20220404),(20220405),(20220406),(20220407),(20220415),(20220416),(20220421);

insert into encarregadoeducacao (idMembroEncEd, idMembroSocio) values
(1,3),(7,5),(8,11),(8,12),(10,15),(2,16);

/*
Lista das chaves primárias dos sócios:
Menores
(5,1),(11,1),(12,1),(15,1),(16,1)
Adultos
(3,2),(4,2),(10,2),(13,2)
Seniores
(1,3),(6,3),(9,3),(14,3)
*/

insert into presencasaula (idAula, idMembro, idTipoSocio) values 
-- Janeiro 2022
(1,3,2),(1,4,2),(1,5,1),(1,10,2),(1,13,2),
(2,11,1),(2,12,1),(2,15,1),(2,16,1),(2,14,3),(2,10,2),
(3,10,2),(3,16,1),(3,4,2),(3,9,3),(3,6,3),(3,12,1),
(4,9,3),(4,4,2),(4,16,1),(4,15,1),
-- Fevereiro 2022
(5,1,3),(5,9,3),(5,14,3),(5,6,3),
(6,11,1),(6,12,1),(6,15,1),(6,16,1),
(7,1,3),(7,9,3),(7,14,3),(7,6,3),
(8,11,1),(8,12,1),(8,16,1),
(9,3,2),(9,4,2),(9,10,2),(9,13,2),
(10,1,3),(10,9,3),(10,14,3),(10,6,3),
(11,4,2),(11,10,2),(11,13,2),
(12,12,1),(12,16,1),(12,9,3),
-- Março 2022
(13,1,3),(13,9,3),(13,14,3),(13,6,3),
(14,11,1),(14,12,1),(14,15,1),(14,16,1),
(15,1,3),(15,9,3),(15,14,3),(15,6,3),
(16,12,1),(16,1,3),
(17,3,2),(17,4,2),(17,10,2),(17,13,2),
(18,10,2),(18,3,2),
-- Abril 2022
(19,10,2),(19,16,1),(19,4,2),
(20,9,3),(20,6,3),(20,12,1),
(21,1,3),(21,6,3),(21,14,3),
(22,12,1),(22,15,1),(22,16,1),
(23,12,1),(23,15,1),(23,16,1),
(24,4,2),(24,10,2),(24,13,2),
(25,14,3),(25,6,3),(25,11,1),(25,12,1),(25,16,1),
(26,11,1),(26,12,1),(26,15,1),(26,10,2),
(27,6,3),(27,9,3),(27,14,3),
(28,5,1),(28,11,1),(28,12,1),(28,15,1),(28,16,1);