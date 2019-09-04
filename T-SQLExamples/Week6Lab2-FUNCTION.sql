/*
Types of functions

A user-defined function is a Transact-SQL or common language runtime (CLR) routine 
that accepts parameters, performs an action, such as a complex calculation, 
and returns the result of that action as a value. 
The return value can either be a scalar (single) value or a table. 

Aggregate Functions
Operate on a collection of values but return a single, summarizing value.
ex of system functions. min(), max()


Scalar Functions (Described below)
Operate on a single value and then return a single value. Scalar functions can be used wherever an expression is valid.
ex of system functions. rand(10), upper('this string')

Inline Table-Valued Function
The user-defined inline table-valued function returns a table variable as a result of actions performed by the function. 
The value of the table variable should be derived from a single SELECT statement.

Error handling is restricted in a user-defined function. A UDF does not support TRY...CATCH, @ERROR or RAISERROR.

Create function fnGetEmployee()
returns Table
As
 return (Select * from Employee) 


*/
---15.0	A scalar user-defined FUNCTION returns a single value and may take parameters.
--			Unlike a SP, a UDF cannot be used to modify data.
--			Unlike a SP, but like a VIEW, a UDF can be used in a select statement

--			


	
--15.1	Simple scalar user-defined FUNCTION
drop procedure getPaperCount
	create function getPaperCount()
	returns int
	as
	begin
		return (select count(*) from Paper)
	end

	go

	select dbo.getPaperCount() as [Paper Count] --must qualify function name with owner name when calling

print dbo.getPaperCount()

--15.2	A UDF may take parameters in the same way as a SP

	create function getLatestInstance
		( @paperID nvarchar(10)	)
	returns char(6)
	as
	begin
		return (	select top 1 s.SemesterID from PaperInstance p
					join Semester s on s.SemesterID = p.SemesterID
					where PaperID = @paperID
					order by s.StartDate desc)
	end
	go

	select dbo.getLatestInstance('IN705')
	go

--15.3	A UDF can be used in a statement, a VIEW or a SP

	create proc getLatestEnrolments
		(	@paperID nvarchar(10) = 'IN705')
	as
	select * from Enrolment
	where PaperID = @paperID
	and SemesterID = dbo.getLatestInstance(@paperID)

	go

	exec getLatestEnrolments 'IN510'
	exec getLatestEnrolments 'IN705'

--NOTE: a UDF can be really useful as a column default value in a table definition


create OR alter function IdentifySemester(@paperID nvarchar(10))
returns char(2)
as
begin
	return(select right(dbo.getLatestInstance(@paperID), 2) )
end
go

select dbo.IdentifySemester('IN605')


/*
Example

CREATE FUNCTION CtrAmount ( @Ctr_Id int(10) ) 
  RETURNS MONEY 
  AS 
  BEGIN 
      DECLARE @CtrPrice MONEY 
        SELECT @CtrPrice = SUM(amount) 
          FROM Contracts 
        WHERE contract_id = @Ctr_Id 
      RETURN(@CtrPrice) 
  END 
GO 

SELECT * FROM CtrAmount(345) 
GO

*/
-- Examples from the AdventureWorks Database
/*
USE AdventureWorks;
GO
IF OBJECT_ID (N'Sales.ufn_SalesByStore', N'IF') IS NOT NULL
    DROP FUNCTION Sales.ufn_SalesByStore;
GO
CREATE FUNCTION Sales.ufn_SalesByStore (@storeid int)
RETURNS TABLE
AS
RETURN 
(
    SELECT P.ProductID, P.Name, SUM(SD.LineTotal) AS 'YTD Total'
    FROM Production.Product AS P 
      JOIN Sales.SalesOrderDetail AS SD ON SD.ProductID = P.ProductID
      JOIN Sales.SalesOrderHeader AS SH ON SH.SalesOrderID = SD.SalesOrderID
    WHERE SH.CustomerID = @storeid
    GROUP BY P.ProductID, P.Name
);
GO




USE AdventureWorks;
GO
IF OBJECT_ID (N'dbo.ISOweek', N'FN') IS NOT NULL
    DROP FUNCTION dbo.ISOweek;
GO
CREATE FUNCTION dbo.ISOweek (@DATE datetime)
RETURNS int
WITH EXECUTE AS CALLER
AS
BEGIN
     DECLARE @ISOweek int;
     SET @ISOweek= DATEPART(wk,@DATE)+1
          -DATEPART(wk,CAST(DATEPART(yy,@DATE) as CHAR(4))+'0104');
--Special cases: Jan 1-3 may belong to the previous year
     IF (@ISOweek=0) 
          SET @ISOweek=dbo.ISOweek(CAST(DATEPART(yy,@DATE)-1 
               AS CHAR(4))+'12'+ CAST(24+DATEPART(DAY,@DATE) AS CHAR(2)))+1;
--Special case: Dec 29-31 may belong to the next year
     IF ((DATEPART(mm,@DATE)=12) AND 
          ((DATEPART(dd,@DATE)-DATEPART(dw,@DATE))>= 28))
          SET @ISOweek=1;
     RETURN(@ISOweek);
END;
GO
SET DATEFIRST 1;
SELECT dbo.ISOweek(CONVERT(DATETIME,'12/26/2004',101)) AS 'ISO Week';

*/
