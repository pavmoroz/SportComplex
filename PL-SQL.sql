
/* Tutaj demonstruję swoją wiedzę języka PL-SQL tworząc dwie procedury i dwa triggiera dla mojej Bazy Danych.
Poniżej udostępniam opisy procedur i triggierów, które sam wymyśliłem i PL-SQL kod rozwiązania */


/*
Procedura 1
Napisz procedurę, która będzie usuwała wszystkie treningi z 
klientem X w dniu Y. Należy sprawdzać czy X jest klientem kompleksu sportowego
i jeżeli jest to czy ma treningi w podanym dniu. Jeżeli nie jest lub nie ma treningów trzeba
wyświetlić odpowiedni komunikat. Niech X, Y bedą dane wejściowe.
*/

CREATE OR REPLACE PROCEDURE usunTreningKlienta
    (imieKlienta varchar2, nazwiskoKlienta varchar2, tmpData date)
AS
    liczbaTreningow INT;
    czyIstniejeKlient INT;
    BEGIN
        SELECT COUNT(1) INTO liczbaTreningow 
        FROM KlientTrener KT
            JOIN Klient K ON KT.idKlient = K.idKlient
            JOIN Trening T ON KT.idTreningu = T.idTreningu
            WHERE K.imie = imieKlienta 
            AND K.nazwisko = nazwiskoKlienta
            AND dataTreningu = tmpData;
        SELECT COUNT(1) INTO czyIstniejeKlient
        FROM Klient K WHERE imie = imieKlienta AND nazwisko = nazwiskoKlienta;
        IF ( czyIstniejeKlient = 0 ) THEN
            DBMS_OUTPUT.PUT_LINE(imieKlienta || ' ' || nazwiskoKlienta || ' nie jest klientem kompleksu sportowego.');
        ELSIF( liczbaTreningow = 0 ) THEN
            DBMS_OUTPUT.PUT_LINE(imieKlienta || ' ' || nazwiskoKlienta || ' nie ma treningów w podanym dniu.');
        ELSE
                DELETE FROM KlientTrener WHERE
                idKlient = (SELECT idKlient FROM Klient WHERE imie = imieKlienta AND nazwisko = nazwiskoKlienta)
                AND idTreningu = (SELECT idTreningu FROM Trening WHERE dataTreningu = tmpData);
                DBMS_OUTPUT.PUT_LINE('Treningi podanego klienta zostaly usuniete.');
        END IF;
    END;

/*
Procedura num. 2
Napisz procedurę, która stworzy każdemu klientowi zniżkę na karnety.
Wysokość zniżki jest określona przez wiek klienta.
Klienci, którzy mają powyżej 65 lat otrzymują 20%, mniej niż 20 lat otrzymują 10%,
a pozostałe otrzymują 5. Należy stworzyć kolumnę Znizka w tabeli CzlonkowskaKarta.
W końcu trzeba wyświetlić ile różnych zniżek było stworzono.
*/

--ALTER TABLE czlonkowskaKarta
--ADD Znizka int DEFAULT 0;

CREATE OR REPLACE PROCEDURE dajZnizke
AS
tmpId int; tmpWiek int;
x20counter int := 0; x10counter int := 0; x5counter int := 0;
CURSOR kursor IS SELECT idCKarty FROM czlonkowskaKarta;
BEGIN
    OPEN kursor;
    LOOP 
        FETCH kursor INTO tmpId;
        EXIT WHEN kursor%NOTFOUND;
        
        SELECT TRUNC(MONTHS_BETWEEN(CURRENT_DATE, dataUrodzenia)/12) INTO tmpWiek
        FROM Klient WHERE idKlient = tmpId;
        
        IF (tmpWiek > 65) THEN
            UPDATE czlonkowskaKarta
            SET Znizka = 20
            WHERE idCKarty = tmpId;
            x20counter := x20counter + 1;
        ELSIF ( tmpWiek < 20 ) THEN
            UPDATE czlonkowskaKarta
            SET Znizka = 10
            WHERE idCKarty = tmpId;
            x10counter := x10counter + 1;
        ELSE
            UPDATE czlonkowskaKarta
            SET Znizka = 5
            WHERE idCKarty = tmpId;
            x5counter := x5counter + 1;
        END IF;
    END LOOP;
    CLOSE kursor;
    DBMS_OUTPUT.PUT_LINE('Zostało dodano ' || x20counter || ' o wysokości 20%, ' ||
    x10counter || ' o wysokości 10% i ' || x5counter || ' o wysokości 5%');
END;


/*
Triggier num.1
Napisz wyzwalacz na wprowadzenie pauzy do karnetu.
Nie można tworzyć pauzy dla tygodniowych i miesięcznych karnetów,
Także nie można tworzyć  pauzy dla już nieaktywnych karnetów.
Jeżeli te warunki są naruszone, wyświetl odpowiedni komunikat i nie dodawaj pauzy.
*/

CREATE OR REPLACE TRIGGER dodaniePauzy
BEFORE INSERT
ON Pauza
FOR EACH ROW 
DECLARE 
tmpIdKarty int; ostatniaData date; typKarnetu int; iloscDni int; dataPocz date;
BEGIN
    SELECT :new.idCKarty INTO tmpIdKarty FROM DUAL;
    SELECT :new.dataoD INTO dataPocz FROM DUAL;

    SELECT MAX(dataOplaty) INTO ostatniaData FROM kupowanieKarnetu
    WHERE idCkarty = tmpIdKarty;
    
    SELECT idKarnetu INTO typKarnetu FROM KupowanieKarnetu
    WHERE dataOplaty = ostatniaData AND idCKarty = tmpIdKarty;
        
    IF(typKarnetu != 3) THEN
        RAISE_APPLICATION_ERROR(-20000,'Pauzę można dodać tylko na roczny karnet.');
    END IF;
    
    SELECT iloscDniAktywnosci INTO iloscDni FROM karnet
    WHERE idKarnetu = typKarnetu;
        
    IF (CURRENT_DATE > ostatniaData + iloscDni OR CURRENT_DATE > dataPocz) THEN
    RAISE_APPLICATION_ERROR(-20000,'Pauzę można dodać tylko na aktywny karnet.');
    END IF;
END;

/*
Triggier num. 2
Napisz triggier na wprowadzenie i aktualizację zarobków trenerów.
Nowy trener nie może zarabiać więcej niż średnia płaca w jego sali.
Juz zatrudniony trener nie moze zarabiać mniej niz 1500.
Jeżeli te warunki sa naruszone, należy wyświetlić odpowiedni komunikat i
nie aktualizować/wprowadzać dane.
*/

CREATE OR REPLACE TRIGGER zmianaWynagrodzenia
BEFORE INSERT OR UPDATE OF Wynagrodzenie
ON Trener
FOR EACH ROW 
DECLARE 
tmpSala int; tmpWyn int; sredniZar int;
BEGIN
    IF INSERTING THEN
        SELECT :new.wynagrodzenie INTO tmpWyn FROM DUAL;
        SELECT :new.idSala INTO tmpSala FROM DUAL;

        SELECT AVG(wynagrodzenie) INTO sredniZar FROM Trener
        WHERE idSala = tmpSala;
        
        IF(sredniZar < tmpWyn) THEN
        RAISE_APPLICATION_ERROR(-20000, 'Nowy trener nie móze zarabiać więcej niż średnie wynagrodzenie w jego sali.');
        END IF;
    ELSE
        SELECT :new.wynagrodzenie INTO tmpWyn FROM DUAL;
        
        IF(tmpWyn < 1500) THEN
        RAISE_APPLICATION_ERROR(-20000, 'Trener z doświadczeniem nie móze zarabiać mniej 2000.');
        END IF;
    END IF;
END;
