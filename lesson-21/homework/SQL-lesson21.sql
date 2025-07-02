create database SQLHomework21
use SQLHomework21


CREATE TABLE ProductSales (
    SaleID INT PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL,
    SaleDate DATE NOT NULL,
    SaleAmount DECIMAL(10, 2) NOT NULL,
    Quantity INT NOT NULL,
    CustomerID INT NOT NULL
);
INSERT INTO ProductSales (SaleID, ProductName, SaleDate, SaleAmount, Quantity, CustomerID)
VALUES 
(1, 'Product A', '2023-01-01', 148.00, 2, 101),
(2, 'Product B', '2023-01-02', 202.00, 3, 102),
(3, 'Product C', '2023-01-03', 248.00, 1, 103),
(4, 'Product A', '2023-01-04', 149.50, 4, 101),
(5, 'Product B', '2023-01-05', 203.00, 5, 104),
(6, 'Product C', '2023-01-06', 252.00, 2, 105),
(7, 'Product A', '2023-01-07', 151.00, 1, 101),
(8, 'Product B', '2023-01-08', 205.00, 8, 102),
(9, 'Product C', '2023-01-09', 253.00, 7, 106),
(10, 'Product A', '2023-01-10', 152.00, 2, 107),
(11, 'Product B', '2023-01-11', 207.00, 3, 108),
(12, 'Product C', '2023-01-12', 249.00, 1, 109),
(13, 'Product A', '2023-01-13', 153.00, 4, 110),
(14, 'Product B', '2023-01-14', 208.50, 5, 111),
(15, 'Product C', '2023-01-15', 251.00, 2, 112),
(16, 'Product A', '2023-01-16', 154.00, 1, 113),
(17, 'Product B', '2023-01-17', 210.00, 8, 114),
(18, 'Product C', '2023-01-18', 254.00, 7, 115),
(19, 'Product A', '2023-01-19', 155.00, 3, 116),
(20, 'Product B', '2023-01-20', 211.00, 4, 117),
(21, 'Product C', '2023-01-21', 256.00, 2, 118),
(22, 'Product A', '2023-01-22', 157.00, 5, 119),
(23, 'Product B', '2023-01-23', 213.00, 3, 120),
(24, 'Product C', '2023-01-24', 255.00, 1, 121),
(25, 'Product A', '2023-01-25', 158.00, 6, 122),
(26, 'Product B', '2023-01-26', 215.00, 7, 123),
(27, 'Product C', '2023-01-27', 257.00, 3, 124),
(28, 'Product A', '2023-01-28', 159.50, 4, 125),
(29, 'Product B', '2023-01-29', 218.00, 5, 126),
(30, 'Product C', '2023-01-30', 258.00, 2, 127);
```

--1. Write a query to assign a row number to each sale based on the SaleDate.

select * from ProductSales
select *,
row_number() over (order by SaleDate) as RowNumber from productSales

--2. Write a query to rank products based on the total quantity sold. 
--give the same rank for the same amounts without skipping numbers.

SELECT 
    ProductName,
    TotalQuantity,
    DENSE_RANK() OVER (ORDER BY TotalQuantity DESC) AS QuantityRank
FROM (
    SELECT ProductName, SUM(Quantity) AS TotalQuantity
    FROM ProductSales
    GROUP BY ProductName
) AS sub;


--3. Write a query to identify the top sale for each customer based on the SaleAmount.

select * from ProductSales

SELECT SaleID, ProductName, SaleDate, SaleAmount, Quantity, CustomerID
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY SaleAmount DESC) AS rn
    FROM ProductSales
) AS ranked
WHERE rn = 1;


--4. Write a query to display each sale's amount along with the next sale amount in the order of SaleDate.

select SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
	LEAD(saleAmount) over (order by SaleDate) as next_sale_amount
from ProductSales


--5. Write a query to display each sale's amount along with the previous sale amount in the order of SaleDate.

select SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
	LAG(saleAmount) over (order by SaleDate) as previous_sale_amount
from ProductSales


--6. Write a query to identify sales amounts that are greater than the previous sale's amount

select* from

(select SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
	LAG(saleAmount) over (order by SaleDate) as previous_sale_amount
from ProductSales) as sales_with_lag
where SaleAmount > previous_sale_amount;

--7. Write a query to calculate the difference in sale amount from the previous sale for every product

select * from ProductSales

SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PreviousSaleAmount,
    SaleAmount - LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS DiffFromPrevious
FROM ProductSales;



--8.  Write a query to compare the current sale amount with the next sale amount in terms of percentage change.

SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    LEAD(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS NextSaleAmount,
    CASE 
        WHEN LEAD(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) IS NOT NULL
        THEN 
            100.0 * (SaleAmount - LEAD(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate)) 
            / LEAD(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate)
    END AS PercentChangeFromNext
FROM ProductSales;


--9. Write a query to calculate the ratio of the current sale amount to the previous sale amount within the same product.

SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PreviousSaleAmount,
    CAST(
        SaleAmount * 1.0 / LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate)
        AS DECIMAL(6,2)
    ) AS RatioToPrevious
FROM ProductSales;


--10. Write a query to calculate the difference in sale amount from the very first sale of that product.

select * from ProductSales
SELECT 
    ProductName,
    SaleDate,
    SaleAmount,
	
    FIRST_VALUE(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS FirstSale,
	SaleAmount-FIRST_VALUE(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) as difference_in_sale_amount
FROM ProductSales
ORDER BY ProductName, SaleDate


--11. Write a query to find sales that have been increasing continuously for a product --(i.e., each sale amount is greater than the previous sale amount for that product).

SELECT *
FROM (
    SELECT 
        SaleID,
        ProductName,
        SaleDate,
        SaleAmount,
        LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PrevSaleAmount
    FROM ProductSales
) AS SalesWithLag
WHERE SaleAmount > PrevSaleAmount;



--12. Write a query to calculate a "closing balance"(running total) for sales amounts 
--which adds the current sale amount to a running total of previous sales.

   SELECT 
        SaleID,
        ProductName,
        SaleDate,
        SaleAmount,
	sum(SaleAmount) over (partition by ProductName ORDER BY SaleDate) as RunningTotal
	from ProductSales

--13. Write a query to calculate the moving average of sales amounts over the last 3 sales.

SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    AVG(SaleAmount) OVER (
        PARTITION BY ProductName 
        ORDER BY SaleDate 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS MovingAvgLast3
FROM ProductSales
ORDER BY ProductName, SaleDate;


--14. Write a query to show the difference between each sale amount and the average sale amount.

SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    AVG(SaleAmount) OVER (
        PARTITION BY ProductName 
        ) as avg_sale_amount,
		 SaleAmount- AVG(SaleAmount) OVER (
        PARTITION BY ProductName 
        ) as difference_in_Sales
	from ProductSales
		
---------------------------------------------



CREATE TABLE Employees1 (
    EmployeeID   INT PRIMARY KEY,
    Name         VARCHAR(50),
    Department   VARCHAR(50),
    Salary       DECIMAL(10,2),
    HireDate     DATE
);

INSERT INTO Employees1 (EmployeeID, Name, Department, Salary, HireDate) VALUES
(1, 'John Smith', 'IT', 60000.00, '2020-03-15'),
(2, 'Emma Johnson', 'HR', 50000.00, '2019-07-22'),
(3, 'Michael Brown', 'Finance', 75000.00, '2018-11-10'),
(4, 'Olivia Davis', 'Marketing', 55000.00, '2021-01-05'),
(5, 'William Wilson', 'IT', 62000.00, '2022-06-12'),
(6, 'Sophia Martinez', 'Finance', 77000.00, '2017-09-30'),
(7, 'James Anderson', 'HR', 52000.00, '2020-04-18'),
(8, 'Isabella Thomas', 'Marketing', 58000.00, '2019-08-25'),
(9, 'Benjamin Taylor', 'IT', 64000.00, '2021-11-17'),
(10, 'Charlotte Lee', 'Finance', 80000.00, '2016-05-09'),
(11, 'Ethan Harris', 'IT', 63000.00, '2023-02-14'),
(12, 'Mia Clark', 'HR', 53000.00, '2022-09-05'),
(13, 'Alexander Lewis', 'Finance', 78000.00, '2015-12-20'),
(14, 'Amelia Walker', 'Marketing', 57000.00, '2020-07-28'),
(15, 'Daniel Hall', 'IT', 61000.00, '2018-10-13'),
(16, 'Harper Allen', 'Finance', 79000.00, '2017-03-22'),
(17, 'Matthew Young', 'HR', 54000.00, '2021-06-30'),
(18, 'Ava King', 'Marketing', 56000.00, '2019-04-16'),
(19, 'Lucas Wright', 'IT', 65000.00, '2022-12-01'),
(20, 'Evelyn Scott', 'Finance', 81000.00, '2016-08-07');
```

--15. Find Employees Who Have the Same Salary Rank

select * from Employees1

select employeeID,
Name, Department,
Salary,
DENSE_RANK() over (order by Salary) as Salary_Rank
from Employees1

--16. Identify the Top 2 Highest Salaries in Each Department

select * from
(select employeeID,
Name, Department,
Salary,
DENSE_RANK() over (partition by Department order by Salary) as Salary_Rank
from Employees1) as Ranked_Salary
where Salary_Rank<=2

--17. Find the Lowest-Paid Employee in Each Department

select * from
(select employeeID,
Name, Department,
Salary,
DENSE_RANK() over (partition by Department order by Salary asc) as Salary_Rank
from Employees1) as Ranked_Salary
where Salary_Rank=1


--18. Calculate the Running Total of Salaries in Each Department

SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    SUM(Salary) OVER (
        PARTITION BY Department 
        ORDER BY EmployeeID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotal
FROM Employees1;


--19. Find the Total Salary of Each Department Without GROUP BY

SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    SUM(Salary) OVER (
        PARTITION BY Department 
    ) AS TotalSalary
FROM Employees1;

--20. Calculate the Average Salary in Each Department Without GROUP BY

SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    AVG(Salary) OVER (
        PARTITION BY Department 
    ) AS AVGSalary
FROM Employees1;

--21. Find the Difference Between an Employee’s Salary and Their Department’s Average

SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    AVG(Salary) OVER (
        PARTITION BY Department 
    ) AS DepAVGSalary,
	salary-AVG(Salary) OVER (
        PARTITION BY Department 
    ) as diff
FROM Employees1;


--22. Calculate the Moving Average Salary Over 3 Employees (Including Current, Previous, and Next)

SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    AVG(Salary) OVER (
        ORDER BY EmployeeID
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) AS MovingAvgSalary
FROM Employees1;


--23. Find the Sum of Salaries for the Last 3 Hired Employees

select * from Employees1

SELECT SUM(Salary) AS TotalSalary_Last3Hired
FROM (
    SELECT *,
        ROW_NUMBER() OVER (ORDER BY HireDate DESC) AS rn
    FROM Employees1
) AS t
WHERE rn <= 3;

