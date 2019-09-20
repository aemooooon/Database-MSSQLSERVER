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


CREATE OR ALTER TRIGGER trig_p_c_AssemblySubcomponent ON Component
AFTER UPDATE
AS
BEGIN
	if UPDATE(ComponentID)
		BEGIN
			DECLARE @newID INT=(SELECT ComponentID FROM inserted)

			UPDATE AssemblySubcomponent SET AssemblySubcomponent.AssemblyID = @newID
			FROM AssemblySubcomponent JOIN deleted
				ON AssemblySubcomponent.AssemblyID = deleted.ComponentID

			UPDATE AssemblySubcomponent SET AssemblySubcomponent.SubcomponentID = @newID
			FROM AssemblySubcomponent JOIN deleted
				ON AssemblySubcomponent.SubcomponentID = deleted.ComponentID

			UPDATE QuoteComponent SET QuoteComponent.ComponentID = @newID
			FROM QuoteComponent JOIN deleted
				ON QuoteComponent.ComponentID = deleted.ComponentID

		END
END
GO

--update Component set ComponentID=30999 where ComponentID=30934
--GO

--update Component set ComponentID=30934 where ComponentID=30999
--GO

--select * from Component;
--go

--select * from AssemblySubcomponent;
--go

--select * from QuoteComponent;
--go



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
--select * from Supplier join Contact on Supplier.SupplierID=Contact.ContactID join Component on Component.SupplierID=Supplier.SupplierID



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

--exec dbo.updateAssemblyPrices
--go


CREATE OR ALTER PROC testCyclicAssembly(@assemblyID INT,
    @isCyclic INT OUTPUT)
AS
BEGIN
    DECLARE @tempT table(
        AssemblyID int,
        SubcomponentID int
    )

    INSERT @tempT
        (AssemblyID, SubcomponentID)
    SELECT AssemblyID, SubcomponentID
    FROM AssemblySubcomponent
    WHERE AssemblyID = @assemblyID

    WHILE @@ROWCOUNT >0
    BEGIN
        INSERT @tempT
            (AssemblyID, SubcomponentID)
        SELECT a.AssemblyID, a.SubcomponentID
        FROM @tempT t
            JOIN AssemblySubcomponent a ON a.AssemblyID = t.SubcomponentID
        WHERE a.AssemblyID NOT IN (SELECT AssemblyID
        FROM @tempT)
    END


    IF (SELECT COUNT(*)
    FROM @tempT
    WHERE SubcomponentID=@assemblyID) > 0
        SET @isCyclic = 1;
    ELSE
        SET @isCyclic = 0;
END
RETURN @isCyclic
GO

--SET NOCOUNT ON
--DECLARE @A INT
--EXEC testCyclicAssembly 30936, @A output
--print @A
--SET NOCOUNT OFF

-- --To insert new line for test, delete constraint first ne
--INSERT INTO AssemblySubcomponent (AssemblyID,SubcomponentID) VALUES (30901,30936)
--INSERT INTO AssemblySubcomponent (AssemblyID,SubcomponentID) VALUES (30934,30934)