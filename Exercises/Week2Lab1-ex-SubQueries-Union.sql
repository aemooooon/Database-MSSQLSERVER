/*
Using Transact-SQL : Exercises
------------------------------------------------------------
Exercises for section 6 Subqueries

e6.1	List the paper with the lowest average enrolment per instance. Ignore all papers with no enrolments.
	Display the paper ID, paper name and average enrolment count.
*/

/*
e6.2	List the paper with the highest average enrolment per instance. 
	Display the paper ID, paper name and average enrolment count.
*/

/*
e6.3	For each paper that has a paper instance: list the paper ID, paper name, 
	starting date of the earliest instance, starting date of the most recent instance, 
	the minimum number of enrolments in the instances,
	maximum number of enrolments in the instances and 
	average number of enrolments across all	the instances.
*/

/*
e6.4	Which paper attracts people with long names? Find the background statistics 
	to support a hypothesis test: for each paper with enrolments calculate the mean full name length, 
	sample standard deviation full name length & sample size (that is: number of enrolments).
*/

/*
e6.5	Rank the semesters from the most loaded (that is: the highest number of enrolments) to
	the least loaded. Calculate the ordinal position (1 for first, 2 for second...) of the semester
	in this ranking.

Exercises for section 7

--Use UNION to solve these tasks. 
--Note that these tasks could possibly be solved by another non-UNION statement.
--Can you also write a non-UNION statement that produces the same result?   

e7.1	In one result, list all the people who enrolled in a paper delivered during 2019 and
	all the people who have enrolled in IN605. 
	The result should have three columns: PersonID, Full Name and the reason the person
	is on the list - either 'enrolled in 2019' or 'enrolled in IN605'

e7.2	Produce one resultset with two columns. List the all Paper Names and all the Person Full Names in one column.
	In the other column calculate the number of characters in the name.
	Sort the result with the longest name first.

*/