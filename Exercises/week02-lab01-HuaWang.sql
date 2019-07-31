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
--e6.4	Which paper attracts people with long names? Find the background statistics 
--	to support a hypothesis test: for each paper with enrolments calculate the mean full name length, 
--	sample standard deviation full name length & sample size (that is: number of enrolments).
SELECT PaperID, COUNT(PersonID) as rcs FROM Enrolment GROUP BY PaperID ORDER BY rcs DESC


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
--e7.1	In one result, list all the people who enrolled in a paper delivered during 2019 and
--	all the people who have enrolled in IN605. 
--	The result should have three columns: PersonID, Full Name and the reason the person
--	is on the list - either 'enrolled in 2019' or 'enrolled in IN605'

SELECT PersonID, 'F', SemesterID, PaperID FROM Enrolment WHERE LEFT(SemesterID,4)='2019' AND PaperID='IN605'
UNION 
SELECT PersonID, FullName as f, 'S', 'pid' FROM Person

SELECT e.PersonID, p.FullName, CONCAT('enrolled in ', e.SemesterID, ' and ', e.PaperID) AS [Reason]
FROM Enrolment AS e JOIN Person AS p 
ON e.PersonID=p.PersonID 
WHERE LEFT(SemesterID,4)='2019' AND PaperID='IN605'

-- e7.2
--e7.2	Produce one resultset with two columns. List the all Paper Names and all the Person Full Names in one column.
--	In the other column calculate the number of characters in the name.
--	Sort the result with the longest name first.

SELECT FullName, LEN(FullName) FROM 
((SELECT FullName FROM Person JOIN Enrolment ON Person.PersonID=Enrolment.PersonID)
UNION
(SELECT PaperName FROM Paper JOIN Enrolment ON Paper.PaperID=Enrolment.PaperID)) AS r
ORDER BY LEN(FullName) DESC