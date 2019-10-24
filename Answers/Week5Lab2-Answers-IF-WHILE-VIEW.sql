/*
Using Transact-SQL : Exercises
------------------------------------------------------------

Exercises for Section 15


15.1    Develop a view [BigPaperInstance] that finds the 10 paper instances
		with the most enrolments. Show the paperID, paper name,
		semesterID, start date and end date of the paper instance.



15.2    Develop a view [SmallPaper] that finds the 10 paper instances
		with the least (lowest number of) enrolments. Show the paperID, paper name,
		semesterID, start date and end date of the paper instance.

		create view SmallPaperInstance
		as
		select top 10 p.PaperID, PaperName, s.SemesterID, StartDate, EndDate
		from Paper p
		join 
		(
			select PaperID, SemesterID, count(*) as EnrolmentCount
			from Enrolment
			group by PaperID, SemesterID
		) e on e.PaperID = p.PaperID
		join Semester s on s.SemesterID = e.SemesterID
		order by EnrolmentCount asc 

		select * from SmallPaperInstance


15.3	Write a view that lists all the current first year students

		alter view getCurrentFirstYearStudents
as
select E.PersonID, E.paperID, E.SemesterID, P.GivenName, P.FamilyName, P.FullName 
from Semester S
join Enrolment E on E.SemesterID = S.SemesterID
join Person P on P.PersonID = E.PersonID
where getdate() between S.StartDate and S.EndDate
and E.PaperID like '__5__'



		You can reference a Database table even if you are not 
		currently connected to it as long as you use its fully qualified domain name.
		The following two questions are using the countries table in the World Database.
		You can use this to find the FQDN for World using a new query pointed at that Database:

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


15.4    Develop a view [ConsonantCountry] that lists the countries that have a name
		starting with a consonant (b c d f g h j k l m n p q r s t v w x y z).
		Show the code and name of each country.

		create view ConsonantCountry
		as
		select Code, Name
		from [World].[dbo].[country]
		where left(name, 1) not in ('a', 'e', 'i', 'o', 'u')

		select * from ConsonantCountry


15.5   Develop a view [RecentlyIndependentCountry] that lists countries that 
		gained their independence within the last 100 years. 
		Make sure the view adjusts the resultset to take account of the date when it is run.

		create view RecentlyIndependentCountry
		as
		select * 
		from [World].[dbo].[country]
		where IndepYear between datepart(year, getdate())-100 and datepart(year, getdate())

		SELECT * FROM RecentlyIndependentCountry


*/

/*