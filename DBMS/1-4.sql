DROP DATABASE IF EXISTS Cars;
CREATE DATABASE Cars;
USE Cars;

CREATE TABLE Car (
	serialno INT(10) NOT NULL,
	model VARCHAR(20) NOT NULL,
	manufacturer VARCHAR(20),
	PRIMARY KEY (serialno)
);

CREATE TABLE Options (
	serialno INT(10) NOT NULL,
	optionname VARCHAR(20) NOT NULL,
	price INT(10),
	FOREIGN KEY (serialno) REFERENCES Car(serialno)
);

CREATE TABLE Salesperson (
	salespersonid INT(10) NOT NULL,
	name VARCHAR(20) NOT NULL,
	phone VARCHAR(10),
	PRIMARY KEY (salespersonid)
);

CREATE TABLE Sales (
	salespersonid INT(10) NOT NULL,
	serialno INT(10) NOT NULL,
	saledate DATE,
	sale_price INT(10),
	FOREIGN KEY (salespersonid) REFERENCES Salesperson(salespersonid),
	FOREIGN KEY (serialno) REFERENCES Car(serialno)	
);

INSERT INTO Car VALUES
	(1, "A", "X"),
	(2, "B", "X"),
	(3, "C", "X"),
	(4, "D", "Y");

INSERT INTO Options VALUES
	(1, "A", 300000),
	(1, "B", 500000),
	(2, "A", 300000),
	(2, "B", 500000),
	(3, "A", 300000),
	(3, "B", 500000);

INSERT INTO Salesperson VALUES
	(1, "John", "9999999999"),
	(2, "Jason", "9999988888"),
	(3, "Charlie", "8888899999");

INSERT INTO Sales VALUES
	(1, 1, "2020-01-01", 500000),
	(1, 2, "2020-01-01", 300000),
	(2, 3, "2020-01-01", 500000),
	(3, 1, "2020-01-01", 300000),
	(3, 3, "2020-01-01", 300000);

SELECT Car.serialno, manufacturer, sale_price FROM (
	(Sales INNER JOIN Salesperson ON Sales.salespersonid=Salesperson.salespersonid) 
	INNER JOIN Car ON Car.serialno=Sales.serialno
) WHERE name="John";
SELECT Car.serialno, model FROM Car LEFT JOIN Options ON Car.serialno=Options.serialno WHERE optionname IS NULL;
SELECT Car.serialno, model FROM Car LEFT JOIN Options ON Car.serialno=Options.serialno WHERE optionname IS NOT NULL;
UPDATE Salesperson SET phone="8888888888" WHERE name="John";
