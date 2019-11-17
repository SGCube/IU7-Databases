USE MetroDB
GO

-- 1. Скалярная функция

DROP FUNCTION GetStationsNumber
GO

CREATE FUNCTION GetStationsNumber(@lineid int)
RETURNS INT AS
BEGIN
	RETURN
	(
	SELECT COUNT(*) As StationsNumber 
	FROM Stations
	WHERE Line_ID = @lineid
	GROUP BY Line_ID
	)
END
GO 

SELECT Lines.Code, dbo.GetStationsNumber(Lines.Code) AS [Number of Stations]
FROM Lines
GO
 
SELECT * FROM Stations WHERE Stations.Line_ID = 10
GO

-- 2. Подставляемая табличная функция

DROP FUNCTION getDepotMissingTrains
GO

CREATE FUNCTION getDepotMissingTrains(@depotid int)
RETURNS TABLE
AS RETURN
(
	SELECT *
	FROM Trains
	WHERE Trains.Model NOT IN
	(
		SELECT Model_Code
		FROM Stocks
		WHERE Depot_ID = @depotid
	)
)
GO

SELECT * FROM dbo.getDepotMissingTrains(10)
GO

SELECT * FROM Stocks
WHERE Depot_ID = 10
GO

-- 3. Многооператорная табличная функция

DROP FUNCTION getDepotFullInfo
GO

CREATE FUNCTION getDepotFullInfo(@DepotID int)
RETURNS @info TABLE
(ID int, Name nvarchar(50), Nearest_Station_ID int, Open_Date date, TrainsQty int)
AS
BEGIN
	INSERT @info
	SELECT ID, Name, Nearest_Station_ID, Open_Date,
		(SELECT SUM(Qty) FROM Stocks WHERE Depot_ID = @DepotID) AS TrainsQty
	FROM Depots
	WHERE Depots.ID = @DepotID
	RETURN
END
GO

SELECT * FROM getDepotFullInfo(5)
GO

-- 4. Рекурсивная функция

DROP FUNCTION lineRoute
GO

CREATE FUNCTION lineRoute(@LineID int)
RETURNS TABLE
RETURN
(
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
)
GO

SELECT * FROM lineRoute(3)
GO

SELECT * FROM lineRoute(5)
GO