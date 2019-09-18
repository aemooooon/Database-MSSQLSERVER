USE [wangh21_IN705Assignment1]
GO

DROP PROC createCustomer
DROP PROC createQuote
DROP PROC addQuoteComponent
DROP PROC updateAssemblyPrices
DROP PROC testCyclicAssembly
GO

CREATE OR ALTER PROC createCustomer(@name NVARCHAR(100),
    @phone NVARCHAR(20),
    @postalAddress NVARCHAR(255),
    @email NVARCHAR(255)=NULL,
    @www NVARCHAR(255)=NULL,
    @fax NVARCHAR(20)=NULL,
    @mobilePhone NVARCHAR(20)=NULL,
    @customerID INT OUTPUT
)
AS
BEGIN
    INSERT INTO Contact
        (ContactName, ContactPhone, ContactFax, ContactMobilePhone, ContactEmail, ContactWWW, ContactPostalAddress)
    VALUES
        (@name, @phone, @fax, @mobilePhone, @email, @www, @postalAddress);

    SET @customerID = (SELECT @@IDENTITY);
    INSERT INTO Customer
        (CustomerID)
    VALUES
        (@customerID)
END
RETURN @customerID
GO


CREATE OR ALTER PROC createQuote(@quoteDescription NVARCHAR(1000),
    @quoteDate DATETIME=NULL,
    @quotePrice MONEY=NULL,
    @quoteCompiler NVARCHAR(100)=NULL,
    @customerID INT,
    @quoteID INT OUTPUT
)
AS
BEGIN
    IF @quoteDate IS NULL SET @quoteDate = getdate()
    IF @quoteCompiler IS NULL SET @quoteCompiler=''
    INSERT INTO Quote
        (QuoteDescription, QuoteDate, QuotePrice, QuoteCompiler, CustomerID)
    VALUES
        (@quoteDescription, @quoteDate, @quotePrice, @quoteCompiler, @customerID)
    SET @quoteID = (SELECT @@IDENTITY);
END
RETURN @quoteID
GO


CREATE OR ALTER PROC addQuoteComponent(@quoteID INT,
    @componentID INT,
    @quantity DECIMAL(15,8)
)
AS
BEGIN
    DECLARE @tradePrice MONEY
    DECLARE @listPrice MONEY
    DECLARE @timeToFit DECIMAL
    SET @tradePrice = (SELECT TradePrice
    FROM Component
    WHERE ComponentID=@componentID)
    SET @listPrice = (SELECT ListPrice
    FROM Component
    WHERE ComponentID=@componentID)
    SET @timeToFit = (SELECT TimeToFit
    FROM Component
    WHERE ComponentID=@componentID)

    INSERT INTO QuoteComponent
        (ComponentID, QuoteID, Quantity, TradePrice, ListPrice, TimeToFit)
    VALUES
        (@componentID, @quoteID, @quantity, @tradePrice, @listPrice, @timeToFit)

END
GO



-- Notes: To run this Trigger you have to delete ComponentID identity Constraint
CREATE OR ALTER TRIGGER trig_cu_AssemblySubcomponent ON AssemblySubcomponent
FOR UPDATE
AS

--SET NOCOUNT ON
BEGIN
    UPDATE Component SET Component.ComponentID = (SELECT AssemblyID
    FROM inserted)
    FROM AssemblySubcomponent INNER JOIN deleted
        ON AssemblySubcomponent.AssemblyID = deleted.AssemblyID

    UPDATE Component SET Component.ComponentID = (SELECT SubcomponentID
    FROM inserted)
    FROM AssemblySubcomponent INNER JOIN deleted
        ON AssemblySubcomponent.SubcomponentID = deleted.SubcomponentID

END
GO


-- Notes: To run this Trigger you have to delete CONSTRAINT FK_Component_Supplier First
CREATE OR ALTER TRIGGER trigSupplierDelete ON Supplier
INSTEAD OF DELETE
AS
BEGIN
    DECLARE @XYZ INT
    DECLARE @K INT
    DECLARE @NAME NVARCHAR(100)
    SET @XYZ = (SELECT SupplierID
    FROM Supplier
    WHERE SupplierID=(SELECT SupplierID
    FROM deleted))
    SET @K = (SELECT COUNT(ComponentID)
    FROM Component
    WHERE SupplierID=@XYZ)
    SET @NAME = (SELECT ContactName
    FROM Contact
    WHERE ContactID=@XYZ)
    PRINT(N'Supplier '+ @NAME + N' has ' + CAST(@K AS NVARCHAR) + N' related components.')
END
GO

--delete from Supplier where SupplierID=1



CREATE OR ALTER PROC updateAssemblyPrices
AS
BEGIN
    UPDATE Component 
	SET TradePrice=T1.ATP, ListPrice=T1.ALP FROM
        Component ct JOIN
        (SELECT Tdata.AssemblyID, Tdata.ATP, Tdata.ALP
        FROM
            (SELECT a.AssemblyID, SUM(c.TradePrice) AS 'ATP', SUM(c.ListPrice) AS 'ALP'
            FROM Component c JOIN AssemblySubcomponent a ON c.ComponentID=a.SubcomponentID
            GROUP BY a.AssemblyID) AS Tdata
	    ) AS T1 ON ct.ComponentID=T1.AssemblyID
END
GO


CREATE OR ALTER PROC testCyclicAssembly(@assemblyID INT,
    @isCyclic INT OUTPUT)
AS
BEGIN
    IF (SELECT COUNT(AssemblyID)
    FROM AssemblySubcomponent
    WHERE AssemblyID=(SELECT SubcomponentID
    FROM AssemblySubcomponent
    WHERE SubcomponentID=@assemblyID)) >= 1
        SET @isCyclic = 1;
    ELSE
        SET @isCyclic = 0;
END
RETURN @isCyclic
GO

--DECLARE @A INT
--EXEC testCyclicAssembly 30801, @A output

--print @A