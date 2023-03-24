<<<<<<< HEAD
Projeto Prático - Clube Náutico

Objetivos
O objetivo deste projeto prático é criar uma aplicação informática para calcular a mensalidade a pagar pelos associados de um clube náutico. Para isso, serão implementadas classes que representam os diferentes tipos de sócios do clube e que permitam o cálculo da mensalidade de cada um.

Enunciado
O clube náutico possui quatro tipos de sócios: Sócio Jovem, Sócio Menor, Sócio Adulto e Sócio Sénior. Considera-se que um sócio é sénior se tiver mais de 60 anos e adulto se tiver mais de 18 anos. Todos os sócios são caracterizados por um identificador, nome, número de contribuinte e ano de nascimento.

Cada identificador de um sócio Menor deve ser do tipo SMenor-X, sendo X um número sequencial iniciado em 1. Cada identificador de um sócio Adulto deve ser do tipo SAdulto-Y, sendo Y um número sequencial iniciado em 1. Cada identificador de um sócio Sénior deve ser do tipo SSenior-Z, sendo Z um número sequencial iniciado em 1.

Os sócios jovens são caracterizados pelo número de aulas por semana (mínimo de 1 aula). O valor a pagar por cada aula é de 25 euros. Os sócios menores têm um desconto de 20% sobre o valor calculado.

O valor a pagar pelos sócios tem por base um valor de referência que é de 100 euros para os jovens e 150 euros para os seniores. Sobre esse valor de referência, os seniores usufruem de um desconto de 10% por cada década de idade que possuam.

Os sócios maiores de idade, poderão ser dirigentes do clube, estando, nesse caso, isentos do pagamento de mensalidade.

Deve ser criada uma classe para testar as classes implementadas e que satisfaça os seguintes requisitos:

a) Construa quatro sócios de cada tipo: Menor, Adulto e Sénior.

b) Construa um contentor de objetos, designado listaSocios, que armazena os sócios criados anteriormente.

c) Apresente uma listagem dos nomes dos encarregados de educação e, para cada um, qual a quantidade de sócios menores a seu cargo.

d) Mostre para cada sócio o valor da mensalidade a pagar. No final deve apresentar o total das mensalidades dos sócios jovens e o total das mensalidades dos sócios séniores, bem como o peso (em percentagem) que cada um destes totais possui sobre o valor total das mensalidades.
=======
Projecto Prático – Criação de base de dados para Clube Náutico

1 - Estrutura:

create database ClubeNautico_SP;
use ClubeNautico_SP;

create table clube(
idClube int primary key auto_increment,
nomeClube varchar(100) not null,
nifClube char(9) not null,
capitalSocial int not null,
precoaula decimal (5,2) default 25.0
);

create table aula(
idAula int primary key auto_increment,
dataAula date not null,
idClube int default 1,
foreign key(idClube) references clube(idClube)
);

create table membro(
idMembro int primary key auto_increment,
nomeMembro varchar(100) not null,
nifMembro char(9) not null,
dataNascimento date not null,
isDirigente boolean
);

create table tiposocio(
idTipoSocio int primary key auto_increment,
idadeMinima varchar(2) not null,
desconto decimal (3,2),
precisaEncEd boolean,
valorRefMensal decimal(5,2) not null,
designacaoTipo varchar(255) not null,
idClube int default 1,
foreign key(idClube) references clube(idClube)
);

create table socio(
identificador varchar(255),
dataRegSocio date not null,
isActivo boolean,
idMembro int not null,
idTipoSocio int not null,
primary key (idMembro, idTipoSocio),
foreign key(idMembro) references membro(idMembro),
foreign key(idTipoSocio) references tiposocio(idTipoSocio)
);

create table presencasAula(
idAula int,
idMembro int,
idTipoSocio int,
primary key (idAula, idMembro, idTipoSocio),
foreign key (idMembro, idTipoSocio) references socio(idMembro,idTipoSocio),
foreign key (idAula) references aula(idAula)
);

create table mensalidade(
idMensalidade int primary key auto_increment,
valorMensal decimal (5,2),
dataMensalidade date,
isPaga boolean,
idClube int default 1,
idMembro int not null,
idTipoSocio int not null,
foreign key(idClube) references clube(idClube),
foreign key(idMembro,idTipoSocio) references Socio(idMembro,idTipoSocio)
);

create table membrosocio(
idMembro int,
idTipoSocio int,
primary key (idMembro, idTipoSocio),
foreign key (idMembro) references membro(idMembro),
foreign key (idTipoSocio) references tiposocio(idTipoSocio)
);

create table encarregadoeducacao(
idMembroEncEd int,
idMembroSocio int,
idTipoSocio int default 1,
foreign key (idMembroEncEd) references membro(idMembro),
foreign key (idMembroSocio) references membro(idMembro),
foreign key (idTipoSocio) references tiposocio(idTipoSocio)
);
 
2 - Dados para inserção na base de dados:
 
use ClubeNautico_SP;

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

Obs: Para a criação do atributo "identificador", optamos por fazer uma concatenação entre dois atributos: a designação do tipo do sócio,calculada pela diferença entre a data de nascimento e a data de registo,
-- e a contagem do número de tipos de sócios com a mesma designação. O parâmetro "and s.identificador is null" foi incluído na query para garantir que não são geradas inconformidades na contagem
-- quando um membro se reinscrever como sócio de outro tipo (p.ex: Adulto para Sénior).

update socio s set s.identificador = (select concat((select ts.designacaoTipo from tiposocio ts where ts.idTiposocio = s.idTipoSocio),(select count(s2.idTipoSocio) from socio s2 where s2.idTipoSocio = s.idTipoSocio)) as T_Id) where s.idmembro=3 and s.identificador is null;
                                                    

-- Após o registo do sócio, o mesmo é introduzido na tabela correspondente aos Membros que são sócios.

insert into membrosocio (idMembro, idTipoSocio) values (3,(select max((select max(ts.idTipoSocio) from tiposocio ts where timestampdiff(year, m.dataNascimento, s.dataRegSocio) > ts.idadeMinima)) as tipo
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

 
3- SQL específico para o cálculo de mensalidades 

De acordo com o enunciado, "os sócios jovens são ainda caracterizados pelo número de aulas por semana (mínimo de 1 aula) ". Sabendo que um mês terá no mínimo 4 semanas, isto equivale a um valor mínimo de 100€ para o sócio jovem, valor igual ao valor actual de referência.
Citando o enunciado: "A mensalidade dos Jovens é calculada com base nas aulas semanais que frequentam, tendo como máximo o valor de referência" e "os Menores têm um desconto de 20% sobre o valor calculado.", a nossa interpretação é a de que os sócios jovens menores pagariam sempre o valor de 100€ ao qual seria deduzido 20%, ou seja, 80€. 
Um cenário semelhante aconteceria com o sócio jovem adulto, mas neste caso não seria aplicado qualquer desconto, ou seja, pagaria sempre 100€.

Abaixo indicamos o SQL que consideramos apto a lidar com possíveis mudanças no preço das aulas e no valor de referência mensal.

-- Cálculo da mensalidade dos sócios Jovens - Menores e Adultos

select least((select (select c.precoaula*(select count(a.idAula) 
 from Aula a
 inner join presencasaula p on a.idAula = p.idAula								 where a.dataAula between '2022-01-01' and '2022-01-31' and (p.idMembro=4 and p.idTipoSocio= 2))
from clube c) *(1-ts.desconto) from tiposocio ts where ts.idtiposocio=2), (select ts.valorRefMensal*(1-ts.desconto)
from tiposocio ts 
where ts.idtiposocio=2)) as 'valor menor';

-- O cálculo da mensalidade dos sócios seniores é diferente dos demais tipos de sócios,uma vez que varia com as décadas de idade do sócio específico. 
-- Como tal, não poderemos determinar um valor fixo de desconto (no atributo tiposocio.desconto) que se aplique a todos os sócios seniores.
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

4 - Query de lista de encarregados de educação com o nome dos encarregados, sócios menores a seu cargo e os seus respectivos nomes.

select m1.nomemembro as 'Encarregado', m2.nomemembro as 'Sócio Menor'
from encarregadoeducacao enc
inner join membro m1 on enc.IdMembroEncEd = m1.idmembro
inner join membro m2 on enc.IdMembroSocio = m2.idmembro;
>>>>>>> 419f7d3973cebd7fb47fc3736a4094eec4e7d27a
