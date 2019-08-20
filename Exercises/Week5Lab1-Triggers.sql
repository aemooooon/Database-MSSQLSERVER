/*
Using Transact-SQL : Exercises
------------------------------------------------------------

Exercises for section 11 : TRIGGER

*In all exercises, write the answer statement and then execute it.

*Before you start, run these statements against your database:

		create table [Password](
			PersonID nvarchar(16) not null primary key,
			pwd char(4) not null default left(newID(), 4)  --automatically create a new password
			constraint [fk_password_person] foreign key (PersonID) references Person (PersonID) 	
			on delete cascade on update cascade 			
			)

		insert Person (PersonID, GivenName, FamilyName, FullName)
		values ('122', 'Krissi', 'Wood', 'Krissi Wood')

		drop table Withdrawn

		create table Withdrawn(
			PaperID nvarchar(10) not null,
			SemesterID char(6) not null,
			PersonID nvarchar(16) not null,
			WithdrawnDateTime datetime not null default getdate()
			constraint [pk_withdrawn] primary key (PaperID, SemesterID, PersonID)
			)


e11.1		Create a trigger that reacts to new records on the Person table. 
			The trigger creates new related records on the Password table, automatically creating passwords.

		
		

e11.2		Create a trigger that reacts to new paper instances
			by automatically making an enrolment for Krissi Wood in those paper instances
			
			drop trigger trigPaperInstanceInsert
			
			
			

			

e11.3		Create two triggers that record the people who withdraw or dropout of a paper 
			when it is running [compare the system date to the semester dates].
			The details of the withdrawl should be posted to the Withdrawn table.


1.	If a student can withdraw from a paper, then re-enrol, then withdraw again in one single semester.
	BTW: this is NOT how things run at Otago Polytechnic.

				--if person already has a withdrawn record for this paper instance
				--insert will cause a PK violation, so
				--delete the existing record before inserting new record

			


2.	If a student can withdraw from the paper only one time in a single semester
	BTW: this is what happens at OP. Drop or disable the previous trigger.





e11.4		Enhance the mechanism from e11.1 so that it also reacts when 
			a person's PersonID is modified. 
			In this case, the system must generate a new password for the modified PersonID.

	*/		