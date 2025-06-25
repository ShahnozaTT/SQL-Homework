	create database SQLHomework17
	use SQLHomework17

	Lesson-17: Practice
	Notes before doing the tasks:
	•	Tasks should be solved using SQL Server.
	•	Case insensitivity applies.
	•	Alias names do not affect the score.
	•	Scoring is based on the correct output.
	•	One correct solution is sufficient.
	________________________________________
	--1. You must provide a report of all distributors and their sales by region. If a distributor did not have any sales for a region, 
	--rovide a zero-dollar value for that day. 
	--Assume there is at least one sale for each region

	SQL Setup:
	DROP TABLE IF EXISTS #RegionSales;
	GO

	CREATE TABLE #RegionSales (
	  Region      VARCHAR(100),
	  Distributor VARCHAR(100),
	  Sales       INTEGER NOT NULL,
	  PRIMARY KEY (Region, Distributor)
	);
	GO

	INSERT INTO #RegionSales (Region, Distributor, Sales) VALUES
	('North','ACE',10), ('South','ACE',67), ('East','ACE',54),
	('North','ACME',65), ('South','ACME',9), ('East','ACME',1), ('West','ACME',7),
	('North','Direct Parts',8), ('South','Direct Parts',7), ('West','Direct Parts',12);

	Input:
	|Region       |Distributor    | Sales |
	|-------------|---------------|--------
	|North        |ACE            |   10  |
	|South        |ACE            |   67  |
	|East         |ACE            |   54  |
	|North        |Direct Parts   |   8   |
	|South        |Direct Parts   |   7   |
	|West         |Direct Parts   |   12  |
	|North        |ACME           |   65  |
	|South        |ACME           |   9   |
	|East         |ACME           |   1   |
	|West         |ACME           |   7   |

	Expected Output:
	|Region |Distributor   | Sales |
	|-------|--------------|-------|
	|North  |ACE           | 10    |
	|South  |ACE           | 67    |
	|East   |ACE           | 54    |
	|West   |ACE           | 0     |
	|North  |Direct Parts  | 8     |
	|South  |Direct Parts  | 7     |
	|East   |Direct Parts  | 0     |
	|West   |Direct Parts  | 12    |
	|North  |ACME          | 65    |
	|South  |ACME          | 9     |
	|East   |ACME          | 1     |
	|West   |ACME          | 7     |

	select * from #regionSales

	SELECT 
    r.Region,
    d.Distributor,
    ISNULL(rs.Sales, 0) AS Sales
FROM 
    (SELECT DISTINCT Region FROM #RegionSales) r
CROSS JOIN 
    (SELECT DISTINCT Distributor FROM #RegionSales) d
LEFT JOIN 
    #RegionSales rs
    ON rs.Region = r.Region AND rs.Distributor = d.Distributor
ORDER BY 
    d.Distributor, r.Region;


	________________________________________

	--2. Find managers with at least five direct reports

	SQL Setup:

	CREATE TABLE Employee (id INT, name VARCHAR(255), department VARCHAR(255), managerId INT);
	TRUNCATE TABLE Employee;

	INSERT INTO Employee VALUES
	(101, 'John', 'A', NULL), (102, 'Dan', 'A', 101), (103, 'James', 'A', 101),
	(104, 'Amy', 'A', 101), (105, 'Anne', 'A', 101), (106, 'Ron', 'B', 101);

	Input:
	| id  | name  | department | managerId |
	+-----+-------+------------+-----------+
	| 101 | John  | A          | null      |
	| 102 | Dan   | A          | 101       |
	| 103 | James | A          | 101       |
	| 104 | Amy   | A          | 101       |
	| 105 | Anne  | A          | 101       |
	| 106 | Ron   | B          | 101       |

	Expected Output:
	+------+
	| name |
	+------+
	| John |
	+------+

	select * from employee

SELECT 
    e.name
FROM 
    employee e
WHERE 
    e.id IN (

	select managerId from employee
	where managerId is not null
		group by managerId
		having count(*)>=5)



	You cal also solve this puzzle in Leetcode: https://leetcode.com/problems/managers-with-at-least-5-direct-reports/description/?envType=study-plan-v2&envId=top-sql-50
	________________________________________

	--3. Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.

	SQL Setup:

	CREATE TABLE Products (product_id INT, product_name VARCHAR(40), product_category VARCHAR(40));
	CREATE TABLE Orders (product_id INT, order_date DATE, unit INT);
	TRUNCATE TABLE Products;

	INSERT INTO Products VALUES
	(1, 'Leetcode Solutions', 'Book'),
	(2, 'Jewels of Stringology', 'Book'),
	(3, 'HP', 'Laptop'), (4, 'Lenovo', 'Laptop'), (5, 'Leetcode Kit', 'T-shirt');

	TRUNCATE TABLE Orders;

	INSERT INTO Orders VALUES
	(1,'2020-02-05',60),(1,'2020-02-10',70),
	(2,'2020-01-18',30),(2,'2020-02-11',80),
	(3,'2020-02-17',2),(3,'2020-02-24',3),
	(4,'2020-03-01',20),(4,'2020-03-04',30),(4,'2020-03-04',60),
	(5,'2020-02-25',50),(5,'2020-02-27',50),(5,'2020-03-01',50);

	Input:
	| product_id  | product_name          | product_category |
	+-------------+-----------------------+------------------+
	| 1           | Leetcode Solutions    | Book             |
	| 2           | Jewels of Stringology | Book             |
	| 3           | HP                    | Laptop           |
	| 4           | Lenovo                | Laptop           |
	| 5           | Leetcode Kit          | T-shirt          |

	Expected Output:
	| product_name       | unit  |
	+--------------------+-------+
	| Leetcode Solutions | 130   |
	| Leetcode Kit       | 100   |
	________________________________________

	
	select * from products
	select * from orders

	select p.product_name, s.totalUnits
	from
	
	(select product_id, sum(unit) as totalUnits
	from orders
	where order_date between '2020-02-01' and '2020-02-29'
	GROUP BY product_id
	HAVING SUM(unit) >= 100) s
	join products p
	on p.product_id=s.Product_id
		

	--4. Write an SQL statement that returns the vendor from which each customer has placed the most orders

	SQL Setup:
	DROP TABLE IF EXISTS Orders;

	CREATE TABLE Orders (
	  OrderID    INTEGER PRIMARY KEY,
	  CustomerID INTEGER NOT NULL,
	  [Count]    MONEY NOT NULL,
	  Vendor     VARCHAR(100) NOT NULL
	);

	INSERT INTO Orders VALUES
	(1,1001,12,'Direct Parts'), (2,1001,54,'Direct Parts'), (3,1001,32,'ACME'),
	(4,2002,7,'ACME'), (5,2002,16,'ACME'), (6,2002,5,'Direct Parts');

	Input:
	|Order ID   | Customer ID | Order Count|     Vendor     |
	---------------------------------------------------------
	|Ord195342  |     1001    |      12    |  Direct Parts  |
	|Ord245532  |     1001    |      54    |  Direct Parts  |
	|Ord344394  |     1001    |      32    |     ACME       |
	|Ord442423  |     2002    |      7     |     ACME       |
	|Ord524232  |     2002    |      16    |     ACME       |
	|Ord645363  |     2002    |      5     |  Direct Parts  |

	Expected Output:
	| CustomerID | Vendor       |
	|------------|--------------|
	| 1001       | Direct Parts |
	| 2002       | ACME         |
	________________________________________

select * from orders

WITH OrderCounts AS (
  SELECT
    CustomerID,
    Vendor,
    COUNT(*) AS OrderCount
  FROM Orders
  GROUP BY CustomerID, Vendor
),

MaxCounts AS (
  SELECT
    CustomerID,
    MAX(OrderCount) AS MaxOrderCount
  FROM OrderCounts
  GROUP BY CustomerID
)
SELECT
  oc.CustomerID,
  oc.Vendor
FROM OrderCounts oc
JOIN MaxCounts mc
  ON oc.CustomerID    = mc.CustomerID
 AND oc.OrderCount    = mc.MaxOrderCount;

	--5. You will be given a number as a variable called @Check_Prime check if this number is prime then return 'This number is prime' else eturn 'This number is not prime'
	Example Input:

	DECLARE @Check_Prime INT = 91;
	-- Your WHILE-based SQL logic here

	--Expected Output:

	This number is not prime(or "This number is prime")
	________________________________________

DECLARE @Check_Prime INT = 91;
DECLARE @i INT = 2;
DECLARE @isPrime BIT = 1; 

WHILE @i < @Check_Prime
BEGIN
    IF @Check_Prime % @i = 0
    BEGIN
        SET @isPrime = 0; 
        BREAK;            
    END
    SET @i += 1;
END

IF @Check_Prime <= 1
    PRINT 'This number is not prime'
ELSE IF @isPrime = 1
    PRINT 'This number is prime';
ELSE
    PRINT 'This number is not prime';
	

	
	--6. Write an SQL query to return the number of locations,in which location most signals sent, and total number of signal for each device from the given table.
	SQL Setup:

	CREATE TABLE Device(
	  Device_id INT,
	  Locations VARCHAR(25)
	);

	INSERT INTO Device VALUES
	(12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'),
	(12,'Hosur'), (12,'Hosur'),
	(13,'Hyderabad'), (13,'Hyderabad'), (13,'Secunderabad'),
	(13,'Secunderabad'), (13,'Secunderabad');

	Expected Output:
	| Device_id | no_of_location | max_signal_location | no_of_signals |
	|-----------|----------------|---------------------|---------------|
	| 12        | 2              | Bangalore           | 6             |
	| 13        | 2              | Secunderabad        | 5             |
	________________________________________


	select * from device

	SELECT 
  device_id, 
  COUNT(DISTINCT locations) AS no_of_locations
FROM 
  Device
GROUP BY 
  device_id;
	
	

	--7. Write a SQL to find all Employees who earn more than the average salary in their corresponding department. 
	--Return EmpID, EmpName,Salary in your output
	SQL Setup:

	CREATE TABLE Employee_ (
	  EmpID INT,
	  EmpName VARCHAR(30),
	  Salary FLOAT,
	  DeptID INT
	);

	INSERT INTO Employee_ VALUES
	(1001,'Mark',60000,2), (1002,'Antony',40000,2), (1003,'Andrew',15000,1),
	(1004,'Peter',35000,1), (1005,'John',55000,1), (1006,'Albert',25000,3), (1007,'Donald',35000,3);

	Expected Output:
	| EmpID | EmpName | Salary |
	|-------|---------|--------|
	| 1001  | Mark    | 60000  |
	| 1004  | Peter   | 35000  |
	| 1005  | John    | 55000  |
	| 1007  | Donald  | 35000  |
	________________________________________

	select * from employee_

	select e.EmpID, e.EmpName, e.Salary, DepAvgSalary.avgSalary  from 

	(select DeptID, avg(salary) as avgSalary from employee_
	group by deptID) as DepAvgSalary
	join Employee_ e
	on e.DeptId=DepAvgSalary.DeptID
	where e.Salary>DepAvgSalary.avgSalary
	

	--8. You are part of an office lottery pool where you keep a table of the winning lottery numbers along with a table of each ticket’s chosen numbers.
	--If a ticket has some but not all the winning numbers, you win $10. If a ticket has all the winning numbers, you win $100. Calculate the total winnings for today’s drawing.

	Winning Numbers:
	|Number|
	--------
	|  25  |
	|  45  |
	|  78  |

	Tickets:
	| Ticket ID | Number |
	|-----------|--------|
	| A23423    | 25     |
	| A23423    | 45     |
	| A23423    | 78     |
	| B35643    | 25     |
	| B35643    | 45     |
	| B35643    | 98     |
	| C98787    | 67     |
	| C98787    | 86     |
	| C98787    | 91     |

	--Expected Output would be $110, as you have one winning ticket, and one ticket that has some but not all the winning numbers.
	
	CREATE TABLE Tickets (
    TicketID VARCHAR(20),
    Number INT
);

INSERT INTO Tickets (TicketID, Number) VALUES
('A23423', 25),
('A23423', 45),
('A23423', 78),
('B35643', 25),
('B35643', 45),
('B35643', 98),
('C98787', 67),
('C98787', 86),
('C98787', 91);

CREATE TABLE ValidNumbers (
    Number INT
);

INSERT INTO ValidNumbers (Number) VALUES
(25),
(45),
(78);


with cte as(
select TicketID, count(ValidNumbers.Number) as Winning_num_cnt from Tickets
LEFT JOIN
 ValidNumbers
on Tickets.Number=ValidNumbers.Number
group by TicketID
)
select sum(case when Winning_num_cnt=0 then 0
        when Winning_num_cnt=3 then 100
        else 10 end) as Total_winning from cte	
	
	
	
	________________________________________

	--9. The Spending table keeps the logs of the spendings history of users that make purchases from an online shopping website which has a desktop and a mobile devices.
	--Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only and both mobile and desktop together for each date.
	SQL Setup:

	CREATE TABLE Spending (
	  User_id INT,
	  Spend_date DATE,
	  Platform VARCHAR(10),
	  Amount INT
	);

	INSERT INTO Spending VALUES
	(1,'2019-07-01','Mobile',100),
	(1,'2019-07-01','Desktop',100),
	(2,'2019-07-01','Mobile',100),
	(2,'2019-07-02','Mobile',100),
	(3,'2019-07-01','Desktop',100),
	(3,'2019-07-02','Desktop',100);

	Expected Output:
	| Row | Spend_date | Platform | Total_Amount | Total_users |
	|-----|------------|----------|--------------|-------------|
	| 1   | 2019-07-01 | Mobile   | 100          | 1           |
	| 2   | 2019-07-01 | Desktop  | 100          | 1           |
	| 3   | 2019-07-01 | Both     | 200          | 1           |
	| 4   | 2019-07-02 | Mobile   | 100          | 1           |
	| 5   | 2019-07-02 | Desktop  | 100          | 1           |
	| 6   | 2019-07-02 | Both     | 0            | 0           |
	
	;WITH UserType AS (
  SELECT 
    Spend_date,
    User_id,
    CASE 
      WHEN COUNT(DISTINCT Platform) = 2 THEN 'Both'
      WHEN MAX(Platform) = 'Mobile' THEN 'Mobile'
      ELSE 'Desktop'
    END AS PlatformType,
    SUM(Amount) AS TotalAmount
  FROM Spending
  GROUP BY Spend_date, User_id
)
SELECT 
  Spend_date,
  PlatformType,
  COUNT(*) AS Total_users,
  SUM(TotalAmount) AS Total_Amount
FROM UserType
GROUP BY Spend_date, PlatformType
ORDER BY Spend_date,
  CASE PlatformType
    WHEN 'Mobile' THEN 1
    WHEN 'Desktop' THEN 2
    WHEN 'Both' THEN 3
  END;

		 
	________________________________________


	--10. Write an SQL Statement to de-group the following data.

	Input Table: 'Grouped'
	|Product  |Quantity|
	--------------------
	|Pencil   |   3    |
	|Eraser   |   4    |
	|Notebook |   2    |

	Expected Output:
	|Product  |Quantity|
	--------------------
	|Pencil   |   1    |
	|Pencil   |   1    |
	|Pencil   |   1    |
	|Eraser   |   1    |
	|Eraser   |   1    |
	|Eraser   |   1    |
	|Eraser   |   1    |
	|Notebook |   1    |
	|Notebook |   1    |
	SQL Setup:

	DROP TABLE IF EXISTS Grouped;

	CREATE TABLE Grouped
	(
	  Product  VARCHAR(100) PRIMARY KEY,
	  Quantity INTEGER NOT NULL
	);

	INSERT INTO Grouped (Product, Quantity) VALUES
	('Pencil', 3), ('Eraser', 4), ('Notebook', 2);

	select * from Grouped


;WITH RecCTE AS (
    -- Anchor part: 1 chi qator
    SELECT 
        Product,
        1 AS Quantity,
        Quantity AS MaxQty
    FROM Grouped

    UNION ALL

    -- Recursive part: Quantity + 1 qilib davom ettiramiz
    SELECT 
        Product,
        Quantity + 1,
        MaxQty
    FROM RecCTE
    WHERE Quantity + 1 <= MaxQty
)

-- Yakuniy natija
SELECT Product, 1 AS Quantity
FROM RecCTE
ORDER BY Product;


