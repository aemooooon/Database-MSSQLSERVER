-- 1.1
select PaperID,PaperName from Paper;

-- 1.2
SELECT SemesterID,DATEDIFF(day,StartDate,EndDate)/7 FROM Semester;

-- 1.3
SELECT PersonID,FamilyName,
   CASE   
      WHEN LEN(FamilyName) <= 4 THEN 'short name'   
      WHEN LEN(FamilyName) <= 8 THEN 'middle length name'
	  WHEN LEN(FamilyName) >=9  THEN 'long name' 
   END AS 'NameType'
FROM Person;

-- 1.4
