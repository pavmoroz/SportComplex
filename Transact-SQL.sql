
/* Tutaj demonstruję swoją wiedzę języka Transact-SQL tworząc dwie procedury i dwa triggiera dla mojej Bazy Danych.
Poniżej udostępniam opisy procedur i triggierów, które sam wymyśliłem i Transact-SQL kod rozwiązania */

/*
Procedura num. 1
Napisz procedurę, która będzie zwiększała o X procent zarobki tych trenerów,
którzy prowadzili nie mniej niż Y treningów.
Jeżeli nikt nie prowadził Y lub więcej treningów proszę wyświetlić odpowiedni komunikat.
Niech X, Y bedą dane wejściowe, X domyślnie będzie 10 procent.
*/

CREATE PROCEDURE powiekszWynagrodzenie
	@oIleProcent int = 10, @liczbaTreningow int
AS
	SET NOCOUNT ON
	IF(@liczbaTreningow > ALL(SELECT COUNT(1) FROM TRENER T
		JOIN KLIENTTRENER KT ON T.IDTRENER = KT.IDTRENER
		GROUP BY T.IDTRENER))
	BEGIN
			PRINT 'Żaden trener nie prowadził tyle treningów';
	END
	ELSE
	BEGIN
		DECLARE @tmpID int, @tmpLiczba int;
		DECLARE kursor CURSOR FOR
			SELECT T.IDTRENER, COUNT(1) FROM TRENER T
			JOIN KLIENTTRENER KT ON T.IDTRENER = KT.IDTRENER
			GROUP BY T.IDTRENER
			HAVING COUNT(1) >= @liczbaTreningow;
		
		OPEN kursor;
		FETCH NEXT FROM kursor INTO @tmpID, @tmpLiczba;
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
			UPDATE TRENER
			SET 
			WYNAGRODZENIE = WYNAGRODZENIE + WYNAGRODZENIE * @oIleProcent / 100
			WHERE idTrener = @tmpID;
			FETCH NEXT FROM kursor INTO @tmpID, @tmpLiczba;
		END
		CLOSE kursor;
		DEALLOCATE kursor;
	END
	
/*
Procedura num. 2
Napisz procedurę, która będzie zamieniać trenera X na Y w treningach od daty Z.
Data Z musi być weryfikowana.
Jeżeli trener X nie jest wpisany do Bazy Danych trzeba poinformować, że zamiana nie jest możliwa.
Natomiast, jeżeli trener Y nie jest wpisany trzeba go wpisać
do sali trenera X z minimalnym wynagrodzeniem i z domyślną datą urodzenia.
Należy jeszcze sprawdzać czy Y może trenować ludzi w sali X.
Niech X, Y, Z bedą dane wejściowe.
*/

CREATE PROCEDURE zamienTrenera 
	@nazwiskoZ varchar(20), @imieNa varchar(20), @nazwiskoNa varchar(20), @dataOd date
AS
	SET NOCOUNT ON
	IF (@dataOd > (SELECT MAX(dataTreningu) FROM Trening)
	OR
		@dataOd < (SELECT MIN(dataTreningu) FROM Trening))
	BEGIN
		PRINT 'Data nie jest poprawna.';
	END
	ELSE
	BEGIN
		IF NOT EXISTS (SELECT idTrener from Trener where nazwisko = @nazwiskoZ)
		BEGIN
			PRINT 'Trener ' + @nazwiskoZ + ' nie istnieje w Bazie Danych.';
		END 
		ELSE
		BEGIN
			IF NOT EXISTS (SELECT idTrener from Trener
			WHERE imie = @imieNa AND nazwisko = @nazwiskoNa)
			BEGIN
				DECLARE @tmpID INT = (SELECT MAX(idtrener) FROM Trener),
				@minWyn INT = (SELECT min(wynagrodzenie) FROM Trener),
				@sala INT = (SELECT idsala FROM Trener WHERE nazwisko = @nazwiskoZ); 

				INSERT INTO Trener(idTrener, Imie, Nazwisko, DataUrodzenia, Wynagrodzenie, idSala)
				VALUES
				(@tmpID+1, @imieNa, @nazwiskoNa,'0001-01-01', @minWyn, @sala);
			END
			ELSE
			BEGIN
				IF ((SELECT idSala FROM Trener where nazwisko = @nazwiskoZ)
				!=
					(SELECT idSala FROM Trener where nazwisko = @nazwiskoNa))
				BEGIN
					PRINT 'Trenerzy pracują w różnych salach, więc zamiana nie może zostać dokonana.';
				END
				ELSE
				BEGIN
					DECLARE @tmpIdTreningu int;
					DECLARE kursor CURSOR FOR
						SELECT idTreningu FROM KlientTrener
						WHERE idTrener = (SELECT idtrener FROM trener WHERE nazwisko = @nazwiskoZ);

					OPEN kursor;
					FETCH NEXT FROM kursor INTO @tmpIdTreningu;
					WHILE @@FETCH_STATUS = 0
					BEGIN
						UPDATE KlientTrener
						SET	IdTrener = (select idTrener from Trener where nazwisko = @nazwiskoNa)
						WHERE idTreningu = @tmpIdTreningu AND
							  idtrener = (SELECT idtrener FROM trener WHERE nazwisko = @nazwiskoZ);

						FETCH NEXT FROM kursor INTO @tmpIdTreningu;
					END
					CLOSE kursor;
					DEALLOCATE kursor;
				END
			END
		END
	END
	
/*
Triggier num. 2
Napisz triggier na wprowadzenie treningu z trenerem.
Trener nie może mieć więcej niż 2 treningi w ciągu jednego dnia.
Jeżeli ten warunek jest naruszony, wyświetl odpowiedni komunikat.
Załóżmy, że zawsze jest wpisywany tylko jeden trening.
*/

 CREATE TRIGGER iloscTreningow on KlientTrener FOR INSERT
 AS
 BEGIN
	DECLARE @iloscTreningow int, @tmpIdTren int, @tmpIdT int;
	SELECT @tmpIdTren = idTreningu, @tmpIdT = IdTrener from INSERTED;

	SELECT @iloscTreningow = COUNT(1) FROM KlientTrener KT
	JOIN Trener T ON KT.IdTrener = T.idTrener
	JOIN Trening TR ON  KT.idTreningu = TR.idTreningu
	WHERE dataTreningu = 
			(SELECT dataTreningu FROM  trening
			WHERE idTreningu = @tmpIdTren)
	AND
		T.idTrener = 
			(SELECT idTrener FROM trener
			WHERE idTrener = @tmpIdT);

	IF(@iloscTreningow > 2)
	BEGIN
		ROLLBACK;
		RAISERROR('Trener nie może mieć więcej niż 2 treningi w ciągu jednego dnia.',1,2);
	END
END

/*
Triggier num. 2
Napisz wyzwalacz na usuwanie karnetu.
Nie wolno usuwać aktywne karnety.
Jeżeli ten warunek jest naruszony, wyświetl odpowiedni komunikat.
Zakładamy, że zawsze usuwany jest jeden karnet.
*/

CREATE TRIGGER kupKar ON KupowanieKarnetu FOR DELETE
AS
BEGIN
	DECLARE @tmpId int, @ostatniaDataKupna date, @dniAktywnosci int;
	SELECT @tmpId = idCKarty FROM DELETED;

	SELECT @ostatniaDataKupna = MAX(dataOplaty) FROM DELETED
	WHERE IdCKarty = @tmpId;

	SELECT @dniAktywnosci = iloscDniAktywnosci FROM Karnet
	WHERE idKarnetu = (SELECT idKarnetu FROM DELETED
	WHERE  IdCKarty = @tmpId AND @ostatniaDataKupna = dataOplaty);

	IF(dateadd(day, @dniAktywnosci, @ostatniaDataKupna) > getDate())
	BEGIN 
		ROLLBACK;
		RAISERROR('Nie można usunąć rekordy z kupna aktywnego karnetu.',1,2);
	END
END
