/*
SELECT ...,
	ROW_NUMBER( ) OVER ( [ <partition_by_clause> ] <order_by_clause> ),
	RANK( ) OVER ( [ <partition_by_clause> ] <order_by_clause> ),
	DENSE_RANK( ) OVER ( [ <partition_by_clause> ] <order_by_clause> ),
	NTILE(integer_expression) OVER ( [ <partition_by_clause> ] < order_by_clause > )
FROM ...


*/

--17.0	RANKing functions are provided in SQL Server from 2005 onwards

--17.1	ROW_NUMBER() calculates the ordinal position of the ROW

	select *, ROW_NUMBER() OVER (ORDER BY PaperName ) as [Row Number]
	from Paper
	
	
--17.2	RANK() calculates the ordinal positon of DATA

--compare this to ROW_NUMBER
--notice how RANK handles ties on 'Special'
	select *, RANK() OVER (ORDER BY PaperName) as [Alphabetical RANK]
	from Paper


--17.3	DENSE_RANK() calculates the ordinal positon of DATA
--			with no gaps in the position sequence

--compare this to RANK
--notice how DENSE_RANK handles Alphabetical Dense RANK
--on 'Extraspecial Topic' and following data
	select 	*, DENSE_RANK() OVER (ORDER BY PaperName) as [Alphabetical Dense RANK]
	from Paper


--17.4	RANKing order and resultset sort order are independent 
--			OVER (ORDER BY ...) clause specifies the order to calculate the RANK value
--			ORDER BY clause specifies the sort order the resultset rows, after RANKing is calculated

	select 	*, RANK() OVER (ORDER by PaperName) as [Alphabetical RANK]
	from Paper
	order by PaperID


	select *, ROW_NUMBER() OVER (ORDER by PaperName) as [Row Number]
	from Paper
	order by PaperID


--17.5	WHERE clause filters data before RANKing is calculated

	select *, RANK() OVER (ORDER by PaperName) as [Alphabetical RANK]
	from Paper
	where left(PaperName, 1) = 'D'
	order by [Alphabetical RANK] desc


	select *, DENSE_RANK() OVER (ORDER by PaperName) as [Alphabetical Dense RANK]
	from Paper
	where left(PaperName, 1) = 'D'



--17.5	PARTITION BY clause breaks data into RANKing groups
--			RANKing value restarts for each partition

--	compare FamilyName RANK with Partitioned FamilyName RANK
	select PersonID, 	FullName, FamilyName,
		RANK() OVER (ORDER BY FamilyName) as [FamilyName RANK],
		RANK() OVER (PARTITION BY FamilyName ORDER BY PersonID) as [Partitioned FamilyName RANK]
	from Person










