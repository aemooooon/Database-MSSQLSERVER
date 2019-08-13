/*                                                                        */
/*              InstPubs.SQL - Creates the Pubs database                  */ 
/*                                                                        */
/*
** Copyright Microsoft, Inc. 
** All Rights Reserved.
*/

/* DB3 STUDENTS: YOUR DATABASE HERE */
--USE [??????]  Your existing DB (it's the only one we have at the moment)


/* Clear out any tables from previous builds */

IF OBJECT_ID('employee') IS NOT NULL DROP TABLE employee
IF OBJECT_ID('jobs') IS NOT NULL DROP TABLE jobs
IF OBJECT_ID('pub_info') IS NOT NULL DROP TABLE pub_info
IF OBJECT_ID('discounts') IS NOT NULL DROP TABLE discounts
IF OBJECT_ID('stor_id') IS NOT NULL DROP TABLE stor_id
IF OBJECT_ID('sales') IS NOT NULL DROP TABLE sales
IF OBJECT_ID('roysched') IS NOT NULL DROP TABLE roysched
IF OBJECT_ID('titleauthor') IS NOT NULL DROP TABLE titleauthor
IF OBJECT_ID('titles') IS NOT NULL DROP TABLE titles
IF OBJECT_ID('publishers') IS NOT NULL DROP TABLE publishers
IF OBJECT_ID('authors') IS NOT NULL DROP TABLE authors
IF OBJECT_ID('stores') IS NOT NULL DROP TABLE stores



SET NOCOUNT ON
GO

set nocount    on
set dateformat dmy

GO


--////////////////////////////////////////////////////////////////////////////////
CREATE TABLE authors
(
   au_id          varchar(11) NOT NULL

         CHECK (au_id like '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]')

         CONSTRAINT UPKCL_auidind PRIMARY KEY CLUSTERED,

   au_lname       varchar(40)       NOT NULL,
   au_fname       varchar(20)       NOT NULL,

   phone          char(12)          NOT NULL

         DEFAULT ('UNKNOWN'),

   address        varchar(40)           NULL,
   city           varchar(20)           NULL,
   state          char(2)               NULL,

   zip            char(5)               NULL

         CHECK (zip like '[0-9][0-9][0-9][0-9][0-9]'),

   contract       bit               NOT NULL
)

GO

--////////////////////////////////////////////////////////////////////////////////
CREATE TABLE publishers
(
   pub_id         char(4)           NOT NULL

         CONSTRAINT UPKCL_pubind PRIMARY KEY CLUSTERED

         CHECK (pub_id in ('1389', '0736', '0877', '1622', '1756')
            OR pub_id like '99[0-9][0-9]'),

   pub_name       varchar(40)           NULL,
   city           varchar(20)           NULL,
   state          char(2)               NULL,

   country        varchar(30)           NULL

         DEFAULT('New Zealand')
)

GO

--////////////////////////////////////////////////////////////////////////////////
CREATE TABLE titles
(
   title_id       varchar(6) NOT NULL

         CONSTRAINT UPKCL_titleidind PRIMARY KEY CLUSTERED,

   title          varchar(80)       NOT NULL,

   type           char(12)          NOT NULL

         DEFAULT ('UNDECIDED'),

   pub_id         char(4)               NULL

         REFERENCES publishers(pub_id),

   price          money                 NULL,
   advance        money                 NULL,
   royalty        int                   NULL,
   ytd_sales      int                   NULL,
   notes          varchar(200)          NULL,

   pubdate        datetime          NOT NULL

         DEFAULT (getdate())
)

GO

--////////////////////////////////////////////////////////////////////////////////
CREATE TABLE titleauthor
(
   au_id          varchar(11) NOT NULL

         REFERENCES authors(au_id),

   title_id       varchar(6) NOT NULL

         REFERENCES titles(title_id),

   au_ord         tinyint               NULL,
   royaltyper     int                   NULL,


   CONSTRAINT UPKCL_taind PRIMARY KEY CLUSTERED(au_id, title_id)
)

GO

--////////////////////////////////////////////////////////////////////////////////
CREATE TABLE stores
(
   stor_id        char(4)           NOT NULL

         CONSTRAINT UPK_storeid PRIMARY KEY CLUSTERED,

   stor_name      varchar(40)           NULL,
   stor_address   varchar(40)           NULL,
   city           varchar(20)           NULL,
   state          char(2)               NULL,
   zip            char(5)               NULL
)

GO

--////////////////////////////////////////////////////////////////////////////////
CREATE TABLE sales
(
   stor_id        char(4)           NOT NULL

         REFERENCES stores(stor_id),

   ord_num        varchar(20)       NOT NULL,
   ord_date       datetime          NOT NULL,
   qty            smallint          NOT NULL,
   payterms       varchar(12)       NOT NULL,

   title_id       varchar(6) NOT NULL

         REFERENCES titles(title_id),


   CONSTRAINT UPKCL_sales PRIMARY KEY CLUSTERED (stor_id, ord_num, title_id)
)

GO

--////////////////////////////////////////////////////////////////////////////////
CREATE TABLE roysched
(
   title_id       varchar(6) NOT NULL

         REFERENCES titles(title_id),

   lorange        int                   NULL,
   hirange        int                   NULL,
   royalty        int                   NULL
)

GO

--////////////////////////////////////////////////////////////////////////////////
CREATE TABLE discounts
(
   discounttype   varchar(40)       NOT NULL,

   stor_id        char(4) NULL

         REFERENCES stores(stor_id),

   lowqty         smallint              NULL,
   highqty        smallint              NULL,
   discount       dec(4,2)          NOT NULL
)

GO

--////////////////////////////////////////////////////////////////////////////////
CREATE TABLE jobs
(
   job_id         smallint          IDENTITY(1,1)

         PRIMARY KEY CLUSTERED,

   job_desc       varchar(50)       NOT NULL

         DEFAULT 'New Position - title not formalized yet',

   min_lvl        tinyint           NOT NULL

         CHECK (min_lvl >= 10),

   max_lvl        tinyint           NOT NULL

         CHECK (max_lvl <= 250)
)

GO

--////////////////////////////////////////////////////////////////////////////////
CREATE TABLE pub_info
(
   pub_id         char(4)           NOT NULL

         REFERENCES publishers(pub_id)

         CONSTRAINT UPKCL_pubinfo PRIMARY KEY CLUSTERED,

   logo           image                 NULL,
   pr_info        text                  NULL
)

GO

--////////////////////////////////////////////////////////////////////////////////
CREATE TABLE employee
(
   emp_id         char(9) NOT NULL

         CONSTRAINT PK_emp_id PRIMARY KEY NONCLUSTERED

         CONSTRAINT CK_emp_id CHECK (emp_id LIKE
            '[A-Z][A-Z][A-Z][1-9][0-9][0-9][0-9][0-9][FM]' or
            emp_id LIKE '[A-Z]-[A-Z][1-9][0-9][0-9][0-9][0-9][FM]'),

   fname          varchar(20)       NOT NULL,
   minit          char(1)               NULL,
   lname          varchar(30)       NOT NULL,

   job_id         smallint          NOT NULL

         DEFAULT 1

         REFERENCES jobs(job_id),

   job_lvl        tinyint

         DEFAULT 10,

   pub_id         char(4)           NOT NULL

         DEFAULT ('9952')

         REFERENCES publishers(pub_id),

   hire_date      datetime          NOT NULL

         DEFAULT (getdate())
)


GO