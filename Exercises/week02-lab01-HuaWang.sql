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
        GROUP BY p.PaperID, p.PaperName
        ORDER BY [Starting Date] ASC
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
SELECT SemesterID, results.counts, RANK
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
SELECT PersonID, FullName, PaperID AS [Enrolled in 2009]
FROM (        
                                                    SELECT PersonID, FullName
        FROM Person
    UNION
        SELECT PersonID, PaperID
        FROM Enrolment) AS Result

-- e7.2
SELECT CONCAT(PaperName,FullName) AS Names, LEN(Names)
FROM (        
                                                            SELECT PaperName
        FROM Paper
    UNION
        SELECT FullName
        FROM Person) AS ResultSet
ORDER BY LEN(Names) DESC;