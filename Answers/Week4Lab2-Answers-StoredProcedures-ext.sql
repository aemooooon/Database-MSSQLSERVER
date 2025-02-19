/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [PaperID]
      ,[SemesterID]
      ,[PersonID]
  FROM [IN705_201902_kwood].[dbo].[Enrolment]
 /*
 13.1 Develop a stored procedure [EnrolmentCount] that accepts a paperID
		and a semesterID and calculates the number of enrolments in the 
		relevant paper instance. It returns the enrolment count as an
		output parameter.


		create proc EnrolmentCount
			(
				@paperID nvarchar(10),
				@semesterID char(6),
				@enrolmentCount int output
			)
		as
		begin
			select @enrolmentCount = count(*) 
			from Enrolment
			where PaperID = @paperID
			and SemesterID = @semesterID
		end



13.2	Re-develop stored procedure [EnrolmentCount] so that semesterID
		is optional and defaults to the current semester. If there is no
		current semester, it chooses the most recent semester. 


  create proc EnrolmentCount
			(
				@paperID nvarchar(10),
				@semesterID char(6) = null,
				@enrolmentCount int output
			)
		as
		begin

			if @semesterID is null  
				select top 1 @semesterID = semesterID
				from Semester
				where StartDate <= getdate()
				order by startDate desc

			select @enrolmentCount = count(*) 
			from Enrolment
			where PaperID = @paperID
			and SemesterID = @semesterID
		end

13.3  Write the script you will need to test 13.2 hint: you may have to cast your output.
	
		declare @EC int
		exec EnrolmentCount 'IN605',default,  @EC output
		print 'The semester with most enrolments is ' + cast(@EC as varchar(255))
		