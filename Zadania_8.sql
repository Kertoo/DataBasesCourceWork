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
