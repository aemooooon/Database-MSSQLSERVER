/*create table structures*/

CREATE TABLE [dbo].[Component](
	[ComponentID] [int] NOT NULL,
 CONSTRAINT [PK_Component] PRIMARY KEY CLUSTERED 
(
	[ComponentID] ASC
)
)
GO

CREATE TABLE [dbo].[Assembly](
	[AssemblyID] [int] NULL,
	[SubcomponentID] [int] NULL
) 
GO
ALTER TABLE [dbo].[Assembly]  WITH CHECK ADD  
CONSTRAINT [FK_Assembly_Assembly] FOREIGN KEY([AssemblyID])
REFERENCES [dbo].[Component] ([ComponentID])
GO
ALTER TABLE [dbo].[Assembly]  WITH CHECK ADD  
CONSTRAINT [FK_Assembly_Subcomponent] FOREIGN KEY([SubcomponentID])
REFERENCES [dbo].[Component] ([ComponentID])


/*create data*/
insert component (componentID) values (1)
insert component (componentID) values (2)
insert component (componentID) values (3)
insert component (componentID) values (4)
insert component (componentID) values (5)
insert component (componentID) values (6)
insert component (componentID) values (7)
insert component (componentID) values (8)
insert component (componentID) values (9)
insert component (componentID) values (10)
insert component (componentID) values (11)
insert component (componentID) values (12)
insert component (componentID) values (13)
insert component (componentID) values (14)
insert component (componentID) values (15)
insert component (componentID) values (16)


insert Assembly (AssemblyID, SubcomponentID) values (1,2)
insert Assembly (AssemblyID, SubcomponentID) values (1,3)
insert Assembly (AssemblyID, SubcomponentID) values (4,5)
insert Assembly (AssemblyID, SubcomponentID) values (4,6)
insert Assembly (AssemblyID, SubcomponentID) values (4,7)
insert Assembly (AssemblyID, SubcomponentID) values (7,8)
insert Assembly (AssemblyID, SubcomponentID) values (7,9)
insert Assembly (AssemblyID, SubcomponentID) values (9,10)
insert Assembly (AssemblyID, SubcomponentID) values (9, 11)
insert Assembly (AssemblyID, SubcomponentID) values (9, 12)
insert Assembly (AssemblyID, SubcomponentID) values (12, 13)
insert Assembly (AssemblyID, SubcomponentID) values (12, 7)
insert Assembly (AssemblyID, SubcomponentID) values (3, 14)
insert Assembly (AssemblyID, SubcomponentID) values (3, 15)

/*create list of edges to represent tree*/

declare @testID int
set @testID = 4

declare @check table(
AssemblyID int,
SubComponentID int
)

insert @check (assemblyID, subcomponentID)
select assemblyID, subcomponentID
from assembly
where assemblyID = @testID

while @@rowcount > 0
begin
	insert @check (assemblyID, subcomponentID) 
	select a.assemblyID, a.subcomponentID 
	from @check c
	join Assembly a on a.AssemblyID = c.SubcomponentID
	where a.AssemblyID not in (select AssemblyID from @check)
end

select * from @check
