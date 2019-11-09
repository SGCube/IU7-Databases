USE MetroDB
GO

-- 1. Сотрудники станций второй ветки метро, рабочий день которых
-- начинается не раньше 8:00:00.
SELECT DISTINCT Workers.Name, Workers.Job, Stations.Name
FROM Workers JOIN Stations on Stations.ID = Workers.Station_ID
WHERE Stations.Line_ID = 2 AND Workers.Start_Time >= '08:00:00'
ORDER BY Workers.Name, Workers.Job
GO

-- 2. Станции, открытые в первом десятилетии 21 века
SELECT DISTINCT Name, Line_ID
FROM Stations
WHERE Open_Date BETWEEN '2001-01-01' AND '2010-12-31'
GO

-- 3. Сотрудники метро, проживающие на улице Жуковского
SELECT DISTINCT Name, Phone_Number, Job
FROM Workers
WHERE Address LIKE 'ул. Жуковского,%'
GO

-- 4. Сотрудники станций, начинающих работу в 5:00
SELECT Name, Phone_Number, Job, Address
FROM Workers
WHERE Station_ID IN
	(
	SELECT ID
	FROM Stations
	WHERE Open_Time = '05:00:00'
	)
GO

-- 5. Депо, в которых есть составы с числом вагонов, большим 6
SELECT Depots.Name AS Depot_Name, Stations.Name AS Station_Name
FROM Depots JOIN Stations on Depots.Nearest_Station_ID = Stations.ID
WHERE EXISTS
	(
	SELECT Depot_ID
	FROM Stocks JOIN Trains on Stocks.Model_Code = Trains.Model
	WHERE Trains.Wagons_Qty > 6
	)
GO

-- 6. Станции, глубина которых больше, чем у всех станций, открытых
-- раньше 1980 года
SELECT Name, Line_ID, Open_Date
FROM Stations
WHERE Depth > ALL
	(
	SELECT Depth
	FROM Stations
	WHERE Open_Date < '1980-01-01'
	)
GO

-- 7. Общее число вагонов в депо, среднее число мест в вагонах, число моделей поездов в депо (депо №8)
SELECT SUM(TotStock.Wagons_Qty) AS 'WagonsOverall',
		AVG(TotStock.Seats_Qty) AS 'AvgSeats',
		COUNT(TotStock.Model) AS 'TrainsQty'
FROM (
	SELECT Trains.Seats_Qty, Trains.Wagons_Qty, Trains.Model
	FROM Trains JOIN (Stocks JOIN Depots on Stocks.Depot_ID = Depots.ID)
	on Trains.Model = Stocks.Model_Code WHERE Depot_ID = 8
	GROUP BY Trains.Wagons_Qty, Trains.Seats_Qty, Trains.Model
) AS TotStock
GO

-- 8. Средняя глубина станций линии и время открытия первой станции
SELECT Lines.Code,
	(
		SELECT AVG(Stations.Depth)
		FROM Stations
		WHERE Stations.Line_ID = Lines.Code
	) AS AvgDepth,
	(
		SELECT MIN(Stations.Open_Time)
		FROM Stations
		WHERE Stations.Line_ID = Lines.Code
	) AS FirstStationOpenTime
FROM Lines
GO

-- 9. Сколько лет назад открылись станции
SELECT Name, Line_ID,
	CASE YEAR(Open_Date)
		WHEN YEAR(Getdate()) THEN 'This Year'
		WHEN YEAR(GetDate()) - 1 THEN 'Last year'
		ELSE CAST(DATEDIFF(year, Open_Date, Getdate()) AS varchar(5)) + ' years ago'
	END AS 'When opened'
FROM Stations
GO

-- 10. Характер пересадок
SELECT S1Name, S2Name,
	CASE
		WHEN TransferTime <= 1 THEN 'Crossplatforming'
		WHEN TransferTime < 3 THEN 'Short'
		WHEN TransferTime < 6 THEN 'Average'
		ELSE 'Long'
	END AS TransferS
FROM
(
	SELECT S1Name, Stations.Name AS S2Name, TransferTime FROM
			Stations JOIN (SELECT Stations.Name AS S1Name,
							Transfers.ID_Station_2 AS ID2,
							Transfers.Time AS TransferTime FROM
							Stations JOIN Transfers on Stations.ID = Transfers.ID_Station_1)
							AS T1 ON Stations.ID = T1.ID2
) AS T
GO

-- 11. 
SELECT Model,
	(CAST(Wagons_Qty AS int) * CAST(Seats_Qty AS int)) AS SeatsOverall,
	YEAR(Getdate()) - Exploit_Since_y AS Exploiting
INTO #ModelExploit
FROM Trains
WHERE EXISTS
(
	SELECT Trains.Model
	FROM Trains JOIN Stocks on Trains.Model = Stocks.Model_Code
	WHERE Stocks.Qty > 10
)
GROUP BY Model, Wagons_Qty, Seats_Qty, Exploit_Since_y
GO

SELECT * FROM #ModelExploit
GO

-- 12. Сотрудники станций линий 1 и 2
SELECT Workers.Name, Workers.Job
FROM Workers JOIN
(
	SELECT ID
	FROM Stations
	WHERE Line_ID = 1
	GROUP BY Open_Time, ID
) AS Station_L1 ON Workers.Station_ID = Station_L1.ID
UNION
SELECT Workers.Name, Workers.Job
FROM Workers JOIN
(
	SELECT ID
	FROM Stations
	WHERE Line_ID = 2
	GROUP BY Open_Time, ID
) AS Station_L2 ON Workers.Station_ID = Station_L2.ID
GO

-- 13. Модели поездов, обслуживающие линии 5 и 6
SELECT Model, Exploit_Since_y
FROM Trains
WHERE EXISTS
(
	SELECT Model_Code
	FROM Stocks
	WHERE EXISTS
	(
		SELECT ID
		FROM Depots
		WHERE EXISTS
		(
			SELECT ID
			FROM Stations
			WHERE Line_ID = 5
		) AND Stocks.Depot_ID = Depots.ID
	) AND Trains.Model = Stocks.Model_Code
)
UNION
SELECT Model, Exploit_Since_y
FROM Trains
WHERE EXISTS
(
	SELECT Model_Code
	FROM Stocks
	WHERE EXISTS
	(
		SELECT ID
		FROM Depots
		WHERE EXISTS
		(
			SELECT ID
			FROM Stations
			WHERE Line_ID = 6
		) AND Stocks.Depot_ID = Depots.ID
	) AND Trains.Model = Stocks.Model_Code
)
GO

-- 14. Сведения по глубине одноплатформенных станций линий
SELECT Lines.Code,
		AVG(Stations.Depth) AS AvgDepth,
		MIN(Stations.Depth) AS MinDepth,
		MAX(Stations.Depth) AS MaxDepth
FROM Lines JOIN Stations ON Stations.Line_ID = Lines.Code
WHERE Stations.Platforms_Qty = 1
GROUP BY Lines.Code, Stations.Depth
GO

-- 15. Станции линии 5, глубина которых меньше средней
SELECT Stations.Name, Stations.Depth, Stations.Open_Date
FROM Stations
GROUP BY Stations.Name, Stations.Depth, Stations.Open_Date
HAVING Stations.Depth <
(
	SELECT AVG(Stations.Depth) AS AvgDepth
	FROM Stations
	WHERE Stations.Line_ID = 5
)
GO

-- 16. Добавление нового сотрудника
INSERT Workers(ID,Name,Sex,Birth_Date,Phone_Number,Address,Job,Station_ID,Line_Code,Start_Time,End_Time)
VALUES	(1001,'Васильев Александр Петрович','М','1980-05-20','+79150885541','ул. Вяземского, д. 3','сотрудник охраны',14,null,'05:00:10','15:00:00')

-- 17. Добавление новых сведений о составах в депо №4
INSERT Stocks(Depot_ID, Model_Code, Qty)
SELECT 4, Model, 10
FROM Trains
WHERE Seats_Qty > 40
GO

-- 18. Увеличить численный состав поездов в депо
UPDATE Stocks
SET Qty = Qty + 10
WHERE Qty < 20
GO

-- 19. Для первых трёх депо
UPDATE Stocks
SET Qty = 
(
	SELECT MAX(Stocks.Qty)
	FROM Stocks JOIN Trains on Stocks.Model_Code = Trains.Model
	WHERE Trains.Seats_Qty > 50
)
WHERE Depot_ID < 4
GO

-- 20. Убрать из депо модели, число составов которых меньше 15
DELETE Stocks
WHERE Qty < 15
