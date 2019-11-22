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

EXECUTE AddTrains '2', 4;
GO

SELECT Stocks.Depot_ID, Qty, QtyBefore
FROM Stocks JOIN #Stocks_Before
ON Stocks.Depot_ID = #Stocks_Before.Depot_ID AND 
Stocks.Model_Code = #Stocks_Before.Model_Code
WHERE Stocks.Model_Code = '2'
GO

DROP TABLE #Stocks_Before;
GO

-- 2. Рекурсивная процедура

DROP PROCEDURE DisplayLineRoute
GO

CREATE PROCEDURE DisplayLineRoute(@LineID int)
AS
BEGIN
	WITH TunnelTransfer(ID_Station_1, ID_Station_2, Time, Level)
	AS
	(
		SELECT T.ID_Station_1, T.ID_Station_2, T.Time, 0 AS Level
		FROM Transfers AS T
		WHERE NOT EXISTS
		(
			SELECT Transfers.ID_Station_2
			FROM Transfers
			WHERE Transfers.ID_Station_2 = T.ID_Station_1
		) AND T.ID_Station_1 IN
		(
			SELECT ID
			FROM Stations
			WHERE Line_ID = @LineID
		)
		UNION ALL
		SELECT T.ID_Station_1, T.ID_Station_2, T.Time, Level + 1
		FROM Transfers AS T INNER JOIN TunnelTransfer AS T2
		ON T.ID_Station_1 = T2.ID_Station_2
		WHERE T2.ID_Station_2 IN
		(
			SELECT ID
			FROM Stations
			WHERE Line_ID = @LineID
		)
	)
	SELECT ID_Station_1, ID_Station_2, Time, Level
	FROM TunnelTransfer
END
GO

EXECUTE DisplayLineRoute 3
GO

EXECUTE DisplayLineRoute 5
GO

-- 3. Процедура с курсором
DROP Procedure LineDepots
GO

CREATE Procedure LineDepots
AS
BEGIN
	DECLARE @id nvarchar(5)
	DECLARE curs CURSOR FOR
		SELECT Lines.Code FROM Lines

	OPEN curs

	FETCH NEXT FROM curs INTO @id
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT Depots.ID, Depots.Name, St.Name AS NearestStation, St.Line_ID
			FROM Depots JOIN (SELECT ID, Line_ID, Name FROM Stations) AS St
			ON Depots.Nearest_Station_ID = St.ID WHERE St.Line_ID = @id
			FETCH NEXT FROM curs INTO @id
		END

	CLOSE curs
	DEALLOCATE curs
END
GO

EXECUTE LineDepots
GO
