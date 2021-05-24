DROP DATABASE IF EXISTS Company;
CREATE DATABASE Company;
USE Company;

CREATE TABLE Department(
	DeptNo INT NOT NULL, 
	DeptName VARCHAR(30), 
	Location VARCHAR(30), 
	PRIMARY KEY (DeptNo)
);

CREATE TABLE Employee( 
	EmpNo INT NOT NULL, 
	EmpName VARCHAR(30), 
	Sex VARCHAR(1), 
	Salary INT, 
	Address VARCHAR(255), 
	DeptNo INT NOT NULL, 
	PRIMARY KEY (EmpNo), 
	FOREIGN KEY (DeptNo) REFERENCES Department(DeptNo) 
);

INSERT INTO Department VALUES 
	(1, 'CSE', 'NITT'),
	(2, 'EEE', 'NITT'),
	(3, 'ECE', 'NITT'),
	(4, 'META', 'NITT');

INSERT INTO Employee VALUES 
	(1, 'Bala', 'M', 20000, 'Chennai', 2),
	(2, 'Anu', 'F', 20012, 'Trichy', 3),
	(3, 'Pavithra', 'F', 20400, 'Bangalore', 1),
	(4, 'Madhav', 'M', 24000, 'Chennai', 2),
	(5, 'Anirudh', 'T', 30000, 'Chennai', 4);

DELIMITER //

-- Question 1
CREATE PROCEDURE get_details(IN empId INT)
BEGIN
	SELECT * FROM Employee WHERE EmpNo=empId;
END //

-- Question 2
CREATE PROCEDURE add_details(IN empId INT, IN empName VARCHAR(30), IN empSex VARCHAR(1), IN empSalary INT, IN empAddr VARCHAR(30), IN empDeptId INT)
BEGIN
	INSERT INTO Employee VALUES (empId, empName, empSex, empSalary,  empAddr, empDeptId);
END //

-- Question 3
CREATE PROCEDURE update_salary(IN empId INT,IN new_salary INT)
BEGIN
	UPDATE Employee SET Salary = new_salary
	WHERE EmpNo = empId;
END //

-- Question 4
CREATE PROCEDURE del_emp(IN ename VARCHAR(30))
BEGIN
	DELETE FROM Employee WHERE EmpName = ename;
END //

-- Question 5
CREATE FUNCTION getMax() RETURNS INT DETERMINISTIC
BEGIN
	DECLARE maxSal INT;
	SELECT MAX(Salary) INTO maxSal FROM Employee;
	RETURN maxSal;
END //

-- Question 6
CREATE FUNCTION total_emp() RETURNS INT DETERMINISTIC
BEGIN
	DECLARE tot INT;
	SELECT Count(*) INTO tot  FROM Employee;
	RETURN tot;
END//


-- Question 7
CREATE FUNCTION getSalary(empId INT) RETURNS INT DETERMINISTIC
BEGIN
	DECLARE empSal INT;
	SELECT Salary INTO empSal FROM Employee WHERE EmpNo=empId;
	RETURN empSal;
END //

-- Question 8
CREATE FUNCTION avg_salary(deptId INT) RETURNS INT DETERMINISTIC
BEGIN
	DECLARE avgSal INT;
	SELECT AVG(Salary) INTO avgSal FROM Employee
	WHERE DeptNo = deptId;
	RETURN avgSal;
END//

-- Question 9
CREATE PROCEDURE get_employees(IN deptId INT)
BEGIN
	SELECT EmpName FROM Employee WHERE DeptNo=deptId;
END //

-- Question 10
CREATE PROCEDURE dept_highest(IN deptId INT)
BEGIN
	SELECT DeptName, MAX(Salary) FROM Department NATURAL JOIN Employee WHERE DeptNo = deptId;
END //

CREATE PROCEDURE highest_salary() 
BEGIN
	DECLARE i INT;
	DECLARE cnt INT; 
	SET i = 1;
	SELECT COUNT(*) INTO cnt FROM Department; 
	loop_label:  LOOP
		IF i > cnt THEN 
			LEAVE loop_label;
		END IF;
		CALL dept_highest(i);
		SET i = i + 1;
	END LOOP; 
END//

-- Question 11
CREATE FUNCTION countHighSalary() RETURNS INT DETERMINISTIC
BEGIN
	DECLARE empCount INT;
	SELECT COUNT(*) INTO empCount FROM Employee WHERE Salary > 50000;
	RETURN empCount;
END //

-- Question 12
CREATE FUNCTION countLocalEmp() RETURNS INT DETERMINISTIC
BEGIN
	DECLARE empCount INT;
	SELECT COUNT(*) INTO empCount FROM Employee WHERE Address='Chennai';
	RETURN empCount;
END //

DELIMITER ;

CALL get_details(1);
SELECT getMax();
SELECT total_emp();
SELECT getSalary(3);
SELECT avg_salary(2);
CALL get_employees(2);
CALL highest_salary();
SELECT countHighSalary();
SELECT countLocalEmp();
