USE [wangh21_IN705Assignment1]
GO


DECLARE @customerID INT
DECLARE @quoteID INT


EXEC @customerID = dbo.createCustomer 'Bimble & Hat', '444 5555', '123 Digit Street, Dunedin', 'guy.little@bh.biz.nz', NULL, NULL, NULL, NULL

EXEC @quoteID = createQuote 'Craypot frame', NULL, NULL, NULL, @customerID, NULL
EXEC addQuoteComponent @quoteID, 30935, 3
EXEC addQuoteComponent @quoteID, 30912, 8
EXEC addQuoteComponent @quoteID, 30901, 24
EXEC addQuoteComponent @quoteID, 30904, 24
EXEC addQuoteComponent @quoteID, 30933, 200
EXEC addQuoteComponent @quoteID, 30921, 150
EXEC addQuoteComponent @quoteID, 30923, 120
EXEC addQuoteComponent @quoteID, 30922, 45


--EXEC @customerID = createCustomer 'Bimble & Hat', '444 5555', '123 Digit Street, Dunedin', 'guy.little@bh.biz.nz', NULL, NULL, NULL, NULL
EXEC @quoteID = createQuote 'Craypot stand', NULL, NULL, NULL, @customerID, NULL
EXEC addQuoteComponent @quoteID, 30914, 2
EXEC addQuoteComponent @quoteID, 30903, 4
EXEC addQuoteComponent @quoteID, 30906, 4
EXEC addQuoteComponent @quoteID, 30933, 100
EXEC addQuoteComponent @quoteID, 30923, 90
EXEC addQuoteComponent @quoteID, 30922, 15


EXEC @customerID = createCustomer 'Hyperfont Modulator (International) Ltd.', '(4)213 4359', '3 Lambton Quay, Wellington', 'sue@nz.hfm.com', NULL, NULL, NULL, NULL
EXEC @quoteID = createQuote 'Phasing restitution fulcrum', NULL, NULL, NULL, @customerID, NULL
EXEC addQuoteComponent @quoteID, 30936, 3
EXEC addQuoteComponent @quoteID, 30934, 1
EXEC addQuoteComponent @quoteID, 30921, 320
EXEC addQuoteComponent @quoteID, 30922, 0.5
EXEC addQuoteComponent @quoteID, 30932, 1000