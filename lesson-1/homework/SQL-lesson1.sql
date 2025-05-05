
Easy

    Define the following terms: data, database, relational database, and table.
    List five key features of SQL Server.
    What are the different authentication modes available when connecting to SQL Server? (Give at least 2)

	1. Data is a collection of information. It's gathered by analysis. Data can be consist of numbers, facts, measures,
	  names, figures, videos, photos, audios or even description of the things. 
	  
	  Database is a collection of structured information which is stored electronically in a computer system.

	  Relational database is a structioned information organized into tables with rows and columns.

	  Table is a database object that stores all data in a database.

	2. Five key features of SQL Server:
		Security
		High availability
		Perfomance
		Intellegent query processing and query store
		Data management and integration


	3. SQL Server supports this main authentification modes for connecting to the server: 
		- Windows Authentification
		- SQL Server Authentication
		- mixed mode Authenfication

Medium

    Create a new database in SSMS named SchoolDB.
    Write and execute a query to create a table called Students with columns: StudentID (INT, PRIMARY KEY), Name (VARCHAR(50)), Age (INT).
    Describe the differences between SQL Server, SSMS, and SQL.


4. 
	create database SchoolDB
	use SchoolDB

5.
	Create table Students (StudentID INT PRIMARY KEY, Name VARCHAR(50), Age INT)

6.  SQL Server is the relational database management system (RDBMS) that stores and manages data.

	SSMS is the tool (interface) that allows you to connect to and manage SQL Server databases.

	SQL is the language used to interact with the data stored in SQL Server (and other relational databases).



Hard

    Research and explain the different SQL commands: DQL, DML, DDL, DCL, TCL with examples.
    Write a query to insert three records into the Students table.
    Restore AdventureWorksDW2022.bak file to your server. (write its steps to submit) You can find the database from this link :https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2022.bak


7.	DQL – Data Query Language: 
	Used to query and retrieve data from the database - SELECT

	DML - Data Manipulation Language:
	Used to manipulate data in existing tables - INSERT, DELETE, UPDATE
	
	DDL - Data Definition Language:
	Used to define or change the structure of database objects like tables, views, schemas - CREATE, ALTER, DROP, TRUNCATE

	DCL - Data Control Language:
	Used to control access to data and database objects - GRANT, REVOKE

	TCL - Transaction Control Language:
	Used to  manage changes made by DML statements and control transactions - COMMIT, ROLLBACK, SAVEPOINT

8. Use SchoolDB
	INSERT into Students (StudentID, Name, Age) Values
	(1, 'Abror', '23'),
	(2, 'Saida', '21'),
	(3, 'Ibrohim', '27')

9. Downloaded the backup file
   Saved it to my location - D:\SQL homeworks\AdventureWorksDW2022.bak
   Opened SSMS
   Clicked to databases, restore database, restored from the device the backup file

   Use AdventureWorksDW2022 

   DONE!


    
