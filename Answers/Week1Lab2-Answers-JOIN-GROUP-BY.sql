/* Answers Section 4

------------------------------------------------------------
/*
Using Transact-SQL : Exercises
------------------------------------------------------------

*/

/*
Exercises for section 4

4.1	List the starting date and ending date of each occasion 
	IN511 Programming 2 has run.

	select StartDate, EndDate from Semester s
	join PaperInstance p on p.SemesterID = s.SemesterID
	where p.PaperID = 'IN511'

4.2	List all the full names of the people who have ever enrolled in
	IN511 Programming 2 .
	If a person has enrolled more than once, do not repeat their name.

	select distinct FullName from Person p
	join Enrolment e on p.PersonID = e.personID
	where e.PaperID = 'IN511'

--	be careful! the statement above will remove duplicates
	if two different people have the same name e.g. Scott Cameron.
	This is more accurate...
	
	select FullName from
	(select distinct p.PersonID, FullName from Person p
	join Enrolment e on p.PersonID = e.personID
	where e.PaperID = 'IN511') list
	order by FullName


4.3	List all the full names of all the people who have never enrolled in a paper
	(according to the data on the database).

	select p.FullName from Person p
	left join Enrolment e on e.PersonID = p.PersonID
	where e.PersonID is null		


4.4	List all the papers that have never been run (according to the data).  There are currently none

	select p.* from Paper p
	left join PaperInstance i on i.PaperId = p.PaperID
	where i.PaperID is null

--	also without using a join
	select * from Paper
	where PaperID not in (select PaperID from PaperInstance)

	
4.5	List all the semesters, showing semester start date and length in days, in which IN511 has run.

	select StartDate, datediff(day, StartDate, EndDate) as [Number of Days] from Semester s
	join PaperInstance i on i.SemesterID = s.SemesterID
	where i.PaperID = 'IN511'


4.6	Develop a statement that returns all people that enrolled in IN511 
	in a semester that started on or between 12-Apr-2018 and 13-Aug-2019.
	Display the full name of each person and the year in which they enrolled. 
	Ensure the people are listed alphabetically according to their family name then given name.

--	this shorcuts the PaperInstance table so avoids indexes.
--	It may run comparatively slowly. We will test this with the Execution Plan analysis later in the course

	select FullName, datepart(year, s.StartDate) as [Enrolment Year] from Person p
	join Enrolment e on e.PersonID = p.PersonID
	join Semester s on s.SemesterID = e.SemesterID
	where e.PaperID = 'IN511'
	and StartDate between '12-Apr-2018' and '13-Aug-2019'
	order by FamilyName, GivenName
*/
/*
Exercises for section 5

5.1	List all the papers that have a paper instance. 
	Display the PaperID and number of instances of the paper.

	select PaperID, count (*) as InstanceCount from PaperInstance
	group by PaperID

5.2	How many people, in total over all semesters, have enrolled in each of the papers
	that have been delivered? Display the paper ID, paper name and enrolment count.

	select p.PaperID, p.PaperName, count(*) as [Total Enrolments] from Enrolment e
	join PaperInstance i on i.PaperID = e.PaperID and i.SemesterID = e.SemesterID
	join Paper p on p.PaperID = i.PaperID
	group by p.PaperID, p.PaperName

--or, by skipping PaperInstance

	select e.PaperID, p.PaperName, count(*) as [Total Enrolments] from Enrolment e
	join Paper p on p.PaperID = e.PaperID
	group by e.PaperID, p.PaperName

5.3	How many people, in total over all semesters, have enrolled in each of the papers
	listed on the Paper table? Display the paper ID, paper name and enrolment count.

	select p.PaperID, p.PaperName, count(e.PaperID) as [Total Enrolments] from Enrolment e
	right join PaperInstance i on i.PaperID = e.PaperID and i.SemesterID = e.SemesterID
	right join Paper p on p.PaperID = i.PaperID
	group by p.PaperID, p.PaperName

5.4	List the paper instance with the highest enrolment. 
	Display the paper instance's start date, end date, paper name and enrolment count.

	select top 1 p.PaperName, s.StartDate, s.EndDate, count(*) as [Enrolment Count] from Enrolment e
	join PaperInstance i on i.PaperID = e.PaperID and i.SemesterID = e.SemesterID
	join Paper p on p.PaperID = i.PaperID
	join Semester s on s.SemesterID = i.SemesterID
	group by p.PaperName, s.StartDate, s.EndDate
	order by count(*) desc

5.5	List all the people who have 3, 4 or 5 enrolments.

	select p.PersonID, FullName,  count(*) as [Enrolment Count] from Person p
	join Enrolment e on e.PersonID = p.PersonID
	group by p.PersonID, FullName
	having count(*) between 3 and 5

*/

insert into Enrolment values ('IN511', '2019S2', 102);
