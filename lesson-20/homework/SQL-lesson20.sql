
create database SQLHomework20
use SQLHomework20

--# Lesson-20: Practice

--> **Notes before doing the tasks:**
--> - Tasks should be solved using **SQL Server**.
--> - Case insensitivity applies.
--> - Alias names do not affect the score.
--> - Scoring is based on the **correct output**.
--> - One correct solution is sufficient.

```sql
CREATE TABLE #Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    Price DECIMAL(10,2),
    SaleDate DATE
);


INSERT INTO #Sales (CustomerName, Product, Quantity, Price, SaleDate) VALUES
('Alice', 'Laptop', 1, 1200.00, '2024-01-15'),
('Bob', 'Smartphone', 2, 800.00, '2024-02-10'),
('Charlie', 'Tablet', 1, 500.00, '2024-02-20'),
('David', 'Laptop', 1, 1300.00, '2024-03-05'),
('Eve', 'Smartphone', 3, 750.00, '2024-03-12'),
('Frank', 'Headphones', 2, 100.00, '2024-04-08'),
('Grace', 'Smartwatch', 1, 300.00, '2024-04-25'),
('Hannah', 'Tablet', 2, 480.00, '2024-05-05'),
('Isaac', 'Laptop', 1, 1250.00, '2024-05-15'),
('Jack', 'Smartphone', 1, 820.00, '2024-06-01');


--# 1. Find customers who purchased at least one item in March 2024 using EXISTS

select * from #sales

SELECT *
FROM #Sales s
WHERE EXISTS (
    SELECT 1
    FROM #Sales m
    WHERE m.CustomerName = s.CustomerName 
      AND m.SaleDate >= '2024-03-01' AND m.SaleDate < '2024-04-01'
);


--# 2. Find the product with the highest total sales revenue using a subquery.

select * from #sales

SELECT Product, SUM(Quantity * Price) AS total_sales_revenue
FROM #Sales
GROUP BY Product
HAVING SUM(Quantity * Price) = (
    SELECT MAX(TotalRevenue)
    FROM (
        SELECT Product, SUM(Quantity * Price) AS TotalRevenue
        FROM #Sales
        GROUP BY Product
    ) AS RevenuePerProduct
);


--# 3. Find the second highest sale amount using a subquery

SELECT *
FROM #Sales
WHERE Quantity * Price = (
    SELECT MAX(Quantity * Price)
    FROM #Sales
    WHERE Quantity * Price < (
        SELECT MAX(Quantity * Price)
        FROM #Sales
    )
);



--# 4. Find the total quantity of products sold per month using a subquery

select * from #sales

select product, totalQuantity, Month 
from (
select Product, sum(quantity) as TotalQuantity, datename(month, SaleDate) as Month
from #sales
group by Product, datename(month, SaleDate)) as monthly_sales



--# 5. Find customers who bought same products as another customer using EXISTS

select * from #sales

SELECT CustomerName, Product
FROM #Sales s
WHERE EXISTS (
    SELECT 1
    FROM #Sales m
    WHERE m.Product = s.Product
	AND m.CustomerName <> s.CustomerName
	
);

--# 6. Return how many fruits does each person have in individual fruit level


create table Fruits(Name varchar(50), Fruit varchar(50))
insert into Fruits values ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Orange'),
							('Francesko', 'Banana'), ('Francesko', 'Orange'), ('Li', 'Apple'), 
							('Li', 'Orange'), ('Li', 'Apple'), ('Li', 'Banana'), ('Mario', 'Apple'), ('Mario', 'Apple'), 
							('Mario', 'Apple'), ('Mario', 'Banana'), ('Mario', 'Banana'), 
							('Mario', 'Orange')


**Expected Output**

+-----------+-------+--------+--------+
| Name      | Apple | Orange | Banana |
+-----------+-------+--------+--------+
| Francesko |   3   |   2    |   1    |
| Li        |   2   |   1    |   1    |
| Mario     |   3   |   1    |   2    |
+-----------+-------+--------+--------+


select * from fruits


select name, 
sum (case when fruit = 'Apple' then 1 else 0 end) as 'Apple',
sum (case when fruit = 'Orange' then 1 else 0 end) as 'Orange',
sum (case when fruit = 'Banana' then 1 else 0 end) as 'Banana'
from fruits
group by Name

--# 7. Return older people in the family with younger ones

create table Family(ParentId int, ChildID int)
insert into Family values (1, 2), (2, 3), (3, 4)


**1 Oldest person in the family --grandfather**
**2 Father**
**3 Son**
**4 Grandson**

**Expected output**
```
+-----+-----+
| PID |CHID |
+-----+-----+
|  1  |  2  |
|  1  |  3  |
|  1  |  4  |
|  2  |  3  |
|  2  |  4  |
|  3  |  4  |
+-----+-----+

select * from Family

WITH CTE_Family (PID, CHID) AS (

    SELECT ParentID, ChildID
    FROM Family

    UNION ALL


    SELECT CTE_Family.PID, Family.ChildID
    FROM CTE_Family
    JOIN Family ON CTE_Family.CHID = Family.ParentID
)

SELECT * FROM CTE_Family
ORDER BY PID, CHID
OPTION (MAXRECURSION 100);



--# 8. Write an SQL statement given the following requirements. 
--For every customer that had a delivery to California, 
--provide a result set of the customer orders that were delivered to Texas

CREATE TABLE #Orders_
(
CustomerID     INTEGER,
OrderID        INTEGER,
DeliveryState  VARCHAR(100) NOT NULL,
Amount         MONEY NOT NULL,
PRIMARY KEY (CustomerID, OrderID)
);


INSERT INTO #Orders_ (CustomerID, OrderID, DeliveryState, Amount) VALUES
(1001,1,'CA',340),(1001,2,'TX',950),(1001,3,'TX',670),
(1001,4,'TX',860),(2002,5,'WA',320),(3003,6,'CA',650),
(3003,7,'CA',830),(4004,8,'TX',120);


select * from #orders

select o.CustomerId, o.DeliveryState
from #orders o
where o.deliveryState='TX'
and exists 
(
select 1
from #orders X
WHERE x.CustomerID = o.CustomerID
        AND x.DeliveryState = 'CA')


--# 9. Insert the names of residents if they are missing


create table #residents(resid int identity, fullname varchar(50), address varchar(100))

insert into #residents values 
('Dragan', 'city=Bratislava country=Slovakia name=Dragan age=45'),
('Diogo', 'city=Lisboa country=Portugal age=26'),
('Celine', 'city=Marseille country=France name=Celine age=21'),
('Theo', 'city=Milan country=Italy age=28'),
('Rajabboy', 'city=Tashkent country=Uzbekistan age=22')

select * from #residents


select *,
 case when CHARINDEX('name=',[address])=0 then  STUFF([address],charindex('age=',[address]),0, concat('name=',fullname,' '))
 else [address] end as updated_address
   from #residents


--# 10. Write a query to return the route to reach from Tashkent to Khorezm. The result should include the cheapest and the most expensive routes


CREATE TABLE #Routes
(
RouteID        INTEGER NOT NULL,
DepartureCity  VARCHAR(30) NOT NULL,
ArrivalCity    VARCHAR(30) NOT NULL,
Cost           MONEY NOT NULL,
PRIMARY KEY (DepartureCity, ArrivalCity)
);

INSERT INTO #Routes (RouteID, DepartureCity, ArrivalCity, Cost) VALUES
(1,'Tashkent','Samarkand',100),
(2,'Samarkand','Bukhoro',200),
(3,'Bukhoro','Khorezm',300),
(4,'Samarkand','Khorezm',400),
(5,'Tashkent','Jizzakh',100),
(6,'Jizzakh','Samarkand',50);



**Expected Output**
```
|             Route                                 |Cost |
|Tashkent - Samarkand - Khorezm                     | 500 |
|Tashkent - Jizzakh - Samarkand - Bukhoro - Khorezm | 650 |


select * from #Routes

with cte as(
select concat_ws('-',first_city.DepartureCity,first_city.ArrivalCity,second_city.ArrivalCity,third_city.ArrivalCity,fourth_city.ArrivalCity) as Road_map,
isnull(first_city.Cost,0)+isnull(second_city.Cost,0)+isnull(third_city.Cost,0)+isnull(fourth_city.cost,0) as Total_cost
 from (select * from #Routes where DepartureCity='Tashkent') as first_city
LEFT JOIN #Routes as second_city
on first_city.ArrivalCity=second_city.DepartureCity
LEFT JOIN #Routes as third_city
on second_city.ArrivalCity=third_city.DepartureCity
LEFT JOIN #Routes as fourth_city
on third_city.ArrivalCity=fourth_city.DepartureCity
)
select * from cte
where Total_cost=(select min(total_cost) from cte) or Total_cost=(select max(total_cost) from cte)



---
--# 11. Rank products based on their order of insertion.

```sql
CREATE TABLE #RankingPuzzle
(
     ID INT
    ,Vals VARCHAR(10)
)

 
INSERT INTO #RankingPuzzle VALUES
(1,'Product'),
(2,'a'),
(3,'a'),
(4,'a'),
(5,'a'),
(6,'Product'),
(7,'b'),
(8,'b'),
(9,'Product'),
(10,'c')

SELECT *
FROM (
    SELECT *,
        SUM(CASE WHEN Vals = 'Product' THEN 1 ELSE 0 END)
        OVER (ORDER BY ID ROWS UNBOUNDED PRECEDING) AS ProductRank
    FROM #RankingPuzzle
) AS t
WHERE Vals <> 'Product';

---
--# Question 12
--# Find employees whose sales were higher than the average sales in their department

CREATE TABLE #EmployeeSales (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    SalesAmount DECIMAL(10,2),
    SalesMonth INT,
    SalesYear INT
);

INSERT INTO #EmployeeSales (EmployeeName, Department, SalesAmount, SalesMonth, SalesYear) VALUES
('Alice', 'Electronics', 5000, 1, 2024),
('Bob', 'Electronics', 7000, 1, 2024),
('Charlie', 'Furniture', 3000, 1, 2024),
('David', 'Furniture', 4500, 1, 2024),
('Eve', 'Clothing', 6000, 1, 2024),
('Frank', 'Electronics', 8000, 2, 2024),
('Grace', 'Furniture', 3200, 2, 2024),
('Hannah', 'Clothing', 7200, 2, 2024),
('Isaac', 'Electronics', 9100, 3, 2024),
('Jack', 'Furniture', 5300, 3, 2024),
('Kevin', 'Clothing', 6800, 3, 2024),
('Laura', 'Electronics', 6500, 4, 2024),
('Mia', 'Furniture', 4000, 4, 2024),
('Nathan', 'Clothing', 7800, 4, 2024);

select * from #EmployeeSales


;WITH SaleAmountCTE AS (
    SELECT *, AVG(SalesAmount) OVER (PARTITION BY Department) AS AvgDepSaleAmount
    FROM #EmployeeSales
)
SELECT EmployeeID, EmployeeName, Department, SalesAmount, AvgDepSaleAmount
FROM SaleAmountCTE
WHERE SalesAmount > AvgDepSaleAmount;


---
--# 13. Find employees who had the highest sales in any given month using EXISTS

select * from #EmployeeSales



SELECT *
FROM #EmployeeSales e1
WHERE NOT EXISTS (
    SELECT 1
    FROM #EmployeeSales e2
    WHERE 
        e1.SalesMonth = e2.SalesMonth AND
        e1.SalesYear = e2.SalesYear AND
        e1.Department = e2.Department AND
        e2.SalesAmount > e1.SalesAmount
)
-----
--# 14. Find employees who made sales in every month using NOT EXISTS


CREATE TABLE Products (
    ProductID   INT PRIMARY KEY,
    Name        VARCHAR(50),
    Category    VARCHAR(50),
    Price       DECIMAL(10,2),
    Stock       INT
);

INSERT INTO Products (ProductID, Name, Category, Price, Stock) VALUES
(1, 'Laptop', 'Electronics', 1200.00, 15),
(2, 'Smartphone', 'Electronics', 800.00, 30),
(3, 'Tablet', 'Electronics', 500.00, 25),
(4, 'Headphones', 'Accessories', 150.00, 50),
(5, 'Keyboard', 'Accessories', 100.00, 40),
(6, 'Monitor', 'Electronics', 300.00, 20),
(7, 'Mouse', 'Accessories', 50.00, 60),
(8, 'Chair', 'Furniture', 200.00, 10),
(9, 'Desk', 'Furniture', 400.00, 5),
(10, 'Printer', 'Office Supplies', 250.00, 12),
(11, 'Scanner', 'Office Supplies', 180.00, 8),
(12, 'Notebook', 'Stationery', 10.00, 100),
(13, 'Pen', 'Stationery', 2.00, 500),
(14, 'Backpack', 'Accessories', 80.00, 30),
(15, 'Lamp', 'Furniture', 60.00, 25);

select * from #EmployeeSales

SELECT DISTINCT SalesMonth FROM #EmployeeSales

SELECT DISTINCT e1.EmployeeID, e1.EmployeeName
FROM #EmployeeSales e1
WHERE NOT EXISTS (
    SELECT 1
    FROM (
        SELECT DISTINCT SalesMonth
        FROM #EmployeeSales
    ) AS all_months
    WHERE NOT EXISTS (
        SELECT 1
        FROM #EmployeeSales e2
        WHERE e2.EmployeeID = e1.EmployeeID
          AND e2.SalesMonth = all_months.SalesMonth
    )
)


--# 15. Retrieve the names of products that are more expensive than the average price of all products.

Select * from Products

select p.name, p.category, p.price, (select avg(price) from Products) as avg_price
from Products p

where p.price>(select avg(price) from Products)


-----
--# 16. Find the products that have a stock count lower than the highest stock count.

Select * from Products

select p.name, p.category, p.Stock, (select max(stock) from products) as highest_stock
from Products p
where p.stock < (select max(stock) from products)

-----
--# 17. Get the names of products that belong to the same category as 'Laptop'.

SELECT Name, Category
FROM Products
WHERE Category = (
    SELECT Category
    FROM Products
    WHERE Name = 'Laptop'
);

-----
--# 18. Retrieve products whose price is greater than the lowest price in the Electronics category.

Select * from Products

select p.name, p.category, p.price, (
select min(price) from products
where Category='Electronics') as min_price_electronics
from products p
where p.Price> (
select min(price) from products
where Category='Electronics')

-----
--# 19. Find the products that have a higher price than the average price of their respective category.

SELECT p.Name, p.Category, p.Price
FROM Products p
WHERE p.Price > (
    SELECT AVG(p2.Price)
    FROM Products p2
    WHERE p2.Category = p.Category
);



CREATE TABLE Orders_ (
    OrderID    INT PRIMARY KEY,
    ProductID  INT,
    Quantity   INT,
    OrderDate  DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Orders_ (OrderID, ProductID, Quantity, OrderDate) VALUES
(1, 1, 2, '2024-03-01'),
(2, 3, 5, '2024-03-05'),
(3, 2, 3, '2024-03-07'),
(4, 5, 4, '2024-03-10'),
(5, 8, 1, '2024-03-12'),
(6, 10, 2, '2024-03-15'),
(7, 12, 10, '2024-03-18'),
(8, 7, 6, '2024-03-20'),
(9, 6, 2, '2024-03-22'),
(10, 4, 3, '2024-03-25'),
(11, 9, 2, '2024-03-28'),
(12, 11, 1, '2024-03-30'),
(13, 14, 4, '2024-04-02'),
(14, 15, 5, '2024-04-05'),
(15, 13, 20, '2024-04-08');


--# 20. Find the products that have been ordered at least once.

select * from Orders_
select * from products

SELECT distinct p.Name, p.Category, p.Price
from Products p
join orders_
on p.ProductID=Orders_.ProductID


--# 21. Retrieve the names of products that have been ordered more than the average quantity ordered.


select * from Orders_
select * from products


SELECT p.Name, p.Category, SUM(o.Quantity) AS TotalQuantity
FROM Products p
JOIN Orders_ o ON p.ProductID = o.ProductID
GROUP BY p.Name, p.Category
HAVING SUM(o.Quantity) > (SELECT AVG(Quantity) FROM Orders_)

-----
--# 22. Find the products that have never been ordered.

SELECT p.ProductID, p.Name
FROM Products p
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders_ o
    WHERE o.ProductID = p.ProductID
);


-----
--# 23. Retrieve the product with the highest total quantity ordered.
---

SELECT TOP 1 p.Name, p.Category, SUM(o.Quantity) AS TotalQuantity
FROM Products p
JOIN Orders_ o ON p.ProductID = o.ProductID
GROUP BY p.Name, p.Category
ORDER BY TotalQuantity DESC;


