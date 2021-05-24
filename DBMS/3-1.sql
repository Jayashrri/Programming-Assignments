DROP DATABASE IF EXISTS Hostels;
CREATE DATABASE Hostels;
USE Hostels;

-- Question 1
CREATE TABLE Hostel (
	hno INT NOT NULL,
	hname VARCHAR(20) NOT NULL,
	type ENUM('Boys', 'Girls') NOT NULL,
	PRIMARY KEY (hno)
);

CREATE TABLE Menu (
	hno INT NOT NULL,
	day ENUM('Mon', 'Tue', 'Wed', 'Thurs', 'Fri', 'Sat', 'Sun') NOT NULL,
	breakfast VARCHAR(200),
	lunch VARCHAR(200),
	dinner VARCHAR(200),
	FOREIGN KEY (hno) REFERENCES Hostel(hno)
);

CREATE TABLE Warden(
	wname VARCHAR(20) NOT NULL,
	qual VARCHAR(20) NOT NULL,
	hno INT NOT NULL,
	FOREIGN KEY (hno) REFERENCES Hostel(hno)
);

CREATE TABLE Student(
	sid INT NOT NULL,
	sname VARCHAR(20) NOT NULL,
	gender ENUM('Boy', 'Girl') NOT NULL,
	year INT NOT NULL,
	hno INT NOT NULL,
	PRIMARY KEY (sid),
	FOREIGN KEY (hno) REFERENCES Hostel(hno)
);

INSERT INTO Hostel VALUES
	(1, 'A', 'Boys'),
	(2, 'B', 'Boys'),
	(3, 'C', 'Boys'),
	(4, 'X', 'Girls'),
	(5, 'Y', 'Girls');

INSERT INTO Menu VALUES
	(1, 'Mon', 'Bread', 'Rice', 'Chapati'),
	(1, 'Tue', 'Bread', 'Rice', 'Chapati'),
	(2, 'Wed', 'Bread', 'Rice', 'Chapati'),
	(2, 'Fri', 'Bread', 'Rice', 'Chapati'),
	(3, 'Sat', 'Bread', 'Rice', 'Chapati'),
	(3, 'Sun', 'Bread', 'Rice', 'Chapati'),
	(4, 'Thurs', 'Bread', 'Rice', 'Chapati'),
	(5, 'Tue', 'Bread', 'Rice', 'Chapati'),
	(5, 'Thurs', 'Bread', 'Rice', 'Chapati');

INSERT INTO Warden VALUES
	('L', 'B.Com', 1),
	('M', 'B.Tech', 1),
	('N', 'B.Com', 2),
	('O', 'B.Sc', 3),
	('P', 'B.Sc', 4),
	('Q', 'B.Com', 4),
	('R', 'B.Tech', 5);

INSERT INTO Student VALUES
	(1, 'A', 'Boy', 1, 1),
	(2, 'B', 'Boy', 2, 1),
	(3, 'C', 'Boy', 3, 1),
	(4, 'D', 'Boy', 1, 2),
	(5, 'E', 'Boy', 2, 2),
	(6, 'F', 'Boy', 3, 2),
	(7, 'G', 'Boy', 1, 3),
	(8, 'H', 'Boy', 2, 3),
	(9, 'I', 'Boy', 3, 3),
	(10, 'J', 'Girl', 1, 4),
	(11, 'K', 'Girl', 2, 4),
	(12, 'L', 'Girl', 3, 4),
	(13, 'M', 'Girl', 4, 4),
	(14, 'N', 'Girl', 1, 5),
	(15, 'O', 'Girl', 2, 5),
	(16, 'P', 'Girl', 3, 5);

-- Question 2
SELECT type, COUNT(*) FROM Hostel GROUP BY type;

-- Question 3
SELECT * FROM Menu NATURAL JOIN Hostel WHERE hname='X';

-- Question 4
SELECT hno, COUNT(*) FROM Warden GROUP BY hno;

-- Question 5
SELECT COUNT(*) FROM Student NATURAL JOIN Hostel WHERE hname='X';

-- Question 6
UPDATE Menu SET breakfast='Noodles' WHERE hno=5 AND day='Tue';

-- Question 7
SELECT * FROM Warden WHERE qual='B.Com';

-- Question 8
SELECT hno, COUNT(*) FROM Student WHERE hno IN (SELECT hno FROM Hostel WHERE hname LIKE 'A%') GROUP BY hno;

-- Question 9
SELECT year, COUNT(*) FROM Student NATURAL JOIN Hostel WHERE gender='Boy' GROUP BY year;

-- Question 10
SELECT wname, hname FROM Warden NATURAL JOIN Hostel WHERE type='Girls';

-- Question 11
SELECT sname, wname, hname FROM Student NATURAL JOIN Warden NATURAL JOIN Hostel WHERE year=3;

-- Question 12
SELECT wname, COUNT(*) FROM Warden NATURAL JOIN Student NATURAL JOIN Hostel GROUP BY wname;

-- Question 13
CREATE VIEW StudentView AS SELECT sname, gender, hno, wname FROM Student NATURAL JOIN Warden;

