USE [wangh21_IN705Assignment1]
GO

DROP PROC createCustomer
DROP PROC createQuote
DROP PROC addQuoteComponent
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


CREATE OR ALTER PROC updateAssemblyPrices
AS
BEGIN
    DECLARE @i INT = 0;

    DECLARE @myPrices TABLE
	(
        ATP FLOAT(8),
        ALP FLOAT(8)
	)

    INSERT INTO @myPrices
    SELECT top 1
        SUM(c.TradePrice) AS 'ATP', SUM(c.ListPrice) AS 'ALP'
    FROM Component c
        JOIN AssemblySubcomponent a ON c.ComponentID=a.SubcomponentID
    GROUP BY a.AssemblyID;

    WHILE (@i<3)
	BEGIN
        UPDATE Component
		SET TradePrice = (SELECT ATP
        FROM @myPrices),
        ListPrice =	(SELECT ALP
        FROM @myPrices)
        WHERE ComponentID IN
        (SELECT DISTINCT AssemblyID
        FROM AssemblySubcomponent
        GROUP BY AssemblyID);

        SET @i = @i + 1
    END

END
GO