drop database Golf;
create database Golf;
use Golf;

create table Spelare(
	PersonNr varchar(13),
    Namn varchar(20),
    Ålder int,
    primary key(PersonNr)
    )engine=innodb;
    
create table Tävling(
    Tävlingsnamn varchar(20),
    Datum date,
    primary key(Tävlingsnamn)
    )engine=innodb;

create table Konstruktion(
    SerialNr varchar(20),
    Hårdhet varchar(2),
    primary key(SerialNr)
    )engine=innodb;

create table Regn(
	Typ varchar(20),
    Vindstyrka varchar(5),
    primary key(Typ)
    )engine=innodb;

create table Jacka(
    Modell varchar(20),
    Storlek varchar(2),
    Material varchar(20),
    PersonNr varchar(13),
    primary key(PersonNr, Modell),
    foreign key(PersonNr) references Spelare(PersonNr)
    on delete cascade
    )engine=innodb;
    
create table Klubba(
    Nr varchar(20),
    Material varchar(20),
    PersonNr varchar(13),
    Konstruktion varchar(20),
    primary key(PersonNr, Nr),
    foreign key(PersonNr) references Spelare(PersonNr)
    on delete cascade
    /*,
    foreign key(Konstruktion) references Konstruktion(SerialNr)
    */
    )engine=innodb;
    
create table Delta(
	PersonNr varchar(13),
    Tävlingsnamn varchar(20),
    primary key(PersonNr, Tävlingsnamn),
    foreign key(PersonNr) references Spelare(PersonNr)
    on delete cascade,
	foreign key(Tävlingsnamn) references Tävling(Tävlingsnamn)
    on delete cascade
    )engine=innodb;
    
create table Har(
	Typ varchar(20),
    Tävlingsnamn varchar(20),
    Tidpunkt datetime,
    primary key(Typ, Tävlingsnamn),
    foreign key(Typ) references Regn(Typ)
    on delete cascade,
    foreign key(Tävlingsnamn) references Tävling(Tävlingsnamn)
    on delete cascade
	)engine=innodb;
    
    
    
INSERT INTO Spelare (PersonNr, Namn, Ålder) VALUES ('19960101-1234', 'Johan Andersson', 25);
INSERT INTO Spelare (PersonNr, Namn, Ålder) VALUES ('19860101-1234', 'Nicklas Jansson', 35);
INSERT INTO Spelare (PersonNr, Namn, Ålder) VALUES ('19910101-1234', 'Annika Persson', 30);

insert into Tävling (Tävlingsnamn, Datum) values ('Big Golf Cup Skövde', '2021-06-10');

insert into Konstruktion (SerialNr, Hårdhet) values ('123456', '10');
insert into Konstruktion (SerialNr, Hårdhet) values ('223456', '5');

insert into Jacka (Modell, Storlek, Material, PersonNr) values ('Munkjacka', 'XL', 'Fleece', '19960101-1234');
insert into Jacka (Modell, Storlek, Material, PersonNr) values ('Regnjacka', 'XL', 'Goretex', '19960101-1234');
    
insert into Klubba (Nr, Material, PersonNr, Konstruktion) values ('1234', 'Trä', '19860101-1234', '123456');
insert into Klubba (Nr, Material, PersonNr, Konstruktion) values ('2234', 'Trä', '19910101-1234', '223456');
insert into Klubba (Nr, Material, PersonNr, Konstruktion) values ('3234', 'Titan', '19960101-1234', '223456');

insert into Delta (PersonNr, Tävlingsnamn) values ('19960101-1234', 'Big Golf Cup Skövde');
insert into Delta (PersonNr, Tävlingsnamn) values ('19860101-1234', 'Big Golf Cup Skövde');
insert into Delta (PersonNr, Tävlingsnamn) values ('19910101-1234', 'Big Golf Cup Skövde');

insert into Regn (Typ, Vindstyrka) values ('hagel', '10m/s');

insert into Har (Typ, Tävlingsnamn, Tidpunkt) values ('hagel', 'Big Golf Cup Skövde', '2021-06-10 12:00:00');


-- 1. Hämta ålder för spelaren Johan Andersson. --
select Ålder from Spelare where Namn='Johan Andersson';

 -- 2. Hämta datum för tävlingen Big Golf Cup Skövde. --
select Datum from Tävling where Tävlingsnamn= 'Big Golf Cup Skövde';

-- 3. Hämta materialet för Johan Anderssons klubba. --
select Material
from Klubba
where PersonNr in (select PersonNr
             from Spelare
             where Namn='Johan Andersson');
             
-- 4. Hämta alla jackor som tillhör Johan Andersson. --  
select Modell, Storlek, Material
from Jacka
where PersonNr in (select PersonNr
             from Spelare
             where Namn='Johan Andersson');

-- 5. Hämta alla spelare som deltog i Big Golf Cup Skövde. --
select Namn from Delta
	inner join Spelare on Delta.PersonNr=Spelare.PersonNr
	inner join Tävling as täv on Delta.Tävlingsnamn=täv.Tävlingsnamn
    where täv.Tävlingsnamn='Big Golf Cup Skövde';

-- 6. Hämta regnens vindstyrka för Big Golf Cup Skövde. --
select Vindstyrka from Har
    inner join Regn on Har.Typ=Regn.Typ
    inner join Tävling as täv on Har.Tävlingsnamn=täv.Tävlingsnamn
    where täv.Tävlingsnamn='Big Golf Cup Skövde';
              
-- 7. Hämta alla spelare som är under 30 år. --
select Namn from Spelare where Ålder < 30;

-- 8. Ta bort Johan Anderssons jackor. --
delete from Jacka
where PersonNr in (select PersonNr
             from Spelare
             where Namn='Johan Andersson');

-- 9. Ta bort Nicklas Jansson. --
delete from Spelare where Namn='Nicklas Jansson' limit 1;

-- 10. Hämta medelåldern för alla spelare. --
select avg(Ålder) from Spelare;

    
    