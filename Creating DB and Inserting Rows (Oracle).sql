
/* Tutaj jest udostępniony kod tworzenia mojej Bazy Danych i kod wprowadzenia nowych rekordów dla testowania zapytań SQL i procedur/triggerów 
   na Oracle Serwerze.  
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
    REFERENCES Klient (idKlient)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: KlienTren_Klient (table: KlientTrener)
ALTER TABLE KlientTrener ADD CONSTRAINT KlienTren_Klient
    FOREIGN KEY (idKlient)
    REFERENCES Klient (idKlient)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: KlientTrener_Trener (table: KlientTrener)
ALTER TABLE KlientTrener ADD CONSTRAINT KlientTrener_Trener
    FOREIGN KEY (IdTrener)
    REFERENCES Trener (idTrener)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: KlientTrener_Trening (table: KlientTrener)
ALTER TABLE KlientTrener ADD CONSTRAINT KlientTrener_Trening
    FOREIGN KEY (idTreningu)
    REFERENCES Trening (idTreningu)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: KupKar_CzlonKar (table: KupowanieKarnetu)
ALTER TABLE KupowanieKarnetu ADD CONSTRAINT KupKar_CzlonKar
    FOREIGN KEY (idCKarty)
    REFERENCES CzlonkowskaKarta (idCKarty)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: KupKar_Karnet (table: KupowanieKarnetu)
ALTER TABLE KupowanieKarnetu ADD CONSTRAINT KupKar_Karnet
    FOREIGN KEY (idKarnetu)
    REFERENCES Karnet (idKarnetu)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Pauza_CzlonKarta (table: Pauza)
ALTER TABLE Pauza ADD CONSTRAINT Pauza_CzlonKarta
    FOREIGN KEY (idCKarty)
    REFERENCES CzlonkowskaKarta (idCKarty)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Trener_Sala (table: Trener)
ALTER TABLE Trener ADD CONSTRAINT Trener_Sala
    FOREIGN KEY (idSala)
    REFERENCES Sala (idSala)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Trening_Sala (table: Trening)
ALTER TABLE Trening ADD CONSTRAINT Trening_Sala
    FOREIGN KEY (idSala)
    REFERENCES Sala (idSala)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

/*Wprowadzenie nowych rekordów*/

-- Wpisujemy karnety
INSERT ALL INTO
KARNET (IDKARNETU, NAZWAKARNETU, CENA, ILOSCDNIAKTYWNOSCI) 
VALUES (1,'TYDZIEN',40,7)
INTO KARNET (IDKARNETU, NAZWAKARNETU, CENA, ILOSCDNIAKTYWNOSCI)
VALUES (2,'MIESIAC',100,30)
INTO KARNET (IDKARNETU, NAZWAKARNETU, CENA, ILOSCDNIAKTYWNOSCI) 
VALUES (3,'ROK',1100,365)
SELECT * FROM dual;

-- Wpisujemy sali
INSERT ALL INTO 
SALA (IDSALA, NAZWA, OPIS) 
VALUES (1,'PLYWALNIA','Sala z basenem o rozmiarze 50x50.')
INTO SALA (IDSALA, NAZWA, OPIS)
VALUES (2,'SILOWNIA','Sala z maszynami do cwiczen.')
INTO SALA (IDSALA, NAZWA, OPIS)
VALUES (3,'CROSSFIT','Sala dla zajec crossfit.')
SELECT * FROM dual;

-- Wpisujemy klientów
INSERT ALL INTO
KLIENT (IDKLIENT, IMIE, NAZWISKO, DATAURODZENIA) 
VALUES (1,'BOB','JONES','21-02-1986')
INTO KLIENT (IDKLIENT, IMIE, NAZWISKO, DATAURODZENIA) 
VALUES (2,'MIKE','TAYLOR','01-12-1999')
INTO KLIENT (IDKLIENT, IMIE, NAZWISKO, DATAURODZENIA) 
VALUES (3,'JOHN','BROWN','13-04-2002')
INTO KLIENT (IDKLIENT, IMIE, NAZWISKO, DATAURODZENIA) 
VALUES (4,'SAM','EVANS','25-10-1999')
INTO KLIENT (IDKLIENT, IMIE, NAZWISKO, DATAURODZENIA) 
VALUES (5,'TED','WILSON','12-05-1998')
INTO KLIENT (IDKLIENT, IMIE, NAZWISKO, DATAURODZENIA)
VALUES (6,'BENJAMIN','THOMAS','09-07-1995')
INTO KLIENT (IDKLIENT, IMIE, NAZWISKO, DATAURODZENIA)
VALUES (7,'HARRISON','ROBERTS','21-11-1981')
INTO KLIENT (IDKLIENT, IMIE, NAZWISKO, DATAURODZENIA)
VALUES (8,'BEATRIX','HALL','21-02-2001')
INTO KLIENT (IDKLIENT, IMIE, NAZWISKO, DATAURODZENIA)
VALUES (9,'ELIZABETH','WALKER','01-12-1999')
INTO KLIENT (IDKLIENT, IMIE, NAZWISKO, DATAURODZENIA)
VALUES (10,'MIKE','EVANS','13-04-1999')
INTO KLIENT (IDKLIENT, IMIE, NAZWISKO, DATAURODZENIA)
VALUES (11,'DONALD','PERSON','13-04-1950');
SELECT * FROM dual;

-- Wpisujemy trenerow
INSERT ALL INTO 
TRENER (IDTRENER, IMIE, NAZWISKO, DATAURODZENIA, WYNAGRODZENIE, IDSALA)
VALUES (1,'OLIVER','DAVIS','21-08-1986',2000,1)
INTO TRENER (IDTRENER, IMIE, NAZWISKO, DATAURODZENIA, WYNAGRODZENIE, IDSALA)
VALUES (2,'JOHN','YOUNG','01-04-1990',3500,1)
INTO TRENER (IDTRENER, IMIE, NAZWISKO, DATAURODZENIA, WYNAGRODZENIE, IDSALA)
VALUES (3,'WILLIAM','BENNETT','16-10-1999',2000,1)
INTO TRENER (IDTRENER, IMIE, NAZWISKO, DATAURODZENIA, WYNAGRODZENIE, IDSALA)
VALUES (4,'JOHN','MITCHELL','01-07-1985',1200,1)
INTO TRENER (IDTRENER, IMIE, NAZWISKO, DATAURODZENIA, WYNAGRODZENIE, IDSALA)
VALUES (5,'ISABELLA','CARTER','28-12-1998',5000,2)
INTO TRENER (IDTRENER, IMIE, NAZWISKO, DATAURODZENIA, WYNAGRODZENIE, IDSALA)
VALUES (6,'JOHN','SHAW','11-01-1998',1300,2)
INTO TRENER (IDTRENER, IMIE, NAZWISKO, DATAURODZENIA, WYNAGRODZENIE, IDSALA)
VALUES (7,'JOANNE','COX','15-09-1999',1200,3)
SELECT * FROM dual;

-- Wpisujemy karty klientów, na które oni mogą kupic karnety
INSERT ALL INTO CZLONKOWSKAKARTA (IDCKARTY, DATAWYDANIA)
VALUES (1,'21-02-2017')
INTO CZLONKOWSKAKARTA (IDCKARTY, DATAWYDANIA)
VALUES (2,'17-02-2018')
INTO CZLONKOWSKAKARTA (IDCKARTY, DATAWYDANIA)
VALUES (3,'01-02-2016')
INTO CZLONKOWSKAKARTA (IDCKARTY, DATAWYDANIA)
VALUES (4,'19-03-2018')
INTO CZLONKOWSKAKARTA (IDCKARTY, DATAWYDANIA)
VALUES (5,'21-12-2017')
INTO CZLONKOWSKAKARTA (IDCKARTY, DATAWYDANIA)
VALUES (6,'08-07-2017')
INTO CZLONKOWSKAKARTA (IDCKARTY, DATAWYDANIA)
VALUES (7,'22-05-2018')
INTO CZLONKOWSKAKARTA (IDCKARTY, DATAWYDANIA)
VALUES (8,'20-06-2018')
INTO CZLONKOWSKAKARTA (IDCKARTY, DATAWYDANIA)
VALUES (9,'21-02-2015')
INTO CZLONKOWSKAKARTA (IDCKARTY, DATAWYDANIA)
VALUES (10,'25-04-2018')
INTO CZLONKOWSKAKARTA (IDCKARTY, DATAWYDANIA)
VALUES (11,'15-05-2017');
SELECT * FROM dual;

-- Wpisujemy kiedy i jaki karnet klient kupił
INSERT ALL INTO KUPOWANIEKARNETU (IDKUPOWANIA, DATAOPLATY, IDKARNETU, IDCKARTY)
VALUES (1,'22-02-2017',2,2)
INTO KUPOWANIEKARNETU (IDKUPOWANIA, DATAOPLATY, IDCKARTY, IDKARNETU)
VALUES (2,'22-04-2017',2,3)
INTO KUPOWANIEKARNETU (IDKUPOWANIA, DATAOPLATY, IDCKARTY, IDKARNETU) 
VALUES (3,'19-03-2018',4,1)
INTO KUPOWANIEKARNETU (IDKUPOWANIA, DATAOPLATY, IDCKARTY, IDKARNETU) 
VALUES (4,'17-03-2018',1,1)
INTO KUPOWANIEKARNETU (IDKUPOWANIA, DATAOPLATY, IDCKARTY, IDKARNETU) 
VALUES (5,'30-03-2018',1,2)
INTO KUPOWANIEKARNETU (IDKUPOWANIA, DATAOPLATY, IDCKARTY, IDKARNETU) 
VALUES (6,'01-05-2018',1,3)
INTO KUPOWANIEKARNETU (IDKUPOWANIA, DATAOPLATY, IDCKARTY, IDKARNETU) 
VALUES (7,'22-12-2017',5,3)
INTO KUPOWANIEKARNETU (IDKUPOWANIA, DATAOPLATY, IDCKARTY, IDKARNETU)
VALUES (8,'26-04-2018',10,2)
INTO KUPOWANIEKARNETU (IDKUPOWANIA, DATAOPLATY, IDCKARTY, IDKARNETU)
VALUES (9,'22-02-2015',9,2)
INTO KUPOWANIEKARNETU (IDKUPOWANIA, DATAOPLATY, IDCKARTY, IDKARNETU)
VALUES (10,'23-04-2015',9,3)
INTO KUPOWANIEKARNETU (IDKUPOWANIA, DATAOPLATY, IDCKARTY, IDKARNETU)
VALUES (11,'24-04-2016',9,3)
INTO KUPOWANIEKARNETU (IDKUPOWANIA, DATAOPLATY, IDCKARTY, IDKARNETU)
VALUES (12,'25-04-2017',9,1)
INTO KUPOWANIEKARNETU (IDKUPOWANIA, DATAOPLATY, IDCKARTY, IDKARNETU) 
VALUES (13,'02-02-2016',3,3)
INTO KUPOWANIEKARNETU (IDKUPOWANIA, DATAOPLATY, IDCKARTY, IDKARNETU) 
VALUES (14,'03-02-2017',3,3)
INTO KUPOWANIEKARNETU (IDKUPOWANIA, DATAOPLATY, IDCKARTY, IDKARNETU) 
VALUES (15,'04-02-2018',3,3)
INTO KUPOWANIEKARNETU (IDKUPOWANIA, DATAOPLATY, IDCKARTY, IDKARNETU) 
VALUES (16,'09-07-2017',6,3)
SELECT * FROM dual;

-- Wpisujemy treningi
INSERT ALL INTO
TRENING (IDTRENINGU, DATATRENINGU, CZASKONTYNUACJITRENINGU, IDSALA)
VALUES (1,'24-05-2015',2,1) 
INTO TRENING (IDTRENINGU, DATATRENINGU, CZASKONTYNUACJITRENINGU, IDSALA)
VALUES (2,'11-08-2016',1,1)
INTO TRENING (IDTRENINGU, DATATRENINGU, CZASKONTYNUACJITRENINGU, IDSALA)
VALUES (3,'15-09-2016',2,2)
INTO TRENING (IDTRENINGU, DATATRENINGU, CZASKONTYNUACJITRENINGU, IDSALA)
VALUES (4,'13-02-2017',3,1)
INTO TRENING (IDTRENINGU, DATATRENINGU, CZASKONTYNUACJITRENINGU, IDSALA)
VALUES (5,'21-04-2017',1,3)
INTO TRENING (IDTRENINGU, DATATRENINGU, CZASKONTYNUACJITRENINGU, IDSALA)
VALUES (6,'01-08-2017',4,2)
INTO TRENING (IDTRENINGU, DATATRENINGU, CZASKONTYNUACJITRENINGU, IDSALA)
VALUES (7,'16-10-2017',2,1)
INTO TRENING (IDTRENINGU, DATATRENINGU, CZASKONTYNUACJITRENINGU, IDSALA)
VALUES (8,'17-01-2018',1,3)
INTO TRENING (IDTRENINGU, DATATRENINGU, CZASKONTYNUACJITRENINGU, IDSALA)
VALUES (9,'28-03-2018',2,2)
INTO TRENING (IDTRENINGU, DATATRENINGU, CZASKONTYNUACJITRENINGU, IDSALA)
VALUES (10,'19-04-2018',3,2)
SELECT * FROM dual;

-- Wpisujemy z jakim trenerem i jaki trening miał klient 
INSERT ALL INTO 
KLIENTTRENER (IDKLIENT, IDTRENER, IDTRENINGU) 
VALUES (1,5,10)
INTO KLIENTTRENER (IDKLIENT, IDTRENER, IDTRENINGU) 
VALUES (2,1,7)
INTO KLIENTTRENER (IDKLIENT, IDTRENER, IDTRENINGU) 
VALUES (3,2,2)
INTO KLIENTTRENER (IDKLIENT, IDTRENER, IDTRENINGU) 
VALUES (5,7,8)
INTO KLIENTTRENER (IDKLIENT, IDTRENER, IDTRENINGU) 
VALUES (6,6,6)
INTO KLIENTTRENER (IDKLIENT, IDTRENER, IDTRENINGU) 
VALUES (9,3,1)
INTO KLIENTTRENER (IDKLIENT, IDTRENER, IDTRENINGU) 
VALUES (9,4,2)
INTO KLIENTTRENER (IDKLIENT, IDTRENER, IDTRENINGU) 
VALUES (9,2,4)
INTO KLIENTTRENER (IDKLIENT, IDTRENER, IDTRENINGU) 
VALUES (9,5,3)
INTO KLIENTTRENER (IDKLIENT, IDTRENER, IDTRENINGU) 
VALUES (3,4,4)
INTO KLIENTTRENER (IDKLIENT, IDTRENER, IDTRENINGU) 
VALUES (9,7,5)
INTO KLIENTTRENER (IDKLIENT, IDTRENER, IDTRENINGU) 
VALUES (6,5,9)
INTO KLIENTTRENER (IDKLIENT, IDTRENER, IDTRENINGU) 
VALUES (4,6,10)
INTO KLIENTTRENER (IDKLIENT, IDTRENER, IDTRENINGU) 
values (4,5,10);
SELECT * FROM dual;

--Wpisujemy pauzy 
INSERT ALL INTO 
PAUZA (IDPAUZY, DATAOD, DATADO, IDCKARTY) 
VALUES (1,'24-04-2015','27-05-2015', 9)
INTO PAUZA (IDPAUZY, DATAOD, DATADO, IDCKARTY) 
VALUES (2,'03-03-2017','10-03-2017', 3)
INTO PAUZA (IDPAUZY, DATAOD, DATADO, IDCKARTY) 
VALUES (3,'05-04-2018','05-05-2018', 1)
SELECT * FROM dual;