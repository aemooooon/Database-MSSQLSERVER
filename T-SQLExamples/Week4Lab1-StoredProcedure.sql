
--12.1	Simple stored procedure. PROCEDURE can be shortened to PROC

	create procedure getPersonList
	as
	select PersonID, FullName from Person
	order by FamilyName


--12.2	EXECUTE a SP to perform the statements. EXECUTE may be shortened or omitted.

	execute getPersonList

	exec getPersonList

	getPersonList --only if it is the first statement in a batch
	

--12.3	SPs can be modifed or deleted
	
	alter proc getPersonList
	as
	select PersonID, FullName, FamilyName from Person
	order by PersonID
	go	
	--GO executes all statements since last execution as a batch.
	--If we do not use GO, alter proc will consider 
	--all the following statements to be part of the SP 

	exec getPersonList

	drop proc getPersonList
	go

	exec getPersonList


--12.4	A SP can return more than one resultset

	create proc getIN705Information
	as
		select * from PaperInstance
		where PaperID = 'IN705'

		select * from Enrolment
		where PaperID = 'IN705'
	go

	exec getIN705Information


--12.5	A SP inherently responds with a return integer value

	create proc getPaperCount
	as
	return (select count(*) from Paper) 
	go

	declare @return_value int
	exec @return_value = getPaperCount
	print 'Paper count is ' + cast(@return_value as nvarchar(5))
	go


	--A SP that does not explicitly set RETURN value will return default value
	declare @return_value int
	--exec @return_value = getIN705Information
	print @return_value
	go


--12.6	Passing Parameters. A SP may accept input parameters; this makes a SP flexible

	alter proc getPaperEnrolment(@paperID nvarchar(10))
	as
	select * from Enrolment
	where paperID = @paperID
	go

	exec getPaperEnrolment 'IN605'
	go

	--parameters are especially useful for insert, update and delete
	alter proc createPaper
	(	@pID nvarchar(10),
		@pName nvarchar(100)	)
	as
	insert Paper (paperID, PaperName) values (@pID, @pName)
	go

	exec createPaper 'IN755', 'Advanced Security'  --- AAArrggghhhhh!!!!!!
	go
	Select * from Paper
	

--12.7	A SP may have OUTPUT parameters. 
--			This is useful when you want to return non-integer values, 
--			or more than one return value.
--			Using output parameters is more complicated

	create proc getPaperDetails
	(	@paperID nvarchar(10),
		@biggestSemester char(6) OUTPUT,
		@longestName nvarchar(100) OUTPUT	)
	as
		select * from Paper where PaperID = @paperID

		set @biggestSemester = 
			(	select top 1 SemesterID from Enrolment
				where PaperID = @paperID
				group by SemesterID	
				order by count(*) desc						)

		set @longestName = 
			(	select top 1 FullName from Person p
				join Enrolment e on e.PersonID = p.PersonID
				where e.PaperID = @paperID
				order by len(FullName) desc				)

	go

	declare @LN nvarchar(50), @BS char(6)
	exec getPaperDetails 'IN605', @BS output, @LN output
	print ''
	print 'The semester with most enrolments is ' + @BS
	print 'The person with the longest name is ' + @LN



