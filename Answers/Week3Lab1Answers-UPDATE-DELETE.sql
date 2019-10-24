/*
Using Transact-SQL : Exercises
------------------------------------------------------------

/*
Exercises for section 9 : UPDATE

*In all exercises, write the answer statement and then execute it.

e9.1	Change the name of IN628 to 'Object-Oriented Software Development (discontinued after 2019)'  

		update Paper
		set PaperName = 'Object-Oriented Software Development (discontinued after 2019)'
		where PaperID = 'IN628'

e9.2	For all the semesters that start after 01-June-2018, alter the end date
		to be 14 days later than currently recorded.

		update Semester
		set EndDate = dateadd(day, 14, EndDate)
		where StartDate > '01-June-2018'

e9.3	Imagine a strange enrolment requirement regarding the students
		enrolled in IN328 for 2020S1 [Ensure your database has all the records
		created by exercise e8.4]: all students with short names [length of FullName
		is less than 12 characters] must have their enrolment moved 
		from 2020S1 to 2019S2. Write a statement that will perform this enrolment change.

		--Ensure you create the related PaperInstance
		insert PaperInstance values ('IN238', '2019S2')

		--Perform the Enrolment change
		update Enrolment
		set SemesterID = '2019S2'
		where PaperID = 'IN238'
		and SemesterID = '2020S1'
		and PersonID in (select PersonID from Person where len(FullName) <12)

Exercises for section 10 : DELETE

*In all exercises, write the answer statement and then execute it.

e10.1	Write a statement to delete all enrolments for IN238 Extraspecial Topic in semester 2020S11.

		delete Enrolment
		where PaperID = 'IN238' and SemesterID = '2020S1'

e10.2	Delete all PaperInstances that have no enrolments.

		delete PaperInstance 
		from PaperInstance i
		left join Enrolment e
		on i.PaperID = e.PaperID and i.SemesterID = e.SemesterID
		where e.PaperID is null