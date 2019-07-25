-- Exercises for section 4
-- 4.1
SELECT s.StartDate, s.EndDate
FROM Semester AS s JOIN PaperInstance AS [pi] ON s.SemesterID=[pi].SemesterID
WHERE [pi].PaperID='IN511';

-- 4.2
SELECT DISTINCT p.FullName
FROM Person AS p JOIN Enrolment AS e ON p.PersonID=e.PersonID
WHERE e.PaperID='IN511';

-- 4.3
SELECT DISTINCT p.FullName
FROM Person AS p LEFT JOIN Enrolment AS e ON p.PersonID=e.PersonID
WHERE e.PersonID IS NULL;
SELECT DISTINCT P.FullName
FROM Enrolment AS e RIGHT JOIN Person AS p ON e.PersonID=p.PersonID
WHERE e.PersonID IS NULL;

-- 4.4
SELECT p.PaperName
FROM Paper AS p LEFT JOIN PaperInstance AS [pi] ON p.PaperID=[pi].PaperID
WHERE [pi].PaperID IS NULL;

-- 4.5
SELECT s.StartDate, DATEDIFF(DAY,s.StartDate,s.EndDate) AS LENGTHofSemester
FROM Semester AS s JOIN PaperInstance AS [pi] ON s.SemesterID=[pi].SemesterID
WHERE [pi].PaperID='IN511';

-- 4.6
SELECT p.FullName, YEAR(s.StartDate) AS [Enrolment Year]
FROM Person AS p JOIN Enrolment AS e ON p.PersonID=e.PersonID JOIN Semester AS s ON e.SemesterID=s.SemesterID
WHERE s.StartDate BETWEEN '2018-4-12' AND '2019-08-13'
ORDER BY p.FamilyName,p.GivenName ASC;


-- Exercises for section 5
-- 5.1
SELECT p.PaperID, COUNT(p.PaperID) AS [Number of Instance]
FROM Paper AS p LEFT JOIN PaperInstance AS [pi] ON p.PaperID=[pi].PaperID
WHERE [pi].PaperID IS NOT NULL
GROUP BY p.PaperID;

-- 5.2
SELECT p.PaperID, p.PaperName, COUNT(e.PersonID) AS [Enrolment Count]
FROM Paper AS p JOIN Enrolment AS e ON p.PaperID=e.PaperID
GROUP BY p.PaperID,p.PaperName;

-- 5.3
--So confused to 5.2

-- 5.4
SELECT s.StartDate, s.EndDate, p.PaperName, COUNT(e.PersonID) AS EnrolmentCount
FROM Semester AS s JOIN PaperInstance AS [pi] ON s.SemesterID=[pi].SemesterID JOIN Paper AS p ON [pi].PaperID=p.PaperID JOIN Enrolment AS e ON [pi].PaperID=e.PaperID
GROUP BY s.StartDate,s.EndDate,p.PaperName
ORDER BY EnrolmentCount DESC;

-- 5.5
SELECT p.FullName, COUNT(e.PaperID) AS [Paper Enrolments Count]
FROM Person AS p JOIN Enrolment AS e ON p.PersonID=e.PersonID
GROUP BY p.FullName
HAVING COUNT(e.PaperID) IN (3,4,5);

