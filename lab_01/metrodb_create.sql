-- Creation Code

USE MetroDB
GO

CREATE TABLE Lines(
	Code nvarchar(5) NOT NULL,
	Name nvarchar(50) NULL,
	Color varchar(20) NOT NULL
)

CREATE TABLE Stations(
	ID int NOT NULL,
	Name nvarchar(50) NOT NULL,
	Line_ID nvarchar(5) NOT NULL,
	Station_State nvarchar(20) NOT NULL,
	Open_Time time NOT NULL,
	Close_Time time NOT NULL,
	Streets nvarchar(200) NOT NULL,
	Open_Date date NOT NULL,
	Platforms_Qty tinyint NOT NULL,
	Depth float NOT NULL
)

CREATE TABLE Depots(
	ID int NOT NULL,
	Name nvarchar(50) NOT NULL,
	Nearest_Station_ID int NULL,
	Open_Date date NOT NULL
)

CREATE TABLE Trains(
	Model nvarchar(10) NOT NULL,
	Wagons_Qty tinyint NOT NULL,
	Seats_Qty tinyint NOT NULL,
	Produce_Start_y smallint NOT NULL,
	Produce_End_y smallint NULL,
	Exploit_Since_y smallint NOT NULL
)

CREATE TABLE Workers(
	ID int NOT NULL,
	Name nvarchar(100) NOT NULL,
	Sex nvarchar(1) NOT NULL,
	Birth_Date date NOT NULL,
	Phone_Number nvarchar(12) NOT NULL,
	Address nvarchar(100) NOT NULL,
	Job nvarchar(50) NOT NULL,
	Station_ID int NULL,
	Line_Code nvarchar(5) NULL,
	Start_Time time NOT NULL,
	End_Time time NOT NULL,
)

CREATE TABLE Transfers(
	ID_Station_1 int NOT NULL,
	ID_Station_2 int NOT NULL,
	Time tinyint NOT NULL,
	Length int NOT NULL
)

CREATE TABLE Stocks(
	Depot_ID int NOT NULL,
	Model_Code nvarchar(10) NOT NULL,
	Qty tinyint NOT NULL
)

