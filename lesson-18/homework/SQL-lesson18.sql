create database SQLHomework18
use SQLHomework18


Lesson-18: View, temp table, variable, functions

--You're working in a database for a Retail Sales System. The database contains the following tables:

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Products (ProductID, ProductName, Category, Price)
VALUES
(1, 'Samsung Galaxy S23', 'Electronics', 899.99),
(2, 'Apple iPhone 14', 'Electronics', 999.99),
(3, 'Sony WH-1000XM5 Headphones', 'Electronics', 349.99),
(4, 'Dell XPS 13 Laptop', 'Electronics', 1249.99),
(5, 'Organic Eggs (12 pack)', 'Groceries', 3.49),
(6, 'Whole Milk (1 gallon)', 'Groceries', 2.99),
(7, 'Alpen Cereal (500g)', 'Groceries', 4.75),
(8, 'Extra Virgin Olive Oil (1L)', 'Groceries', 8.99),
(9, 'Mens Cotton T-Shirt', 'Clothing', 12.99),
(10, 'Womens Jeans - Blue', 'Clothing', 39.99),
(11, 'Unisex Hoodie - Grey', 'Clothing', 29.99),
(12, 'Running Shoes - Black', 'Clothing', 59.95),
(13, 'Ceramic Dinner Plate Set (6 pcs)', 'Home & Kitchen', 24.99),
(14, 'Electric Kettle - 1.7L', 'Home & Kitchen', 34.90),
(15, 'Non-stick Frying Pan - 28cm', 'Home & Kitchen', 18.50),
(16, 'Atomic Habits - James Clear', 'Books', 15.20),
(17, 'Deep Work - Cal Newport', 'Books', 14.35),
(18, 'Rich Dad Poor Dad - Robert Kiyosaki', 'Books', 11.99),
(19, 'LEGO City Police Set', 'Toys', 49.99),
(20, 'Rubiks Cube 3x3', 'Toys', 7.99);

INSERT INTO Sales (SaleID, ProductID, Quantity, SaleDate)
VALUES
(1, 1, 2, '2025-04-01'),
(2, 1, 1, '2025-04-05'),
(3, 2, 1, '2025-04-10'),
(4, 2, 2, '2025-04-15'),
(5, 3, 3, '2025-04-18'),
(6, 3, 1, '2025-04-20'),
(7, 4, 2, '2025-04-21'),
(8, 5, 10, '2025-04-22'),
(9, 6, 5, '2025-04-01'),
(10, 6, 3, '2025-04-11'),
(11, 10, 2, '2025-04-08'),
(12, 12, 1, '2025-04-12'),
(13, 12, 3, '2025-04-14'),
(14, 19, 2, '2025-04-05'),
(15, 20, 4, '2025-04-19'),
(16, 1, 1, '2025-03-15'),
(17, 2, 1, '2025-03-10'),
(18, 5, 5, '2025-02-20'),
(19, 6, 6, '2025-01-18'),
(20, 10, 1, '2024-12-25'),
(21, 1, 1, '2024-04-20');

--1. Create a temporary table named MonthlySales to store the total quantity sold and total revenue for each product in the current month.
--Return: ProductID, TotalQuantity, TotalRevenue

select * from Sales 
select * from Products

CREATE TABLE #MonthlySales (
    ProductID INT,
    TotalQuantity INT,
    TotalRevenue DECIMAL(10,2)
);

INSERT INTO #MonthlySales (ProductID, TotalQuantity, TotalRevenue)
SELECT 
    s.ProductID,
    SUM(s.Quantity) AS TotalQuantity,
    SUM(s.Quantity * p.Price) AS TotalRevenue
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
WHERE YEAR(SaleDate) = YEAR(GETDATE())
  AND MONTH(SaleDate) = MONTH(GETDATE())
GROUP BY s.ProductID;

SELECT * FROM #MonthlySales;



--2. Create a view named vw_ProductSalesSummary that returns product info along with total sales quantity across all time.
--Return: ProductID, ProductName, Category, TotalQuantitySold

select * from Sales 
select * from Products

CREATE VIEW vw_ProductSalesSummary AS
SELECT 
p.ProductID, 
p.ProductName, 
p.Category,  
SUM(s.Quantity) AS TotalQuantitySold
FROM Products p
join Sales s
on s.ProductID=p.ProductID
GROUP BY 
p.ProductID, 
p.ProductName, 
p.Category 

SELECT * FROM vw_ProductSalesSummary;

--3. Create a function named fn_GetTotalRevenueForProduct(@ProductID INT)
--Return: total revenue for the given product ID

select * from Sales 
select * from Products

CREATE FUNCTION fn_GetTotalRevenueForProduct (@ProductID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Revenue DECIMAL(10,2)
    SELECT @Revenue = SUM(s.Quantity * p.Price)
    FROM Sales s
    JOIN Products p ON s.ProductID = p.ProductID
    WHERE s.ProductID = @ProductID

    RETURN @Revenue
END;

SELECT dbo.fn_GetTotalRevenueForProduct(2);

--4. Create an function fn_GetSalesByCategory(@Category VARCHAR(50))
--Return: ProductName, TotalQuantity, TotalRevenue for all products in that category.

select * from Sales 
select * from Products

CREATE FUNCTION fn_GetSalesByCategory (@Category varchar(50))
RETURNS table
AS
return
(
    SELECT p.ProductName,
        SUM(s.Quantity) AS TotalQuantity,
        SUM(s.Quantity * p.Price) AS TotalRevenue
    FROM Products p
    JOIN Sales s ON s.ProductID = p.ProductID
    WHERE p.Category = @Category
	group by p.ProductName)

SELECT * from dbo.fn_GetSalesByCategory('Electronics');



--Now we will move on with 2 Lateral-thinking puzzles (5 and 6th puzzles). 
--Lateral-thinking puzzles are the ones that can’t be solved by straightforward logic — you have to think outside the box. 🔍🧠

--5. You have to create a function that get one argument as input from user and the function should return 'Yes' 
--if the input number is a prime number and 'No' otherwise. You can start it like this:
--Create function dbo.fn_IsPrime (@Number INT)
--Returns ...
--This is for those who has no idea about prime numbers: A prime number is a number greater than 1 that has only two divisors:
--1 and itself(2, 3, 5, 7 and so on).



--6. Create a table-valued function named fn_GetNumbersBetween that accepts two integers as input:

@Start INT
@End INT
The function should return a table with a single column:
| Number |
|--------|
| @Start |
...
...
...
|   @end |
It should include all integer values from @Start to @End, inclusive.

CREATE FUNCTION fn_GetNumbersBetween (@Start INT, @End INT)
RETURNS @Numbers TABLE (Number INT)
AS
BEGIN
    WITH Numbers_CTE AS (
        SELECT @Start AS Number
        UNION ALL
        SELECT Number + 1
        FROM Numbers_CTE
        WHERE Number + 1 <= @End
    )
    INSERT INTO @Numbers
    SELECT Number FROM Numbers_CTE;

    RETURN;
END;

SELECT * FROM fn_GetNumbersBetween(1, 20) OPTION (MAXRECURSION 32767);

--7. Write a SQL query to return the Nth highest distinct salary from the Employee table. If there are fewer than N distinct salaries, return NULL.

Example 1:
Input.Employee table:
| id | salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
n = 2
Output:
| getNthHighestSalary(2) |
|    HighestNSalary      |
|------------------------|
| 200                    |
Example 2:
Input.Employee table:
| id | salary |
|----|--------|
| 1  | 100    |
n = 2
Output:
| getNthHighestSalary(2) |
|    HighestNSalary      |
|        null            |
You can also solve this in Leetcode: https://leetcode.com/problems/nth-highest-salary/description/

CREATE TABLE Employee_ (
    id INT,
    salary INT
);

INSERT INTO employee_ (id, salary)
values
(1, 100),
(2, 200),
(3, 300)

select * from employee_	

DROP FUNCTION IF EXISTS fn_GetNthHighestSalary;
GO

CREATE FUNCTION fn_GetNthHighestSalary (@N INT)
RETURNS INT
AS
BEGIN
    DECLARE @Result INT;

    SELECT @Result = salary
    FROM (
        SELECT DISTINCT salary,
               DENSE_RANK() OVER (ORDER BY salary DESC) AS rk
        FROM Employee_
    ) AS ranked
    WHERE rk = @N;

    RETURN @Result;
END;


SELECT dbo.fn_GetNthHighestSalary(2) 


--8. Write a SQL query to find the person who has the most friends.

--Return: Their id, The total number of friends they have Friendship is mutual. 
--For example, if user A sends a request to user B and it's accepted, both A and B are considered friends with each other. 
--The test case is guaranteed to have only one user with the most friends.
--Explanation: The person with id 3 is a friend of people 1, 2, and 4, so he has three friends in total, which is the most number than any others.

Input.RequestAccepted table:

| requester_id | accepter_id | accept_date |
+--------------+-------------+-------------+
| 1            | 2           | 2016/06/03  |
| 1            | 3           | 2016/06/08  |
| 2            | 3           | 2016/06/08  |
| 3            | 4           | 2016/06/09  |
Output:
| id | num |
+----+-----+
| 3  | 3   |


CREATE TABLE RequestAccepted (
    requester_id INT,
    accepter_id INT,
    accept_date DATE
);


INSERT INTO RequestAccepted (requester_id, accepter_id, accept_date)
VALUES
(1, 2, '2016-06-03'),
(1, 3, '2016-06-08'),
(2, 3, '2016-06-08'),
(3, 4, '2016-06-09');

	SELECT TOP 1 user_id AS id, COUNT(DISTINCT friend_id) AS num
	FROM (
		SELECT requester_id AS user_id, accepter_id AS friend_id
		FROM RequestAccepted
		UNION ALL
		SELECT accepter_id AS user_id, requester_id AS friend_id
		FROM RequestAccepted
	) AS AllFriends
	GROUP BY user_id
	ORDER BY COUNT(DISTINCT friend_id) DESC;



--You can also solve this in Leetcode: https://leetcode.com/problems/friend-requests-ii-who-has-the-most-friends/description/?envType=study-plan-v2&envId=top-sql-50

----9. Create a View for Customer Order Summary.



CREATE TABLE Customers1 (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE Orders1 (
    order_id INT PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id),
    order_date DATE,
    amount DECIMAL(10,2)
);

-- Customers
INSERT INTO Customers1 (customer_id, name, city)
VALUES
(1, 'Alice Smith', 'New York'),
(2, 'Bob Jones', 'Chicago'),
(3, 'Carol White', 'Los Angeles');

-- Orders
INSERT INTO Orders1 (order_id, customer_id, order_date, amount)
VALUES
(101, 1, '2024-12-10', 120.00),
(102, 1, '2024-12-20', 200.00),
(103, 1, '2024-12-30', 220.00),
(104, 2, '2025-01-12', 120.00),
(105, 2, '2025-01-20', 180.00);


		SELECT * FROM CUSTOMERS1
		SELECT * FROM orders1
		
CREATE VIEW vw_CustomerOrderSummary AS
SELECT
    o.customer_id,
    c.name,
    COUNT(*) AS total_orders,
    SUM(o.amount) AS total_amount,
    MAX(o.order_date) AS last_order_date
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.name

SELECT * FROM vw_CustomerOrderSummary

--Create a view called vw_CustomerOrderSummary that returns a summary of customer orders. The view must contain the following columns:

•	Column Name | Description
•	customer_id | Unique identifier of the customer
•	name | Full name of the customer
•	total_orders | Total number of orders placed by the customer
•	total_amount | Cumulative amount spent across all orders
•	last_order_date | Date of the most recent order placed by the customer


--10. Write an SQL statement to fill in the missing gaps. You have to write only select statement, no need to modify the table.

| RowNumber | Workflow |
|----------------------|
| 1         | Alpha    |
| 2         |          |
| 3         |          |
| 4         |          |
| 5         | Bravo    |
| 6         |          |
| 7         |          |
| 8         |          |
| 9         |          |
| 10        | Charlie  |
| 11        |          |
| 12        |          |
Here is the expected output.
| RowNumber | Workflow |
|----------------------|
| 1         | Alpha    |
| 2         | Alpha    |
| 3         | Alpha    |
| 4         | Alpha    |
| 5         | Bravo    |
| 6         | Bravo    |
| 7         | Bravo    |
| 8         | Bravo    |
| 9         | Bravo    |
| 10        | Charlie  |
| 11        | Charlie  |
| 12        | Charlie  |
DROP TABLE IF EXISTS Gaps;

CREATE TABLE Gaps
(
RowNumber   INTEGER PRIMARY KEY,
TestCase    VARCHAR(100) NULL
);`1111``																																															

INSERT INTO Gaps (RowNumber, TestCase) VALUES
(1,'Alpha'),(2,NULL),(3,NULL),(4,NULL),
(5,'Bravo'),(6,NULL),(7,NULL),(8,NULL),(9,NULL),(10,'Charlie'), (11, NULL), (12, NULL)

