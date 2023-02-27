-- Zad 1 --
SELECT * FROM Oddzialy

-- Zad 2 --
SELECT * FROM Pracownicy

-- Zad 3  i 4 --
SELECT Nazwisko, [P³aca roczna] = (Placa_pod + ISNULL(Placa_dod, 0)) * 12 
FROM Pracownicy ORDER BY [P³aca roczna] ASC

SELECT Nazwisko, [P³aca roczna] = (Placa_pod + ISNULL(Placa_dod, 0)) * 12 
FROM Pracownicy ORDER BY [P³aca roczna] DESC

-- Zad 5 --
SELECT Nazwisko, Stanowisko, [P³aca miesiêczna] = (Placa_pod + ISNULL(Placa_dod, 0)) 
FROM Pracownicy

-- Zad 6 --
SELECT * FROM Oddzialy ORDER BY Nazwa

-- Zad 7 --
SELECT DISTINCT Stanowisko FROM Pracownicy

-- Zad 8 --
SELECT * FROM Pracownicy WHERE Stanowisko = 'KIEROWNIK'

-- Zad 9 --
SELECT ID, Stanowisko, Placa_pod, ID_Oddz 
FROM Pracownicy WHERE ID_Oddz IN (30, 40)
ORDER BY Placa_pod DESC

-- Zad 10 --
SELECT * FROM Pracownicy
WHERE Placa_pod BETWEEN 1300 AND 1800

-- Zad 11 --
SELECT Pracownicy.Nazwisko, Pracownicy.Stanowisko, [Oddzia³] = Oddzialy.Nazwa FROM Pracownicy, Oddzialy 
WHERE Nazwisko LIKE '%ski%' AND Oddzialy.ID = Pracownicy.ID_Oddz

-- Zad 12 --
SELECT ID, Szef, Nazwisko, Placa_pod FROM Pracownicy 
WHERE Placa_pod > 2000 AND Szef IS NOT NULL

-- Zad 13 --
SELECT Nazwisko, Oddzia³ = ID_Oddz FROM Pracownicy
WHERE ID_Oddz = 20 AND Nazwisko LIKE '^M' OR Nazwisko LIKE '%ski'

-- Zad 14 --
