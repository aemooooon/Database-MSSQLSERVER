USE [wangh21_IN705Assignment1]
GO


DECLARE @customerID INT
DECLARE @quoteID INT

EXEC @customerID = createCustomer 'Bimble & Hat', '444 5555', '123 Digit Street, Dunedin', 'guy.little@bh.biz.nz'

INSERT INTO Customer
    (CustomerID)
VALUES
    (@customerID)

EXEC @quoteID = createQuote 'Craypot frame', NULL, NULL, NULL, @customerID