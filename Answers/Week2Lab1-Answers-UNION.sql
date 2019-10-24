/*
Using Transact-SQL : Exercises
------------------------------------------------------------

Exercises for section 6

e6.1	List the paper with the lowest average enrolment per instance. Ignore all papers with no enrolments.
	Display the paper ID, paper name and average enrolment count.

	select top 1 p.PaperID, p.PaperName, avg(EnrolmentCount) as AverageCount from
	(select PaperID, SemesterID, cast(count(*) as decimal(9,4)) as EnrolmentCount from Enrolment e
	group by PaperID, SemesterID) ec
	join Paper p
		on p.PaperID = ec.PaperID
	group by p.PaperID, p.PaperName
	order by AverageCount asc 

e6.2	List the paper with the highest average enrolment per instance. 
	Display the paper ID, paper name and average enrolment count.

	select top 1 p.PaperID, p.PaperName, avg(EnrolmentCount) as AverageCount from
	(select PaperID, SemesterID, cast(count(*) as decimal(9,4)) as EnrolmentCount from Enrolment e
	group by PaperID, SemesterID) ec
	join Paper p
		on p.PaperID = ec.PaperID
	group by p.PaperID, p.PaperName
	order by AverageCount desc

e6.3	For each paper that has a paper instance: list the paper ID, paper name, 
	starting date of the earliest instance, starting date of the most recent instance, 
	the minimum number of enrolments in the instances,
	maximum number of enrolments in the instances and 
	average number of enrolments across all	the instances.

	select counts.PaperID, p.PaperName,
	min(counts.StartDate) as [Earliest Instance Started], max(counts.StartDate) as [Latest instance Started],
	min(counts.EnrolmentCount) as [Smallest Enrolment], max(counts.EnrolmentCount) as [Largest Enrolment],
	avg(counts.EnrolmentCount) as [Average Enrolment]
	from
	(select i.PaperID, i.SemesterID, s.StartDate, cast(count(*) as decimal(9,6)) as EnrolmentCount from PaperInstance i 
	join Semester s on s.SemesterID = i.SemesterID
	join Enrolment e on e.PaperID = i.PaperID and e.SemesterID = i.SemesterID
	group by i.PaperID, i.SemesterID , s.StartDate) counts
	join Paper p on p.PaperID = counts.PaperID
	group by counts.PaperID, p.PaperName
	
	--or more simply
	
	select 
		p.PaperID, 
		p.PaperName,
		Min(s.StartDate) as EarliestStartDate, --need aliases
		Max(s.StartDate) as LatestStartDate,
		Min(ec.EnrolmentCount) as SmallestEnrolment ,
		Max(ec.EnrolmentCount) as LargestEnrolment ,
		avg(ec.EnrolmentCount) as AverageEnrolment
	from
			(
				select
				PaperID,
				SemesterID,
				COUNT(*) as EnrolmentCount
				from Enrolment
				group by
				PaperID,
				SemesterID 
			) ec --get the enrolment counts for each paper instance
	join Semester s
		on s.SemesterID = ec.SemesterID
	join Paper p
		on p.PaperID=ec.PaperID 
	group by 
		p.PaperID, 
		p.PaperName


e6.4	Which paper attracts people with long names? Find the background statistics 
	to support a hypothesis test: for each paper with enrolments calculate the mean full name length, 
	sample standard deviation full name length & sample size (that is: number of enrolments).

	select NL.PaperID, count(*) as [Sample Size], avg(NL.NameLength) as [Average Name Length],
	stdev(NL.NameLength) as [Standard Deviation Name Length] from 
	(select e.PaperID, cast(len(p.FullName) as decimal(9,4)) as NameLength from Enrolment e
	join Person p on p.PersonID = e.PersonID) NL
	group by NL.PaperID

e6.5	Rank the semesters from the most loaded (that is: the highest number of enrolments) to
	the least loaded. Calculate the ordinal position (1 for first, 2 for second...) of the semester
	in this ranking.

--SQL Server 2000 and earlier
	select SemesterID, EnrolmentCount, count(innerSemesterID) + 1 as Rank from
	( (select i.SemesterID , count(*) as EnrolmentCount from PaperInstance i 
	join Semester s on s.SemesterID = i.SemesterID
	join Enrolment e on e.PaperID = i.PaperID and e.SemesterID = i.SemesterID
	group by i.SemesterID ) counts1
	left join
	(select i.SemesterID as innerSemesterID, count(*) as innerEnrolmentCount from PaperInstance i 
	join Semester s on s.SemesterID = i.SemesterID
	join Enrolment e on e.PaperID = i.PaperID and e.SemesterID = i.SemesterID
	group by i.SemesterID ) counts2
	on counts1.EnrolmentCount < counts2.innerEnrolmentCount) 
	group by SemesterID, EnrolmentCount
	order by Rank 

--SQL Server 2017 can use RANK() function
	select 
		i.SemesterID,
		s.StartDate, 
		count(*) as EnrolmentCount,
		rank() over (order by count(*)) 
	from PaperInstance i 
	join Semester s on s.SemesterID = i.SemesterID
	join Enrolment e on e.PaperID = i.PaperID and e.SemesterID = i.SemesterID
	group by i.SemesterID, StartDate
	order by count(*)
	
	--or
	
	select 
		s.SemesterID,
		s.StartDate ,
		s.EndDate ,
		COUNT(*) EnrolmentCount,
		RANK() over (order by COUNT(*) desc ) as [ordinal position]
	from Enrolment e
	join Semester s 
		on s.SemesterID= e.SemesterID 
	group by 
		s.SemesterID ,	
		s.StartDate ,
		s.EndDate 
	
*/


/*
Exercises for section 7

--Use UNION to solve these tasks. 
--Note that these tasks could possibly be solved by another non-UNION statement.
--Can you also write a non-UNION statement that produces the same result?   

e7.1 In one result, list all the people who enrolled in a paper delivered during 2019 and
	all the people who have enrolled in IN605. 
	The result should have three columns: PersonID, Full Name and the reason the person
	is on the list - either 'enrolled in 2019' or 'enrolled in IN605'
*/

select 
	p.PersonID,
	Fullname,
	'enrolled in 2019' as Reason
from Enrolment e
join Person p on p.PersonID = e.PersonID
where e.SemesterID like '2019__'
union 
select 
	p.PersonID,
	Fullname,
	'enrolled in IN605' as Reason
from Enrolment e
join Person p on p.PersonID = e.PersonID
where e.PaperID = 'IN605'

--without union...
--gives DIFFERENT results, so you can't use this as a substitiute
select 
	p.PersonID,
	Fullname,
	case
	when e.SemesterID like '2019__'  then 'enrolled in 2019'
	when e.PaperID = 'IN605' then 'enrolled in IN605'
	end as Reason
from Enrolment e
join Person p on p.PersonID = e.PersonID
where e.SemesterID like '2019__' 
or e.PaperID = 'N605'


/*
e7.2	Produce one resultset with two columns. 
	List the all Paper Names and all the Person Full Names in one column.
	In the other column calculate the number of characters in the name.
	Sort the result with the longest name first.

*/

--with UNION
select
	PaperName,
	len(PaperName) as [Number of characters]
from Paper
union
select
	Fullname,
	len(Fullname)
from Person
order by [Number of characters] desc

--without UNION is impossible
--because we need to merge data from two columns
--on two different tables; join does not perform this