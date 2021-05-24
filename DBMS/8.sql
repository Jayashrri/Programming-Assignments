DROP DATABASE IF EXISTS School;
CREATE DATABASE School;
USE School;

CREATE TABLE Students(
	rollNumber INT NOT NULL,
	lastName VARCHAR(255),
	firstName VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL,
	classYear INT NOT NULL,
	major VARCHAR(255) NOT NULL,
	phoneNumber VARCHAR(255) NOT NULL,
	PRIMARY KEY (rollNumber)
);

CREATE TABLE StudentLog(
	time DATETIME NOT NULL,
	rollNumber INT NOT NULL,
	action VARCHAR(255)
);

CREATE TABLE Message(
	time DATETIME NOT NULL,
	rollNumber INT NOT NULL,
	message VARCHAR(255)
);

CREATE TABLE StudentNameMerged(
	rollNumber INT NOT NULL,
	name VARCHAR(255),
	PRIMARY KEY (rollNumber)
);

CREATE VIEW StudentNames AS
SELECT lastName, firstName FROM Students;
	

DELIMITER //

-- Question 1
SET @totalInserted = 0;

CREATE TRIGGER insertCount
AFTER INSERT ON Students FOR EACH ROW
	SET @totalInserted = @totalInserted + 1;

-- Question 2
CREATE TRIGGER insertMessage
AFTER INSERT ON Students FOR EACH ROW
	INSERT INTO Message VALUES (CURRENT_TIMESTAMP, NEW.rollNumber, 'Inserted');

-- Question 3
CREATE TRIGGER addCountryCode
BEFORE INSERT ON Students FOR EACH ROW
BEGIN
	IF NEW.phoneNumber NOT LIKE "+91%" THEN
		SET NEW.phoneNumber = CONCAT("+91", NEW.phoneNumber);
	END IF;
END //

CREATE TRIGGER updateCountryCode
BEFORE UPDATE ON Students FOR EACH ROW
BEGIN
	IF NEW.phoneNumber NOT LIKE "+91%" THEN
		SET NEW.phoneNumber = CONCAT("+91", NEW.phoneNumber);
	END IF;
END //

-- Question 4
CREATE PROCEDURE splitName()
BEGIN
	ALTER TABLE StudentNameMerged ADD (lastName VARCHAR(255));
	UPDATE StudentNameMerged SET lastName = SUBSTRING_INDEX(name, ' ', -1), name = SUBSTRING_INDEX(name, ' ', 1);
	ALTER TABLE StudentNameMerged RENAME COLUMN name TO firstName;
END //

-- Question 5
CREATE TRIGGER logInsert
AFTER INSERT ON Students FOR EACH ROW
	INSERT INTO StudentLog VALUES (CURRENT_TIMESTAMP,  NEW.rollNumber, "INSERT");

CREATE TRIGGER logUpdate
AFTER UPDATE ON Students FOR EACH ROW
	INSERT INTO StudentLog VALUES (CURRENT_TIMESTAMP,  NEW.rollNumber, "UPDATE");

CREATE TRIGGER logDelete
AFTER DELETE ON Students FOR EACH ROW
	INSERT INTO StudentLog VALUES (CURRENT_TIMESTAMP,  OLD.rollNumber, "DELETE");

-- Question 6
CREATE TRIGGER checkYear
BEFORE INSERT ON Students FOR EACH ROW
BEGIN
	IF NEW.classYear > 2015 THEN
		SIGNAL SQLSTATE '45000' SET message_text = 'Invalid Class Year';
	END IF;
END //

-- Question 7
CREATE TRIGGER checkName
BEFORE INSERT ON Students FOR EACH ROW
BEGIN
	IF NEW.firstName = 'John' THEN
		SIGNAL SQLSTATE '45000' SET message_text = 'Invalid Name';
	END IF;
END //

-- Question 8
CREATE TRIGGER checkRollNumber
BEFORE UPDATE ON Students FOR EACH ROW
BEGIN	
	IF NEW.rollNumber != OLD.rollNumber THEN
		SIGNAL SQLSTATE '45000' SET message_text = 'Roll Number Cannot Be Changed';
	END IF;
END //

-- Question 9

-- Outputs
DELIMITER ;

SELECT * FROM StudentNames;

INSERT INTO Students VALUES (106118019, "B", "Jayashrri", "106118019@nitt.edu", "2015", "CSE", "9999999999");
SELECT @totalInserted;
SELECT * FROM StudentNames;
SELECT * FROM Message;

UPDATE Students SET phoneNumber = "8888888888" WHERE rollNumber = 106118019;
SELECT * FROM Students;

INSERT INTO StudentNameMerged VALUES (106118019, 'Jayashrri B');
SELECT * FROM StudentNameMerged;
CALL splitName();
SELECT * FROM StudentNameMerged;

DELETE FROM Students WHERE rollNumber = 106118019;
SELECT * FROM StudentLog;

-- INSERT INTO Students VALUES (106118011, "B", "Anu", "106118011@nitt.edu", "2020", "CSE", "9999999999");

-- INSERT INTO Students VALUES (106118091, "S", "John", "106118091@nitt.edu", "2015", "CSE", "9999999999");

-- UPDATE Students SET rollNumber = 106118001 WHERE rollNumber = 106118019;
