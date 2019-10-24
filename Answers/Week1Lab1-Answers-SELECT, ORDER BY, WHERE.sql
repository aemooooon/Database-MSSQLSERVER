/*
Exercises for section 1

1.1   	Develop a statement that returns all columns from Paper 

	select * from Paper

1.2   	Develop a statement that returns the semester ID and number of weeks in the semester

	select SemesterID, datediff(week, StartDate, EndDate) as [Number of Weeks] from Semester

1.3	Develop a statement that returns a person's ID, family name 
	and Name Type, a text value about the length of the family name; 
	if the family name is 4 characters or less return 'short name'
	if the family name is 5-8 characters long return 'middle length name'
	if the family name is 9 characters or more return 'long name'

	select PersonID, FamilyName,
		case 
		when len(FamilyName) <= 4 then 'short name'
		when len(FamilyName) >= 9 then 'long name'
		else 'middle length name'
		end as [Name Type]
	from Person

1.4	Develop a statement that returns the starting dates of the first four semesters

	select top 4 StartDate from Semester

1.5	Develop a statement that returns every unique person given name only once

	select distinct GivenName from Person

*/
/*
Exercises for section 2

2.1	Develop a statement that returns semester ID and start date
	of all semesters in reverse chronological order of their start date

	select SemesterID, StartDate from Semester order by StartDate desc

2.2	Develop a statement that lists each different family name (on the Person table)
	sorted according to the length of the family name with the longest family names first.
	If different family names have the same length, they must be listed alphabetically.

	select distinct FamilyName, len(FamilyName) as [Name Length] from Person order by len(FamilyName) desc, FamilyName

2.3	Develop a statement that returns the semester ID of the three shortest semesters
	based on the number of days in the semester. Include all semesters that tie for third shortest.

	select top 3 with ties semesterID from Semester order by datediff(day, StartDate, EndDate) asc

*/

/*
Exercises for section 3

3.1	Develop a statement that returns the ID and full name of each person
	who has a given name starting with 'Gr' and ending with 'n'

	select PersonID, FullName from Person where GivenName like 'Gr%n'

3.2	Develop a statement that returns the full name of every person
	who has no letter 'e' in their full name. 
	Output the names in alphabetical order of the family name.

	select FullName from Person where FullName not like '%e%' order by FamilyName asc

3.3	Develop a statement that returns the ID and Name of the papers
	that have an ID not starting with the characters 'IT'

	select PaperID, PaperName from Paper where left(PaperID, 2) !='IT'

3.4	Develop a statement that returns the full name of every person 
	who has a given name with at least 5 characters 
	and a family name beginning with a letter in the first half of the alphabet (A to M)

	select FullName from Person where len(GivenName) >= 5 and FamilyName like '[A-M]%'

*/