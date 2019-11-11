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
