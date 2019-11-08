USE MetroDB
GO

-- 1. ���������� ������� ������ ����� �����, ������� ���� �������
-- ���������� �� ������ 8:00:00.
SELECT DISTINCT Workers.Name, Workers.Job, Stations.Name
FROM Workers JOIN Stations on Stations.ID = Workers.Station_ID
WHERE Stations.Line_ID = 2 AND Workers.Start_Time >= '08:00:00'
ORDER BY Workers.Name, Workers.Job
GO

-- 2. �������, �������� � ������ ����������� 21 ����
SELECT DISTINCT Name, Line_ID
FROM Stations
WHERE Open_Date BETWEEN '2001-01-01' AND '2010-12-31'
GO

-- 3. ���������� �����, ����������� �� ����� ����������
SELECT DISTINCT Name, Phone_Number, Job
FROM Workers
WHERE Address LIKE '��. ����������,%'
GO

-- 4. ���������� �������, ���������� ������ � 5:00
SELECT Name, Phone_Number, Job, Address
FROM Workers
WHERE Station_ID IN
	(
	SELECT ID
	FROM Stations
	WHERE Open_Time = '05:00:00'
	)
GO

-- 5. ����, � ������� ���� ������� � ������ �������, ������� 6
SELECT Depots.Name AS Depot_Name, Stations.Name AS Station_Name
FROM Depots JOIN Stations on Depots.Nearest_Station_ID = Stations.ID
WHERE EXISTS
	(
	SELECT Depot_ID
	FROM Stocks JOIN Trains on Stocks.Model_Code = Trains.Model
	WHERE Trains.Wagons_Qty > 6
	)
GO