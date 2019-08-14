--Using Transact-SQL : Exercises
--------------------------------------------------------------

--Exercises for section 12 : STORED PROCEDURE

--*In all exercises, write the answer statement and then execute it.



--e12.1		Create a SP that returns the people with a family name that 
--			starts with a vowel [A,E,I,O,U]. List the PersonID and the FullName.

CREATE PROCEDURE getPeopleIDName
AS
SELECT PersonID, FullName FROM Person
WHERE LEFT(FamilyName,1) IN ('A','E','I','O','U')
ORDER BY FamilyName;

EXEC getPeopleIDName
		
GO

--e12.2		Create a SP that accepts a semesterID parameter and returns the papers that
--			have enrolments in that semester. List the PaperID and PaperName.
CREATE PROCEDURE getPapers(@semesterID char(6))
AS
SELECT p.PaperID, p.PaperName FROM Paper p JOIN PaperInstance [pi] ON p.PaperID=[pi].PaperID JOIN Enrolment e ON [pi].SemesterID=e.SemesterID AND [pi].PaperID=e.PaperID
WHERE e.SemesterID=@semesterID;

EXEC getPapers '2019S2'

GO


--e12.3		Create a SP that creates a new semester record. the user must supply all
--			appropriate input parameters.
CREATE PROCEDURE addASemester(@SemesterID char(6), @StartDate datetime, @EndDate datetime)
AS
INSERT INTO Semester(SemesterID, StartDate, EndDate) VALUES (@SemesterID, @StartDate, @EndDate);

EXEC addASemester '2022S1','2022-02-15','2022-06-22'

GO