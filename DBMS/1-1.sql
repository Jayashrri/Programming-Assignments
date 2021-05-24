DROP DATABASE IF EXISTS Company;
CREATE DATABASE Company;
USE Company;

CREATE TABLE Employee (
	Empid INT(10) NOT NULL,
	Empname VARCHAR(20) NOT NULL,
	Address VARCHAR(200),
	Doj DATE,
	Salary INT(10),
	PRIMARY KEY (Empid)
);

CREATE TABLE Project (
	Projectno INT(10) NOT NULL,
	Duration VARCHAR(20),
	Projectname VARCHAR(20),
	PRIMARY KEY (Projectno)
);

CREATE TABLE Workson (
	Empid INT(10) NOT NULL,
	Projectno INT(10) NOT NULL,
	FOREIGN KEY (Empid) REFERENCES Employee(Empid),
	FOREIGN KEY (Projectno) REFERENCES Project(Projectno)
);

INSERT INTO Employee VALUES
	(1, "A", "A", "2010-01-01", 80000),
	(2, "B", "A", "2010-01-01", 80000),
	(3, "C", "A", "2010-01-01", 80000),
	(4, "D", "A", "2010-01-01", 80000),
	(5, "E", "A", "2010-01-01", 80000),
	(6, "F", "A", "2010-01-01", 80000),
	(7, "G", "A", "2010-01-01", 80000),
	(8, "H", "A", "2010-01-01", 80000),
	(9, "I", "A", "2010-01-01", 80000),
	(10, "J", "A", "2010-01-01", 80000);
	
INSERT INTO Project VALUES
	(1, "X", "A"), 
	(2, "X", "B"), 
	(3, "X", "C"), 
	(4, "X", "D"), 
	(5, "X", "E");

INSERT INTO Workson VALUES
	(1, 1),
	(2, 1),
	(3, 2),
	(4, 2),
	(5, 3),
	(6, 3),
	(7, 4),
	(8, 4),
	(9, 5),
	(10, 5);

SELECT * FROM Employee ORDER BY Empname DESC;
SELECT * FROM Project WHERE Projectno=2;
SELECT Empname FROM Employee WHERE Empname LIKE "B%";
SELECT Empid FROM Workson WHERE Projectno=1;
