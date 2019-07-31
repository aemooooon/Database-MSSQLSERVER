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

-- e6.3
SELECT p.PaperID, p.PaperName, [Starting Date], [Recent Date], [Min Enrolment], [Max Enrolment], [Average Enrolment]
FROM (                    
                                                                                                                                                                                            (
                SELECT TOP 1 WITH TIES
            p.PaperID, p.PaperName, s.StartDate AS [Starting Date]
        FROM Paper p JOIN PaperInstance AS [pi] ON Paper.PaperID=PaperInstance.PaperID JOIN Semester AS s ON PaperInstance.SemesterID=Semester.SemesterID
        ORDER BY [Starting Date] ASC GROUP BY p.PaperID, p.PaperName
        )

    UNION

        (SELECT TOP 1 WITH TIES
            p.PaperID, p.PaperName, s.StartDate AS [Recent Date]
        FROM Paper p JOIN PaperInstance AS [pi] ON Paper.PaperID=PaperInstance.PaperID JOIN Semester AS s ON PaperInstance.SemesterID=Semester.SemesterID
        GROUP BY p.PaperID, p.PaperName
        ORDER BY [Recent Date] DESC)

    UNION

        (SELECT TOP 1 WITH TIES
            p.PaperID, p.PaperName, MIN(subTable.papercounts) AS [Min Enrolment]
        From (SELECT PaperID, COUNT(PersonID) AS papercounts
            FROM Enrolment
            GROUP BY PaperID) AS subTable JOIN Paper AS p ON p.PaperID=subTable.PaperID
        GROUP BY p.PaperID, p.PaperName
        ORDER BY [Min Enrolment] ASC)

    UNION

        (SELECT TOP 1 WITH TIES
            p.PaperID, p.PaperName, MAX(subTable.papercounts) AS [Max Enrolment]
        From (SELECT PaperID, COUNT(PersonID) AS papercounts
            FROM Enrolment
            GROUP BY PaperID) AS subTable JOIN Paper AS p ON p.PaperID=subTable.PaperID
        GROUP BY p.PaperID, p.PaperName
        ORDER BY [Max Enrolment] DESC)

    UNION

        (SELECT p.PaperID, p.PaperName, AVG(subTable.papercounts) AS [Average Enrolment]
        From (SELECT PaperID, COUNT(PersonID) AS papercounts
            FROM Enrolment
            GROUP BY PaperID) AS subTable JOIN Paper AS p ON p.PaperID=subTable.PaperID
        GROUP BY p.PaperID, p.PaperName
        ORDER BY [Average Enrolment] ASC)) AS result;

-- e6.4


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
SELECT PersonID, 'F', SemesterID FROM Enrolment WHERE LEFT(SemesterID,4)='2019' AND PaperID='IN605'
UNION 
SELECT PersonID, FullName as f, 'S' FROM Person

-- e7.2
SELECT CONCAT(FullName,PaperName) AS [who takes paper], LEN(CONCAT(PaperName,FullName)) as [Length]
FROM (        
    SELECT PaperName, 'F' as FullName
        FROM Paper
    UNION
        SELECT 'P' as PaperName, FullName
        FROM Person) as r