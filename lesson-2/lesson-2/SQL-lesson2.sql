use [SQL HW2]
go

Create a table Employees with columns: EmpID INT, Name (VARCHAR(50)), and Salary (DECIMAL(10,2)).

create table Employees (EmpID INT, Name VARCHAR(50), Salary DECIMAL(10,2))
insert into Employees (EmpID, Name, salary) values (1, 'Said', '9.3')
insert into Employees (EmpID, Name, salary) values (2, 'Komil', '15.5')
insert into Employees (EmpID, Name, salary) values (3, 'Ahmed', '6.0')

2.Insert three records into the Employees table using 
different INSERT INTO approaches (single-row insert and multiple-row insert).

delete from Employees
delete Employees

insert into Employees (EmpID, Name, salary) values (1, 'Said', '9.3'),
(2, 'Komil', '15.5'),
(3, 'Ahmed', '6.0')

3. Update the salary of an employee to 7000 where EmpID = 1.

Select * from Employees
Update Employees
Set Salary=7000
where EmpID=1

4. Delete a record from the Employees table where EmpID = 2.

Delete from Employees
where EmpID=1

5. Give a brief definition for difference between DELETE, TRUNCATE, and DROP.

Delete - берилган шарт бўйича (where) жадвалдан маълумотлар бор қаторларни ўчиради. Орқага қайтариш мумкин
Truncate - жадвалнинг шаклини сақлаб қолган холда барча маълумотларни ўчиради
DROP - тўлиқ холда жадвал ва ундаги барча маълумотларни ўчиради.Орқага қайтариш мумкин эмас.

6. Modify the Name column in the Employees table to VARCHAR(100)

Alter table Employees 
Alter Column Name VARCHAR (100);

7. Add a new column Department (VARCHAR(50)) to the Employees table.

Alter table Employees 
Add Department varchar (50)

8. Change the data type of the Salary column to FLOAT

Alter table Employees 
Alter Column Salary FlOAT 

9. Create another table Departments with columns DepartmentID (INT, PRIMARY KEY) and DepartmentName (VARCHAR(50)).

create table Departments (DepartmentID INT PRIMARY KEY ,
							DepartmentName VARCHAR(50))

10. Remove all records from the Employees table without deleting its structure.

Truncate table Employees

11. Insert five records into the Departments table using INSERT INTO SELECT method(you can write anything you want as data).

insert into Departments (DepartmentID, DepartmentName) values 
(1, 'HR'), 
(2, 'Sales'),
(3, 'Management'), 
(4, 'Director'),
(5, 'Production')

12. Update the Department of all employees where Salary > 5000 to 'Management'.

select * from Employees

Update Employees 
Set Department ='Management'
where Salary > 5000

13. Write a query that removes all employees but keeps the table structure intact.

Truncate table Employees

14. Drop the Department column from the Employees table.

Alter table Employees
Drop column Department

15. Rename the Employees table to StaffMembers using SQL commands.

Exec sp_rename 'Employees', 'StaffMembers' 

16. Write a query to completely remove the Departments table from the database.

Drop table Departments

17. Create a table named Products with at least 5 columns, including: 
ProductID (Primary Key), ProductName (VARCHAR), Category (VARCHAR), Price (DECIMAL)

Create table Products (ProductID int Primary Key, ProductName VARCHAR(50), 
			Category VARCHAR(50), Price DECIMAL(10,3), Quantity int)

18. Add a CHECK constraint to ensure Price is always greater than 0.

ALTER TABLE Products
ADD CONSTRAINT chk_price_positive CHECK (Price > 0);

19. Modify the table to add a StockQuantity column with a DEFAULT value of 50.

Alter table products
Add StockQuantity int DEFAULT 50

20. Rename Category to ProductCategory

EXEC sp_rename 'Products.Category', 'ProductCategory', 'COLUMN';

21. Insert 5 records into the Products table using standard INSERT INTO queries.

insert into Products(ProductID, ProductName, ProductCategory, Price, Quantity) values 
(1, 'Bahroma', 'ice-cream', 6000, 25),
(2, 'Rjanoe', 'Bread', 3000, 55),
(3, 'jacket', 'Cloth', 50000, 15),
(4, 'Cup', 'Dishes', 30000, 40),
(5, 'sock', 'Cloth', 6000, 30)

select * from Products

22. Use SELECT INTO to create a backup table called Products_Backup containing all Products data.

Select * into Products_backup
from Products

23. Rename the Products table to Inventory.

Exec sp_rename Products, Inventory

24. Alter the Inventory table to change the data type of Price from DECIMAL(10,2) to FLOAT.

Alter table Inventory 
drop CONSTRAINT chk_price_positive 

Alter table Inventory
Alter Column Price FlOAT;

25. Add an IDENTITY column named ProductCode that starts from 1000 and increments by 5 to Inventory table.

 тушунмадим)