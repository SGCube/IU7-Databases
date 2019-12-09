USE MetroDB
GO

sp_configure 'show advanced options', 1
GO
RECONFIGURE
GO
sp_configure 'clr enabled', 1
GO
RECONFIGURE
GO
sp_configure 'clr strict security', 0
GO
RECONFIGURE
GO

CREATE ASSEMBLY SQL_CLR
FROM 'D:\Programming\education\DataBases\lab_04\sql_clr\bin\Debug\sql_clr.dll'
GO

-- 1. Скалярная функция

CREATE FUNCTION CountOpenedStations()
RETURNS INT
AS 
EXTERNAL NAME SQL_CLR.UserDefinedFunctions.CountOpenedStations
GO

SELECT dbo.CountOpenedStations() AS OpenedStations
GO

DROP FUNCTION IF EXISTS CountOpenedStations
GO

-- 2. Пользовательская агрегатная функция

CREATE AGGREGATE CountNotLess10(@value int)
RETURNS INT
EXTERNAL NAME SQL_CLR.CountNotLess10
GO

SELECT dbo.CountNotLess10(Qty) AS TrainsAmount
FROM Stocks
WHERE Depot_ID = 5
GO

DROP AGGREGATE IF EXISTS CountNotLess10
GO

-- 3. Определяемая пользователем табличная функция

CREATE FUNCTION DepotMissingTrains(@depotid int)
RETURNS TABLE
(
	Model_Name NVARCHAR(10),
	Wagons_Qty tinyint,
	Seats_Qty tinyint
)
AS
EXTERNAL NAME SQL_CLR.UserDefinedFunctions.DepotMissingTrains
GO

SELECT * FROM dbo.DepotMissingTrains(5)
GO

DROP FUNCTION IF EXISTS DepotMissingTrains
GO

-- 4. Хранимая процедура

CREATE PROCEDURE AddTrainsToStocks(@Model nvarchar(10), @Amount int)
AS
EXTERNAL NAME SQL_CLR.StoredProcedures.AddTrainsToStocks
GO

SELECT Depot_ID, Model_Code, Qty AS QtyBefore
INTO #Stocks_Before
FROM Stocks
GO

EXECUTE AddTrains '10', 10;
GO

SELECT Stocks.Depot_ID, Qty, QtyBefore
FROM Stocks JOIN #Stocks_Before
ON Stocks.Depot_ID = #Stocks_Before.Depot_ID AND 
Stocks.Model_Code = #Stocks_Before.Model_Code
WHERE Stocks.Model_Code = '10'
GO

DROP TABLE IF EXISTS #Stocks_Before
GO

DROP PROCEDURE IF EXISTS AddTrainsToStocks
GO

-- 5. Триггер

CREATE TRIGGER T_NoLineDelete ON Lines
INSTEAD OF DELETE
AS
EXTERNAL NAME SQL_CLR.Triggers.T_NoLineDelete
GO

DELETE Lines
WHERE Code = '2'
GO

DROP TRIGGER IF EXISTS NoLineDelete

-- 6. Определяемый пользователем тип данных CLR



-- -- --

DROP ASSEMBLY IF EXISTS SQL_CLR
GO