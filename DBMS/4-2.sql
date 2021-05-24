DROP DATABASE IF EXISTS Labs;
CREATE DATABASE Labs;
USE Labs;

-- Question 1
CREATE TABLE Class(
	class VARCHAR(255), 
	descrip VARCHAR(255), 
	PRIMARY KEY (class)
);

CREATE TABLE Student(
	stud_no INT NOT NULL, 
	stud_name VARCHAR(255), 
	class VARCHAR(255), 
	PRIMARY KEY (stud_no), 
	FOREIGN KEY (class) REFERENCES Class(class)
);

CREATE TABLE Lab(
	mach_no INT NOT NULL, 
	lab_no INT NOT NULL, 
	description VARCHAR(255), 
	PRIMARY KEY (mach_no)
);

CREATE TABLE Allotment(
	stud_no INT NOT NULL, 
	mach_no INT NOT NULL, 
	day_of_week ENUM('Mon', 'Tue', 'Wed', 'Thurs', 'Fri') NOT NULL, 
	FOREIGN KEY (stud_no) REFERENCES Student(stud_no), 
	FOREIGN KEY (mach_no) REFERENCES Lab(mach_no)
);

INSERT INTO Class VALUES
	('CSIT', 'V'),
	('ABCD', 'W'),
	('LMNO', 'X'),
	('PQRS', 'Y'),
	('WXYZ', 'Z');

INSERT INTO Student VALUES
	(1, 'A', 'CSIT'),
	(2, 'B', 'CSIT'),
	(3, 'C', 'LMNO'),
	(4, 'D', 'WXYZ'),
	(5, 'E', 'PQRS'),
	(6, 'F', 'ABCD');
	
INSERT INTO Lab VALUES
	(1, 1, 'A'),
	(2, 1, 'B'),
	(3, 2, 'C'),
	(4, 2, 'D'),
	(5, 3, 'E');
	
INSERT INTO Allotment VALUES
	(1, 1, 'Mon'),
	(2, 1, 'Tue'),
	(3, 2, 'Mon'),
	(4, 3, 'Thurs'),
	(5, 5, 'Mon');

-- Question 2
SELECT stud_name, mach_no, lab_no FROM Allotment NATURAL JOIN Lab NATURAL JOIN Student;

-- Question 3
SELECT stud_name FROM Student WHERE stud_no NOT IN (SELECT stud_no FROM Allotment);

-- Question 4
SELECT COUNT(DISTINCT mach_no) FROM Allotment NATURAL JOIN Student WHERE class='CSIT';   

-- Question 5
SELECT COUNT(*) FROM Allotment NATURAL JOIN Lab WHERE lab_no=1 AND day_of_week='Mon';

-- Question 6
CREATE VIEW AllotView AS SELECT stud_no, stud_name, mach_no, lab_no, day_of_week FROM Allotment NATURAL JOIN Student NATURAL JOIN Lab;

