USE MetroDB
GO

-- 1. Простая хранимая процедура
DROP PROCEDURE AddTrains
GO

CREATE PROCEDURE AddTrains(@Model nvarchar(10), @Amount int)
AS
BEGIN
	UPDATE Stocks
	SET Qty = Qty + @Amount WHERE Model_Code = @Model
END
GO

DROP TABLE IF EXISTS #Stocks_Before
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

EXECUTE AddTrains '2', -15;
GO

SELECT Stocks.Depot_ID, Qty, QtyBefore
FROM Stocks JOIN #Stocks_Before
ON Stocks.Depot_ID = #Stocks_Before.Depot_ID AND 
Stocks.Model_Code = #Stocks_Before.Model_Code
WHERE Stocks.Model_Code = '2'
GO

DROP TABLE #Stocks_Before
EXECUTE AddTrains '10', -10;
EXECUTE AddTrains '2', -4;
GO
