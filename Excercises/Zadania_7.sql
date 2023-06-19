-- Zad 1 --
IF OBJECT_ID('PRZEDMIOTY','U') IS NOT NULL 
DROP TABLE PRZEDMIOTY

IF OBJECT_ID('NAUCZYCIELE','U') IS NOT NULL 
DROP TABLE NAUCZYCIELE

IF OBJECT_ID('SZKOLY','U') IS NOT NULL 
DROP TABLE SZKOLY

IF OBJECT_ID('KADRY','U') IS NOT NULL 
DROP TABLE KADRY

IF OBJECT_ID('ETATY','U') IS NOT NULL 
DROP TABLE ETATY

IF OBJECT_ID('DZIALY','U') IS NOT NULL 
DROP TABLE DZIALY

-- Zad 2 --
IF OBJECT_ID('SZKOLY','U') IS NULL	
CREATE TABLE SZKOLY(				
	ID_szkola	INT IDENTITY(1,1),
	Nazwa		VARCHAR(30),
	Miasto		VARCHAR(30),
	PRIMARY KEY (ID_szkola)
)

SELECT * FROM SZKOLY

-- Zad 3 --
IF OBJECT_ID('NAUCZYCIELE','U') IS NULL	
CREATE TABLE NAUCZYCIELE(				
	ID_nauczyciel	INT IDENTITY(1,1),
	Nazwisko		VARCHAR(30),
	Imie			VARCHAR(30),
	Data_urodzenia  DATETIME,
	Stawka			MONEY,
	PRIMARY KEY (ID_nauczyciel)
)

SELECT * FROM NAUCZYCIELE

-- Zad 4 --
IF OBJECT_ID('PRZEDMIOTY','U') IS NULL
CREATE TABLE PRZEDMIOTY(				
	ID_przedmiot	INT IDENTITY(1,1),
	nazwa			VARCHAR(30),
	ID_szkola		INT,
	ID_nauczyciel	INT,
	PRIMARY KEY (ID_przedmiot),
	FOREIGN KEY (ID_szkola)		REFERENCES SZKOLY(ID_szkola),
	FOREIGN KEY (ID_nauczyciel)	REFERENCES NAUCZYCIELE(ID_nauczyciel)
)

SELECT * FROM PRZEDMIOTY

-- Zad 5 --
IF OBJECT_ID('DZIALY','U') IS NULL
CREATE TABLE DZIALY(				
	ID_dzial	INT NOT NULL,
	Nazwa		VARCHAR(30),
	Adres		VARCHAR(30),
	PRIMARY KEY (ID_dzial)
)

SELECT * FROM DZIALY

-- Zad 6 --
IF OBJECT_ID('ETATY','U') IS NULL
CREATE TABLE ETATY(				
	ID_etat		VARCHAR(30),
	Placa_min	MONEY,
	Placa_max	MONEY,
	PRIMARY KEY (ID_etat)
)

IF (OBJECT_ID('ETATY','U') IS NOT NULL AND
	COL_LENGTH('ETATY','Placa_min') IS NOT NULL AND
	COL_LENGTH('ETATY','Placa_max') IS NOT NULL)
ALTER TABLE ETATY ADD CONSTRAINT Placa_ok CHECK(ISNULL(Placa_min, 0) < ISNULL(Placa_max, 0))

SELECT * FROM ETATY

-- Zad 7 --
IF OBJECT_ID('KADRY','U') IS NULL
CREATE TABLE KADRY(				
	ID_pracownik	INT NOT NULL,
	Nazwisko		VARCHAR(30),
	ID_etat			VARCHAR(30),
	Szef			INT,
	Zatrudniony		DATE,
	ID_dzial		INT,
	PRIMARY KEY (ID_pracownik),
	FOREIGN KEY (ID_etat)	REFERENCES ETATY(ID_etat),
	FOREIGN KEY (ID_dzial)	REFERENCES DZIALY(ID_dzial)
)

SELECT * FROM KADRY

-- Zad 8 --
IF OBJECT_ID('ETATY','U') IS NOT NULL
	IF COL_LENGTH('ETATY','Wymagania') IS NULL
		ALTER TABLE ETATY ADD Wymagania VARCHAR(255)

SELECT * FROM ETATY

-- Zad 9 --
IF OBJECT_ID('KADRY','U') IS NOT NULL
	IF COL_LENGTH('KADRY','Pesel') IS NULL
		ALTER TABLE KADRY ADD Pesel VARCHAR(11)

SELECT * FROM KADRY

-- Zad 10 --
IF OBJECT_ID('KADRY','U') IS NOT NULL
	IF COL_LENGTH('KADRY','Pesel') IS NULL
		IF OBJECT_ID('CT_Pesel','C') IS NULL
			ALTER TABLE KADRY ADD CONSTRAINT CT_Pesel CHECK (Pesel LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')

SELECT * FROM KADRY

-- Zad 11 --
IF OBJECT_ID('ETATY','U') IS NOT NULL
	IF COL_LENGTH('ETATY','Wymagania') IS NOT NULL
		ALTER TABLE ETATY DROP COLUMN Wymagania -- Musi pan tutaj chyba uaktualniæ wiadomoœci w
		-- sekcji Modyfikacja tabeli bo tam sugeruje pan ¿eby u¿yæ DROP bez COLUMN

SELECT * FROM ETATY
-- Zad 12 --

INSERT INTO DZIALY(ID_dzial, Nazwa, Adres)
SELECT 
	ID_dzial = ID, 
	Nazwa,
	Adres
FROM Oddzialy

SELECT * FROM DZIALY

INSERT INTO ETATY(ID_etat, Placa_min, Placa_max)
SELECT 
	ID_etat = Stanowisko,
	Placa_min,
	Placa_max
FROM Stanowiska

SELECT * FROM ETATY

INSERT INTO KADRY(ID_pracownik, Nazwisko, Szef, Zatrudniony, ID_dzial)
SELECT
	ID_pracownik = ID,
	Nazwisko,
	Szef,
	Zatrudniony,
	ID_dzial = ID_Oddz
FROM Pracownicy

SELECT * FROM KADRY