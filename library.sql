CREATE DATABASE Library;

-- Create table "Branch"
CREATE TABLE branch (
    branch_id VARCHAR(10) PRIMARY KEY NOT NULL,
    manager_id VARCHAR(10),
    branch_address VARCHAR(30),
    contact_no NUMERIC(12)
);


-- Create Table "Employee"
CREATE TABLE Employees (
    Emp_id VARCHAR(10) PRIMARY KEY NOT NULL,
    Emp_name VARCHAR(20),
    Position VARCHAR(15),
    Salary NUMERIC(10),
    branch_id VARCHAR(10),
    FOREIGN KEY (branch_id)
        REFERENCES branch (branch_id)
);

 -- Create table "Members"
CREATE TABLE members (
    Member_id VARCHAR(10) PRIMARY KEY NOT NULL,
    Member_name VARCHAR(20),
    Member_address VARCHAR(30),
    Reg_date DATE
);

-- Create table "Books"
CREATE TABLE Books (
    Isbn VARCHAR(30) PRIMARY KEY NOT NULL,
    Book_title VARCHAR(50),
    Category VARCHAR(15),
    Rental_price FLOAT,
    Status VARCHAR(5),
    Author VARCHAR(30),
    Publisher VARCHAR(30)
);

-- Create table "Return_status"
CREATE TABLE Return_status (
    Return_id VARCHAR(10) PRIMARY KEY,
    Issued_id VARCHAR(10),
    Return_book_name VARCHAR(30),
    Return_date DATE,
    Return_book_isbn VARCHAR(30),
    FOREIGN KEY (Return_book_isbn)
        REFERENCES Books (Isbn)
);

-- Create table "Issued_status"
CREATE TABLE Issued_status (
    Issued_id VARCHAR(10) PRIMARY KEY,
    Issued_member_id VARCHAR(10),
    Issued_book_name VARCHAR(50),
    Issued_date DATE,
    Issued_book_isbn VARCHAR(30),
    Issued_emp_id VARCHAR(10),
    FOREIGN KEY (Issued_member_id)
        REFERENCES Members (Member_id),
    FOREIGN KEY (Issued_book_isbn)
        REFERENCES Books (Isbn),
    FOREIGN KEY (Issued_emp_id)
        REFERENCES employees (Emp_id)
);


-- Create  a New Book Record - "978-1-60129-456-2", 'To Kill a Mockingbird', 'Classic',6.00,'yes',Harper Lee,''J.B.Lippincott & Co.'

INSERT INTO books 
VALUES("978-1-60129-456-2","To Kill a Mockingbird","Classic",6.00,"yes",'Harper Lee','J.B. Lippincott & Co,.');

SELECT* FROM books;

-- Update an existing Member's Address

SELECT * FROM members;

UPDATE members 
SET 
    Member_address = '125 Oak St'
WHERE
    Member_id = 'C103';
    
-- Delete a Record from issued status table

SELECT 
    *
FROM
    issued_status;

DELETE FROM issued_status 
WHERE
    Issued_id = 'IS121';
    

-- Retrive all books issued by employee e101

SELECT 
    Issued_book_name
FROM
    issued_status
WHERE
    Issued_emp_id = 'E101';
    

-- List members who have issued more than one book

SELECT 
    Issued_member_id, COUNT(Issued_member_id) AS Book_issued
FROM
    issued_status
GROUP BY 1
HAVING Book_issued >= 2;


-- CTAS- Create Table As Select

CREATE TABLE book_issued_cnt AS SELECT b.Isbn, b.Book_title, COUNT(ist.Issued_id) AS issue_count FROM
    books AS b
        JOIN
    issued_status AS ist ON b.Isbn = ist.Issued_book_isbn
GROUP BY 1 , 2;

SELECT* FROM book_issued_cnt;


-- Data Analysis and Findings

-- 1. Retrieve all books in a specific category

SELECT 
    *
FROM
    books
WHERE
    Category = 'Fiction';
    
-- 2. Find total rental income  by category

SELECT 
    b.Category, SUM(Rental_price * issue_count) AS revenue
FROM
    books AS b
        JOIN
    issued_status AS ist ON b.Isbn = ist.Issued_book_isbn
        JOIN
    book_issued_cnt AS bic ON b.Isbn = bic.Isbn
GROUP BY 1;

-- List members who registered in the last 180 days

-- select * from members
-- where Reg_date >= current_date-interval '180 days';



-- List the employee with their branch manager's name and their branch details

SELECT 
    emp.Emp_id,
    emp.Emp_name,
    emp.Position,
    emp.Salary,
    b.*,
    emp2.Emp_name AS manager
FROM
    employees AS emp
        JOIN
    branch AS b ON emp.branch_id = b.branch_id
        JOIN
    employees AS emp2 ON emp2.Emp_id = b.manager_id;
    
    
-- Create a table of books with rental price above a certain threshold

CREATE TABLE Expensive_books AS SELECT * FROM
    books
WHERE
    Rental_price >= 7.0;
    
SELECT * FROM expensive_books;


-- Retrieve the list of books not yet returned

SELECT 
    ist.*
FROM
    issued_status AS ist
        LEFT JOIN
    return_status AS rst ON ist.Issued_id = rst.Issued_id
WHERE
    rst.Return_id IS NULL;



