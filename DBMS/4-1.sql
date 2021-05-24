DROP DATABASE IF EXISTS Billing;
CREATE DATABASE Billing;
USE Billing;

-- Question 1
CREATE TABLE Customer(
	cust_id INT NOT NULL, 
	cust_name VARCHAR(125), 
	PRIMARY KEY (cust_id)
);

CREATE TABLE Item(
	item_id INT NOT NULL, 
	item_name VARCHAR(255), 
	price INT, 
	PRIMARY KEY (item_id)
);

CREATE TABLE Sales(
	bill_no INT NOT NULL, 
	bill_date DATE DEFAULT (CURDATE()), 
	cust_id INT NOT NULL, 
	item_id INT NOT NULL,  
	qty_sold INT NOT NULL, 
	PRIMARY KEY (bill_no), 
	FOREIGN KEY (cust_id) REFERENCES Customer(cust_id), 
	FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

INSERT INTO Customer VALUES
	(1, 'A'),
	(2, 'B'),
	(3, 'C'),
	(4, 'D'),
	(5, 'E');

INSERT INTO Item VALUES
	(1, 'L', 100),
	(2, 'M', 200),
	(3, 'N', 150),
	(4, 'O', 300),
	(5, 'P', 450);


INSERT INTO Sales (bill_no, cust_id, item_id, qty_sold) VALUES 
	(1,1,1,4),
	(2,1,2,3),
	(3,2,5,1),
	(4,4,3,3),
	(5,5,4,2);

-- Question 2
SELECT Sales.*, cust_name, item_id FROM Sales NATURAL JOIN Item NATURAL JOIN Customer WHERE bill_date=CURDATE();

-- Question 3
SELECT Customer.* FROM Sales NATURAL JOIN Item NATURAL JOIN Customer WHERE price>200;

-- Question 4
SELECT SUM(qty_sold) FROM Sales GROUP BY cust_id;

-- Question 5
SELECT DISTINCT Item.* FROM Item NATURAL JOIN Sales WHERE cust_id=5;

-- Question 6
SELECT item_name, price, qty_sold FROM Item NATURAL JOIN Sales WHERE bill_date<=CURDATE();

-- Question 7
CREATE VIEW BillView AS SELECT bill_no, bill_date, cust_id, item_id, price, qty_sold, price*qty_sold AS amount FROM Sales NATURAL JOIN Item;
CREATE VIEW WeekView AS SELECT * FROM Sales WHERE bill_date BETWEEN CURDATE() - INTERVAL 7 DAY AND CURDATE() ORDER BY bill_date;

