
-- Read the documentation for the use of the inserted and deleted tables
--https://docs.microsoft.com/en-us/sql/relational-databases/triggers/use-the-inserted-and-deleted-tables?view=sql-server-2017


--11.0   TRIGGERs fire in response to a table event - insert, update or delete

/*
--   Useful scripts

	select * from Words

	delete InsertedWords
	delete DeletedWords
	delete Words

	drop table Words
	drop table InsertedWords
	drop table DeletedWords
*/
	
--11.1   Create tables to track the operation of triggers

	--target table that we will insert, update and delete on
	create table Words
		( 
		theID int identity(1000, 1) primary key,
		theWord nvarchar(50) not null default '<no word>',
		theMeaning nvarchar(100) null,
		aValue decimal(9,4) default 0
		)
	go

	-- table to permanently capture the contents of
	-- the 'Inserted' virtual table
	create table InsertedWords
		( 
		theID int ,
		theWord nvarchar(50) null,
		theMeaning nvarchar(100) null,
		aValue decimal(9,4) null,
		tableEvent nvarchar(10) null,
		eventTime dateTime default getdate(),
		eventUser nvarchar(128) default system_user
		)
	go

	-- table to permanently capture the contents of
	-- the 'Deleted' virtual table
	create table DeletedWords
		( 
		theID int ,
		theWord nvarchar(50) null,
		theMeaning nvarchar(100) null,
		aValue decimal(9,4) null,
		tableEvent nvarchar(10) null,
		eventTime dateTime default getdate(),
		eventUser nvarchar(128) default system_user
		)
	go

--11.2   CREATE TRIGGERs on the target table 
--	capture the contents of the Inserted virtual table
--	to the InsertedWords table
--	and capture the contents of the Deleted virtual table
--	to the DeletedWords table
--	NOTE: this is not a normal use of triggers;
--	it's to learn about what is going on

	--when rows are added to the Words table
	create trigger trigInsertWord on Words
	after insert
	as
	begin
		insert InsertedWords (theID, theWord, theMeaning, aValue, tableEvent)
		select theID, theWord, theMeaning, aValue, 'insert' from inserted

		insert DeletedWords (theID, theWord, theMeaning, aValue, tableEvent)
		select theID, theWord, theMeaning, aValue, 'insert' from deleted
	end
	go

	--when rows are removed from the Words table
	create trigger trigDeletedWord on Words
	After delete
	as
	begin
		insert InsertedWords (theID, theWord, theMeaning, aValue, tableEvent)
		select theID, theWord, theMeaning, aValue, 'delete' from inserted

		insert DeletedWords (theID, theWord, theMeaning, aValue, tableEvent)
		select theID, theWord, theMeaning, aValue, 'delete' from deleted
	end
	go

	--when values are changed on the Words table
	create trigger trigUpdateWord on Words
	After update
	as
	begin
		insert InsertedWords (theID, theWord, theMeaning, aValue, tableEvent)
		select theID, theWord, theMeaning, aValue, 'update' from inserted

		insert DeletedWords (theID, theWord, theMeaning, aValue, tableEvent)
		select theID, theWord, theMeaning, aValue, 'update' from deleted
	end
	go

--	11.3		ALTER TRIGGER & DROP TRIGGER 

	create trigger dummyTrigger on Enrolment
	for insert
	as
	begin
		print 'New enrolment attempted'
	end
	go

--		Use ALTER TRIGGER when modifying an existing trigger.
--		This ensures that trigger settings are retained across versions

	alter trigger dummyTrigger on Enrolment
	for insert
	as
	begin
		print 'Enrolment insert'
	end
	go				

--		DROP TRIGGER deletes an existing trigger

	drop trigger dummyTrigger
	go


--11.4   Test the triggers and observe the changes to 
--	the InsertedWords and DeletedWords tables

--11.4a	insert a row
	insert Words (theWord, theMeaning, aValue)
	values ('cat', 'animal of the feline persuasion', 7)

	select * from Words
	select * from InsertedWords
	select * from DeletedWords


--11.4b	insert a set of rows
	insert Words (theWord, theMeaning, aValue)
	select top 5 with ties p.FullName, 'top 5 most enrolled person', count(e.PaperID)
	from Enrolment e
	join Person p on p.PersonID = e.PersonID
	group by e.PersonID, p.FullName
	order by count(PaperID) desc

	select * from Words
	select * from InsertedWords
	select * from DeletedWords


--11.4c	update a single row
	update Words set theMeaning = reverse(theWord), aValue = len(theWord)
	where theWord = 'cat'

	select * from Words
	select * from InsertedWords
	select * from DeletedWords


--11.4d	update a set of rows
	update Words set aValue = len(theWord)
	where theMeaning like 'top 5%'

	select * from Words
	select * from InsertedWords
	select * from DeletedWords


--11.4e	delete a single row
	delete Words where theWord = 'cat'

	select * from Words
	select * from InsertedWords
	select * from DeletedWords


--11.4f	delete a set of rows
	delete Words
	from Words w
	join Person p on w.theWord = p.FullName
	join Enrolment e on e.PersonID = p.PersonID
	where e.PaperID = 'IN510'

	select * from Words
	select * from InsertedWords
	select * from DeletedWords


--11.5	A trigger in SQL Server 2017 is either a FOR AFTER trigger or a INSTEAD OF trigger.
--	FOR AFTER triggers (AFTER is the default when FOR is the only key word specified) fire after all the triggering
--	operations have completed.
--	INSTEAD OF triggers fire before the triggering operation and override the
--	triggering operation. Read http://www.sqlservertutorial.net/sql-server-triggers/sql-server-instead-of-trigger/ for a more thorough explanation.

--11.5	You can restrict the firing of a trigger depending on the columns that are updated.
	create trigger trigUpdateTheWord
	on Words
	after update, insert
	as
	begin
		if update(theWord)
		update Words set theMeaning = 'theWord has ' + cast(len(i.theWord) as nvarchar(4)) + ' characters'
		from inserted i 
		join Words w on w.theID = i.theID
	end

--	now test it
	--check data before operations
	select * from Words

	--perform an insert
	insert Words (theWord) values ('whale')
	insert Words (aValue) values (22)	

	--check data
	select * from Words

	--perform an update
	update Words set theWord = 'fish' where theWord = 'whale'
	update Words set theMeaning = null
	update Words set aValue = aValue + 3.0
	update Words set theWord = 'whale', aValue = 0.0 where theWord = 'fish'

	--check data
	select * from Words
	
	--tidy up
	drop trigger trigUpdateTheWord



--11.6	Auditing column triggers
--	record the modifier and modification date of rows

--	On lecture database
	alter table Words add
	 	Creator nvarchar(16) not null  default user_name() with values ,
	 	CreationTime datetime not null default getdate() with values,
	 	Modifier nvarchar(16) not null default user_name() with values,
	 	ModificationTime datetime not null default getdate() with values
	
	go

	create trigger Words_UTrig 
	on Words 
	for update
	as
	set nocount on
	begin
		update Words
		set Words.ModificationTime=getdate(), Words.Modifier=user_name()
		from Words, inserted
		where inserted.theID=Words.theID
	end
	
	--alternatively
	
	create trigger Words_UTrig 
	on Words 
	for update
	as
	set nocount on
	begin
		update Words
		set Words.ModificationTime=getdate(), Words.Modifier=user_name()
		from Words
		join inserted
			on inserted.theID=Words.theID
	end

--	now test it by modifying data on the Words table
Select * from words
Update Words set theMeaning = 'Hello World' where theID = 1002
Select * from words

