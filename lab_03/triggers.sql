USE MetroDB
GO

-- 1. ������� AFTER
DROP TRIGGER TrgInsertWorker
GO 

CREATE TRIGGER TrgInsertWorker
ON Workers
AFTER INSERT
AS BEGIN
	PRINT 'Trigger "TrgInsertWorker" is working'
	SELECT * FROM Workers
END
GO

INSERT Workers(ID,Name,Sex,Birth_Date,Phone_Number,Address,Job,Station_ID,Line_Code,Start_Time,End_Time)
VALUES ((SELECT COUNT(*) FROM Workers) + 1,'�������� ��������� ��������','�','1980-05-20','+79150885541',
		'��. ����������, �. 3','��������� ������',14,null,'05:00:10','15:00:00')
GO
