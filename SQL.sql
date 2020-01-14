
/* Tutaj demonstruję swoją wiedzę języka SQL tworząc zapytania dla mojej Bazy Danych.
Poniżej udostępniam opisy zapytań, które sam wymyśliłem i PL-SQL kod rozwiązania */

-- Polecenia SELECT z warunkiem WHERE.

-- 1) Wypisz imię, nazwisko i wynagrodzenie trenerów zarabiających więcej od 1500.

SELECT IMIE, NAZWISKO, WYNAGRODZENIE
FROM TRENER
WHERE WYNAGRODZENIE > 1500;

-- 2) Wypisz wszystkie dane klientów, którzy się urodzili w 1998 roku lub mają nazwisko Evans.

SELECT * FROM KLIENT 
WHERE EXTRACT(YEAR FROM DATAURODZENIA) = 1998 OR NAZWISKO = 'EVANS';

-- 3) Wypisz id, imię i nazwisko wszystkich trenerów, którzy mają imię John i urodzili się po 1985 roku. Wyniki posortuj według nazwiska rosnąco.

SELECT IDTRENER, IMIE, NAZWISKO
FROM TRENER
WHERE IMIE='JOHN' AND EXTRACT(YEAR FROM DATAURODZENIA) > 1985 ORDER BY NAZWISKO;

-- 4) Wypisz id i czas kontynuacji wszystkich treningów 2016 roku i 3-godz. treningów 2017 roku. Wynili podaj w postaci "Trening o id: ID trwał CZAS godzin.

SELECT 'Trening o id: ' || IDTRENINGU || ' trwał ' || CZASKONTYNUACJITRENINGU || ' godzinę(y).' as Treningi
FROM TRENING
WHERE EXTRACT(YEAR FROM DATATRENINGU) = 2016 OR (EXTRACT(YEAR FROM DATATRENINGU) = 2017 AND CZASKONTYNUACJITRENINGU < 3);

-- 5) Wypisz imię i nazwisko trenerów którzy mają wynagrodzenie w przedziale od 1000 do 2500 i w swoim nazwisku lub imieniu mają literki LL.

SELECT IMIE, NAZWISKO 
FROM TRENER 
WHERE WYNAGRODZENIE BETWEEN 1000 AND 2500 AND (IMIE LIKE '%LL%' OR NAZWISKO LIKE '%LL%');


-- Polecenia SELECT ze złączeniem tabel.

-- 1) Wypisz id, imię i nazwisko trenerów ktorzy pracują w siłowni lub plywalni i zarabijają powyżej 2000.

SELECT SALA.IDSALA, IMIE, NAZWISKO
FROM TRENER
JOIN SALA ON TRENER.IDSALA = SALA.IDSALA
WHERE (NAZWA = 'SILOWNIA' OR NAZWA = 'PLYWALNIA') AND WYNAGRODZENIE > 2000;

-- 2) Wypisz id,imię i nazwisko klientów którzy mieli trening w pływalni w 2017 roku.

SELECT K.IDKLIENT,IMIE, NAZWISKO
FROM KLIENT K
JOIN KLIENTTRENER KT ON K.IDKLIENT=KT.IDKLIENT
JOIN TRENING T ON KT.IDTRENINGU=T.IDTRENINGU
JOIN SALA S ON T.IDSALA=S.IDSALA
WHERE S.NAZWA='PLYWALNIA' AND EXTRACT(YEAR FROM T.DATATRENINGU) = 2017;

-- 3) Wypisz id, imię i nazwisko klientów, ktorzy kupili karnet "ROK" w 2017 roku.

SELECT IDKLIENT, IMIE, NAZWISKO 
FROM KLIENT
JOIN CZLONKOWSKAKARTA C ON KLIENT.IDKLIENT = C.IDCKARTY
JOIN KUPOWANIEKARNETU K ON C.IDCKARTY = K.IDCKARTY
JOIN KARNET KAR ON K.IDKARNETU = KAR.IDKARNETU
WHERE KAR.NAZWAKARNETU='ROK' AND EXTRACT(YEAR FROM K.DATAOPLATY) = 2017;

-- 4) Wypisz daty, miejsca treningów i nazwiska trenerów, z którymi Elizabeth Walker miała treningi po 2015 roku.

SELECT TR.DATATRENINGU, S.NAZWA, T.NAZWISKO
FROM KLIENT K
JOIN KLIENTTRENER KT ON K.IDKLIENT=KT.IDKLIENT
JOIN TRENER T ON KT.IDTRENER=T.IDTRENER
JOIN TRENING TR ON KT.IDTRENINGU=TR.IDTRENINGU
JOIN SALA S ON T.IDSALA = S.IDSALA
WHERE K.IMIE='ELIZABETH' AND K.NAZWISKO='WALKER' AND EXTRACT(YEAR FROM TR.DATATRENINGU) > 2015;

-- 5) Wypisz imię, nazwisko i datę urodzenia klientów którzy mieli trening z Isabella Carter więcek niż 1 godzinę.

SELECT K.IMIE, K.NAZWISKO, K.DATAURODZENIA 
FROM KLIENT K
JOIN KLIENTTRENER KT ON K.IDKLIENT=KT.IDKLIENT
JOIN TRENER T ON KT.IDTRENER=T.IDTRENER
JOIN TRENING TR ON KT.IDTRENINGU=TR.IDTRENINGU
WHERE T.IMIE='ISABELLA' AND T.NAZWISKO='CARTER' AND TR.CZASKONTYNUACJITRENINGU > 1;

-- Polecenia SELECT z klauzulą GROUP BY, w tym co najmniej 2 z klauzulą HAVING.

-- 1) Podaj sumę pensji trenerów z każdej sali.

SELECT NAZWA, SUM(WYNAGRODZENIE) "Suma Pensji"
FROM SALA
JOIN TRENER ON SALA.IDSALA = TRENER.IDSALA
GROUP BY NAZWA;

-- 2) Wyświetl id, imię i nazwisko trenerów, którzy mieli tylko 1 trening.

SELECT TRENER.IDTRENER, IMIE, NAZWISKO FROM TRENER 
JOIN KLIENTTRENER ON TRENER.IDTRENER = KLIENTTRENER.IDTRENER
GROUP BY TRENER.IDTRENER, IMIE, NAZWISKO
HAVING COUNT(1) = 1;

-- 3) Wyświetl id, imię, nazwisko klienta, który kupił największą ilość karnetów o nazwie "Rok".

SELECT IDKLIENT, IMIE, NAZWISKO, COUNT(1) "LICZBA KARNETÓW"
FROM KLIENT
JOIN CZLONKOWSKAKARTA C ON KLIENT.IDKLIENT = C.IDCKARTY
JOIN KUPOWANIEKARNETU K ON C.IDCKARTY = K.IDCKARTY
JOIN KARNET KAR ON K.IDKARNETU = KAR.IDKARNETU
WHERE KAR.NAZWAKARNETU='ROK'
GROUP BY IDKLIENT, IMIE, NAZWISKO
HAVING COUNT(1) >= ALL(SELECT COUNT(1) FROM KLIENT
                            JOIN CZLONKOWSKAKARTA C ON KLIENT.IDKLIENT = C.IDCKARTY
                            JOIN KUPOWANIEKARNETU K ON C.IDCKARTY = K.IDCKARTY
                            JOIN KARNET KAR ON K.IDKARNETU = KAR.IDKARNETU
                            WHERE KAR.NAZWAKARNETU='ROK'
			    GROUP BY IDKLIENT);

-- 4) Podaj imię i nazwisko trenerów, którzy zarabiają powyżej średniej pensji w sali o nazwie "Plywalnia".

SELECT IMIE, NAZWISKO,WYNAGRODZENIE
FROM TRENER JOIN SALA ON TRENER.IDSALA = SALA.IDSALA
GROUP BY IMIE, NAZWISKO, WYNAGRODZENIE
HAVING WYNAGRODZENIE >= (SELECT AVG(WYNAGRODZENIE) FROM TRENER JOIN SALA ON TRENER.IDSALA = SALA.IDSALA WHERE NAZWA = 'PLYWALNIA');

-- 5) Wypisz datę pierwszego i ostatniego treningu dla trenerów, którzy mieli co najmniej dwa treningi.

SELECT TRENER.IDTRENER, IMIE, NAZWISKO, MIN(DATATRENINGU) "Pierwszy trening", MAX(DATATRENINGU) "Ostatni trening" FROM TRENER 
JOIN KLIENTTRENER ON TRENER.IDTRENER = KLIENTTRENER.IDTRENER
JOIN TRENING ON KLIENTTRENER.IDTRENINGU = TRENING.IDTRENINGU
GROUP BY TRENER.IDTRENER, IMIE, NAZWISKO
HAVING COUNT(1) > 1;
