/*
	SELECT select_list 
	[ INTO new_table ] 
	[ FROM table_source ] 
	[ WHERE search_condition ] 
	[ GROUP BY group_by_expression ] 
	[ HAVING search_condition ] 
	[ ORDER BY order_expression [ ASC | DESC ] ] 
	
	The UNION operator can be used between queries to combine their results into a single result set.

*/
--1.0   SELECT clause specifies the output columns of the query

--1.1   Simple SELECT statement

	select PersonID, FamilyName from Person

	select * from Person --this is a comment

--1.2   Output can be a calculation

	select FamilyName, len(FamilyName) from Person

--1.3   Output can be a fixed value or fixed text

	select FamilyName, 5, 'student' from Person

--1.X !!!!! watch out

	select 5, 'student' from Person

	select 5, 'student'

--1.4   CASE switches fixed output value depending on input. 
--	Note that output for each switch can be only one SQL statement
	
	--simple CASE
	select PaperID, PaperName, 
		case PaperID 
		when 'IN705' then 'this paper'
		when 'IN605' then 'redundant paper'
		else 'another paper'
		end
	from Paper

	--searched CASE with simple outputs
	select SemesterID,
		case
		when getdate() > EndDate then 'past semester'
		when getdate() between StartDate and EndDate then 'current semester'
		when getdate() < StartDate then 'future semester'
		else 'unknown'
		end
	from Semester

	--searched CASE with calculated outputs
	select SemesterID,
		case
		when getdate() > EndDate then 'past semester, ended ' + cast(datediff(day, EndDate, getdate()) as nvarchar(4)) + ' days ago'
		when getdate() between StartDate and EndDate then 'current semester, ' + cast(datediff(day, getdate(), EndDate) as nvarchar(4)) + ' days remaining'
		when getdate() < StartDate then 'future semester, starts in ' + cast(datediff(day, getdate(), StartDate) as nvarchar(4)) + ' days'
		else 'error: check StartDate and EndDate data'
		end
	from Semester

--1.5   Column can be aliased

	select PersonID as StudentCode, FullName as [Student Name] from Person

--1.6   TOP N selects only the first portion of records; compare the number of rows returned by each of these statements

	select FamilyName from Person
		
	select top 10 FamilyName from Person
	
	select top 10 percent FamilyName from Person

--1.7   DISTINCT removes duplicates; compare the number of rows returned by each of these statements

	select FamilyName from Person

	select distinct FamilyName from Person


--2.0   ORDER BY sorts the rows

--2.1   Simple ORDER BY sorting

	select * from Person order by FamilyName

--2.2   ASC sorts ascending, DESC sorts descending. ASC is default

	select * from Person order by FamilyName ASC

	select * from Person order by FamilyName DESC

--2.3   Sorting column does not have to appear in the output

	select PersonID, FullName from Person order by FamilyName

--2.4   Multiple ORDER BY columns creates a nested sort

	select PersonID, FullName from Person order by FamilyName, GivenName

--2.5   TOP N WITH TIES allows more than N rows returned

	select top 10 with ties FamilyName from Person order by FamilyName


--3.0   WHERE clause filters the rows from resultset

--3.1   Simple WHERE clause

	select * from Person where FamilyName = 'Anderson'

	select * from Person where PersonID = system_user

--3.2   numeric datatype columns filtered with mathematical comparisons =, <, >, >=, <=, <>, !, between

	select * from Semester where StartDate > '01-Jan-2019'

	select * from Semester where StartDate != '02-feb-2019'

	select * from Semester where StartDate between  '02-Aug-2018' and '03-March-2019'


--3.3   text datatype columns filtered with LIKE with wildcards %, _ , [] <--Any single character within the specified range ([a-f]) or set ([abcdef]).

	select * from Person where GivenName like 'Br%'

	select * from Person where FamilyName like 'Jo%s'

	select * from Person where GivenName like 'Brend_n'

	select * from Person where GivenName like 'Camer[m-s]n'

--3.4   NOT logical operator restricts to the complementary data

	select * from Person where not GivenName like 'G%'

	select * from Person where GivenName not like 'G%'

--3.5   Multiple WHERE conditions with AND, OR

	select * from Person where GivenName like 'G%' and FamilyName ='Orr'

	select * from Person where FamilyName = 'Jones' or FamilyName = 'Brown'

--3.6    AND takes precedence over OR

	select * from Person where GivenName like 'G%' and FamilyName = 'Orr' or FamilyName = 'Jones'

	select * from Person where FamilyName = 'Orr' or FamilyName = 'Jones' and GivenName like 'G%'

--3.7   Brackets affect the logic of the WHERE clause.

	select * from Person where (GivenName like 'G%' and FamilyName = 'Smith') or FamilyName = 'Anderson'

	select * from Person where GivenName like 'G%' and (FamilyName = 'Smith' or FamilyName = 'Anderson')

--3.8   Multiple WHERE conditions using IN
	

	select * from Person where 'Smith' in (GivenName, FamilyName)

--3.9   NOT returns the complementary restriction

	select * from Person where FamilyName not in ('Smith', 'Green')

	select * from Person where not FamilyName in ('Smith', 'Green')