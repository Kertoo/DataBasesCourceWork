-- Zad 1 --
SELECT
	P.Nazwisko,
	P.Stanowisko,
	O.ID,
	O.Nazwa
FROM Pracownicy P
INNER JOIN Oddzialy O ON  P.ID_Oddz = O.ID
ORDER BY P.Nazwisko

-- Zad 2 --
SELECT
	P.Nazwisko,
	P.Stanowisko,
	P.ID_Oddz,
	O.Nazwa
FROM Pracownicy P INNER JOIN Oddzialy O ON  P.ID_Oddz = O.ID
WHERE O.Nazwa = 'WARSZAWA'
ORDER BY P.Nazwisko

-- Zad 3 --
SELECT
	P.Nazwisko,
	O.Nazwa,
	O.Adres,
	P.Stanowisko,
	P.Placa_pod
FROM Pracownicy P 
INNER JOIN Oddzialy O ON  P.ID_Oddz = O.ID
WHERE P.Placa_pod > 2500
ORDER BY P.Placa_pod

--Zad 4 --
SELECT
	P.Nazwisko,
	P.Stanowisko,
	P.Placa_pod,
	S.Placa_min,
	S.Placa_max
FROM Pracownicy P 
INNER JOIN Stanowiska S ON S.Stanowisko = P.Stanowisko

-- Zrozumia³em najpierw Ÿle zadanie
--SELECT
--	Pracownicy.Nazwisko,
--	Pracownicy.Stanowisko,
--	Pracownicy.Placa_pod,
--	Temp.Placa_min,
--	Temp.Placa_max
--FROM Pracownicy INNER JOIN (
--	SELECT Placa_min = MIN(Placa_pod), Placa_max = MAX(Placa_pod), Stanowisko
--	FROM Pracownicy
--	GROUP BY Stanowisko
--) AS Temp ON Temp.Stanowisko = Pracownicy.Stanowisko

-- Zad 5 --
SELECT
	P.Nazwisko,
	P.Stanowisko,
	P.Placa_pod,
	S.Placa_min,
	S.Placa_max
FROM Pracownicy P INNER JOIN Stanowiska S
ON S.Stanowisko = P.Stanowisko
WHERE P.Stanowisko = 'BRYGADZISTA' AND NOT P.Placa_pod BETWEEN S.Placa_min AND S.Placa_max

-- Zad 6 --
SELECT
	P.Nazwisko,
	P.Stanowisko,
	O.Nazwa,
	P.Placa_pod
FROM Pracownicy P 
INNER JOIN Oddzialy O ON P.ID_Oddz = O.ID
WHERE NOT P.Stanowisko = 'PRAKTYKANT'
ORDER BY P.Placa_pod DESC

-- Zad 7 --
SELECT
	P.Nazwisko,
	P.Stanowisko,
	O.Nazwa,
	Roczna_placa_min = P.Placa_pod * 12
FROM Pracownicy P INNER JOIN Oddzialy O
ON P.ID_Oddz = O.ID
WHERE P.Placa_pod * 12 > 15000
ORDER BY P.Nazwisko

-- Zad 8 --
SELECT
	P.ID,
	P.Nazwisko,
	P.Szef,
	SZ.Nazwisko
FROM Pracownicy P
INNER JOIN Pracownicy SZ ON SZ.ID = P.Szef

-- Zad 9 --
SELECT
	A.ID,
	A.Nazwisko,
	A.Szef,
	B.Nazwisko
FROM Pracownicy A 
LEFT JOIN Pracownicy B ON B.ID = A.Szef

-- Zad 10 --
SELECT
	O.ID,
	Oddzia³             = O.Nazwa,
	[Iloœæ pracowników] = COUNT(P.ID_Oddz),
	[Œrednia p³aca]     = AVG(P.Placa_pod + ISNULL(P.Placa_dod, 0))
FROM Pracownicy P 
RIGHT JOIN Oddzialy O ON P.ID_Oddz = O.ID
GROUP BY O.ID, O.Nazwa

-- Zad 11 --
SELECT
	SZ.Nazwisko,
	[Iloœæ podw³adnych] = COUNT(*)
FROM Pracownicy SZ
INNER JOIN Pracownicy P ON SZ.ID = P.Szef
GROUP BY SZ.Nazwisko
ORDER BY COUNT(*) DESC

-- Zad 12 --
SELECT
	P.Nazwisko,
	P.Zatrudniony,
	SZ.Nazwisko,
	SZ.Zatrudniony,
	[Iloœæ miesiêcy] = DATEDIFF(MONTH, SZ.Zatrudniony, P.Zatrudniony)
FROM Pracownicy SZ
INNER JOIN Pracownicy P ON SZ.ID = P.Szef
WHERE DATEDIFF(DAY, SZ.Zatrudniony, P.Zatrudniony) < 3650

-- Zad 13 --
SELECT Nazwisko, Zatrudniony 
FROM Pracownicy
WHERE YEAR(Zatrudniony) = 1992
UNION
SELECT Nazwisko, Zatrudniony 
FROM Pracownicy
WHERE YEAR(Zatrudniony) = 1993

-- Zad 14 --
SELECT Nazwisko, Zatrudniony 
FROM Pracownicy
WHERE YEAR(Zatrudniony) = 1992 OR YEAR(Zatrudniony) = 1993

-- Zad 15 --
SELECT
	ID = O.ID
FROM Pracownicy P 
LEFT JOIN Oddzialy O ON P.ID_Oddz = O.ID
GROUP BY O.ID, O.Nazwa
EXCEPT 
SELECT ID
FROM Oddzialy

-- Zad 16 --
SELECT O.ID
FROM Pracownicy P 
RIGHT JOIN Oddzialy O ON P.ID_Oddz = O.ID
GROUP BY O.ID, O.Nazwa
HAVING COUNT(P.ID_Oddz) = 0