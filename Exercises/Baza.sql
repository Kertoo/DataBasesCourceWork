IF OBJECT_ID('dbo.Pracownicy','U') IS NOT NULL
	DROP TABLE dbo.Pracownicy 
	
IF OBJECT_ID('dbo.Oddzialy','U') IS NOT NULL
	DROP TABLE dbo.Oddzialy

IF OBJECT_ID('dbo.Stanowiska','U') IS NOT NULL
DROP TABLE dbo.Stanowiska 
GO

CREATE TABLE dbo.Oddzialy (
	ID INT  CONSTRAINT PK_ODDZ PRIMARY KEY,
	Nazwa VARCHAR(20),
	Adres VARCHAR(20) )

CREATE TABLE dbo.Stanowiska (
	Stanowisko VARCHAR(20) CONSTRAINT PK_STAN PRIMARY KEY,
	Placa_min MONEY,
	Placa_max MONEY)

CREATE TABLE dbo.Pracownicy (
    ID INT CONSTRAINT PK_PRAC PRIMARY KEY,
	Nazwisko VARCHAR(15),
	Stanowisko VARCHAR(20) CONSTRAINT FK_STAN REFERENCES dbo.Stanowiska(stanowisko),
	Szef INT CONSTRAINT FK_ID_SZEFA REFERENCES dbo.Pracownicy(ID),
	Zatrudniony DATE,
	Placa_pod MONEY CONSTRAINT MIN_PLACA_POD CHECK(placa_pod>100),
	Placa_dod MONEY,
	ID_Oddz INT CONSTRAINT FK_ID_ODDZ REFERENCES dbo.Oddzialy(ID))
GO

INSERT INTO dbo.Oddzialy VALUES (10,'POZNAN','Kwiatowa 3');
INSERT INTO dbo.Oddzialy VALUES (20,'WARSZAWA','al. Jerozolimskie 22');
INSERT INTO dbo.Oddzialy VALUES (30,'KRAKOW','Planty 14');
INSERT INTO dbo.Oddzialy VALUES (40,'WROCLAW','Nad Odra 16');
INSERT INTO dbo.Oddzialy VALUES (50,'GDANSK', 'Portowa 30');
GO

INSERT INTO dbo.Stanowiska VALUES ('KIEROWNIK'  ,3800.00,5500.00);
INSERT INTO dbo.Stanowiska VALUES ('BRYGADZISTA' ,2510.00, 3750.00);
INSERT INTO dbo.Stanowiska VALUES ('MONTER'  ,1300.00, 2500.00);
INSERT INTO dbo.Stanowiska VALUES ('PRAKTYKANT'  ,1150.00, 1250.00);
INSERT INTO dbo.Stanowiska VALUES ('SEKRETARKA',1270.00, 2050.00);
INSERT INTO dbo.Stanowiska VALUES ('DYREKTOR' ,8100.00,9200.00);
GO
 
INSERT INTO dbo.Pracownicy VALUES (100,'SUMINSKI'    ,'DYREKTOR'  ,NULL,'19680101',8130.00,420.50,10);
INSERT INTO dbo.Pracownicy VALUES (110,'BARTCZAK'    ,'KIEROWNIK'  ,100 ,'19730501',4350.00,210.00,40);
INSERT INTO dbo.Pracownicy VALUES (120,'MALINOWSKI'  ,'KIEROWNIK'  ,100 ,'19770901',4070.00,  NULL,30);
INSERT INTO dbo.Pracownicy VALUES (130,'BRZEZINSKI'  ,'KIEROWNIK'  ,100 ,'19680701', 4960.00,  NULL,20);
INSERT INTO dbo.Pracownicy VALUES (140,'ZABLOCKI'    ,'BRYGADZISTA'  ,130 ,'19750915', 4830.00,105.00,20);
INSERT INTO dbo.Pracownicy VALUES (150,'LEWANDOWSKI' ,'BRYGADZISTA'   ,130 ,'19770901', 2645.50,  NULL,20);
INSERT INTO dbo.Pracownicy VALUES (160,'KOPROWSKI'   ,'BRYGADZISTA'   ,130 ,'19850301', 2590.00,  NULL,20);
INSERT INTO dbo.Pracownicy VALUES (170,'JEZIERSKI'   ,'MONTER'  ,130 ,'19921001', 1439.70, 80.50,20);
INSERT INTO dbo.Pracownicy VALUES (190,'MALINIAK'    ,'MONTER'  ,140 ,'19930901', 1371.00,  NULL,20);
INSERT INTO dbo.Pracownicy VALUES (180,'BOGULA'      ,'SEKRETARKA',100 ,'19850220', 1410.20,  NULL,10);
INSERT INTO dbo.Pracownicy VALUES (200,'URBANIAK'    ,'PRAKTYKANT'  ,140 ,'19940715', 908.00,  NULL,30);
INSERT INTO dbo.Pracownicy VALUES (210,'CELINSKI'    ,'PRAKTYKANT'  ,130 ,'19931015', 950.00,170.60,30);
INSERT INTO dbo.Pracownicy VALUES (220,'KOWAL'       ,'MONTER'  ,110 ,'19930110', 1480.00,  NULL,20);
INSERT INTO dbo.Pracownicy VALUES (230,'HANTCZAK'    ,'MONTER'  ,120 ,'19920901', 1480.00, 90.00,30);
GO 

-------------------------------------------------
--   Angielski
-------------------------------------------------

IF OBJECT_ID('dbo.Branches','V') IS NOT NULL
DROP VIEW dbo.Branches
GO

CREATE VIEW dbo.Branches AS
SELECT 
	ID		= ID,
	Name	= Nazwa,
	Addr	= Adres 
FROM Oddzialy
GO

IF OBJECT_ID('dbo.Positions','V') IS NOT NULL
DROP VIEW dbo.Positions
GO

CREATE VIEW dbo.Positions AS
SELECT 
	Position	= Stanowisko,
	Salary_min	= Placa_min,
	Salary_max	= Placa_max
FROM Stanowiska
GO

IF OBJECT_ID('dbo.Employees','V') IS NOT NULL
DROP VIEW dbo.Employees
GO

CREATE VIEW dbo.Employees AS
SELECT   
	ID				= ID,
	Name			= Nazwisko,
	Position		= Stanowisko,
	Boss			= Szef,
	Employed		= Zatrudniony,
	Salary_base		= Placa_pod, 
	Salary_ext		= Placa_dod,
	Branch			= ID_Oddz
FROM Pracownicy
GO

-------------------------------------------------
--   Turecki
-------------------------------------------------

IF OBJECT_ID('dbo.Subeler','V') IS NOT NULL
DROP VIEW dbo.Subeler
GO

CREATE VIEW dbo.Subeler AS
SELECT 
	ID		= ID,
	Ad		= Nazwa,
	Adres	= Adres 
FROM Oddzialy
GO

IF OBJECT_ID('dbo.Pozisyonlar','V') IS NOT NULL
DROP VIEW dbo.Pozisyonlar
GO

CREATE VIEW dbo.Pozisyonlar AS
SELECT 
	Pozisyonu	= Stanowisko,
	Maas_min	= Placa_min,
	Maas_max	= Placa_max
FROM Stanowiska
GO

IF OBJECT_ID('dbo.Personel','V') IS NOT NULL
DROP VIEW dbo.Personel
GO

CREATE VIEW dbo.Personel AS
SELECT   
	ID				= ID,
	Ad				= Nazwisko,
	Pozisyonu		= Stanowisko,
	Patron			= Szef,
	Istihdam		= Zatrudniony,
	Maas_bir		= Placa_pod, 
	Maas_ek			= Placa_dod,
	ID_Subeler		= ID_Oddz
FROM Pracownicy
GO

