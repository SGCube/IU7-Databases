USE MetroDB
GO

SELECT DISTINCT Workers.Name, Workers.Job, Workers.Phone_Number
FROM Workers
WHERE Workers.Station_ID = 1
FOR XML AUTO, ELEMENTS
GO

SELECT DISTINCT Workers.Name, Workers.Job, Workers.Phone_Number
FROM Workers
WHERE Workers.Station_ID = 1
FOR XML RAW, ELEMENTS
GO

SELECT DISTINCT Workers.Name, Workers.Job, Workers.Phone_Number
FROM Workers
WHERE Workers.Station_ID = 1
FOR XML PATH('Workers'), ELEMENTS
GO

SELECT DISTINCT 1 AS Tag, NULL AS PARENT, Name AS 'Station!1!Name', Line_ID AS 'Station!1!Line_ID'
FROM Stations
WHERE Stations.Depth > 50
FOR XML EXPLICIT
GO