-- Constraints

USE MetroDB
GO

ALTER TABLE Lines ADD
	CONSTRAINT PK_Code PRIMARY KEY(Code)
GO

ALTER TABLE Stations ADD
	CONSTRAINT PK_ID PRIMARY KEY(ID),
	CONSTRAINT FK_Line_ID FOREIGN KEY(Line_ID) REFERENCES Lines(Code),
	CHECK (Station_State IN ('Работает', 'Закрыта', 'Строится')),
	CHECK (Platforms_Qty > 0),
	CHECK (Depth >= 0)
GO

ALTER TABLE Trains ADD
	CHECK (Wagons_Qty > 0),
	CHECK (Seats_Qty >= 0),
	CHECK (Produce_Start_y <= Exploit_Since_y AND (Produce_End_y is NULL OR Produce_Start_y <= Produce_End_y))
GO

ALTER TABLE Workers ADD
	CHECK (Sex IN ('М', 'Ж')),
	CHECK (Phone_Number LIKE '+7[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	CHECK (Birth_Date BETWEEN DATEADD(YEAR, -80, GETDATE()) AND DATEADD(YEAR, -18, GETDATE()))
GO

ALTER TABLE Depots ADD
	CONSTRAINT PK_Depot_ID PRIMARY KEY(ID),
	CONSTRAINT FK_Nearest_Station_ID FOREIGN KEY(Nearest_Station_ID) REFERENCES Stations(ID)
GO

ALTER TABLE Workers ADD
	CONSTRAINT PK_Worker_ID PRIMARY KEY(ID)
GO

ALTER TABLE Trains ADD
	CONSTRAINT PK_Model PRIMARY KEY(Model)
GO

ALTER TABLE Transfers ADD
	CONSTRAINT FK_Transfer_Station_1 FOREIGN KEY(ID_Station_1) REFERENCES Stations(ID),
	CONSTRAINT FK_Transfer_Station_2 FOREIGN KEY(ID_Station_2) REFERENCES Stations(ID),
	CHECK (Time > 0),
	CHECK (Length > 0)
GO

ALTER TABLE Stocks ADD
	CONSTRAINT FK_Stock_Depot FOREIGN KEY(Depot_ID) REFERENCES Depots(ID),
	CONSTRAINT FK_Stock_Model FOREIGN KEY(Model_Code) REFERENCES Trains(Model),
	CHECK (Qty > 0)
GO

ALTER TABLE WorkersPlaces ADD
	CONSTRAINT FK_Worker_ID FOREIGN KEY(Worker_ID) REFERENCES Workers(ID),
	CONSTRAINT FK_Station_ID FOREIGN KEY(Station_ID) REFERENCES Stations(ID),
	CONSTRAINT FK_Line_Code FOREIGN KEY(Line_Code) REFERENCES Lines(Code)
GO


