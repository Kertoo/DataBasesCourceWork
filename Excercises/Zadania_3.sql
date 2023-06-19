-- Zad 1 --
SELECT Nazwisko, KOD = LEFT(Stanowisko, 2)+ CAST(Id as VARCHAR)
FROM Pracownicy

-- Zad 2 --
SELECT Nazwisko, WOJNA_LITEROM = REPLACE(REPLACE(REPLACE(Nazwisko, 'M','X'), 'L','X'), 'K','X')
FROM Pracownicy

-- Zad 3 --
SELECT Nazwisko FROM Pracownicy
WHERE CHARINDEX('L', Nazwisko) BETWEEN 1 AND LEN(Nazwisko) / 2

-- Zad 4 --
SELECT Nazwisko, Podwyzka = CAST(ROUND(Placa_pod * 1.15, 0, 0) as Int)
FROM Pracownicy

-- Zad 5 --
-- Zwracamy wszystkie kolumny jako typ MONEY
SELECT Nazwisko, Placa_pod, Inwestycja = CAST(Placa_pod * .2 as MONEY), 
Kapital = CAST(ROUND(Placa_pod * .2 * POWER(CAST(1.1 as float), 10.0), 2) as MONEY),
Zysk = CAST(ROUND(Placa_pod * .2 * POWER(CAST(1.1 as float), 10.0) - Placa_pod * .2, 2) as MONEY)
FROM Pracownicy

-- Zad 6 --
SELECT Nazwisko, Zatrudniony, Sta¿_w_2000 = DATEDIFF(yy, Zatrudniony, '2000-01-01')
FROM Pracownicy

-- Zad 7 --
-- w treœci zadania podany jest format MMDDYY i polecenie wybrania pracowników oddzia³u 20 ale podana odpowiedŸ jest inna :)
-- w formacie DDMMYY i dla pracowników innych zespo³ów
SET LANGUAGE 'POLISH'
SELECT Nazwisko, Data_Zatrudnienia = DATENAME(MONTH, Zatrudniony) + ' ' + DATENAME(DAY, Zatrudniony) + ' ' + DATENAME(YEAR, Zatrudniony)
FROM Pracownicy WHERE ID_Oddz = 20

-- Zad 8 --
SELECT Dziœ = DATENAME(WEEKDAY, GETDATE())

-- Zad 9 --
SELECT Nazwisko, Oddzia³ = ID_Oddz, 
Region = CASE 
	WHEN ID_Oddz IN (10, 20) THEN 'POLSKA CENTRALNA'
	WHEN ID_Oddz IN (30, 40) THEN 'POLSKA PO£UDNIOWA'
	WHEN ID_Oddz = 50		 THEN 'POLSKA PÓ£NOCNA'
END FROM Pracownicy

-- Zad 10 --
SELECT Nazwisko, Placa_pod, 
Próg = CASE 
	WHEN Placa_pod < CAST(1480.00 as MONEY) THEN 'Poni¿ej 1480'
	WHEN Placa_pod = CAST(1480.00 as MONEY) THEN 'Równo 1480'
	WHEN Placa_pod > CAST(1480.00 as MONEY)	THEN 'Powy¿ej 1480'
END FROM Pracownicy