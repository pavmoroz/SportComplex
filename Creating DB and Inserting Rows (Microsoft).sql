
/* Tutaj jest udostępniony kod tworzenia mojej Bazy Danych i kod wprowadzenia nowych rekordów dla testowania zapytań SQL i procedur/triggerów 
   na Microsoft Serwerze.  
*/

/*Tworzenie Bazy Danych*/

-- Table: CzlonkowskaKarta
CREATE TABLE CzlonkowskaKarta (
    idCKarty int  NOT NULL,
    DataWydania date  NOT NULL,
    CONSTRAINT CzlonkowskaKarta_pk PRIMARY KEY (idCKarty)
);

-- Table: Karnet
CREATE TABLE Karnet (
    idKarnetu int  NOT NULL,
    NazwaKarnetu varchar(20)  NOT NULL,
    Cena int  NOT NULL,
    IloscDniAktywnosci int  NOT NULL,
    CONSTRAINT Karnet_pk PRIMARY KEY (idKarnetu)
);

-- Table: Klient
CREATE TABLE Klient (
    idKlient int  NOT NULL,
    Imie varchar(20)  NOT NULL,
    Nazwisko varchar(20)  NOT NULL,
    DataUrodzenia date  NOT NULL,
    CONSTRAINT Klient_pk PRIMARY KEY (idKlient)
);

-- Table: KlientTrener
CREATE TABLE KlientTrener (
    idKlient int  NOT NULL,
    IdTrener int  NOT NULL,
    idTreningu int  NOT NULL,
    CONSTRAINT KlientTrener_pk PRIMARY KEY (idKlient,IdTrener,idTreningu)
);

-- Table: KupowanieKarnetu
CREATE TABLE KupowanieKarnetu (
    idKupowania int  NOT NULL,
    DataOplaty date  NOT NULL,
    idKarnetu int  NOT NULL,
    idCKarty int  NOT NULL,
    CONSTRAINT KupowanieKarnetu_pk PRIMARY KEY (idKupowania)
);

-- Table: Pauza
CREATE TABLE Pauza (
    idPauzy int  NOT NULL,
    DataOd date  NOT NULL,
    DataDo date  NOT NULL,
    idCKarty int  NOT NULL,
    CONSTRAINT Pauza_pk PRIMARY KEY (idPauzy)
);

-- Table: Sala
CREATE TABLE Sala (
    idSala int  NOT NULL,
    Nazwa varchar(25)  NOT NULL,
    Opis varchar(100)  NOT NULL,
    CONSTRAINT Sala_pk PRIMARY KEY (idSala)
);

-- Table: Trener
CREATE TABLE Trener (
    idTrener int  NOT NULL,
    Imie varchar(20)  NOT NULL,
    Nazwisko varchar(20)  NOT NULL,
    DataUrodzenia date  NOT NULL,
    Wynagrodzenie int  NOT NULL,
    idSala int  NOT NULL,
    CONSTRAINT Trener_pk PRIMARY KEY (idTrener)
);

-- Table: Trening
CREATE TABLE Trening (
    idTreningu int  NOT NULL,
    DataTreningu date  NOT NULL,
    CzasKontynuacjiTreningu int  NOT NULL,
    idSala int  NOT NULL,
    CONSTRAINT Trening_pk PRIMARY KEY (idTreningu)
);

-- Reference: CzlonKar_Klient (table: CzlonkowskaKarta)
ALTER TABLE CzlonkowskaKarta ADD CONSTRAINT CzlonKar_Klient
    FOREIGN KEY (idCKarty)
    REFERENCES Klient (idKlient);

-- Reference: KlienTren_Klient (table: KlientTrener)
ALTER TABLE KlientTrener ADD CONSTRAINT KlienTren_Klient
    FOREIGN KEY (idKlient)
    REFERENCES Klient (idKlient);

-- Reference: KlientTrener_Trener (table: KlientTrener)
ALTER TABLE KlientTrener ADD CONSTRAINT KlientTrener_Trener
    FOREIGN KEY (IdTrener)
    REFERENCES Trener (idTrener);

-- Reference: KlientTrener_Trening (table: KlientTrener)
ALTER TABLE KlientTrener ADD CONSTRAINT KlientTrener_Trening
    FOREIGN KEY (idTreningu)
    REFERENCES Trening (idTreningu);

-- Reference: KupKar_CzlonKar (table: KupowanieKarnetu)
ALTER TABLE KupowanieKarnetu ADD CONSTRAINT KupKar_CzlonKar
    FOREIGN KEY (idCKarty)
    REFERENCES CzlonkowskaKarta (idCKarty);

-- Reference: KupKar_Karnet (table: KupowanieKarnetu)
ALTER TABLE KupowanieKarnetu ADD CONSTRAINT KupKar_Karnet
    FOREIGN KEY (idKarnetu)
    REFERENCES Karnet (idKarnetu);

-- Reference: Pauza_CzlonKarta (table: Pauza)
ALTER TABLE Pauza ADD CONSTRAINT Pauza_CzlonKarta
    FOREIGN KEY (idCKarty)
    REFERENCES CzlonkowskaKarta (idCKarty);

-- Reference: Trener_Sala (table: Trener)
ALTER TABLE Trener ADD CONSTRAINT Trener_Sala
    FOREIGN KEY (idSala)
    REFERENCES Sala (idSala);

-- Reference: Trening_Sala (table: Trening)
ALTER TABLE Trening ADD CONSTRAINT Trening_Sala
    FOREIGN KEY (idSala)
    REFERENCES Sala (idSala);

/*Wprowadzenie nowych rekordów*/

-- Wpisujemy karnety
INSERT INTO
KARNET (IDKARNETU, NAZWAKARNETU, CENA, ILOSCDNIAKTYWNOSCI) 
VALUES 
(1,'TYDZIEN',40,7),
(2,'MIESIAC',100,30), 
(3,'ROK',1100,365);

-- Wpisujemy sali
INSERT INTO 
SALA (IDSALA, NAZWA, OPIS) 
VALUES 
(1,'PLYWALNIA','Sala z basenem o rozmiarze 50x50.'),
(2,'SILOWNIA','Sala z maszynami do cwiczen.'),
(3,'CROSSFIT','Sala dla zajec crossfit.');

-- Wpisujemy klientów
INSERT INTO
KLIENT (IDKLIENT, IMIE, NAZWISKO, DATAURODZENIA) 
VALUES
 (1,'BOB','JONES','1986-02-21'),
 (2,'MIKE','TAYLOR','1999-12-01'),
 (3,'JOHN','BROWN','2002-04-13'),
 (4,'SAM','EVANS','1999-10-25'),
 (5,'TED','WILSON','1998-05-12'),
 (6,'BENJAMIN','THOMAS','1995-07-09'),
 (7,'HARRISON','ROBERTS','1981-11-21'),
 (8,'BEATRIX','HALL','2001-02-21'),
 (9,'ELIZABETH','WALKER','1999-12-01'),
 (10,'MIKE','EVANS','1999-04-13');

-- Wpisujemy trenerow
INSERT INTO 
TRENER (IDTRENER, IMIE, NAZWISKO, DATAURODZENIA, WYNAGRODZENIE, IDSALA)
VALUES
 (1,'OLIVER','DAVIS','1986-08-21',2000,1),
 (2,'JOHN','YOUNG','1990-04-01',3500,1),
 (3,'WILLIAM','BENNETT','1999-10-16',2000,1),
 (4,'JOHN','MITCHELL','1985-07-01',1200,1),
 (5,'ISABELLA','CARTER','1998-12-28',5000,2),
 (6,'JOHN','SHAW','1998-01-11',1300,2),
 (7,'JOANNE','COX','1999-09-15',1200,3);

-- Wpisujemy karty klientów, na które oni mogą kupic karnety
INSERT INTO CZLONKOWSKAKARTA (IDCKARTY, DATAWYDANIA)
VALUES
 (1,'2017-02-21'),
 (2,'2018-02-17'),
 (3,'2016-02-01'),
 (4,'2018-03-19'),
 (5,'2017-12-21'),
 (6,'2017-07-08'),
 (7,'2018-05-22'),
 (8,'2018-06-20'),
 (9,'2015-02-21'),
 (10,'2018-04-25');

-- Wpisujemy kiedy i jaki karnet klient kupił
INSERT INTO KUPOWANIEKARNETU (IDKUPOWANIA, DATAOPLATY, IDCKARTY, IDKARNETU)
VALUES 
 (1,'2017-02-22',2,2),
 (2,'2017-04-22',2,3),
 (3,'2018-03-19',4,1),
 (4,'2018-03-17',1,1),
 (5,'2018-03-30',1,2),
 (6,'2018-05-01',1,3),
 (7,'2017-12-22',5,3),
 (8,'2018-04-26',10,2),
 (9,'2015-02-22',9,2),
 (10,'2015-04-23',9,3),
 (11,'2016-04-24',9,3),
 (12,'2017-04-25',9,1),
 (13,'2016-02-02',3,3),
 (14,'2017-02-03',3,3),
 (15,'2018-02-04',3,3),
 (16,'2017-07-09',6,3);

-- Wpisujemy treningi
INSERT INTO
TRENING (IDTRENINGU, DATATRENINGU, CZASKONTYNUACJITRENINGU, IDSALA)
VALUES
 (1,'2015-05-24',2,1),
 (2,'2016-08-11',1,1),
 (3,'2016-09-15',2,2),
 (4,'2017-02-13',3,1),
 (5,'2017-04-21',1,3),
 (6,'2017-08-01',4,2),
 (7,'2017-10-16',2,1),
 (8,'2018-01-17',1,3),
 (9,'2018-03-28',2,2),
 (10,'2018-04-19',3,2)
 (11, '2018-04-19', 1, 2),
 (12, '2018-04-19', 5, 2);

-- Wpisujemy z jakim trenerem i jaki trening miał klient 
INSERT INTO 
KLIENTTRENER (IDKLIENT, IDTRENER, IDTRENINGU) 
VALUES
 (1,5,10),
 (2,1,7),
 (3,2,2),
 (5,7,8),
 (6,6,6),
 (9,3,1),
 (9,4,2),
 (9,2,4),
 (9,5,3),
 (3,4,4),
 (9,7,5),
 (6,5,9),
 (4,6,10),
 (2, 5, 11);
	
-- Wpisujemy pauzy 
INSERT INTO 
PAUZA (IDPAUZY, DATAOD, DATADO, IDCKARTY) 
VALUES
 (1,'2015-04-24','2015-05-27', 9),
 (2,'2017-03-03','2017-03-10', 3),
 (3,'2018-04-05','2018-05-05', 1);