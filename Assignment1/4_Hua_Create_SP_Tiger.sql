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
    @quantity FLOAT(8)
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


CREATE TRIGGER trig_cu_AssemblySubcomponent ON AssemblySubcomponent
AFTER UPDATE
AS
BEGIN
	select * from Contact
END
GO


CREATE TRIGGER trigSupplierDelete ON Supplier
FOR DELETE
AS
BEGIN
	
	DECLARE @XYZ INT
	DECLARE @K INT
	SET @XYZ = (SELECT SupplierID FROM inserted)
	SET @K = (SELECT COUNT(*) FROM Component WHERE SupplierID=@XYZ)
	IF @K >= 1
	PRINT(@XYZ + ' HAS ' + @K + ' related components.')
END
GO


CREATE OR ALTER PROC updateAssemblyPrices
AS
BEGIN
    DECLARE @ATP FLOAT(8)
    DECLARE @ALP FLOAT(8)

    DECLARE cursor1 CURSOR FOR 
	SELECT *
    FROM
        (SELECT SUM(c.TradePrice) AS 'ATP', SUM(c.ListPrice) AS 'ALP'
        FROM Component c JOIN AssemblySubcomponent a ON c.ComponentID=a.SubcomponentID
        GROUP BY a.AssemblyID)
	AS T1

    OPEN cursor1

    FETCH NEXT FROM cursor1 INTO @ATP,@ALP

    WHILE @@FETCH_STATUS=0
	BEGIN
        print @ATP
        PRINT @ALP
        UPDATE Component 
		SET TradePrice=@ATP, ListPrice=@ALP 
		WHERE ComponentID IN
        (SELECT AssemblyID
        FROM AssemblySubcomponent
        GROUP BY AssemblyID)
        FETCH NEXT FROM cursor1 INTO @ATP,@ALP
    END
    CLOSE cursor1
    DEALLOCATE cursor1
END
GO

--BEGIN
--    DECLARE @i INT = 0;

--	DECLARE @myPrices TABLE
--	(
--        ATP FLOAT(8),
--        ALP FLOAT(8)
--	)

--    INSERT INTO @myPrices
--    SELECT top 1 SUM(c.TradePrice) AS 'ATP', SUM(c.ListPrice) AS 'ALP'
--    FROM Component c
--        JOIN AssemblySubcomponent a ON c.ComponentID=a.SubcomponentID
--    GROUP BY a.AssemblyID;

--    WHILE (@i<3)
--	BEGIN
--        UPDATE Component
--		SET TradePrice = (SELECT ATP
--        FROM @myPrices),
--        ListPrice =	(SELECT ALP
--        FROM @myPrices)
--        WHERE ComponentID IN
--        (SELECT DISTINCT AssemblyID
--        FROM AssemblySubcomponent
--        GROUP BY AssemblyID);

--        SET @i = @i + 1
--    END

--END


CREATE OR ALTER PROC testCyclicAssembly(@assemblyID INT,
    @isCyclic INT OUTPUT)
AS
BEGIN
    IF (SELECT COUNT(AssemblyID)
    FROM AssemblySubcomponent
    WHERE AssemblyID=(SELECT SubcomponentID
    FROM AssemblySubcomponent
    where SubcomponentID=@assemblyID)) >= 1
        SET @isCyclic = 1;
    ELSE
        SET @isCyclic = 0;
END
RETURN @isCyclic
GO

