-- LIBRARY_SYSTEM_MANAGEMENT_ANALYSIS_PROJECT

-- CREATING DATABASE

CREATE DATABASE LIBRARY_MANAGEMENT_ANALYSIS;

USE LIBRARY_MANAGEMENT_ANALYSIS;

CREATE table BRANCH(
branch_id	varchar(10) PRIMARY KEY,
manager_id	varchar(10),
branch_address	varchar(55),
contact_no varchar(10)
);

ALTER TABLE BRANCH
MODIFY COLUMN contact_no varchar(20);

CREATE  TABLE EMPLOYEES(
emp_id	varchar(10) PRIMARY KEY,
emp_name	varchar(25),
position	varchar(15),
salary	INT,
branch_id varchar(25)); -- FK

DROP TABLE BOOKS;

CREATE TABLE BOOKS(
isbn	varchar(20) PRIMARY KEY,
book_title	varchar(75),
category	varchar(10),
rental_price	FLOAT,
status	varchar(15),
author	varchar(35),
publisher varchar(55));

ALTER table BOOKS
MODIFY column category varchar(20);

DESC BOOKS;

CREATE TABLE MEMBERS(
member_id	varchar(20) PRIMARY KEY,
member_name	varchar(25),
member_address	varchar(75),
reg_date DATE
);

CREATE TABLE ISSUED_STATUS(
issued_id	varchar(10) PRIMARY KEY,
issued_member_id	varchar(10), -- FK
issued_book_name	varchar(75), 
issued_date	DATE,
issued_book_isbn	varchar(25), -- FK
issued_emp_id varchar(10));  -- FK

CREATE TABLE RETURN_STATUS(
return_id	varchar(10) PRIMARY KEY,
issued_id	varchar(10),
return_book_name	varchar(75),
return_date	DATE,
return_book_isbn varchar(20));

-- FOREIGN KEY
ALTER TABLE ISSUED_STATUS
ADD constraint FK_MEMBERS
foreign key (issued_member_id)
references MEMBERS(member_id);

ALTER TABLE ISSUED_STATUS
ADD constraint FK_BOOKS
foreign key (issued_book_isbn)
references BOOKS(isbn);

ALTER TABLE ISSUED_STATUS
ADD constraint FK_EMPLOYEES
foreign key (issued_emp_id)
references EMPLOYEES(emp_id);

ALTER TABLE EMPLOYEES
ADD constraint FK_BRANCH
foreign key (branch_id)
references BRANCH(branch_id);

ALTER TABLE RETURN_STATUS
ADD constraint FK_ISSUED
foreign key (issued_id)
references ISSUED_STATUS(issued_id);

SELECT* FROM issued_status;
SELECT* FROM employees;

select * from books;
select * from branch;
select * from employees;
select * from issued_status;
select * from members;
select * from return_status;


-- prject tasks

# 2. CRUD Operations
Create : Inserted sample records into the books table.
Read: Retrieved and displayed data from various tables.
Update: Updated records in the employees table.
Delete: Removed records from the members table as needed. #

-- Task 1. Create a New Book Record 
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

insert into books(isbn, book_title, category, rental_price, status, author, publisher)
values('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

-- Task 2: Update an Existing Member's Address

update	members
set member_address = "125 Oak St"
where member_id = 'C103';

-- Task 3: Delete a Record from the Issued Status Table
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

delete from issued_status
where issued_id ='IS121';

-- Task 4: Retrieve All Books Issued by a Specific Employee
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

select  * 
from  issued_status
where issued_emp_id= 'E101';

-- Task 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.

select issued_member_id, count(issued_member_id) as Total_books_Issued
from issued_status
group by issued_member_id
having Total_books_Issued > 1;

SELECT
    issued_emp_id,
    COUNT(issued_id) as Total_books_issued
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_id) > 1;

# 3. CTAS (Create Table As Select) #
 -- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt** 

select * from books;
select * from issued_status;

create table book_issued_cnt as
select b.isbn, b.book_title, count(issued_book_isbn) as issued_cnt
from books as b
join issued_status as iss
on b.isbn = iss.issued_book_isbn
group by b.isbn, b.book_title;

select * from book_issued_cnt;

-- 4. Data Analysis & Findings
-- The following SQL queries were used to address specific questions: 

-- Task 7. Retrieve All Books in a Specific Category:

select * 
from books 
where category = "children";

-- Task 8: Find Total Rental Income by Category:

select b.category, sum(b.rental_price) as Total_Rental_Income, count(*)
from books as b
join issued_status as iss
on b.isbn = iss.issued_book_isbn
group by b.category;

-- List Members Who Registered in the Last 180 Days:

select * from members;

select *
from members
where reg_date >= current_date()-interval 180 day ;

-- List Employees with Their Branch Manager's Name and their branch details:

select* from employees;
select* from branch;

select e1.emp_id,e1.emp_name,e1.position,e1.salary,b.*,e2.emp_name as Manager
from employees e1
join 
branch b
on e1.branch_id = b.branch_id
join 
employees e2
on e2.emp_id = b.manager_id;

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:

select* from books;

create table Expensive_books as
select * from books where rental_price > 7;

select* from expensive_books;

-- Task 12: Retrieve the List of Books Not Yet Returned

select* from return_status;

SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;

-- end of project
