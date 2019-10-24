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
			
			)


e11.1		Create a trigger that reacts to new records on the Person table. 
			The trigger creates new related records on the Password table, automatically creating passwords.
*/
			create trigger trigPersonInsert on Person
			for insert
			as
			begin
				set nocount on 

				insert [Password](PersonID) 
				select PersonID from inserted
			end

		
/*
e11.2		Create a trigger that reacts to new paper instances
			by automatically making an enrolment for Krissi Wood in those paper instances
*/
			drop trigger trigPaperInstanceInsert
			
			create trigger trigPaperInstanceInsert on PaperInstance
			for insert
			as
			begin
				set nocount on

				insert Enrolment (PaperID, SemesterID, PersonID)
				select PaperID, SemesterID, 122	from inserted
			end

			insert into PaperInstance values (105, '2019S2')
			select * from enrolment
/*
e11.3		Create a mechanism that records the people who withdraw or dropout of a paper 
			when it is running [compare the system date to the semester dates].
			The details of the withdrawl should be posted to the Withdrawn table.


	If a student can withdraw from a paper, then re-enrol, then withdraw again in one single semester then use this
	BTW: this is NOT how things run at Otago Polytechnic.
 */
			alter trigger trigEnrolmentDelete on Enrolment
			for delete, update
			as
			begin
				set nocount on

				--if person already has a withdrawn record for this paper instance
				--insert will cause a PK violation, so
				--delete the existing record before inserting new record

				delete Withdrawn
				from Withdrawn w
				join deleted d
				on d.PaperID = w.PaperID and d.SemesterID = w.SemesterID and d.PersonID = w.PersonID

				insert Withdrawn (PaperID, SemesterID, PersonID)
				select d.PaperID, d.SemesterID, d.PersonID
				from deleted d
				join Semester s on d.SemesterID = s.SemesterID
				where getdate() between s.StartDate and s.EndDate
			end


Insert into enrolment values
delete from enrolment where PaperID= 'IN238' and personID = 101
delete from withdrawn
insert into enrolment values ('IN238','2019S2', 101)
drop trigger trigInsertEnrolment
drop trigger trigLogWithdraw
/*	If a student can withdraw from the paper only one time in a single semester then use this
	BTW: this is what happens at OP
 */
alter trigger trigLogWithdraw
on Enrolment
for delete
as
begin
	set nocount on
	
	insert Withdrawn (paperID, semesterID, personID)
	select distinct paperID, d.semesterID, personID from deleted d
	join Semester s on s.semesterID = d.semesterID
	where getdate() between s.startdate and s.enddate
	
end

/*
e11.4		Enhance the mechanism from e11.1 so that it also reacts when 
			a person's PersonID is modified. 
			In this case, the system must generate a new password for the modified PersonID.
*/
			create trigger trigPersonUpdate on Person
			for update
			as
			begin
				set nocount on 

				update [Password]
				set pwd = default
				where PersonID in (select PersonID from inserted)
			end