﻿
create database SQLHomework19
use SQLHomework19
go

--Lesson-19: Stored procedures, Merge and Practice
--Notes before doing the tasks:
--Tasks should be solved using SQL Server. Case insensitivity applies. Alias names do not affect the score.
--Scoring is based on the correct output. One correct solution is sufficient.
________________________________________
✅ TASKS on Stored Procedures and MERGE
________________________________________
🔵 Part 1: Stored Procedure Tasks
Tables to use:
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Department NVARCHAR(50),
    Salary DECIMAL(10,2)
);

CREATE TABLE DepartmentBonus (
    Department NVARCHAR(50) PRIMARY KEY,
    BonusPercentage DECIMAL(5,2)
);

INSERT INTO Employees VALUES
(1, 'John', 'Doe', 'Sales', 5000),
(2, 'Jane', 'Smith', 'Sales', 5200),
(3, 'Mike', 'Brown', 'IT', 6000),
(4, 'Anna', 'Taylor', 'HR', 4500);

INSERT INTO DepartmentBonus VALUES
('Sales', 10),
('IT', 15),
('HR', 8);
________________________________________
--📄 Task 1:
--Create a stored procedure that:
--•	Creates a temp table #EmployeeBonus
--•	Inserts EmployeeID, FullName (FirstName + LastName), Department, Salary, and BonusAmount into it 
--o	(BonusAmount = Salary * BonusPercentage / 100)
--•	Then, selects all data from the temp table.

select * from employees
select * from departmentBonus

CREATE PROCEDURE GetEmployeeBonus
AS
BEGIN

    CREATE TABLE #EmployeeBonus (
        EmployeeID INT,
        FullName NVARCHAR(100),
        Department NVARCHAR(50),
        Salary DECIMAL(10,2),
        BonusAmount DECIMAL(10,2)
    );

    INSERT INTO #EmployeeBonus (EmployeeID, FullName, Department, Salary, BonusAmount)
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS FullName,
        e.Department,
        e.Salary,
        e.Salary * db.BonusPercentage / 100 AS BonusAmount
    FROM Employees e
    JOIN DepartmentBonus db ON e.Department = db.Department;

    SELECT * FROM #EmployeeBonus
	end

	EXEC GetEmployeeBonus;

________________________________________
📄 Task 2:
Create a stored procedure that:
•	Accepts a department name and an increase percentage as parameters
•	Update salary of all employees in the given department by the given percentage
•	Returns updated employees from that department.

CREATE PROCEDURE UpdateSalary
    @DeptName VARCHAR(50),
    @IncreasePerc DECIMAL(10,2)
AS
BEGIN
    UPDATE Employees
    SET Salary = Salary * (1 + @IncreasePerc / 100)
    WHERE Department = @DeptName;

    SELECT * FROM Employees
    WHERE Department = @DeptName;
END;

EXEC UpdateSalary @DeptName = 'Sales', @IncreasePerc = 5;


________________________________________
🔵 Part 2: MERGE Tasks
Tables to use:

CREATE TABLE Products_Current (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Price DECIMAL(10,2)
);

CREATE TABLE Products_New (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Price DECIMAL(10,2)
);

INSERT INTO Products_Current VALUES
(1, 'Laptop', 1200),
(2, 'Tablet', 600),
(3, 'Smartphone', 800);

INSERT INTO Products_New VALUES
(2, 'Tablet Pro', 700),
(3, 'Smartphone', 850),
(4, 'Smartwatch', 300);

________________________________________
📄 Task 3:
Perform a MERGE operation that:
•	Updates ProductName and Price if ProductID matches
•	Inserts new products if ProductID does not exist
•	Deletes products from Products_Current if they are missing in Products_New
•	Return the final state of Products_Current after the MERGE.

select * from Products_current
select * from Products_new


	MERGE Products_current AS C
	USING Products_new AS N
	ON C.ProductID = N.ProductID
	WHEN MATCHED THEN
		UPDATE SET C.ProductName = N.ProductName,
				   C.Price=N.Price
	WHEN NOT MATCHED BY TARGET THEN
		INSERT (ProductID, ProductName, Price) VALUES (N.ProductID, N.ProductName, N.Price)
	WHEN NOT MATCHED BY SOURCE THEN
		DELETE;

________________________________________
📄 Task 4:
Tree Node
Each node in the tree can be one of three types:
•	"Leaf": if the node is a leaf node.
•	"Root": if the node is the root of the tree.
•	"Inner": If the node is neither a leaf node nor a root node.
Write a solution to report the type of each node in the tree.
Input:
CREATE TABLE Tree (id INT, p_id INT);
TRUNCATE TABLE Tree;
INSERT INTO Tree (id, p_id) VALUES (1, NULL);
INSERT INTO Tree (id, p_id) VALUES (2, 1);
INSERT INTO Tree (id, p_id) VALUES (3, 1);
INSERT INTO Tree (id, p_id) VALUES (4, 2);
INSERT INTO Tree (id, p_id) VALUES (5, 2);
Output:
id	type
1	Root
2	Inner
3	Leaf
4	Leaf
5	Leaf
🔗 Solve this puzzle on LeetCode

select * from Tree

SELECT 
    t1.id,
    CASE 
        WHEN t1.p_id IS NULL THEN 'Root'           -- p_id yo‘q → Root
        WHEN COUNT(t2.id) > 0 THEN 'Inner'         -- t1.id boshqa tugunlarga ota bo‘lgan → Inner
        ELSE 'Leaf'                                -- hech kimga ota emas → Leaf
    END AS type
FROM Tree t1
LEFT JOIN Tree t2 ON t1.id = t2.p_id
GROUP BY t1.id, t1.p_id;



________________________________________
📄 Task 5:
Confirmation Rate
Find the confirmation rate for each user. If a user has no confirmation requests, the rate should be 0.
Input:
CREATE TABLE Signups (user_id INT, time_stamp DATETIME);
CREATE TABLE Confirmations (
    user_id INT,
    time_stamp DATETIME,
    action VARCHAR(20) CHECK (action IN ('confirmed', 'timeout'))
);

TRUNCATE TABLE Signups;
INSERT INTO Signups (user_id, time_stamp) VALUES 
(3, '2020-03-21 10:16:13'),
(7, '2020-01-04 13:57:59'),
(2, '2020-07-29 23:09:44'),
(6, '2020-12-09 10:39:37');

TRUNCATE TABLE Confirmations;
INSERT INTO Confirmations (user_id, time_stamp, action) VALUES 
(3, '2021-01-06 03:30:46', 'timeout'),
(3, '2021-07-14 14:00:00', 'timeout'),
(7, '2021-06-12 11:57:29', 'confirmed'),
(7, '2021-06-13 12:58:28', 'confirmed'),
(7, '2021-06-14 13:59:27', 'confirmed'),
(2, '2021-01-22 00:00:00', 'confirmed'),
(2, '2021-02-28 23:59:59', 'timeout');

Output:

user_id	confirmation_rate
6	0.00
3	0.00
7	1.00
2	0.50
🔗 Solve this puzzle on LeetCode

select * from Signups
select * from Confirmations

CREATE PROCEDURE sp_GetConfirmationRate
AS
BEGIN
    SELECT 
        s.user_id,
        CAST(
            IIF(
                COUNT(c.action) = 0, 
                0.00, 
                COUNT(CASE WHEN c.action = 'confirmed' THEN 1 END) * 1.0 / COUNT(c.action)
            )
        AS DECIMAL(4,2)) AS confirmation_rate
    FROM Signups s
    LEFT JOIN Confirmations c ON s.user_id = c.user_id
    GROUP BY s.user_id;
END;
EXEC sp_GetConfirmationRate;


________________________________________
📄 Task 6:
--Find employees with the lowest salary
Input:
CREATE TABLE employees_ (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10,2)
);

INSERT INTO employees_ (id, name, salary) VALUES
(1, 'Alice', 50000),
(2, 'Bob', 60000),
(3, 'Charlie', 50000);

•	--Find all employees who have the lowest salary using subqueries.

select * from employees_

drop procedure LowestSalary

CREATE PROCEDURE LowestSalary
AS
BEGIN
    SELECT * 
    FROM employees_
    WHERE salary = (
        SELECT MIN(salary) 
        FROM employees_
    );
END;

EXEC LowestSalary;



________________________________________
📄 Task 7:
Get Product Sales Summary
Input:
-- Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    Price DECIMAL(10,2)
);

-- Sales Table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT,
    SaleDate DATE
);

INSERT INTO Products (ProductID, ProductName, Category, Price) VALUES
(1, 'Laptop Model A', 'Electronics', 1200),
(2, 'Laptop Model B', 'Electronics', 1500),
(3, 'Tablet Model X', 'Electronics', 600),
(4, 'Tablet Model Y', 'Electronics', 700),
(5, 'Smartphone Alpha', 'Electronics', 800),
(6, 'Smartphone Beta', 'Electronics', 850),
(7, 'Smartwatch Series 1', 'Wearables', 300),
(8, 'Smartwatch Series 2', 'Wearables', 350),
(9, 'Headphones Basic', 'Accessories', 150),
(10, 'Headphones Pro', 'Accessories', 250),
(11, 'Wireless Mouse', 'Accessories', 50),
(12, 'Wireless Keyboard', 'Accessories', 80),
(13, 'Desktop PC Standard', 'Computers', 1000),
(14, 'Desktop PC Gaming', 'Computers', 2000),
(15, 'Monitor 24 inch', 'Displays', 200),
(16, 'Monitor 27 inch', 'Displays', 300),
(17, 'Printer Basic', 'Office', 120),
(18, 'Printer Pro', 'Office', 400),
(19, 'Router Basic', 'Networking', 70),
(20, 'Router Pro', 'Networking', 150);

INSERT INTO Sales (SaleID, ProductID, Quantity, SaleDate) VALUES
(1, 1, 2, '2024-01-15'),
(2, 1, 1, '2024-02-10'),
(3, 1, 3, '2024-03-08'),
(4, 2, 1, '2024-01-22'),
(5, 3, 5, '2024-01-20'),
(6, 5, 2, '2024-02-18'),
(7, 5, 1, '2024-03-25'),
(8, 6, 4, '2024-04-02'),
(9, 7, 2, '2024-01-30'),
(10, 7, 1, '2024-02-25'),
(11, 7, 1, '2024-03-15'),
(12, 9, 8, '2024-01-18'),
(13, 9, 5, '2024-02-20'),
(14, 10, 3, '2024-03-22'),
(15, 11, 2, '2024-02-14'),
(16, 13, 1, '2024-03-10'),
(17, 14, 2, '2024-03-22'),
(18, 15, 5, '2024-02-01'),
(19, 15, 3, '2024-03-11'),
(20, 19, 4, '2024-04-01');

--Create a stored procedure called GetProductSalesSummary that:
--•	Accepts a @ProductID input
--•	Returns: 
--o	ProductName
--o	Total Quantity Sold
--o	Total Sales Amount (Quantity × Price)
--o	First Sale Date
--o	Last Sale Date
--•	If the product has no sales, return NULL for quantity, total amount, first date, and last date, but still return the product name.


select * from Products
select * from Sales

CREATE PROCEDURE GetProductSalesSummary
    @ProductID INT
AS
BEGIN
    SELECT 
        p.ProductName,
        SUM(s.Quantity) as Total_Quantity_Sold,
        SUM(s.Quantity * p.Price) as Total_Sales_Amount,
        MIN(s.SaleDate) as First_Sale_Date,
        MAX(s.SaleDate) as Last_Sale_Date
    FROM Products p
    LEFT JOIN Sales s ON p.ProductID = s.ProductID
    WHERE p.ProductID = @ProductID
    GROUP BY p.ProductName
END

EXEC GetProductSalesSummary 1;




when SaleID>0 then (select ProductName,
sum(QUANTITY) as Total_Quantity_Sold,
sum(Quantity*Price) as Total_Sales_Amount,
min(SaleDate) as First_Sale_Date,
max(SaleDate) as Last_Sale_Date
group by SaleID)
when SaleID isnull then Null

end
________________________________________

