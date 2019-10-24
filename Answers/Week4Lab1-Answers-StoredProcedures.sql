/*
Using Transact-SQL : Exercises
------------------------------------------------------------

Exercises for section 12 & 13 : STORED PROCEDURE

*In all exercises, write the answer statement and then execute it.



e12.1		Create a SP that returns the people with a family name that 
			starts with a vowel [A,E,I,O,U]. List the PersonID and the FullName.

			create proc getVowelFamilyNames
			as
			begin
				select 
					PersonID,
					FullName
				from Person
				where left(FamilyName, 1) in ('A','E','I','O','U')					
			end

			exec getVowelFamilyNames
			

e12.2		Create a SP that accepts a semesterID parameter and returns the papers that
			have enrolments in that semester. List the PaperID and PaperName.

			create proc getPaperWithEnrolments 
			(
				@semesterID nchar(6)
			)
			as
			begin
				select distinct
					p.PaperID,
					p.PaperName
				from Paper p
				join PaperInstance i on i.PaperID = p.PaperID
				join Enrolment e on e.PaperID = i.PaperID and e.SemesterID = i.SemesterID
				where i.SemesterID = @semesterID
			end

			exec getPaperWithEnrolments '2019S2'

e12.3		Modify the SP of 12.2 so that the parameter is optional.
			If the user	does not supply a parameter value default to the current semester.
			If there is no current semester default to the most recent semester.

			create proc getPaperWithEnrolments2 
			(
				@semesterID nchar(6) = null
			)
			as
			begin
				--assign @semesterID if it is missing
				if @semesterID is null
					select top 1 @semesterID = SemesterID
					from Semester
					where StartDate <= getdate()
					order by StartDate desc  

				--generate resultset
				select distinct
					p.PaperID,
					p.PaperName
				from Paper p
				join PaperInstance i on i.PaperID = p.PaperID
				join Enrolment e on e.PaperID = i.PaperID and e.SemesterID = i.SemesterID
				where i.SemesterID = @semesterID
			end
			exec getPaperWithEnrolments '2019S2'

e12.4		Create a SP that creates a new semester record. the user must supply all
			appropriate input parameters.

			create proc insertSemester
			(
				@semesterID nchar(6),
				@startDate datetime,
				@endDate datetime
			)
			as
			begin
				insert Semester (SemesterID, StartDate, EndDate)
				values (@semesterID, @startDate, @endDate)
			end

