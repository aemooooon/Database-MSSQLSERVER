-- e6.1
SELECT TOP 1 WITH TIES
    p.PaperID, p.PaperName, AVG(subTable.papercounts) AS [Average Enrolment]
From (SELECT PaperID, COUNT(PersonID) AS papercounts
    FROM Enrolment
    GROUP BY PaperID) AS subTable JOIN Paper AS p ON p.PaperID=subTable.PaperID
GROUP BY p.PaperID, p.PaperName
ORDER BY [Average Enrolment] ASC;

-- e6.2
SELECT TOP 1 WITH TIES
    p.PaperID, p.PaperName, AVG(subTable.papercounts) AS [Average Enrolment]
From (SELECT PaperID, COUNT(PersonID) AS papercounts
    FROM Enrolment
    GROUP BY PaperID) AS subTable JOIN Paper AS p ON p.PaperID=subTable.PaperID
GROUP BY p.PaperID, p.PaperName
ORDER BY [Average Enrolment] DESC;

/*
e6.3	For each paper that has a paper instance: list the paper ID, paper name, 
	starting date of the earliest instance, starting date of the most recent instance, 
	the minimum number of enrolments in the instances,
	maximum number of enrolments in the instances and 
	average number of enrolments across all	the instances.
*/
-- e6.3
SELECT top 1 with ties p.PaperID, p.PaperName, MAX(DATEDIFF(SECOND,'1970-01-01',s.StartDate)) AS [Earliest] FROM Paper p JOIN Enrolment e ON p.PaperID=e.PaperID JOIN Semester s ON e.SemesterID=s.SemesterID
GROUP BY p.PaperID, p.PaperName ORDER BY [Earliest] DESC

UNION

SELECT top 1 with ties p.PaperID, p.PaperName, MIN(DATEDIFF(SECOND,'1970-01-01',s.StartDate)) AS [Recent] FROM Paper p JOIN Enrolment e ON p.PaperID=e.PaperID JOIN Semester s ON e.SemesterID=s.SemesterID
GROUP BY p.PaperID, p.PaperName ORDER BY [Recent] ASC

UNION

        SELECT TOP 1 WITH TIES
            p.PaperID, p.PaperName, MIN(subTable.papercounts) AS [Min Enrolment]
        From (SELECT PaperID, COUNT(PersonID) AS papercounts
            FROM Enrolment
            GROUP BY PaperID) AS subTable JOIN Paper AS p ON p.PaperID=subTable.PaperID
        GROUP BY p.PaperID, p.PaperName
        ORDER BY [Min Enrolment] ASC

    UNION

        SELECT TOP 1 WITH TIES
            p.PaperID, p.PaperName, MAX(subTable.papercounts) AS [Max Enrolment]
        From (SELECT PaperID, COUNT(PersonID) AS papercounts
            FROM Enrolment
            GROUP BY PaperID) AS subTable JOIN Paper AS p ON p.PaperID=subTable.PaperID
        GROUP BY p.PaperID, p.PaperName
        ORDER BY [Max Enrolment] DESC

    UNION

        SELECT p.PaperID, p.PaperName, AVG(subTable.papercounts) AS [Average Enrolment]
        From (SELECT PaperID, COUNT(PersonID) AS papercounts
            FROM Enrolment
            GROUP BY PaperID) AS subTable JOIN Paper AS p ON p.PaperID=subTable.PaperID
        GROUP BY p.PaperID, p.PaperName
        ORDER BY [Average Enrolment] ASC

-- e6.4
SELECT top 1 with ties e.PaperID, p.FullName, LEN(FullName) AS [Length of Name] From Person p JOIN Enrolment e ON p.PersonID=e.PersonID WHERE PaperID in (
SELECT top 1 with ties PaperID FROM Enrolment GROUP BY PaperID ORDER BY COUNT(PersonID) DESC
) ORDER BY [Length of Name] DESC


-- e6.5
SELECT SemesterID, results.counts AS [Enrolment Count], RANK
() OVER
(ORDER BY counts DESC) AS Rank
FROM
    (SELECT SemesterID, COUNT(PersonID) AS [counts]
    FROM Enrolment
    GROUP BY SemesterID
)
AS results
ORDER BY counts DESC;

-- e7.1
SELECT e.PersonID, p.FullName, CONCAT('enrolled in ', e.SemesterID, ' and ', e.PaperID) AS [Reason]
FROM Enrolment AS e JOIN Person AS p 
ON e.PersonID=p.PersonID 
WHERE LEFT(SemesterID,4)='2019' AND PaperID='IN605'

-- e7.2
SELECT FullName AS [Full Name or Paer Name], LEN(FullName) AS [Number of Full Name] FROM 
((SELECT FullName FROM Person JOIN Enrolment ON Person.PersonID=Enrolment.PersonID)
UNION
(SELECT PaperName FROM Paper JOIN Enrolment ON Paper.PaperID=Enrolment.PaperID)) AS r
ORDER BY LEN(FullName) DESC