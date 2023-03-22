create database ClubeNautico_SP_JM;
use ClubeNautico_SP_JM;

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