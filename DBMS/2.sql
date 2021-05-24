DROP DATABASE IF EXISTS Company;
CREATE DATABASE Company;
USE Company;

CREATE TABLE Department (
	dno INT(10) NOT NULL,
	dname VARCHAR(20) NOT NULL,
	managername VARCHAR(20) NOT NULL,
	PRIMARY KEY(dno)
);

CREATE TABLE Employee (
	empno INT(10) NOT NULL,
	ename VARCHAR(20) NOT NULL, 
	address VARCHAR(200),
	sex VARCHAR(10),
	dob DATE,
	joiningdate DATE,
	deptno INT(10) NOT NULL,
	division VARCHAR(20),
	designation VARCHAR(20),
	salary INT(10) NOT NULL,
	PRIMARY KEY(empno)
);

INSERT INTO Department VALUES
	(1, 'admin', 'A'),
	(2, 'finance', 'B'),
	(3, 'sales', 'C'),
	(4, 'marketing', 'D'),
	(5, 'technical', 'X');

INSERT INTO Employee VALUES
	(1, 'A', '123', 'F', '2000-01-01', '2009-01-01', 1, 'ne', 'X', 13000),
	(2, 'B', '123', 'F', '2000-01-01', '2008-01-01', 2, 'se', 'X', 10000),
	(3, 'C', '123', 'F', '2000-01-01', '2007-01-01', 3, 'nw', 'X', 9000),
	(4, 'D', '123', 'F', '2000-01-01', '2010-01-01', 4, 'nw', 'X', 6000),
	(5, 'E', '123', 'F', '2000-01-01', '2010-01-01', 1, 'ne', 'X', 8000),
	(6, 'F', '123', 'F', '2000-01-01', '2009-01-01', 2, 'se', 'X', 5000),
	(7, 'G', '123', 'F', '2000-01-01', '2014-01-01', 3, 'se', 'X', 3000),
	(8, 'H', '123', 'F', '2000-01-01', '2014-01-01', 4, 'ne', 'X', 16000),
	(9, 'I', '123', 'F', '2000-01-01', '2020-01-01', 1, 'nw', 'X', 2000),
	(10, 'J', '123', 'F', '2000-01-01', '2012-01-01', 2, 'se', 'X', 4000),
	(11, 'K', '123', 'F', '2000-01-01', '2016-01-01', 3, 'nw', 'X', 7000),
	(12, 'L', '123', 'F', '2000-01-01', '2012-01-01', 4, 'sw', 'X', 7000),
	(13, 'M', '123', 'F', '2000-01-01', '2015-01-01', 1, 'sw', 'X', 6000),
	(14, 'N', '123', 'F', '2000-01-01', '2020-01-01', 2, 'nw', 'X', 5000),
	(15, 'O', '123', 'F', '2000-01-01', '2017-01-01', 3, 'se', 'X', 4000);

-- Question 1
SELECT ename, division FROM Employee 
	WHERE salary NOT BETWEEN 3000 and 5000;

-- Question 2
SELECT ename, salary FROM Employee E 
	INNER JOIN Department D ON E.deptno=D.dno 
	WHERE dname IN ('admin', 'finance', 'sales');

-- Question 3
(SELECT ename, dname FROM Employee E 
	INNER JOIN Department D ON E.deptno=D.dno 
	WHERE dname='sales') 
	UNION 
	(SELECT ename, dname FROM Employee E 
	INNER JOIN Department D ON E.deptno=D.dno 
	WHERE dname='marketing');

-- Question 4	
SELECT ename FROM Employee 
	WHERE division='ne' OR division='se';
	
-- Question 5
SELECT ename, salary FROM Employee WHERE salary=(SELECT MAX(salary) FROM Employee);

-- Question 6	
SELECT designation, salary FROM Employee
	WHERE salary=(SELECT AVG(salary) FROM Employee);

-- Question 7
SELECT E1.ename FROM Employee E1 
	WHERE E1.salary IN 
	(SELECT MIN(E2.salary) FROM Employee E2 
	GROUP BY E2.deptno 
	HAVING E1.deptno=E2.deptno);

-- Question 8
SELECT * FROM Employee E1 
	WHERE E1.salary > 
	(SELECT AVG(E2.salary) FROM Employee E2 
	GROUP BY E2.deptno 
	HAVING E1.deptno=E2.deptno);

-- Question 9
SELECT * FROM Employee 
	WHERE ename NOT IN 
	(SELECT managername FROM Department);

-- Question 10
SELECT * FROM Employee 
	WHERE salary > 
	(SELECT MIN(salary) FROM Employee E 
	INNER JOIN Department D ON E.deptno=D.dno 
	WHERE E.ename=D.managername);
	
-- Question 11
SELECT dname FROM Department D 
	LEFT JOIN 
	(SELECT deptno, COUNT(*) AS empcount FROM Employee GROUP BY deptno) C 
	ON D.dno=C.deptno 
	WHERE empcount IS NULL;

-- Question 12
SELECT * FROM Employee 
	WHERE salary > 
	(SELECT MAX(salary) FROM Employee E 
	INNER JOIN Department D ON E.deptno=D.dno 
	WHERE E.ename=D.managername);
	
-- Question 13
SELECT ename, YEAR(CURDATE())-YEAR(dob) AS age FROM Employee;

-- Question 14
SELECT ename FROM Employee WHERE FLOOR(DATEDIFF(CURDATE(), joiningdate)/365) > 10;

-- Question 15
CREATE VIEW EmployeeView AS
	SELECT empno, ename, salary FROM Employee;

CREATE VIEW SalaryView AS
	SELECT empno, salary FROM EmployeeView
	WHERE salary>3000;

