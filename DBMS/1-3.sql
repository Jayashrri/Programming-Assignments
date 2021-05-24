DROP DATABASE IF EXISTS Sales;
CREATE DATABASE Sales;
USE Sales;

CREATE TABLE Salesperson (
	ssn INT(10) NOT NULL,
	name VARCHAR(20) NOT NULL,
	startyear INT(4),
	deptno INT(10),
	PRIMARY KEY (ssn)
);

CREATE TABLE Trip (
	ssn INT(10) NOT NULL,
	fromcity VARCHAR(20),
	tocity VARCHAR(20),
	departuredate DATE,
	returndate DATE,
	tripid INT(10) NOT NULL,
	PRIMARY KEY (tripid),
	FOREIGN KEY (ssn) REFERENCES Salesperson(ssn)
);

CREATE TABLE SalerepExpense (
	tripid INT(10) NOT NULL,
	expensetype VARCHAR(10) NOT NULL,
	amount INT(10),
	FOREIGN KEY (tripid) REFERENCES Trip(tripid)
);

ALTER TABLE SalerepExpense ADD CONSTRAINT CHECK (expensetype IN ("TRAVEL", "FOOD", "STAY")); 

INSERT INTO Salesperson VALUES
	(1, "A", 2010, 1),
	(2, "B", 2010, 1),
	(3, "C", 2010, 2),
	(4, "D", 2010, 2),
	(5, "E", 2010, 3);
	
INSERT INTO Trip VALUES
	(1, "Bangalore", "Chennai", "2020-01-01", "2020-02-01", 1),
	(1, "Bangalore", "Chennai", "2020-01-01", "2020-02-01", 2),
	(2, "Bangalore", "Chennai", "2020-01-01", "2020-02-01", 3),
	(3, "Bangalore", "Chennai", "2020-01-01", "2020-02-01", 4),
	(4, "Bangalore", "Chennai", "2020-01-01", "2020-02-01", 5),
	(4, "Bangalore", "Chennai", "2020-01-01", "2020-02-01", 6),
	(5, "Bangalore", "Chennai", "2020-01-01", "2020-02-01", 7);

INSERT INTO SalerepExpense VALUES
	(1, "TRAVEL", 1000),
	(1, "STAY", 1000),
	(2, "TRAVEL", 1000),
	(2, "STAY", 1000),
	(2, "FOOD", 1000),
	(3, "TRAVEL", 1000),
	(4, "TRAVEL", 1000),
	(5, "TRAVEL", 1000),
	(6, "TRAVEL", 1000),
	(7, "TRAVEL", 1000);
	
SELECT Trip.* FROM Trip INNER JOIN SalerepExpense ON Trip.tripid=SalerepExpense.tripid GROUP BY Trip.tripid HAVING SUM(amount)>2000;
SELECT ssn FROM Trip GROUP BY ssn HAVING COUNT(tocity="Chennai")>1;
SELECT SUM(amount) FROM SalerepExpense INNER JOIN Trip on Trip.tripid=SalerepExpense.tripid WHERE ssn=1;
SELECT * FROM Salesperson ORDER BY name DESC; 
