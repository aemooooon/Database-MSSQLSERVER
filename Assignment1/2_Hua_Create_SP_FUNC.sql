USE [wangh21_IN705Assignment1]
GO

--drop functions and sp

drop proc createAssembly
drop proc addSubComponent
drop function dbo.getCategoryID
drop function dbo.getAssemblySupplierID
drop function dbo.getComponentIDByName
go

CREATE OR ALTER FUNCTION getCategoryID(@categoryName NVARCHAR(20))
RETURNS INT
AS
BEGIN
	RETURN(SELECT CategoryID
	FROM Category
	WHERE CategoryName=@categoryName)
END
GO


CREATE OR ALTER FUNCTION getAssemblySupplierID()
RETURNS INT
AS
BEGIN
	RETURN(SELECT ContactID
	FROM Contact
	WHERE ContactName='BIT Manufacturing Ltd.')
END
GO


CREATE OR ALTER FUNCTION getComponentIDByName(@componentName NVARCHAR(100))
RETURNS INT
AS
BEGIN
	RETURN(SELECT ComponentID
	FROM Component
	WHERE ComponentName=@componentName)
END
GO


CREATE OR ALTER PROC createAssembly(@componentID INT,
	@componentName NVARCHAR(100),
	@componentDescription NVARCHAR(1000))
AS
BEGIN
	DECLARE @categoryID INT
	DECLARE @supplierID INT
	SET @categoryID = dbo.getCategoryID('Assembly')
	SET @supplierID = dbo.getAssemblySupplierID()
	INSERT INTO Component
		(ComponentID, ComponentName,ComponentDescription,TradePrice,ListPrice,TimeToFit,CategoryID,SupplierID)
	VALUES
		(@componentID, @componentName, @componentDescription, 0, 0, 0, @categoryID, @supplierID)
END
GO


CREATE OR ALTER PROC addSubComponent(@assemblyName NVARCHAR(100),
	@subComponentName NVARCHAR(100),
	@quantity DECIMAL(10,7))
AS
BEGIN
	DECLARE @assemblyID INT
	DECLARE @subcomponentID INT
	SET @AssemblyID=dbo.getComponentIDByName(@assemblyName)
	SET @subcomponentID=dbo.getComponentIDByName(@subComponentName)
	INSERT INTO AssemblySubcomponent
		(AssemblyID,SubcomponentID,Quantity)
	VALUES
		(@assemblyID, @subcomponentID, @quantity)
END
GO

