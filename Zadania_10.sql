-- Zad 1 --
-- Set up
IF OBJECT_ID('Zatrudnieni','U') IS NOT NULL 
DROP TABLE Zatrudnieni
GO

SELECT * INTO Zatrudnieni 
FROM dbo.Pracownicy
GO

-- Sprawdzenie
SELECT * FROM Zatrudnieni

-- Zad 2 --
IF OBJECT_ID('Podwyzka','P') IS NOT NULL 
DROP PROCEDURE Podwyzka
GO

CREATE PROCEDURE Podwyzka(
	@Oddzial INT,
	@Procent FLOAT = 15
) AS
UPDATE Zatrudnieni SET Placa_pod = Placa_pod * (1 + @Procent / 100)
WHERE ID_Oddz = @Oddzial
GO

-- Test

BEGIN TRAN--Rozpoczêcie transakcji
SELECT TOP 5 Placa_pod,* FROM Zatrudnieni
EXEC Podwyzka 10, 50 
SELECT TOP 5 Placa_pod,* FROM Zatrudnieni
ROLLBACK--Wycofanie zmian

-- Zad 3 --
IF OBJECT_ID('Podwyzka','P') IS NOT NULL 
DROP PROCEDURE Podwyzka
GO

CREATE PROCEDURE Podwyzka(
	@Oddzial INT,
	@Procent FLOAT = 15
) AS
IF @Oddzial NOT IN (SELECT DISTINCT ID_Oddz FROM Zatrudnieni)
	RAISERROR (N'B³êdny numer oddzia³u: %d', 16, 1, @Oddzial)
ELSE
	UPDATE Zatrudnieni SET Placa_pod = Placa_pod * (1 + @Procent / 100)
	WHERE ID_Oddz = @Oddzial
GO

-- Test

BEGIN TRAN--Rozpoczêcie transakcji
SELECT TOP 5 Placa_pod, * FROM Zatrudnieni

BEGIN TRY 
	EXEC Podwyzka 97,50 
	SELECT TOP 5 Placa_pod,* FROM Zatrudnieni
END TRY
BEGIN CATCH
	  SELECT
		ErrorNumber  = ERROR_NUMBER(),
		ErrorMessage = ERROR_MESSAGE();--Zwróæ tekst b³êdu
END CATCH

ROLLBACK--Wycofanie zmian

-- Zad 4 --
IF OBJECT_ID('LICZBA_PRACOWNIKOW','P') IS NOT NULL 
DROP PROCEDURE LICZBA_PRACOWNIKOW
GO

CREATE PROCEDURE LICZBA_PRACOWNIKOW (
	@Oddzial INT,
	@Liczba  INT OUTPUT
) AS BEGIN
	IF NOT EXISTS (SELECT ID FROM Oddzialy WHERE ID = @Oddzial)
		RAISERROR (N'Z³y kod oddzia³u: %d ', 16, 1, @Oddzial)
	BEGIN TRY 
		SET @Liczba = (SELECT COUNT(*) FROM Zatrudnieni WHERE ID_Oddz = @Oddzial) 
	END TRY 
	BEGIN CATCH
		  SELECT
			ErrorNumber  = ERROR_NUMBER(),
			ErrorMessage = ERROR_MESSAGE();
	END CATCH
END
GO

-- Test
BEGIN TRAN
DECLARE @Oddzial INT 
DECLARE @Liczba  INT

SET @Oddzial=10

BEGIN TRY 
	EXEC LICZBA_PRACOWNIKOW @Oddzial, @Liczba OUTPUT
	PRINT 'Liczba pracowników w oddziale: ' + CAST(@oddzial AS VARCHAR(2)) +
	' wynosi: ' + CAST(@Liczba AS VARCHAR(10))
END TRY
BEGIN CATCH 
	  SELECT 
		ErrorNumber  = ERROR_NUMBER(),
		ErrorMessage = ERROR_MESSAGE();
END CATCH
ROLLBACK

-- Zad 5 --
IF OBJECT_ID('Nowy_pracownik','P') IS NOT NULL 
DROP PROCEDURE Nowy_pracownik
GO

CREATE PROCEDURE Nowy_pracownik(
	@Nazwisko VARCHAR(30),
	@Oddzial  INT,
	@NazwiskoSzefa VARCHAR(30),
	@Placa_pod REAL,
	@Stanowisko VARCHAR(30) = 'MONTER',
	@Zatrudniony DATETIME = NULL
) AS --1. Zadeklaruj nowe zmienne @Szef i @ID typu INT
DECLARE @Szef INT
DECLARE @ID INT

--2. Ustal ID szefa na podstawie nazwiska
	SET @Szef = (SELECT ID FROM Zatrudnieni WHERE Nazwisko = @NazwiskoSzefa)

--3. Ustal nowe ID pracownika. Nowe ID jest równe MAX istniej¹cych ID + 10
	SET @ID = (SELECT ISNULL(MAX(ID),0) + 10 FROM Zatrudnieni)

--4. Jeœli data zatrudnienia nie zosta³a podana (jest NULL), pobierz datê dzisiejsz¹
	IF @Zatrudniony IS NULL SET @Zatrudniony = GETDATE() -- Sprawdza³em sql automatycznie zamienia to na poprawny format (bez godziny)

--5. Jeœli Nazwisko ju¿ istnieje wywo³aj bl¹d i zakoñcz procedurê
	IF EXISTS (SELECT ID FROM Zatrudnieni WHERE Nazwisko = @Nazwisko)
	BEGIN
		RAISERROR (N'Pracownik o nazwisku %s ju¿ istnieje', 16, 1, @Nazwisko)
		GOTO ProcEnd
	END
	
--6. Jeœli ID szefa nie jest prawid³owe wywo³aj bl¹d i zakoñcz procedurê
	IF NOT EXISTS (SELECT ID FROM Zatrudnieni WHERE Nazwisko = @NazwiskoSzefa)
	BEGIN
		RAISERROR (N'B³êdne nazwisko szefa: %s', 16, 1, @NazwiskoSzefa)
		GOTO ProcEnd
	END

--7. Je¿eli kod oddzia³u nie jest prawid³owy wywo³aj bl¹d i zakoñcz procedurê
	IF NOT EXISTS (SELECT ID FROM Oddzialy WHERE ID = @Oddzial)
	BEGIN
		RAISERROR (N'B³êdny numer oddzia³u: %d', 16, 1, @Oddzial)
		GOTO ProcEnd
	END
	
--8. Wstaw nowe dane
	INSERT INTO Zatrudnieni
	(ID, Nazwisko, ID_Oddz, Stanowisko, Szef, Zatrudniony, Placa_pod)
	VALUES (@ID, @Nazwisko, @Oddzial, @Stanowisko, @Szef, @Zatrudniony, @Placa_pod)

ProcEnd:
GO

-- Test
-- Skryp testuj¹cy procedurê(4 przypadki)
BEGIN TRAN -- Rozpoczêcie transakcji
SELECT TOP 5 * FROM Zatrudnieni WHERE Nazwisko LIKE 'B%'

-- Test 1
BEGIN TRY
	EXEC Nowy_pracownik 'BARTCZAK', 99, 'NOWAK', 1200--1. B³¹d nazwiska
	SELECT TOP 5 * FROM Zatrudnieni WHERE Nazwisko LIKE 'B%'
END TRY 
BEGIN CATCH 
	  SELECT
	  ErrorNumber  = ERROR_NUMBER(),
	  ErrorMessage = ERROR_MESSAGE();--Zwróæ komunikat b³êdu
END CATCH

--Test 2
BEGIN TRY
	  EXEC Nowy_pracownik 'BANAS', 99, 'NOWAK', 1200 --2. B³¹d szefa
	  SELECT TOP 5 * FROM Zatrudnieni WHERE Nazwisko LIKE'B%'
END TRY 
BEGIN CATCH
	  SELECT
		ErrorNumber  = ERROR_NUMBER(),
		ErrorMessage = ERROR_MESSAGE();--Zwróæ komunikat b³êdu
END CATCH

--Test 3
BEGIN TRY
	  EXEC Nowy_pracownik 'BANAS', 99, 'BRZEZINSKI', 1200 --3. B³¹d oddzia³u
	  SELECT TOP 5 * FROM Zatrudnieni WHERE Nazwisko LIKE 'B%'
END TRY
BEGIN CATCH
	  SELECT
		ErrorNumber  = ERROR_NUMBER(),
		ErrorMessage = ERROR_MESSAGE();--Zwróæ komunikat b³êdu
END CATCH

--Test 4
BEGIN TRY
	  EXEC Nowy_pracownik 'BANAS', 10, 'BRZEZINSKI', 1200--4. Paremetry prawid³owe
	  SELECT TOP 5 * FROM Zatrudnieni WHERE Nazwisko LIKE 'B%' 
END TRY
BEGIN CATCH
	  SELECT
	  ErrorNumber  = ERROR_NUMBER(),
	  ErrorMessage = ERROR_MESSAGE(); --Zwróæ komunikat b³êdu
END CATCH

ROLLBACK

-- Zad 6 --
IF OBJECT_ID('PLACA_NETTO', 'FN') IS NOT NULL
DROP FUNCTION PLACA_NETTO 
GO

CREATE FUNCTION PLACA_Netto(
	@Placa_Brutto FLOAT,
	@ProcentPodatku FLOAT
)
RETURNS FLOAT
AS
BEGIN
	RETURN(@Placa_Brutto * (1 - @ProcentPodatku / 100))
END
GO

-- Test
SELECT Netto = [LABS\s456516].PLACA_NETTO(120,30), Brutto = 120

-- Zad 7 --
IF OBJECT_ID('Silnia','FN') IS NOT NULL
DROP FUNCTION Silnia 
GO

CREATE FUNCTION Silnia (@n INT)
RETURNS INT
AS
BEGIN
	DECLARE @Wynik INT
	DECLARE @k INT
	
	SET @Wynik = 1
	SET @k = 1
	WHILE @k <= @n
	BEGIN 
		SET @Wynik = @k * @Wynik
		SET @k = @k + 1
	END
	RETURN(@Wynik)
END
GO

-- Test
SELECT 
	'1!' = [LABS\s456516].Silnia(1), 
	'2!' = [LABS\s456516].Silnia(2), 
	'3!' = [LABS\s456516].Silnia(3), 
	'4!' = [LABS\s456516].Silnia(4), 
	'5!' = [LABS\s456516].Silnia(5), 
	'6!' = [LABS\s456516].Silnia(6), 
	'0!' = [LABS\s456516].Silnia(0)

-- Zad 8 --
IF OBJECT_ID('Staz','FN') IS NOT NULL
DROP FUNCTION Staz
GO

CREATE FUNCTION Staz (@Data DATETIME)
RETURNS INT
AS
BEGIN
	RETURN(DATEDIFF(yy, @Data, GETDATE()))
END
GO

-- Test
SELECT Nazwisko, Zatrudniony, Sta¿=[LABS\s456516].Staz(Zatrudniony) FROM Zatrudnieni

-- Zad 9 --
--To ostrze¿enie z zadania 10 odnoœnie w³aœciciela tabeli mo¿e te¿ warto tutaj dodaæ
IF OBJECT_ID('[LABS\s456516].Szef', 'TR') IS NOT NULL
DROP TRIGGER [LABS\s456516].Szef 
GO


-- Swoj¹ drog¹ u Pana w pdfie komenda UPDATE jest na niebiesko nie na ró¿owo
CREATE TRIGGER Szef ON Zatrudnieni 
FOR DELETE
AS 
BEGIN
	UPDATE Zatrudnieni SET 
		Szef = NULL
	WHERE Szef IN (SELECT ID FROM deleted) 
END
GO

--Test
BEGIN TRAN

	SELECT * FROM Zatrudnieni  
	WHERE Szef IS NULL OR Szef IN('110', '120', '130')
	
	DELETE FROM Zatrudnieni WHERE ID IN ('120', '130');
	
	SELECT * FROM Zatrudnieni 
	WHERE Szef IS NULL OR Szef IN('110', '120', '130')

ROLLBACK

-- Wynik poprawny

-- Zad 10 --
IF OBJECT_ID('[LABS\s456516].Historia', 'U') IS NOT NULL 
DROP TABLE [LABS\s456516].Historia
GO

CREATE TABLE [LABS\s456516].Historia(
	ID_his	   INT IDENTITY(1,1),
	Typ		   VARCHAR(1),
	ID		   INT,
	Nazwisko   VARCHAR(30),
	Placa_pod  FLOAT,
	Stanowisko VARCHAR(20),
	ID_Oddz	   VARCHAR(20),
	Sysdate	   DATETIME DEFAULT GETDATE(),
	[User]	   VARCHAR(30) DEFAULT SUSER_SNAME()
);
GO

-- Usuwanie trigeru szef ¿eby nie pokazywa³ siê w tabeli Historia
IF OBJECT_ID('[LABS\s456516].Szef', 'TR') IS NOT NULL
DROP TRIGGER [LABS\s456516].Szef 
GO

--Tworzenie wyzwalacza
IF OBJECT_ID('[LABS\s456516].Trace', 'TR') IS NOT NULL
DROP TRIGGER [LABS\s456516].Trace
GO

CREATE TRIGGER [LABS\s456516].Trace ON [LABS\s456516].Zatrudnieni
FOR INSERT, UPDATE, DELETE
AS
BEGIN
	-- Tutaj w tych warunkach IF EXISTS u Pana jest ID_his zamiast ID
	-- a ID_his nie jest nazw¹ kolumny w Zatrudnieni (ani pracownicy)
	IF EXISTS (SELECT ID FROM inserted)
	BEGIN
		--Stare wartoœci
		IF EXISTS (SELECT ID FROM deleted)
		BEGIN
			INSERT INTO [LABS\s456516].Historia (Typ, ID, Nazwisko, Placa_pod, Stanowisko, ID_Oddz)
			SELECT 'S', ID, Nazwisko, Placa_pod, Stanowisko, ID_Oddz
			FROM deleted
		END
		--Nowe wartoœci
		INSERT INTO [LABS\s456516].Historia (Typ, ID, Nazwisko, Placa_pod, Stanowisko, ID_Oddz)
		SELECT'N', ID, Nazwisko, Placa_pod, Stanowisko, ID_Oddz
		FROM inserted 
	END ELSE BEGIN
		--Usuwane wartoœci
		IF EXISTS (SELECT ID FROM deleted)
		BEGIN
			INSERT INTO [LABS\s456516].Historia (Typ, ID, Nazwisko, Placa_pod, Stanowisko, ID_Oddz)
			SELECT 'U', ID, Nazwisko, Placa_pod, Stanowisko, ID_Oddz
			FROM deleted 
		END
	END
END
GO

-- Skrypt testuj¹cy
-- W pliku u¿ywa Pan tabeli Pracownicy nie Zatrudnieni
-- I zmiana p³acy u kowala jest z 3800 na 3800 zmieni³em bo normalnie nie by³oby widaæ zmiany
-- Doda³em te¿ usuwanie pierwszej osoby z tabeli tj. SUMINSKI, ¿eby by³o widaæ ¿e dla usuwania
-- te¿ jest poprawnie i 
BEGIN TRAN
	SELECT * FROM Historia;
	
	UPDATE [LABS\s456516].Zatrudnieni SET Placa_pod = 4200 
	WHERE Nazwisko ='KOWAL';
	
	DELETE FROM [LABS\s456516].Zatrudnieni 
	WHERE Nazwisko ='BOGULA';--brak zmian

	UPDATE [LABS\s456516].Zatrudnieni SET Placa_pod = 4200 
	WHERE Nazwisko ='BOGULA'; --brak zmian

	DELETE FROM [LABS\s456516].Zatrudnieni 
	WHERE Nazwisko ='SUMINSKI';

	SELECT * FROM Historia;
ROLLBACK