-- Zad 1 --
SELECT 
	Nazwisko, 
	Stanowisko
FROM Pracownicy
WHERE ID_Oddz = (
	SELECT ID_Oddz
	FROM Pracownicy
	WHERE Nazwisko = 'KOWAL'
)

-- Zad 2 --
SELECT 
	Nazwisko, 
	Stanowisko,
	Zatrudniony
FROM Pracownicy
WHERE Zatrudniony = (
	SELECT MIN(Zatrudniony)
	FROM Pracownicy
	WHERE Stanowisko = 'KIEROWNIK'-- W teorii mog� istnie� osoby zatrudnione na innym stanowisku
) AND Stanowisko = 'KIEROWNIK'    -- tego samego dnia st�d dodatkowy warunek

-- Zad 3 --
SELECT 
	P.Nazwisko,
	P.Stanowisko,
	P.Zatrudniony
FROM Pracownicy P INNER JOIN (
	SELECT M = MAX(Zatrudniony) 
	FROM Pracownicy
	GROUP BY ID_Oddz
) T ON T.M = P.Zatrudniony

-- Zad 4 --
SELECT 
	O.ID,
	O.Nazwa
FROM Oddzialy O LEFT JOIN (
	SELECT DISTINCT ID_Oddz
	FROM Pracownicy
) T ON O.ID = T.ID_Oddz
WHERE T.ID_Oddz IS NULL

-- Zad 5 --
SELECT 
	P.Nazwisko,
	P.Stanowisko,
	P.Placa_pod,
	�rednia = T.mean
FROM Pracownicy P INNER JOIN (
	SELECT
		mean = AVG(Placa_pod),
		Stanowisko
	FROM Pracownicy
	GROUP BY Stanowisko
) T ON P.Stanowisko = T.Stanowisko
WHERE T.mean < P.Placa_pod

-- Zad 6 --
SELECT 
	P.Nazwisko,
	P.Stanowisko,
	[P�aca podstawowa pracownika] = P.Placa_pod,
	P.Szef,
	[P�aca podstawowa szefa] = Sz.Placa_pod
FROM Pracownicy P INNER JOIN (
	SELECT
		ID,
		Placa_pod
	FROM Pracownicy
) Sz ON P.Szef = Sz.ID
WHERE Sz.Placa_pod * 0.75 <= P.Placa_pod

-- Zad 7 --
SELECT
	Nazwisko,
	Stanowisko
FROM Pracownicy
WHERE Stanowisko = 'KIEROWNIK' AND ID NOT IN (
	SELECT Szef
	FROM Pracownicy
	WHERE Stanowisko = 'PRAKTYKANT'
	GROUP BY Szef
)


-- Sprawdzamy, �e faktycznie si� zgadza
--SELECT
--	[Nazwisko szefa] = Sz.Nazwisko, 
--	[Stanowisko szefa] = Sz.Stanowisko,
--	[Nazwisko pracownika] = P.Nazwisko, 
--	[Stanowisko pracownika] = P.Stanowisko
--FROM Pracownicy P 
--LEFT JOIN Pracownicy Sz ON P.Szef = Sz.ID

-- Zad 8 --
SELECT
	O.ID,
	O.Nazwa
FROM Oddzialy O
WHERE (SELECT COUNT(*)
	FROM Pracownicy
	WHERE ID_Oddz = O.ID
) = 0

-- Zad 9 --
SELECT TOP(1)
	O.ID,
	O.Nazwa,
	P.P�ace
FROM Oddzialy O
INNER JOIN (
	SELECT
		ID_Oddz,
		P�ace = SUM(Placa_pod + ISNULL(Placa_dod, 0))
	FROM Pracownicy
	GROUP BY ID_Oddz
) P ON O.ID = P.ID_Oddz
ORDER BY P.P�ace DESC

-- Zad 10 --
-- Najprostrze rozwi�zanie ale chyba nie o to chodzi�o
SELECT
	Rok = YEAR(Zatrudniony),
	Ilo�� = COUNT(*)
FROM Pracownicy
GROUP BY YEAR(Zatrudniony)
ORDER BY Rok, Ilo��

-- Sprawdzanie poprawno�ci wyniku
--SELECT Rok = YEAR(Zatrudniony) 
--FROM Pracownicy 
--ORDER BY Rok

SELECT
	Rok,
	Ilo�� = COUNT(*)
FROM (SELECT Rok = YEAR(Zatrudniony)
	  FROM Pracownicy) Y
GROUP BY Rok
ORDER BY Rok, Ilo��

-- Zad 11 --
SELECT
	Rok = YEAR(Zatrudniony),
	Ilo�� = COUNT(*)
FROM Pracownicy
GROUP BY YEAR(Zatrudniony)
HAVING COUNT(*) = (SELECT MAX(Ilo��) 
	FROM (
	SELECT Ilo�� = COUNT(*)
	FROM Pracownicy
	GROUP BY YEAR(Zatrudniony)
) C)

SELECT 
	Rok, Ilo��
FROM (SELECT
	Rok = YEAR(Zatrudniony),
	Ilo�� = COUNT(*)
FROM Pracownicy
GROUP BY YEAR(Zatrudniony)) A