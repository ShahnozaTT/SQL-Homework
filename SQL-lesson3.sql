1. Define and explain the purpose of BULK INSERT in SQL Server

Bulk Insert бу ташқи файлдан катта хажмдаги маълумотларни SQL Server га тезкорлик билан олиш учун ишлатиладиган оператор.
FIELDTERMINATOR, ROWTERMINATOR, FIRSTROW каби операторлар билан ишлатилади.

2. List four file formats that can be imported into SQL Server

CSV (Comma-Separated Values) - маълумотлар вергуллар орқали ажратилган

TXT (Text File) - маълумотлар (\t), (;) ёки бошқа символлар билан ажратилади

XML (eXtensible Markup Language) - OPENXML, XML Bulk Load ёки XML типдаги маълумотлар билан ишлашда қўлланилади

JSON (JavaScript Object Notation) - OPENJSON функцияси ва бошқа T-SQL методларини ишлатилади.

3. Create a table Products with columns: ProductID (INT, PRIMARY KEY), ProductName (VARCHAR(50)), Price (DECIMAL(10,2))

create database SQLHomework
use SQLHomework
go
create table Products (ProductId int  primary key, productName varchar (50), Price decimal (10,2))


4. Insert three records into the Products table using INSERT INTO.

Insert into Products(ProductId, productName, Price) values
(1, 'Banana', '25.5'),
(2, 'Potato', '7.5'),
(3, 'Tomato', '20.5')

5. Explain the difference between NULL and NOT NULL

NULL — бўш қиймат

    Ушбу устунда қиймат йўқ ёки номаълум дегани.

    NULL деб белгиланган устунга қиймат киритмасдан ҳам бўлади.

    Одатда мажбурий бўлмаган маълумотлар учун қўлланилади.

NOT NULL — мажбурий қиймат

    Бу устунда албатта қиймат бўлиши керак.

    Агар қиймат киритилмаса — хатолик юзага келади.

    Муҳим ёки зарур маълумотлар учун мўлжалланган.

6. Add a UNIQUE constraint to the ProductName column in the Products table.

Alter table Products
Add constraint UQ_ProductName Unique (ProductName)

7. Write a comment in a SQL query explaining its purpose.

1-қаторли изоҳ (// ёки -- билан) ёзилади

--	барча махсулотларни чиқариб оламиз

	Select * from Products

Кўп қаторли изоҳ (/* ... */ билан) ёзилади

	/*Products жадвалидан нархи 10 дан катта бўлган
	барча махсулотларни чиқариб оламиз*/


Select * from Products
Where price>10


8. Create a table Categories with a CategoryID as PRIMARY KEY and a CategoryName as UNIQUE.


Create table Categories (CategoryID int, CategoryName varchar(20), Primary key (CategoryID), Unique (CategoryName))


9. Explain the purpose of the IDENTITY column in SQL Server.

Автоматик сонлаш — ҳар бир янги ёзув учун автоматик рақам бериш.

Қайтарилмас (unique) ID — ҳар бир қаторнинг ўз рақами бўлади.

Primary Key билан ишлатиш учун жуда қулай.

CREATE TABLE Talabalar (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Ism VARCHAR(50),
    Yil INT
);

10. Use BULK INSERT to import data from a text file into the Products table.

Select * from Products
bulk insert [SQLHomework].[dbo].[Products]
from 'D:\DATA ANALYTICS\Lesson query\Data for HW 3.csv'
with (
firstrow=2,
fieldterminator=',',
rowterminator='\n');


11. Create a FOREIGN KEY in the Products table that references the Categories table.


ALTER TABLE Products
Add CategoryID int

ALTER TABLE Products
ADD CONSTRAINT FK_Products_Categories
FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID);

12. PRIMARY KEY (Асосий калит)

    PRIMARY KEY — жадвалдаги ҳар бир қаторни ноёб (ягона) қилиб белгилайди.

    Ҳар бир жадвалда фақат битта PRIMARY KEY бўлиши мумкин.

    Автоматик равишда NOT NULL (яъни, бўш қолдириб бўлмайди) қўлланади.

    Одатда бошқа жадваллар билан боғлаш (FOREIGN KEY) учун ишлатилади.


	UNIQUE KEY ҳам маълумотларнинг ноёб (қайтарилмас) бўлишини таъминлайди.

	Жадвалда бир нечта UNIQUE KEY бўлиши мумкин.

	PRIMARY KEY дан фарқли равишда, NULL (бўш) қийматларга рухсат беради.

	Одатда маълумотлар такрорланмаслиги учун ишлатилади, лекин у асосий идентификатор эмас.

13. Add a CHECK constraint to the Products table ensuring Price > 0.

ALTER TABLE Products
ADD CONSTRAINT CHK_Price_Positive CHECK (Price > 0);

14. Modify the Products table to add a column Stock (INT, NOT NULL).

ALTER TABLE Products
Add Stock int not null default 0

15. Use the ISNULL function to replace NULL values in Price column with a 0.

SELECT ProductId, ProductName, ISNULL(Price, 0) AS Price
FROM Products;

16. Describe the purpose and usage of FOREIGN KEY constraints in SQL Server.

FOREIGN KEY (Ташқи калит) — бу SQL Serverдаги constraint яъни бир жадвалдаги маълумотларнинг 
бошқа жадвалдаги маълумотлар билан боғланишини таъминлайди. 

17. Write a script to create a Customers table with a CHECK constraint ensuring Age >= 18.

Create table Customers (CustomerId int primary key, CustomerAdress varchar (50), Age int 
Check (Age>=18))

18. Create a table with an IDENTITY column starting at 100 and incrementing by 10

CREATE TABLE NEW
(ID INT IDENTITY(100, 10) PRIMARY KEY)

19. Write a query to create a composite PRIMARY KEY in a new table OrderDetails.

Create table OrderDetails (OrderId int, PRoductId int, Price int, Primary key (OrderId, ProductId))                     

20. Explain the use of COALESCE and ISNULL functions for handling NULL values.

COALESCE — бу стандарт SQL функцияси бўлиб, у бир нечта ифода ёки 
қийматнинг биринчи NULL бўлмаган қийматини қайтариш учун ишлатилади.

У биринчи NULL бўлмаган қийматни қайтариб беради.
Агар барча ифодалар NULL бўлса, у NULL қайтариб беради.

SELECT COALESCE(NULL, NULL, 'Биринчи null эмас', 10);

    Натижа: 'Биринчи null эмас'

ISNULL — бу баъзи маълумотлар базаларида (масалан, SQL Serverда) мавжуд бўлган функция бўлиб, 
NULL қийматини кўрсатилган ўрнига алмаштиради.

Агар expression NULL бўлса, ISNULL уни replacement_value билан алмаштиради.
Агар expression NULL бўлмаса, у асл ифодани қайтариб беради.

SELECT ISNULL(NULL, 'Алмаштириш');

    Натижа: 'Алмаштириш'

21. Create a table Employees with both PRIMARY KEY on EmpID and UNIQUE KEY on Email.

Create table Employees (EmpID int primary key, EmpName varchar (50), Email varchar (30) unique)


22. Write a query to create a FOREIGN KEY with ON DELETE CASCADE and ON UPDATE CASCADE options.

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);