--Using Transact-SQL : Exercises
--------------------------------------------------------------

--Exercises for Section 15


--15.1    Develop a view [BigPaperInstance] that finds the 10 paper instances
--		with the most enrolments. Show the paperID, paper name,
--		semesterID, start date and end date of the paper instance.
ALTER VIEW BigPaperInstance
AS
SELECT TOP 10 p.PaperID,p.PaperName,s.SemesterID,s.StartDate,s.EndDate,COUNT(e.PersonID) AS [Counts] FROM Paper p JOIN Enrolment e ON p.PaperID=e.PaperID JOIN Semester s ON e.SemesterID=s.SemesterID
GROUP BY p.PaperID,p.PaperName,s.SemesterID,s.StartDate,s.EndDate
ORDER BY [Counts] DESC



--15.2    Develop a view [SmallPaper] that finds the 10 paper instances
--		with the least (lowest number of) enrolments. Show the paperID, paper name,
--		semesterID, start date and end date of the paper instance.
CREATE VIEW SmallPaper
AS
SELECT TOP 10 p.PaperID,p.PaperName,s.SemesterID,s.StartDate,s.EndDate,COUNT(e.PersonID) AS [Counts] FROM Paper p JOIN Enrolment e ON p.PaperID=e.PaperID JOIN Semester s ON e.SemesterID=s.SemesterID
GROUP BY p.PaperID,p.PaperName,s.SemesterID,s.StartDate,s.EndDate
ORDER BY [Counts]

--15.3	Write a view that lists all the current first year students
CREATE VIEW AllCurrentStudents
AS
SELECT DISTINCT p.PersonID,p.FullName FROM Person p JOIN Enrolment e ON p.PersonID=e.PersonID
WHERE LEFT(e.SemesterID,4)=DATEPART(YEAR,GETDATE()) AND SUBSTRING(e.SemesterID,6,1)=1

--***************************************************************************************

--		You can reference a Database table even if you are not 
--		currently connected to it as long as you use its fully qualified domain name.
--		The following two questions are using the countries table in the World Database.
--		You can use this to find the FQDN for World using a new query pointed at that Database:

			select
				 @@SERVERNAME [server name],
				 DB_NAME() [database name],
				 SCHEMA_NAME(schema_id) [schema name], 
				 name [table name],
				 object_id,
				 "fully qualified name (FQN)" =
				 concat(QUOTENAME(DB_NAME()), '.', QUOTENAME(SCHEMA_NAME(schema_id)),'.', QUOTENAME(name))
			from sys.tables
			where type = 'U' -- USER_TABLE


--15.4    Develop a view [ConsonantCountry] that lists the countries that have a name
--		starting with a consonant (b c d f g h j k l m n p q r s t v w x y z).
--		Show the code and name of each country.
ALTER VIEW [ConsonantCountry]
AS
SELECT *
FROM [World].[dbo].[country]
WHERE LEFT(Name,1) IN ('b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'y', 'z')


--15.5   Develop a view [RecentlyIndependentCountry] that lists countries that 
--		gained their independence within the last 100 years. 
--		Make sure the view adjusts the resultset to take account of the date when it is run.
CREATE VIEW [RecentlyIndependentCountry]
AS
SELECT COUNT(*) AS CountryCount
FROM [World].[dbo].[country]
WHERE IndepYear 
BETWEEN DATEPART(YEAR, DATEADD(YEAR, -100, GETDATE())) 
AND DATEPART(YEAR, DATEADD(YEAR, 0, GETDATE()))