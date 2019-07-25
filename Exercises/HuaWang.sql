-- Exercises for section 1
-- 1.1
SELECT PaperID, PaperName
FROM Paper;

-- 1.2
SELECT SemesterID, DATEDIFF(DAY,StartDate,EndDate)/7
FROM Semester;

-- 1.3
SELECT PersonID, FamilyName,
   CASE   
      WHEN LEN(FamilyName) <= 4 THEN 'short name'   
      WHEN LEN(FamilyName) <= 8 THEN 'middle length name'
	  WHEN LEN(FamilyName) >= 9  THEN 'long name' 
   END AS 'NameType'
FROM Person;

-- 1.4
SELECT TOP 4
   StartDate
FROM Semester;

-- 1.5
SELECT DISTINCT GivenName
FROM Person;


-- Exercises for section 2
-- 2.1
SELECT SemesterID, StartDate
FROM Semester
ORDER BY StartDate Desc;

-- 2.2
SELECT DISTINCT FamilyName, LEN(FamilyName) AS orderfacts
FROM Person
ORDER BY orderfacts DESC;

-- 2.3
SELECT TOP 3 WITH TIES
   SemesterID, DATEDIFF(DAY,StartDate,EndDate) AS days
FROM Semester
ORDER BY days ASC;


-- Exercises for section 2
-- 3.1
SELECT PersonID, FullName
FROM Person
WHERE GivenName like 'Gr%n';

-- 3.2
SELECT FullName
FROM Person
WHERE not FullName like '%e%'
ORDER BY FamilyName ASC;

-- 3.3
SELECT PaperID, PaperName
FROM PAPER
WHERE PaperID NOT LIKE 'IT%';

-- 3.4
SELECT FullName
FROM Person
WHERE LEN(GivenName) >= 7 AND SUBSTRING(FamilyName,1,1) BETWEEN 'A' AND 'M';