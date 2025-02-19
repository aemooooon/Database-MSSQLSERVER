-- Script for SelectTopNRows command from SSMS  

--SELECT TOP (1000) [PaperID]
--      ,[SemesterID]
--      ,[PersonID]
--  FROM [IN705_201902_kwood].[dbo].[Enrolment]
  
--  Week 2 labs are due on Friday 16 August

-- 13.1 Develop a stored procedure [EnrolmentCount] that accepts a paperID
--		and a semesterID and calculates the number of enrolments in the 
--		relevant paper instance. It returns the enrolment count as an
--		output parameter.
ALTER PROC EnrolmentCount1(@PaperID nvarchar(10), @SemesterID char(6), @EnrolmentCount int OUTPUT)
AS
SELECT @EnrolmentCount=COUNT(*) FROM Paper p JOIN Enrolment e ON p.PaperID=e.PaperID
WHERE e.PaperID=@PaperID AND e.SemesterID=@SemesterID
GO

DECLARE @EnrolmentCount int
EXEC EnrolmentCount1 'IN510','2019S2', @EnrolmentCount OUTPUT
PRINT @EnrolmentCount
		
--13.2	Re-develop stored procedure [EnrolmentCount] so that semesterID
--		is optional and defaults to the current semester. If there is no
--		current semester, it chooses the most recent semester. 
ALTER PROC EnrolmentCount2(@PaperID nvarchar(10), @SemesterID char(6)=NULL, @EnrolmentCount int OUTPUT)
AS
BEGIN
	BEGIN
	IF @SemesterID IS NULL
		BEGIN
		IF (SELECT SemesterID FROM Semester s WHERE GETDATE() BETWEEN s.StartDate AND s.EndDate) IS NOT NULL
			SET @SemesterID = (SELECT SemesterID FROM Semester s WHERE GETDATE() BETWEEN s.StartDate AND s.EndDate) --current semester
		ELSE
			SET @SemesterID = (SELECT TOP 1 SemesterID FROM Semester s WHERE GETDATE()> s.EndDate ORDER BY s.EndDate DESC) -- most recent semester
		END
	END
SELECT @EnrolmentCount=COUNT(*) FROM Paper p JOIN Enrolment e ON p.PaperID=e.PaperID
WHERE e.PaperID=@PaperID AND e.SemesterID=@SemesterID
END
GO

select * from Enrolment
go

DECLARE @EnrolmentCount int
EXEC EnrolmentCount2 'IN238',NULL, @EnrolmentCount OUTPUT
PRINT @EnrolmentCount

--13.3  Write the script you will need to test 13.2 hint: you may have to cast your output.
	
		