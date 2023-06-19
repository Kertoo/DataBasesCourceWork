-- Przygotowanie --
IF OBJECT_ID('Zatrudnieni') IS NOT NULL DROP TABLE Zatrudnieni 
SELECT * INTO Zatrudnieni FROM dbo.Pracownicy

-- Sprawdzenie czy dzia³a
SELECT * FROM Zatrudnieni

-- Zad 1 --
UPDATE Zatrudnieni SET Placa_pod = 1600 WHERE ID = 170

-- Sprawdzian
-- w nowej tabeli
SELECT * FROM Zatrudnieni WHERE ID = 170

-- w oryginalnej
SELECT * FROM Pracownicy WHERE ID = 170

-- Zad 2 --
UPDATE Zatrudnieni 
SET 
	ID_Oddz = 10,
	Zatrudniony = DATEADD(MONTH, 1, Zatrudniony)
WHERE Nazwisko IN ('ZABLOCKI', 'KOPROWSKI')

-- Sprawdzian
-- w nowej tabeli
SELECT * FROM Zatrudnieni 
WHERE Nazwisko IN ('ZABLOCKI', 'KOPROWSKI')

-- w oryginalnej
SELECT * FROM Pracownicy
WHERE Nazwisko IN ('ZABLOCKI', 'KOPROWSKI')

-- Zad 3 --
INSERT INTO Zatrudnieni (ID, Nazwisko, Stanowisko, Szef, Zatrudniony, Placa_pod, Placa_dod, ID_Oddz)
VALUES (240, 'ADAMIAK', 'MONTER', 100, GETDATE(), PI() * 1000, 0.577 * 100, 40),
	   (250, 'ZIELINSKI', 'PRAKTYKANT', 240, GETDATE(), EXP(1) * 1000, NULL, 20)

-- Sprawdzian
-- w nowej tabeli
SELECT * FROM Zatrudnieni 
WHERE ID > 200

-- w oryginalnej
SELECT * FROM Pracownicy
WHERE ID > 200

-- Zad 4 --
UPDATE Zatrudnieni SET Placa_pod = Placa_pod + 0.1 * Sredia
FROM Zatrudnieni z
INNER JOIN (
	SELECT ID_Oddz, Sredia = AVG(Placa_pod)
	FROM Zatrudnieni
	GROUP BY ID_Oddz
) s ON z.ID_Oddz = s.ID_Oddz

-- Sprawdzian
-- w nowej tabeli
SELECT Placa_pod 
FROM Zatrudnieni 
ORDER BY Placa_pod DESC

-- w oryginalnej
SELECT Placa_pod, [Œrednia na 10] = 0.1 * Sredia
FROM Pracownicy p
INNER JOIN (
	SELECT ID_Oddz, Sredia = AVG(Placa_pod)
	FROM Pracownicy
	GROUP BY ID_Oddz
) s ON p.ID_Oddz = s.ID_Oddz
ORDER BY Placa_pod DESC

-- niewielkie ró¿nice spowodowane s¹ dodaniem dwóch nowych pracowników


-- Zad 5 --

UPDATE Zatrudnieni 
SET Placa_dod = (
	SELECT Srednia = AVG(Placa_pod)
	FROM Zatrudnieni
	WHERE Szef = (
		SELECT ID
		FROM Zatrudnieni
		WHERE Nazwisko LIKE 'BRZEZINSKI'
	)
	GROUP BY Szef
)
WHERE ID_Oddz = 20

-- Sprawdzian
-- w nowej tabeli
SELECT * FROM Zatrudnieni 
WHERE ID_Oddz = 20

-- w oryginalnej
SELECT * FROM Pracownicy
WHERE ID_Oddz = 20

-- Zad 6 --
-- Troche inaczej ni¿ Pan sugeruje w pliku z wykorzystaniem faktu, ¿e:
-- max(x, y) = (x + y + |x - y|) / 2
-- dla liczb rzeczywistych

-- Sprawdzian
-- Aktualnie
SELECT Placa_pod FROM Zatrudnieni

-- UPDATE
UPDATE Zatrudnieni 
SET Placa_pod = 0.5 * (Placa_pod + (SELECT AVG(Placa_pod) FROM Zatrudnieni) + ABS(Placa_pod - (SELECT AVG(Placa_pod) FROM Zatrudnieni)))
FROM Zatrudnieni

-- Sprawdzian
-- Po operacji
SELECT Placa_pod FROM Zatrudnieni

-- Zad 7 --

-- Sprawdzian
-- Aktualnie
SELECT 
	Placa_pod, 
	LATA = DATEDIFF(year, Zatrudniony, GETDATE()) 
FROM Zatrudnieni

-- UPDATE
UPDATE Zatrudnieni 
SET Placa_pod = 1.15 * Placa_pod
FROM Zatrudnieni
WHERE DATEDIFF(year, Zatrudniony, GETDATE()) > 10

-- Sprawdzian
-- Po operacji
SELECT 
	Placa_pod, 
	LATA = DATEDIFF(year, Zatrudniony, GETDATE()) 
FROM Zatrudnieni

-- Zad 8 --

-- Sprawdzian
-- Aktualnie
SELECT *
FROM Zatrudnieni

-- Usuwanie
DELETE FROM Zatrudnieni
WHERE ID_Oddz = 10

-- Sprawdzian
-- Po operacji
SELECT *
FROM Zatrudnieni

-- Zad 9 --

-- Sprawdzian
-- Aktualnie
SELECT *
FROM Zatrudnieni

-- Usuwanie
DELETE FROM Zatrudnieni
WHERE Szef IN (
	SELECT ID
	FROM Zatrudnieni
	WHERE Nazwisko LIKE 'BRZEZINSKI' OR Nazwisko LIKE 'MALINOWSKI'
)

-- Sprawdzian
-- Po operacji
SELECT *
FROM Zatrudnieni
