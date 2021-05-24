DROP DATABASE IF EXISTS Institute;
CREATE DATABASE Institute;
USE Institute;

-- Question 1
CREATE TABLE Department(
	deptid INT NOT NULL, 
	deptname VARCHAR(255) NOT NULL,
	PRIMARY KEY (deptid)
);

CREATE TABLE Student (
	rollno INT NOT NULL, 
	name VARCHAR(20) NOT NULL, 
	gender ENUM('Boy', 'Girl') NOT NULL, 
	mark1 INT, 
	mark2 INT,
	mark3 INT, 
	deptid INT NOT NULL,
	total INT AS (mark1+mark2+mark3), 
	average FLOAT(5) AS (total/3), 
	PRIMARY KEY (rollno),
	FOREIGN KEY (deptid) REFERENCES Department(deptid)
);

CREATE TABLE Staff (
	staffid INT NOT NULL, 
	staffname VARCHAR(20), 
	designation VARCHAR(20), 
	qualification VARCHAR(20), 
	deptid INT NOT NULL,
	PRIMARY KEY (staffid),
	FOREIGN KEY (deptid) REFERENCES Department(deptid)
);

CREATE TABLE Tutor(
	rollno INT NOT NULL, 
	staffid INT NOT NULL,
	FOREIGN KEY (rollno) REFERENCES Student(rollno),
	FOREIGN KEY (staffid) REFERENCES Staff(staffid)
);

INSERT INTO Department VALUES
	(1, 'CSE'),
	(2, 'ECE'),
	(3, 'EEE'),
	(4, 'MECH'),
	(5, 'PROD');

INSERT INTO Student (rollno, name, gender, mark1, mark2, mark3, deptid) VALUES
	(1, 'L', 'Boy', 89, 90, 82, 1),
	(2, 'M', 'Girl', 90, 90, 87, 1),
	(3, 'N', 'Girl', 81, 91, 81, 1),
	(4, 'O', 'Boy', 86, 93, 81, 2),
	(5, 'P', 'Girl', 83, 93, 86, 2),
	(6, 'Q', 'Boy', 82, 92, 82, 2),
	(7, 'R', 'Girl', 89, 99, 89, 3),
	(8, 'S', 'Boy', 89, 90, 92, 3),
	(9, 'T', 'Boy', 79, 80, 82, 3),
	(10, 'U', 'Girl', 96, 87, 92, 4),
	(11, 'V', 'Boy', 89, 90, 87, 4),
	(12, 'W', 'Girl', 85, 95, 86, 4),
	(13, 'X', 'Boy', 77, 78, 82, 5),
	(14, 'Y', 'Girl', 95, 90, 92, 5),
	(15, 'Z', 'Boy', 85, 93, 87, 5);

INSERT INTO Staff VALUES
	(1, 'A', 'Professor', 'M.Sc', 1),
	(2, 'B', 'HOD', 'M.Tech', 1),
	(3, 'C', 'HOD', 'M.Tech', 2),
	(4, 'D', 'Professor', 'M.Com', 3),
	(5, 'E', 'HOD', 'M.Sc', 4),
	(6, 'F', 'Professor', 'M.Tech', 4),
	(7, 'X', 'Professor', 'M.Sc', 5);

INSERT INTO Tutor VALUES
	(1, 1),
	(2, 1),
	(3, 2),
	(4, 3),
	(5, 3),
	(6, 3),
	(7, 4),
	(8, 4),
	(9, 4),
	(10, 5),
	(11, 6),
	(12, 6),
	(13, 7),
	(14, 7),
	(15, 7);

-- Question 2
SELECT COUNT(*) FROM Student NATURAL JOIN Department WHERE deptname='CSE';

-- Question 3
SELECT * FROM Student WHERE average>85;

-- Question 4
SELECT COUNT(*) FROM Tutor NATURAL JOIN Staff WHERE staffname='X';

-- Question 5
SELECT * FROM Staff NATURAL JOIN Department WHERE deptname='CSE';

-- Question 6
SELECT (SELECT COUNT(DISTINCT designation) FROM Staff) AS designations, (SELECT COUNT(*) FROM Department) AS departments;

-- Question 7
SELECT * FROM Student WHERE name LIKE 'R%';

-- Question 8
SELECT rollno, staffid, deptname FROM Student NATURAL JOIN Department NATURAL JOIN Tutor WHERE rollno=6;

-- Question 9
SELECT COUNT(*), gender, deptid FROM Student GROUP BY deptid, gender;

-- Question 10
SELECT S1.name, S1.deptid FROM Student S1 WHERE S1.total IN (SELECT MAX(S2.total) FROM Student S2 GROUP BY S2.deptid HAVING S1.deptid=S2.deptid);

-- Question 11
SELECT S1.deptid, staffid FROM Student S1 NATURAL JOIN Tutor WHERE S1.total IN (SELECT MAX(S2.total) FROM Student S2 GROUP BY S2.deptid HAVING S1.deptid=S2.deptid);

-- Question 12
SELECT Staff.* FROM Staff NATURAL JOIN Tutor NATURAL JOIN Student WHERE gender='Girl';

-- Question 13
CREATE VIEW StaffDept AS SELECT Staff.*, deptname FROM Staff NATURAL JOIN Department WHERE designation='Professor';

