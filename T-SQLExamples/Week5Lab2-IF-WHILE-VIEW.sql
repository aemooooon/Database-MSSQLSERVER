/*


How to get different SQL Server date formats
   - Use the date format option along with CONVERT function
   - Check out the chart to get a list of all format options
 ********  Have a play around with these they are very useful *****************

drop table #dateFormats
DECLARE @counter INT = 0
DECLARE @date DATETIME = GETDATE()

CREATE TABLE #dateFormats (dateFormatOption int, dateOutput nvarchar(40))

WHILE (@counter <= 150 )
BEGIN
   BEGIN TRY
      INSERT INTO #dateFormats
      SELECT CONVERT(nvarchar, @counter), CONVERT(nvarchar,@date, @counter) 
      SET @counter = @counter + 1
   END TRY
   BEGIN CATCH;
      SET @counter = @counter + 1
      IF @counter >= 150
      BEGIN
         BREAK
      END
   END CATCH
END

SELECT * FROM #dateFormats
select convert(varchar, getdate(), 9) as FormattedDate
	
--14.1	IF...ELSE... is the only branching structure available for flow control

--14.1a	simple IF
	if datepart(weekday, getdate()) >= 4 --Wednesday or later in the week
		select * from Paper
	go

--14.1b	IF with ELSE

	if datepart(weekday, getdate()) <= 4
		select * from Paper
	else
		select * from Person
	go

--14.1c	when a branch contains more than one statement
--			you must bracket the statements with BEGIN...END

	if datepart(weekday, getdate()) <= 4
		begin	
			select * from Paper
			select * from Semester
		end
	go

	if datepart(weekday, getdate()) <= 4
		begin	
			select * from Paper
			select * from Semester
		end
	else
		begin
			select * from Person
			select * from Enrolment where semesterID = '2019S11'
			select * from PaperInstance
		end
	go


--14.1d	Nested IFs get ugly but often there is no better way

	if datename(weekday, getdate()) in ('Monday', 'Wednesday', 'Friday') 
		if datepart(month, getdate()) > 6 --July or later in the year
			select * from Paper
		else
			select * from Semester
	else
		if datepart(hour, getdate()) < 12 --in the morning
			select * from Person
		else
			print 'No resultset for output'
		
	go


--14.2	WHILE..END is the only looping structure available for flow control

--14.2a	Simple WHILE..END

	declare @iterator int
	set @iterator = 0
	while (@iterator < 10)
		begin
			print 'This is loop number ' + cast(@iterator as char(1))
			set @iterator = @iterator + 1
		end

	go



--	decent structured programming
	declare @iterator int
	set @iterator = 0
	while (@iterator < 40 and datepart(day, getdate()) != @iterator)
		begin
			print 'This is loop number ' + cast(@iterator as char(2))
			set @iterator = @iterator + 1
		end

	go

/*
A VIEW stores a single SELECT statement for later execution.
        A view is a pseudo table. It is a stored query which looks like a table. And it can be referenced like a table.
		A view is used to provide controlled access to datatables by
		restricting the columns or rows returned from a table.
		Granularity and flexibility of permission schemes can be achieved
		when using views.	
		To provide a backward compatible interface to emulate a table whose schema has changed.

		

*/

--15.1	Simple VIEW

	create view PaperList
	as
	select * from Paper 

select * from PaperList


--15.3	Updateable views
/*	

	
You can modify the data of an underlying base table through a view, as long as the following conditions are true: 
1.	Any modifications, including UPDATE, INSERT, and DELETE statements, must reference columns from only one base table.
 
2.	The columns being modified in the view must directly reference the underlying data in the table columns. 
	The columns cannot be derived in any other way, such as through the following: 
	a.	An aggregate function: AVG, COUNT, SUM, MIN, MAX, GROUPING, STDEV, STDEVP, VAR, and VARP.
	b.	A computation. The column cannot be computed from an expression that uses other columns. 
		Columns that are formed by using the set operators UNION, UNION ALL, CROSSJOIN, EXCEPT, 
		and INTERSECT amount to a computation and are also not updatable.
    c.  The columns being modified are not affected by GROUP BY, HAVING, or DISTINCT clauses.
	d.  TOP is not used anywhere in the select_statement of the view together with the WITH CHECK OPTION clause.
The previous restrictions apply to any subqueries in the FROM clause of the view, 
just as they apply to the view itself. Generally, the Database Engine must be able to 
unambiguously trace modifications from the view definition to one base table.


insert PaperList(PaperID, PaperName)
values ('IN107', 'Special')
*/	

update PaperList
set PaperID = 'IN107'
where PaperID = 'IN105'

select * from PaperList


delete PaperList
where PaperID = 'IN555'	

select * from PaperList


insert PaperList(PaperID, PaperName)
values ('IN555', 'Programming Fundamentals')

select * from PaperList


--now more complicated

getIndependenceCountByDate calculates the 
		number of countries that gained independence within 100 years of a chosen date
		(that is, 100 years before or after the date). Make the chosen date 
		 default to today. Make number of countries
		a return value.


drop view IndieCountByDate
create view IndieCountByDate
as 
select count(*) as CountryCount
from [World].[dbo].[country]
where IndepYear 
between datepart(year, dateadd(year, -100, GETDATE())) 
and datepart(year, dateadd(year, 10, GETDATE()))
	

go

select * from IndieCountByDate

select * from getCurrentFirstYearStudents

--data modification
update getCurrentFirstYearStudents
set GivenName = 'TONY', FamilyName = 'Wood', FullName = 'Tony Wood'
where PersonID = '110'

select * from getCurrentFirstYearStudents
select * from Person

--note: insert and delete through getCurrentFirstYearStudents will not work; try it and find out why.


		