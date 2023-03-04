-- Zad 1 --
SELECT 
	MAXIMUM = MAX(Placa_pod), 
	MINIMUM = MIN(Placa_pod), 
	RÓ¯NICA = MAX(Placa_pod) - MIN(Placa_pod) 
FROM Pracownicy

-- Zad 2 --
SELECT STANOWISKO = Stanowisko, ŒREDNIA = AVG(Placa_pod)
FROM Pracownicy GROUP BY Stanowisko ORDER BY ŒREDNIA DESC

-- Zad 3 --
SELECT KIEROWNICY = COUNT(ID) FROM Pracownicy WHERE Stanowisko = 'KIEROWNIK'

-- Zad 4 --
SELECT ID_Oddz, SUMARYCZNE_PLACE = SUM(Placa_pod + ISNULL(Placa_dod, 0)) 
FROM Pracownicy GROUP BY ID_Oddz

-- Zad 5 --
SELECT TOP(1) MAKS_SUM_PLACA = SUM(Placa_pod + ISNULL(Placa_dod, 0)) 
FROM Pracownicy GROUP BY ID_Oddz ORDER BY MAKS_SUM_PLACA DESC

-- Zad 6 --
-- Razem z p³ac¹ dodatkow¹.
SELECT SZEF = Szef, MINIMALNA = MIN(Placa_pod + ISNULL(Placa_dod, 0))
FROM Pracownicy WHERE Szef IS NOT NULL 
GROUP BY Szef ORDER BY MINIMALNA DESC

-- Zad 7 --
SELECT ID_Oddz, ILOSC_PRAC = COUNT(ID)
FROM Pracownicy GROUP BY ID_Oddz
ORDER BY ILOSC_PRAC DESC

-- Alternatywnie je¿eli nie ma dostêpu do 
-- unikalnego identyfikatora w postaci ID

SELECT ID_Oddz, ILOSC_PRAC = COUNT(*)
FROM Pracownicy GROUP BY ID_Oddz
ORDER BY ILOSC_PRAC DESC

-- Zad 8 --
SELECT ID_Oddz, ILOSC_PRAC = COUNT(ID)
FROM Pracownicy GROUP BY ID_Oddz HAVING COUNT(ID) > 3
ORDER BY ILOSC_PRAC DESC

-- Zad 9 --
SELECT ID FROM Pracownicy
GROUP BY ID HAVING COUNT(*) > 1

-- Zad 10 --
SELECT 
	STANOWISKO = Stanowisko, 
	ŒREDNIA    = AVG(Placa_pod + ISNULL(Placa_dod, 0)), 
	LICZBA     = COUNT(*)
FROM Pracownicy WHERE YEAR(Zatrudniony) < 1991
GROUP BY Stanowisko

-- Zad 11 --
SELECT 
	ID_ODDZ    = ID_Oddz,
	STANOWISKO = Stanowisko,
	SREDNIA    = ROUND(AVG(Placa_pod + ISNULL(Placa_dod, 0)), 0),
	MAKSYMALNA = ROUND(MAX(Placa_pod + ISNULL(Placa_dod, 0)), 0)
FROM Pracownicy
GROUP BY ID_Oddz, Stanowisko HAVING Stanowisko IN ('KIEROWNIK', 'BRYGADZISTA')
ORDER BY ID_ODDZ, STANOWISKO

-- Zad 12 --
SELECT 
	ROK = YEAR(Zatrudniony), 
	ILU_PRACOWNIKOW = COUNT(*)
FROM Pracownicy
GROUP BY YEAR(Zatrudniony)
ORDER BY ROK ASC

-- Zad 13 --
SELECT
	[Ile liter] = LEN(Nazwisko),
	[W ilu nazwiskach] = COUNT(*)
FROM Pracownicy
GROUP BY LEN(Nazwisko)
ORDER BY [Ile liter] ASC

-- Zad 14 --
SELECT
	[Ile naziwsk z A] = SUM(A),
	[Ile naziwsk z E] = SUM(E)
FROM 
(SELECT
	A = CASE
	WHEN CHARINDEX('a', Nazwisko, 1) > 0 THEN 1
	ELSE 0
END,
	E = CASE
	WHEN CHARINDEX('e', Nazwisko, 1) > 0 THEN 1
	ELSE 0
END
FROM Pracownicy) AS TABLICA_AE