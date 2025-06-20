create database SQLHomework16
go
use SQLHomework16

--Lesson-16: CTEs and Derived Tables
--Notes before doing the tasks:
--•	Tasks should be solved using SQL Server.
--•	Case insensitivity applies.
--•	Alias names do not affect the score.
--•	Scoring is based on the correct output.
--•	One correct solution is sufficient.
--________________________________________
--Easy Tasks
--1.	Create a numbers table using a recursive query from 1 to 1000.


; with cte as(
select 1 as num
union all
select num+1 as num from cte
where num<=100
)
select * from cte
option(maxrecursion 1000)

--2.	Write a query to find the total sales per employee using a derived table.(Sales, Employees)

select * from Sales
select * from Employees

SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    SalesPerEmployee.TotalSales
FROM (
    SELECT EmployeeID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID
) AS SalesPerEmployee
JOIN Employees e ON e.EmployeeID = SalesPerEmployee.EmployeeID;


--3.	Create a CTE to find the average salary of employees.(Employees)

select * from Employees

; with avg_salary as(
select avg(salary) as avg_salary from Employees)
select * from avg_salary


--4.	Write a query using a derived table to find the highest sales for each product.(Sales, Products)

select * from Sales
select * from Products

SELECT 
    p.ProductID,
    p.ProductName,
    
    HighSales.HighestSales
FROM (
    SELECT ProductID, MAX(SalesAmount) AS HighestSales
    FROM Sales
    GROUP BY ProductID
) AS HighSales
JOIN Products p ON p.ProductID = HighSales.ProductID;


--5.	Beginning at 1, write a statement to double the number for each record, the max value you get should be less than 1000000.

; with cte as(
select 1 as num
union all
select num*2 as num from cte
where num*2<=1000000
)
select * from cte
option(maxrecursion 0)



--6.	Use a CTE to get the names of employees who have made more than 5 sales.(Sales, Employees)

select * from Sales
select * from Employees


WITH SalesCountCTE AS (
    SELECT EmployeeID, COUNT(*) AS SalesCount
    FROM Sales
    GROUP BY EmployeeID
    HAVING COUNT(*) > 5
)
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    s.SalesCount
FROM SalesCountCTE s
JOIN Employees e ON e.EmployeeID = s.EmployeeID;

--7.	Write a query using a CTE to find all products with sales greater than $500.(Sales, Products)

select * from Sales
select * from Products

; with total_salesCTE as (
select ProductID, sum(SalesAmount) as total_sales
from sales
group by ProductID
having sum(SalesAmount)>500)

select p.ProductID, p.ProductName, s.total_sales
from total_salesCTE s
join Products p
on p.productID=s.ProductID

--8.	Create a CTE to find employees with salaries above the average salary.(Employees)


select * from Employees

;with avg_salaryCTE as (
select avg(salary) as avgSalary
from Employees)
select e.employeeID, e.FirstName, e.LastName, e.Salary
from Employees e
cross join avg_salaryCTE a
where e.salary>a.avgSalary


--Medium Tasks
--1.	Write a query using a derived table to find the top 5 employees by the number of orders made.(Employees, Sales)

select * from Employees
select * from Sales

SELECT TOP 5
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    s.OrderCount
FROM (
    SELECT EmployeeID, COUNT(*) AS OrderCount
    FROM Sales
    GROUP BY EmployeeID
) AS s
JOIN Employees e ON e.EmployeeID = s.EmployeeID
ORDER BY s.OrderCount DESC;

--2.	Write a query using a derived table to find the sales per product category.(Sales, Products)

select * from Sales
select * from Products

select p.CategoryID, sum(Total_Amount.totalAmount) as sales_per_product_category
from products p
left join

(select ProductId, sum(salesAmount) as totalAmount
from sales
group by ProductID) as Total_Amount
on Total_Amount.ProductID=p.ProductID
group by p.categoryID


--3.	Write a script to return the factorial of each value next to it.(Numbers1)


;WITH Numbers AS (
    SELECT Number, 1 AS Counter, 1 AS Factorial
    FROM Numbers1
    WHERE Number >= 1

    UNION ALL

    SELECT n.Number, c.Counter + 1, c.Factorial * (c.Counter + 1)
    FROM Numbers1 n
    JOIN Numbers c 
      ON n.Number > c.Counter 
     AND n.Number = c.Number
)
SELECT 
    Number,
    MAX(Factorial) AS Factorial
FROM Numbers
GROUP BY Number

--4.	This script uses recursion to split a string into rows of substrings for each character in the string.(Example)

select * from Example

;WITH SplitCTE AS (
    SELECT 
        Id,
        1 AS Position,
        SUBSTRING(String, 1, 1) AS Character,
        String
    FROM Example

    UNION ALL

    SELECT 
        Id,
        Position + 1,
        SUBSTRING(String, Position + 1, 1),
        String
    FROM SplitCTE
    WHERE Position < LEN(String)
)
SELECT Id, Position AS CharPosition, Character
FROM SplitCTE
ORDER BY Id, Position
OPTION (MAXRECURSION 1000);



--5.	Use a CTE to calculate the sales difference between the current month and the previous month.(Sales)

;WITH MonthlySales AS (
    SELECT 
        YEAR(SaleDate) AS SaleYear,
        MONTH(SaleDate) AS SaleMonth,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY YEAR(SaleDate), MONTH(SaleDate)
)

SELECT 
    curr.SaleYear,
    curr.SaleMonth,
    curr.TotalSales,
    prev.TotalSales AS PrevMonthSales,
    curr.TotalSales - ISNULL(prev.TotalSales, 0) AS SalesDiff
FROM MonthlySales AS curr
LEFT JOIN MonthlySales AS prev
    ON (
        (curr.SaleYear = prev.SaleYear AND curr.SaleMonth = prev.SaleMonth + 1)
        OR (curr.SaleYear = prev.SaleYear + 1 AND curr.SaleMonth = 1 AND prev.SaleMonth = 12)
    )
ORDER BY curr.SaleYear, curr.SaleMonth;



--6.	Create a derived table to find employees with sales over $45000 in each quarter.(Sales, Employees)

select * from Sales
select * from Employees

select e.EmployeeID,
    e.FirstName,
    e.LastName,
    sq.SaleYear,
    sq.SaleQuarter,
    sq.TotalSales
from 
(select EmployeeID, year(saleDate) as SaleYear, DATEPART(quarter,SaleDate) as SaleQuarter, sum(SalesAmount) as TotalSales
from Sales
group by EmployeeID, year(saleDate),DATEPART(quarter,SaleDate) ) 
as sq
join Employees e
on e.EmployeeID=sq.EmployeeID
where sq.TotalSales>45000
ORDER BY sq.SaleYear, sq.SaleQuarter, e.EmployeeID



--Difficult Tasks
--1.	This script uses recursion to calculate Fibonacci numbers



--2.	Find a string where all characters are the same and the length is greater than 1.(FindSameCharacters)

SELECT * 
FROM FindSameCharacters
WHERE 
    Vals IS NOT NULL
    AND LEN(Vals) > 1
    AND LEN(REPLACE(Vals, LEFT(Vals, 1), '')) = 0;




--3.	Create a numbers table that shows all numbers 1 through n and their order gradually increasing by the next number in the sequence.
--	(Example:n=5 | 1, 12, 123, 1234, 12345)


--4.	Write a query using a derived table to find the employees who have made the most sales in the last 6 months.(Employees,Sales)

select * from Employees
select * from Sales

SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    s.TotalSales
FROM Employees e
JOIN (
    SELECT EmployeeID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    WHERE SaleDate >= DATEADD(MONTH, -6, GETDATE())
    GROUP BY EmployeeID
) s ON e.EmployeeID = s.EmployeeID
WHERE s.TotalSales = (
    SELECT MAX(TotalSales)
    FROM (
        SELECT EmployeeID, SUM(SalesAmount) AS TotalSales
        FROM Sales
        WHERE SaleDate >= DATEADD(MONTH, -6, GETDATE())
        GROUP BY EmployeeID
    ) AS sub
);


--5.	Write a T-SQL query to remove the duplicate integer values present in the string column. 
--	Additionally, remove the single integer character that appears in the string.(RemoveDuplicateIntsFromNames)


CREATE TABLE Numbers1(Number INT)

INSERT INTO Numbers1 VALUES (5),(9),(8),(6),(7)

CREATE TABLE FindSameCharacters
(
     Id INT
    ,Vals VARCHAR(10)
)
 
INSERT INTO FindSameCharacters VALUES
(1,'aa'),
(2,'cccc'),
(3,'abc'),
(4,'aabc'),
(5,NULL),
(6,'a'),
(7,'zzz'),
(8,'abc')



CREATE TABLE RemoveDuplicateIntsFromNames
(
      PawanName INT
    , Pawan_slug_name VARCHAR(1000)
)
 
 
INSERT INTO RemoveDuplicateIntsFromNames VALUES
(1,  'PawanA-111'  ),
(2, 'PawanB-123'   ),
(3, 'PawanB-32'    ),
(4, 'PawanC-4444' ),
(5, 'PawanD-3'  )





CREATE TABLE Example
(
Id       INTEGER IDENTITY(1,1) PRIMARY KEY,
String VARCHAR(30) NOT NULL
);


INSERT INTO Example VALUES('123456789'),('abcdefghi');


CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    DepartmentID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Salary DECIMAL(10, 2)
);

INSERT INTO Employees (EmployeeID, DepartmentID, FirstName, LastName, Salary) VALUES
(1, 1, 'John', 'Doe', 60000.00),
(2, 1, 'Jane', 'Smith', 65000.00),
(3, 2, 'James', 'Brown', 70000.00),
(4, 3, 'Mary', 'Johnson', 75000.00),
(5, 4, 'Linda', 'Williams', 80000.00),
(6, 2, 'Michael', 'Jones', 85000.00),
(7, 1, 'Robert', 'Miller', 55000.00),
(8, 3, 'Patricia', 'Davis', 72000.00),
(9, 4, 'Jennifer', 'García', 77000.00),
(10, 1, 'William', 'Martínez', 69000.00);

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'HR'),
(2, 'Sales'),
(3, 'Marketing'),
(4, 'Finance'),
(5, 'IT'),
(6, 'Operations'),
(7, 'Customer Service'),
(8, 'R&D'),
(9, 'Legal'),
(10, 'Logistics');

CREATE TABLE Sales (
    SalesID INT PRIMARY KEY,
    EmployeeID INT,
    ProductID INT,
    SalesAmount DECIMAL(10, 2),
    SaleDate DATE
);
INSERT INTO Sales (SalesID, EmployeeID, ProductID, SalesAmount, SaleDate) VALUES
-- January 2025
(1, 1, 1, 1550.00, '2025-01-02'),
(2, 2, 2, 2050.00, '2025-01-04'),
(3, 3, 3, 1250.00, '2025-01-06'),
(4, 4, 4, 1850.00, '2025-01-08'),
(5, 5, 5, 2250.00, '2025-01-10'),
(6, 6, 6, 1450.00, '2025-01-12'),
(7, 7, 1, 2550.00, '2025-01-14'),
(8, 8, 2, 1750.00, '2025-01-16'),
(9, 9, 3, 1650.00, '2025-01-18'),
(10, 10, 4, 1950.00, '2025-01-20'),
(11, 1, 5, 2150.00, '2025-02-01'),
(12, 2, 6, 1350.00, '2025-02-03'),
(13, 3, 1, 2050.00, '2025-02-05'),
(14, 4, 2, 1850.00, '2025-02-07'),
(15, 5, 3, 1550.00, '2025-02-09'),
(16, 6, 4, 2250.00, '2025-02-11'),
(17, 7, 5, 1750.00, '2025-02-13'),
(18, 8, 6, 1650.00, '2025-02-15'),
(19, 9, 1, 2550.00, '2025-02-17'),
(20, 10, 2, 1850.00, '2025-02-19'),
(21, 1, 3, 1450.00, '2025-03-02'),
(22, 2, 4, 1950.00, '2025-03-05'),
(23, 3, 5, 2150.00, '2025-03-08'),
(24, 4, 6, 1700.00, '2025-03-11'),
(25, 5, 1, 1600.00, '2025-03-14'),
(26, 6, 2, 2050.00, '2025-03-17'),
(27, 7, 3, 2250.00, '2025-03-20'),
(28, 8, 4, 1350.00, '2025-03-23'),
(29, 9, 5, 2550.00, '2025-03-26'),
(30, 10, 6, 1850.00, '2025-03-29'),
(31, 1, 1, 2150.00, '2025-04-02'),
(32, 2, 2, 1750.00, '2025-04-05'),
(33, 3, 3, 1650.00, '2025-04-08'),
(34, 4, 4, 1950.00, '2025-04-11'),
(35, 5, 5, 2050.00, '2025-04-14'),
(36, 6, 6, 2250.00, '2025-04-17'),
(37, 7, 1, 2350.00, '2025-04-20'),
(38, 8, 2, 1800.00, '2025-04-23'),
(39, 9, 3, 1700.00, '2025-04-26'),
(40, 10, 4, 2000.00, '2025-04-29'),
(41, 1, 5, 2200.00, '2025-05-03'),
(42, 2, 6, 1650.00, '2025-05-07'),
(43, 3, 1, 2250.00, '2025-05-11'),
(44, 4, 2, 1800.00, '2025-05-15'),
(45, 5, 3, 1900.00, '2025-05-19'),
(46, 6, 4, 2000.00, '2025-05-23'),
(47, 7, 5, 2400.00, '2025-05-27'),
(48, 8, 6, 2450.00, '2025-05-31'),
(49, 9, 1, 2600.00, '2025-06-04'),
(50, 10, 2, 2050.00, '2025-06-08'),
(51, 1, 3, 1550.00, '2025-06-12'),
(52, 2, 4, 1850.00, '2025-06-16'),
(53, 3, 5, 1950.00, '2025-06-20'),
(54, 4, 6, 1900.00, '2025-06-24'),
(55, 5, 1, 2000.00, '2025-07-01'),
(56, 6, 2, 2100.00, '2025-07-05'),
(57, 7, 3, 2200.00, '2025-07-09'),
(58, 8, 4, 2300.00, '2025-07-13'),
(59, 9, 5, 2350.00, '2025-07-17'),
(60, 10, 6, 2450.00, '2025-08-01');

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    CategoryID INT,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2)
);

INSERT INTO Products (ProductID, CategoryID, ProductName, Price) VALUES
(1, 1, 'Laptop', 1000.00),
(2, 1, 'Smartphone', 800.00),
(3, 2, 'Tablet', 500.00),
(4, 2, 'Monitor', 300.00),
(5, 3, 'Headphones', 150.00),
(6, 3, 'Mouse', 25.00),
(7, 4, 'Keyboard', 50.00),
(8, 4, 'Speaker', 200.00),
(9, 5, 'Smartwatch', 250.00),
(10, 5, 'Camera', 700.00);

