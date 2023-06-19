-- Zad 1 --
-- Set up
IF OBJECT_ID('Zatrudnieni','U') IS NOT NULL 
DROP TABLE Zatrudnieni
GO

SELECT * INTO Zatrudnieni FROM Pracownicy

SELECT * FROM Zatrudnieni

-- Zad 2 --
IF OBJECT_ID('BRYGADZISCI','V') IS NOT NULL DROP VIEW BRYGADZISCI 
GO 
CREATE VIEW BRYGADZISCI AS
SELECT
	ID,
	Nazwisko,
	Placa_pod,
	Lata_pracy = DATEDIFF(YEAR, Zatrudniony, GETDATE())
FROM Zatrudnieni
WHERE Stanowisko = 'BRYGADZISTA'
GO

-- Sprawdzenie czy zosta³ utworzony
SELECT * FROM BRYGADZISCI

-- Zad 3 --
IF OBJECT_ID('PLACE','V') IS NOT NULL DROP VIEW PLACE 
GO 
CREATE VIEW PLACE AS
SELECT
	ID_Oddz,
	Srednia   = AVG(Placa_pod + ISNULL(Placa_dod, 0)),
	Placa_min = MIN(Placa_pod + ISNULL(Placa_dod, 0)),
	Placa_max = MAX(Placa_pod + ISNULL(Placa_dod, 0)),
	Fundusz   = SUM(Placa_pod + ISNULL(Placa_dod, 0)),
	IL_pensji = COUNT(Placa_pod),
	IL_dod    = COUNT(Placa_dod)
FROM Zatrudnieni
GROUP BY ID_Oddz
GO

-- Sprawdzenie czy zosta³ utworzony
SELECT * FROM PLACE

-- Zad 4 --
SELECT 
	z.Nazwisko, 
	z.Placa_pod, 
	p.Srednia
FROM Zatrudnieni z
INNER JOIN PLACE p ON p.ID_Oddz = z.ID_Oddz
WHERE z.Placa_pod + ISNULL(z.Placa_dod, 0) < p.Srednia
GO

-- Zad 5 --
IF OBJECT_ID('PLACE_POD','V') IS NOT NULL DROP VIEW PLACE_POD 
GO 
CREATE VIEW PLACE_POD AS
SELECT 
	p.ID_Oddz,
	z.Nazwisko, 
	z.Placa_pod
FROM Zatrudnieni z
INNER JOIN PLACE p ON p.ID_Oddz = z.ID_Oddz
WHERE z.Placa_pod + ISNULL(z.Placa_dod, 0) = p.Placa_max
GO

-- Sprawdzenie czy zosta³ utworzony
SELECT * FROM PLACE_POD

-- Zad 6 --
IF OBJECT_ID('PLACE_MIN','V') IS NOT NULL DROP VIEW PLACE_MIN 
GO 
CREATE VIEW PLACE_MIN AS
SELECT 
	ID,
	Nazwisko,
	Placa_pod
FROM Zatrudnieni 
WHERE Placa_pod < 1500
WITH CHECK OPTION
GO

SELECT * FROM PLACE_MIN

-- Zad 7 --
UPDATE PLACE_MIN SET Placa_pod = 1700
WHERE Nazwisko = 'URBANIAK'

-- Zad 8 --

IF OBJECT_ID('ZAROBKI','V') IS NOT NULL DROP VIEW ZAROBKI 
GO 
CREATE VIEW ZAROBKI
WITH ENCRYPTION 
AS
	SELECT
		z.ID,
		z.Nazwisko,
		z.Placa_pod,
		z.Szef,
		Nazwisko_szef = s.Nazwisko,
		Placa_szef = s.Placa_pod
	FROM Zatrudnieni z
	INNER JOIN (
		SELECT ID, Nazwisko, Placa_pod
		FROM Zatrudnieni
	) s ON s.ID = z.Szef
	WHERE s.Placa_pod > z.Placa_pod
	WITH CHECK OPTION
GO

-- Zadanie 9 jest wykonane ale nie mam jak pokazaæ w .sql wiêc przesy³am w osobny pliku png