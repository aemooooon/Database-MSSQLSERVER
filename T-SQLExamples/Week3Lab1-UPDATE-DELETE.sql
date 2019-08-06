
--9.1   Simple UPDATE statements modify all rows of a table

	update Words set aValue = 3.21

	update Words set aValue = aValue * 1.125

--9.2   Use WHERE clause to restrict the rows that are modified

	update Words set theMeaning = reverse(theWord), aValue = len(theWord)
	where theMeaning is null

	update Words set aValue = len(theWord)
	where theMeaning like 'top 10%'

--9.3   Set values to DEFAULT value

	update Words set aValue = default
	where theMeaning like '%most enrolled%'

--9.4   Use FROM clause to gather update values from other tables

	update Words set aValue = w.aValue + ec.EnrolmentCount
select * from Words w
	join (select p.FullName, count(e.PaperID) as EnrolmentCount
		from Person p
		join Enrolment e on e.PersonID = p.PersonID
		group by p.Fullname
		) ec on ec.FullName = w.theWord
		
		

GO
IF OBJECT_ID ('Table1', 'U') IS NOT NULL
    DROP TABLE Table1;
GO
IF OBJECT_ID ('Table2', 'U') IS NOT NULL
    DROP TABLE Table2;
GO

/* note on decimal: decimal(p ,s) 
p (precision)
The maximum total number of decimal digits to be stored. 
This number includes both the left and the right sides of the decimal point. 
The precision must be a value from 1 through the maximum precision of 38. The default precision is 18.
s (scale)
The number of decimal digits that are stored to the right of the decimal point. 
This number is subtracted from p to determine the maximum number of digits to the left of the decimal point. 
Scale must be a value from 0 through p, and can only be specified if precision is specified. 
The default scale is 0 and so 0 <= s <= p. Maximum storage sizes vary, based on the precision.
*/
CREATE TABLE Table1 
    (ColA int NOT NULL, ColB decimal(10,3) NOT NULL); 
GO
CREATE TABLE Table2 
    (ColA int PRIMARY KEY NOT NULL, ColB decimal(10,3) NOT NULL);
GO
INSERT INTO Table1 VALUES(1, 10.0), (1, 20.0), (1, 0.0);
GO
INSERT INTO Table2 VALUES(1, 10.0), (2, 20.0), (3, 0.0);
GO
UPDATE Table2 
SET Table2.ColB = Table2.ColB + Table1.ColB
FROM Table2 
    INNER JOIN Table1 
    ON (Table2.ColA = Table1.ColA);
GO
SELECT ColA, ColB 
FROM Table2;


--10.0   DELETE statements remove entire rows from a table

/*
--   useful scripts

	select * from Words

--   note: run all statements in section 8 to re-populate Words table
*/

--10.1   Simple DELETE statements remove all rows of a table
--	FROM is optional

	delete from Words 

--10.2   Use WHERE clause to restrict the rows that are deleted

	delete Words 
	where theMeaning is null

	delete Words 
	where theMeaning like 'top 10%' and aValue < 3

	delete Words
	where len(theWord) in (3, 5, 7, 9)

--10.3   Transact-SQL allows joins to restrict rows to be deleted

	delete Words
--	select *
	from Words w
	join Person p on w.theWord = p.FullName
	join Enrolment e on e.PersonID = p.PersonID
	where e.PaperID = 'IN705'

--10.4	TRUNCATE TABLE is a fast, non-logged method 
--		to remove all rows on a table.
--		It has the side effect of reseting IDENTITY values 
--		back to identity seed.

	truncate table Words