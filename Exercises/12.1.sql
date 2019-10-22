use Cars
GO
create schema Sales AUTHORIZATION dbo
go

use Cars
go
create schema Maintenance AUTHORIZATION dbo
go

use Cars
go
create schema Staff authorization dbo
go

create table Staff.tblStaffDetails(
	StaffID int identity(1,1) PRIMARY KEY,
	Firstname nvarchar(100) not null,
	Lastname nvarchar(100) not null
)

insert into Staff.tblStaffDetails(Firstname,Lastname) values (
'Michael','Harrington'),('Paul','Simons'),('Dave','Stern')

create table Sales.tblCarDetails(
CarID int identity(1,1) PRIMARY KEY,
VINNumber nvarchar(255) not null,
NumberOfDoors nvarchar(10) not null
)

insert into Sales.tblCarDetails(VINNumber,NumberOfDoors) values
('00001AB','4'),
('00007AS','3'),
('00006AT','3'),
('00004AY','4'),
('00002aJ','1')

create table Maintenance.tblBuildingMaintenance
(
Maintenance int identity(1,1) PRIMARY KEY,
BuldingID int NOT NULL,
Fault nvarchar(500) not null
)

insert into Maintenance.tblBuildingMaintenance(BuldingID,Fault) values
('1','Blown light'),
('2','Blocked toilet'),
('3','Broken door'),
('4','Broken window')