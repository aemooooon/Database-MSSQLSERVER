/*
Using Transact-SQL
---------------------------------------------


--16.0	NULL values require careful treatment

--16.1	NULLs are not included in aggregations

    --use World database
	--NB: IndepYear is null for some countries

	select count(*) as [Row Count], count(IndepYear) as [IndepYear Count] from Country

	select sum(IndepYear) as [IndepYear Total], count(*) as [Row Count], 
				sum(IndepYear)/count(*) as [Bad Average Calculation],
				avg(IndepYear) as [Correct Average Calculation]
	from Country


--16.2	NULLs cannot be compared another value

	select * from Country
	where IndepYear = NULL

	select * from Country
	where IndepYear != NULL

	--Note: NULL does not equal NULL !!!
	select * from Country
	where 1 = 1 --always true for every row

	select * from Country
	where null = null --always true for every row?


--16.3	Use IS to compare values to NULL

	select * from Country
	where IndepYear IS NULL

	select * from Country
	where IndepYear IS NOT NULL

	select * from Country
	where NOT IndepYear IS NULL

	--count the nulls
	select count(*) as [IndepYear Null Count] from Country
	where IndepYear IS NULL
		


--16.4	Use ISNULL() to treat nulls in a query

	--Convert NULL values to a non-null value
	select IndepYear, ISNULL(IndepYear, 123456) as [Processed Nulls] from Country