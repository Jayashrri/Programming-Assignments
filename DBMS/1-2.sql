DROP DATABASE IF EXISTS School;
CREATE DATABASE School;
USE School;

CREATE TABLE Student (
	Rollno INT(10) NOT NULL,
	Name VARCHAR(20) NOT NULL,
	M1 INT(3),
	M2 INT(3),
	M3 INT(3),
	M4 INT(3),
	M5 INT(3),
	M6 INT(3),
	Total INT(3),
	PRIMARY KEY (Rollno)
);

CREATE TABLE Department (
	Deptid INT(10) NOT NULL,
	Deptname VARCHAR(20),
	HODname VARCHAR(20),
	PRIMARY KEY (Deptid)
);

CREATE TABLE StudDep (
	Rollno INT(10) NOT NULL,
	Deptid INT(10) NOT NULL,
	FOREIGN KEY (Rollno) REFERENCES Student(Rollno),
	FOREIGN KEY (Deptid) REFERENCES Department(Deptid)
);

INSERT INTO Student VALUES
	(1, "A", 80, 80, 80, 80, 80, 80, 0),
	(2, "B", 80, 80, 80, 80, 80, 80, 0),
	(3, "C", 80, 80, 80, 80, 80, 80, 0),
	(4, "D", 80, 80, 80, 80, 80, 80, 0),
	(5, "E", 80, 80, 80, 80, 80, 80, 0),
	(6, "F", 80, 80, 80, 80, 80, 80, 0),
	(7, "G", 80, 80, 80, 80, 80, 80, 0),
	(8, "H", 80, 80, 80, 80, 80, 80, 0),
	(9, "I", 80, 80, 80, 80, 80, 80, 0),
	(10, "J", 80, 80, 80, 80, 80, 80, 0);
	
UPDATE Student SET Total=M1+M2+M3+M4+M5+M6;

INSERT INTO Department VALUES
	(1, "A", "X"),
	(2, "B", "X"),
	(3, "C", "X");
	
INSERT INTO StudDep VALUES
	(1, 1),
	(2, 1),
	(3, 1),
	(4, 1),
	(5, 2),
	(6, 2),
	(7, 2),
	(8, 3),
	(9, 3),
	(10, 3);
	
SELECT * FROM Student INNER JOIN StudDep ON Student.Rollno=StudDep.Rollno WHERE Deptid=1;
SELECT * FROM Department INNER JOIN StudDep ON StudDep.Deptid=Department.Deptid WHERE Rollno=1;
SELECT Name FROM Student WHERE Total>500;
SELECT HODname FROM Department WHERE Deptname="A";
SELECT Rollno FROM StudDep INNER JOIN Department ON StudDep.DeptId=Department.DeptId WHERE DeptName="A";
