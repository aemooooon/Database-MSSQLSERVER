
-- 4.0   JOINs in the FROM clause let you access data from a number of tables or views

-- 4.1   INNER JOINs select only the rows that match the ON criteria. Keyword INNER is optional.
	
	--join two tables
	select Paper.*, PaperInstance.* from Paper 
	join PaperInstance on Paper.PaperID = PaperInstance.PaperID
	
	--join three tables
	select Paper.*, PaperInstance.*, Semester.* from Paper
	join PaperInstance on Paper.PaperID = PaperInstance.PaperID
	join Semester on PaperInstance.SemesterID = Semester.SemesterID

-- 4.2   Use a table alias to clarify the statement. Keyword AS is optional
	
	select p.*, i.* from Paper as p 
	join PaperInstance i on p.PaperID = i.PaperID

--	note that pi is a keyword. Delimit the alias with [] or choose another alias
	select p.*, [pi].*, s.* from	Paper p 
	join PaperInstance [pi] on p.PaperID = [pi].PaperID
	join Semester s on [pi].SemesterID = s.SemesterID

--	using table alias in SELECT clause is necessary only when there are duplicate names
	select p.PaperID, PaperName, SemesterID from Paper p
	inner join PaperInstance i on p.PaperID = i.PaperID

--4.3   OUTER JOINs retrieve all rows from the table on one side of the join 
--	and only matching rows from the from the other side of the join.
--	Compare the resultsets for INNER JOIN and OUTER JOIN

	select p.PaperID, p.PaperName, i.SemesterID from Paper p
	inner join PaperInstance i on p.PaperID = i.PaperID

	select p.PaperID, p.PaperName, i.SemesterID from Paper p left outer join PaperInstance i on p.PaperID = i.PaperID

--4.4   LEFT OUTER JOIN and RIGHT OUTER JOIN specify the joined table that returns all rows.
--	Keyword OUTER is optional. Compare these statements and their resultsets

delete from PaperInstance where PaperID = 'IN610' -- I populated this table using a cross join so all of the data will match otherwise.

	select p.PaperID, p.PaperName, i.SemesterID from Paper p
	left join PaperInstance i on p.PaperID = i.PaperID

	select p.PaperID, p.PaperName, i.SemesterID from Paper p
	right join PaperInstance i on p.PaperID = i.PaperID

	select p.PaperID, p.PaperName, i.SemesterID from PaperInstance i
	left join Paper p on p.PaperID = i.PaperID

--4.5	Be careful mixing INNER JOINs and OUTER JOINs. 
--	Compare these statements and resultsets

	select p.PaperID, p.paperName, s.StartDate from Paper p
	left join paperInstance i on i.PaperID = p.PaperID
	join Semester s on i.SemesterID = s.SemesterID

	select p.PaperID, p.paperName, s.StartDate from Paper p
	left join paperInstance i on i.PaperID = p.PaperID
	left join Semester s on i.SemesterID = s.SemesterID

--4.6	CROSS JOIN returns the Cartesian product;
--	every possible combination of rows from each table is returned

	select p.PaperID, s.SemesterID, s.StartDate from Paper p
	cross join Semester s

--	WARNING for p/SQL users: T-SQL does not support natural joins
--	A comma in JOIN clause replaces keyphrase CROSS JOIN

	select p.PaperID, s.SemesterID, s.StartDate from Paper p, Semester s

--4.7	ATTENTION: an alternative method of expressing an inner join
--	appears similar to a cross join, but with a WHERE clause

	select p.*, i.* from Paper p, PaperInstance i
	where p.PaperID = i.PaperID

	select p.PaperID, PaperName, s.SemesterID 
	from Paper p, PaperInstance i, Semester s
	where p.PaperID = i.PaperID
	and s.SemesterID = i.SemesterID

--4.8	A table joining to itself is a self-join

--	Find semesters that end on the same day as another starts
	select s1.*, s2.* from Semester s1
	join Semester s2 on s1.EndDate = s2.StartDate
	

--4.9	ON clause may use multiple column comparisons

	select i.*, e.PersonID from PaperInstance i
	join Enrolment e on i.SemesterID = e.SemesterID and i.PaperID = e.PaperID

--4.10	ON clause can use comparisons other than =

--	Find pairs of semesters where there is 0 to 30 days inter-semester break
	select s1.*, s2.* from Semester s1
	join Semester s2 on datediff(day, s1.EndDate, s2.StartDate) between 0 and 30

--4.11	JOIN with subqueries is an ideal method to find matching values between resultsets

--	Find the semesters in which IN605 and IN705 have run concurrently
	select IN605_Instances.SemesterID
	from 
	(select SemesterID from PaperInstance where PaperID = 'IN605') IN605_Instances
	join
	(select SemesterID from PaperInstance where PaperID = 'IN705') IN705_Instances
	on IN605_Instances.SemesterID = IN705_Instances.SemesterID

--4.12	FULL OUTER JOINS return all matched and unmatched rows
--	from both sides of the join. Keyword OUTER is optional

--	Find the semesters in which IN512 and/or IN510 has run
	select IN512_Instances.SemesterID, IN510_Instances.SemesterID
	from 
	(select SemesterID from PaperInstance where PaperID = 'IN510') IN510_Instances
	full join
	(select SemesterID from PaperInstance where PaperID = 'IN512') IN512_Instances
	on IN510_Instances.SemesterID = IN512_Instances.SemesterID


--5.0	GROUP BY clause collects data into groups. Data for groups can be summarised

--5.1	Simple grouping. GROUP BY columns must appear in the SELECT clause

	select PaperID from Enrolment
	group by PaperID

--5.2	Use multiple GROUP BY columns for nested groups

	select PaperID, SemesterID from Enrolment
	group by PaperID, SemesterID

--5.3	Aggregate functions process columns.
--	The aggregated columns do not have to be in the GROUP BY clause

	select PaperID, count(PersonID) as [Enrolment Count] from Enrolment
	group by PaperID

	select PaperID, count(*) as [Enrolment Count] from Enrolment
	group by PaperID

	select PaperID, SemesterID, count(PersonID) as [Enrolment Count] from Enrolment
	group by PaperID, SemesterID

--5.3	Combining JOINS, GROUP BY and ORDER BY

	select p.PaperID, p.PaperName, e.SemesterID, s.StartDate, count(e.PersonID) as [Enrolment Count] from Enrolment e
	join PaperInstance i on e.PaperID = i.PaperID and e.SemesterID = i.SemesterID
	join Paper p on i.PaperID = p.PaperID
	join Semester s on i.SemesterID = s.SemesterID
	group by p.PaperID, p.PaperName, e.SemesterID, s.StartDate
	order by p.PaperName, s.StartDate

--5.4	HAVING restricts the rows returned by aggregations

	select PaperID, SemesterID, count(PersonID) as [Enrolment Count] from Enrolment
	group by PaperID, SemesterID
	having count(PersonID) < 10

--5.5	WHERE restricts rows returned by the SELECT...FROM... clauses
--	HAVING restricts rows returned after the GROUP BY clause takes effect (if there is no aggregater function)

--	Compare these resultsets.
--	Which might be faster when Enrolment has a very large number of rows?

	select PaperID, SemesterID, count(PersonID) as [Enrolment Count] from Enrolment
	group by PaperID, SemesterID
	having SemesterID = '2019S1'

	select PaperID, SemesterID, count(PersonID) as [Enrolment Count] from Enrolment
	where SemesterID = '2019S1'
	group by PaperID, SemesterID

