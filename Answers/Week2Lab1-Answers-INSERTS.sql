/*



Exercises for section 8 : INSERT

*In all exercises, write the answer statement and then execute it.


e8.1	Write a statement to create 2 new papers: IN338 and IN238 Extraspecial Topic 

		insert Paper (PaperID, PaperName) values ('IN338', 'Extraspecial Topic')


e8.2	Create a new user (yourself)
		Write statements that will add three enrolments for you
		in papers you have completed.
		
		insert Person values (122, 'Krissi', 'Wood', 'Krissi Wood')
		insert Paper values('IN105', 'Special')
e.g.	insert PaperInstance (PaperID, SemesterID) values ('IN105', '2018S2')
		insert Enrolment (PaperID, SemesterID, PersonID)
		values ('IN105', '2018S2', 122) ** fixed
etc.


e8.3	Imagine that every paper in the database will run in 2021S1.
		Write the statements that will create all the necessary paper instances. You will need to add the Semester
		--use a left outer join to find missing rows

		insert Semester values ('2021S1', '02-feb-2021', '02-June-2021')
		
		Insert PaperInstance(PaperID, SemesterID)
		select allpapers.* from
		(select PaperID, '2021S1' as SemesterID from Paper) allpapers
		left join
		(select PaperID, SemesterID from PaperInstance where SemesterID = '2021S1') instances
		on instances.PaperID = allpapers.PaperID
		and instances.SemesterID = allpapers.SemesterID --this line is unnecessary because we know that semesterID = '2021S1' in all rows of both subqueries
		where instances.paperID is null


		--alternatively
		insert PaperInstance(PaperID, SemesterID)
		select PaperID, '2021S1'
		from Paper
		where PaperID not in (select PaperID from PaperInstance where semesterID = '2021S1')


/*
e8.4	Imagine a strange path-of-study requirement: in semester 2020S1
		all people who are currently enrolled in IN605 and not enrolled in IN612 and enrol them in IN238.
		Write a statement to create the correct paper instance for IN238.
		Write a statement that will find all people enrolled in IN605 (semester 2019S2)
		but	not enrolled in IN612 (semester 2019S2) and 
		will create IN238 (semester 2020S1) enrolments for them.


select * from Paper where paperID = 'IN238'

1. create paper, semester and paper instance data

insert Paper values ('IN238', 'Unnamed Paper')
insert semester values('2020S1','02-feb-2020', '06-june-2020')

insert PaperInstance values ('IN238', '2020S1')

2. Find IN605/2019S2 enrolments

select * from (select PaperID, SemesterID, PersonID
from Enrolment
where PaperID = 'IN605'
	and SemesterID = '2019S2'
) IN605
left join	
(
select PaperID, SemesterID, PersonID
from Enrolment
where PaperID = 'IN612'
	and SemesterID = '2019S2'
) IN612
	
on IN605.PersonID = IN612.PersonID
where IN612.PersonID is null


3. insert new enrolments

insert Enrolment (PaperID, SemesterID, PersonID)
select 'IN238', '2020S1', IN605.PersonID from
(select PaperID, SemesterID, PersonID
from Enrolment
where PaperID = 'IN605'
	and SemesterID = '2019S2') IN605
left join	
(select PaperID, SemesterID, PersonID
from Enrolment
where PaperID = 'IN612'
	and SemesterID = '219S2') IN612
	
on IN605.PersonID = IN612.PersonID
where IN612.PersonID is null