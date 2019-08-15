	
--13.1	SP parameters may take default values; the parameters become optional.

	create proc getEnrolmentByInstance(@semesterID char(6),	@paperID nvarchar(10) = 'IN605')
	as
	select * from Enrolment
	where SemesterID = @semesterID
	and PaperID = @paperID
	go

	--test it
	exec getEnrolmentByInstance '2019S2', 'IN510'
	exec getEnrolmentByInstance '2019S2'


--13.2	Parameter default values must be fixed values.
--			If you want to use a calculated default value then you must use a workaround 
	
	create proc getEnrolmentByDate(@date datetime = null )	--we want to use today's date as the default
	as											--so we would like to have default = getdate()
	begin
	
		if @date is null set @date = getdate() --catch the NULL parameter value and replace it

		select e.* from Enrolment e
		join Semester s on s.SemesterID = e.SemesterID
		where @date between s.StartDate and s.EndDate
	
	end

	go


	--test it
	exec getEnrolmentByDate '12-August-2019'
	exec getEnrolmentByDate
	go


--13.3	Using OR logical shortcutting makes a flexible SP  

	create proc getPaper (@paperID nvarchar(10) = null)
	as
	select * from Paper
	where @paperID is null or PaperID = @paperID
	--if @paperID is null then where returns true for all papers, 
	--PaperID = @paperID is not evaluated; all rows are returned

	go

	--test it
	exec getPaper 'IN510'
	exec getPaper


--13.4	Clarify a call to a SP by naming the parameters in the call

	create proc getEnrolment
		(@paperID nvarchar(10) = null,
		@semesterID char(6) = null,
		@personID nvarchar(16) = null	)
	as

	select * from Enrolment
	where (@paperID is null or PaperID = @paperID)
	and (@semesterID is null or SemesterID = @semesterID)
	and (@personID is null or PersonID = @personID)

	go

	--test it
	exec getEnrolment @paperID='IN605', @semesterID='2019S2', @personID='101'

	--parameter order is not important anymore
	exec getEnrolment  @semesterID='2019S2',@paperID='IN605', @personID='101'
	exec getEnrolmentByInstance  @paperID='IN605', @semesterID='2019S2'

	--omitted parameters use their default value
	exec getEnrolment  @personID='101', @paperID='IN605'
	--note: if you don't name parameters, you must specify all parameter values including placeholders
	exec getEnrolment 'IN605', null, '101'
	exec getEnrolment 'IN605', '2019S2', default  --also this, thanks Jun Cui 
	
	


--13.5	A SP can execute other SPs

	create proc getThemAll
	as
		exec getEnrolment 'IN605', null, '101'
		select * from Paper
		exec getEnrolmentByInstance '2019S2'
	go

	--test it
	exec getThemAll


--13.6	You can use variables to pass parameters to a SP

	declare @theSemester char(6)
	set @theSemester = '2019S2'
	exec getEnrolmentByInstance @theSemester

--13.6a	Inside a SP is a good place to use this technique

	create proc getEnrolmentDetail
		(	@thePaper nvarchar(10) = null,
			@theSemester char(6) = null,
			@thePerson nvarchar(16) = null	)
	as
	exec getPaper @thePaper
	exec getEnrolment @paperID=@thePaper, 
				@semesterID=@theSemester, @personID=@thePerson

	go

	--test it
	exec getEnrolmentDetail @thePaper='IN605'


