create table Supplier (
SupplierID int not null,
SupplierName nvarchar(50) not null,
GSTNumber nvarchar(10) null,
constraint PK_Supplier primary key (SupplierID)
)

insert Supplier (SupplierID, SupplierName, GSTNumber) values (1, 'ABC Ltd.', '12345678')
insert Supplier (SupplierID, SupplierName, GSTNumber) values (2, 'DEF Co.', '13579246')
insert Supplier (SupplierID, SupplierName, GSTNumber) values (3, 'KJL Ltd.', '12349878')


create table Customer (
CustomerID int not null,
CustomerName nvarchar(50) not null,
ContactEmail nvarchar(150) null,
IsLocal bit not null constraint DF_Customer_ContactEmail default 1,
constraint PK_Customer primary key (CustomerID)
)


insert Customer (CustomerID, CustomerName, ContactEmail, IsLocal) values (1, 'XYZ', 'xyz@internet.com', 1)
insert Customer (CustomerID, CustomerName,  ContactEmail, IsLocal) values (2, 'TUV', null, 1)
insert Customer (CustomerID, CustomerName,  ContactEmail, IsLocal) values (3, 'KJL Ltd.', 'info@kjl.co.nz', 1)


