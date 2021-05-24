DROP DATABASE IF EXISTS Hospitals;
CREATE DATABASE Hospitals;
USE Hospitals;

CREATE TABLE Hospital(
	HID INT NOT NULL,
	HospName VARCHAR(20) NOT NULL,
	Location VARCHAR(200),
	State VARCHAR(20) NOT NULL,
	PRIMARY KEY (HID)
);

CREATE TABLE Patient(
	PID INT NOT NULL,
	PatName VARCHAR(20) NOT NULL,
	Sex ENUM('M', 'F') NOT NULL,
	Age INT NOT NULL,
	Address VARCHAR(200),
	HID INT NOT NULL,
	PRIMARY KEY (PID),
	FOREIGN KEY (HID) REFERENCES Hospital(HID)
);

CREATE TABLE TestResults(
	TID INT NOT NULL,
	PID INT NOT NULL,
	HID INT NOT NULL,
	ReportDate DATE,
	Result ENUM('POS', 'NEG') NOT NULL,
	DischargeDate DATE,
	PRIMARY KEY (TID),
	FOREIGN KEY (PID) REFERENCES Patient(PID),
	FOREIGN KEY (HID) REFERENCES Hospital(HID)
);

INSERT INTO Hospital VALUES
	(1, 'A', 'Chennai', 'Tamil Nadu'),
	(2, 'B', 'Bangalore', 'Karnataka'),
	(3, 'C', 'Kolkata', 'West Bengal'),
	(4, 'D', 'Trichy', 'Tamil Nadu');

INSERT INTO Patient VALUES
	(1, 'V', 'M', 21, 'L', 1),
	(2, 'W', 'F', 10, 'M', 1),
	(3, 'X', 'F', 30, 'N', 2),
	(4, 'Y', 'M', 64, 'O', 3),
	(5, 'Z', 'F', 16, 'P', 3),
	(6, 'U', 'M', 61, 'M', 4),
	(7, 'T', 'F', 63, 'O', 1);

INSERT INTO TestResults VALUES
	(1, 1, 1, '2020-01-10', 'POS', '2020-03-16'),
	(2, 2, 1, '2020-02-10', 'POS', '2020-03-10'),
	(3, 3, 2, '2020-02-24', 'POS', '2020-05-21'),
	(4, 4, 3, '2020-04-10', 'POS', '2020-05-12'),
	(5, 5, 3, '2020-04-19', 'NEG', '2020-04-22'),
	(6, 6, 4, '2020-04-19', 'POS', '2020-05-22'),
	(7, 7, 1, '2020-04-09', 'POS', '2020-04-28');

DELIMITER //

-- Question 1
CREATE PROCEDURE GetPatientDetails (IN patientId INT)
BEGIN
	SELECT * FROM Patient WHERE PID=patientId;
END//

-- Question 2
CREATE PROCEDURE AddPatient (IN patiendId INT, IN patientName VARCHAR(20), IN sex CHAR, IN age INT, IN address VARCHAR(200), IN hospitalId INT) 
BEGIN 
	INSERT INTO Patient VALUES (patientId, patientName, sex, age, address, hospitalId);
END // 

-- Question 3
CREATE PROCEDURE FindHighest (IN stateName VARCHAR(20))
BEGIN
	SELECT Location, COUNT(*) FROM Hospital 
	NATURAL JOIN TestResults 
	WHERE State = stateName AND Result = 'POS' 
	GROUP BY Location 
	ORDER BY COUNT(*) DESC LIMIT 1;
END //

-- Question 4
CREATE PROCEDURE FastestRecovery ()
BEGIN
	SELECT HID, HospName FROM TestResults
	NATURAL JOIN Hospital
	WHERE Result = 'POS' AND DATEDIFF(DischargeDate, ReportDate) = 
		(SELECT MIN(DATEDIFF(DischargeDate, ReportDate)) FROM TestResults WHERE Result = 'POS');
END //

-- Question 5
CREATE PROCEDURE DeleteIfNegative ()
BEGIN
	DELETE Patient, TestResults FROM Patient NATURAL JOIN TestResults WHERE Result = 'NEG';
END //

-- Question 6
CREATE PROCEDURE ShowPatients ()
BEGIN
	SELECT * FROM Patient;
END //

-- Question 7
CREATE FUNCTION MaxState ()
RETURNS VARCHAR(20) DETERMINISTIC
BEGIN
	DECLARE MaxStateName VARCHAR(20);
	DECLARE MaxCount INT;
	
	SELECT State, COUNT(*) INTO MaxStateName, MaxCount FROM Hospital 
	NATURAL JOIN TestResults 
	WHERE Result = 'POS' 
	GROUP BY State 
	ORDER BY COUNT(*) DESC LIMIT 1;
	
	RETURN MaxStateName;
END //

-- Question 8
CREATE FUNCTION HotSpot (stateName VARCHAR(20))
RETURNS VARCHAR(20) DETERMINISTIC
BEGIN
	DECLARE MaxLocation VARCHAR(20);
	DECLARE MaxCount INT;
	
	SELECT Location, COUNT(*) INTO MaxLocation, MaxCount FROM Hospital 
	NATURAL JOIN TestResults 
	WHERE State = stateName AND Result = 'POS' 
	GROUP BY Location 
	ORDER BY COUNT(*) DESC LIMIT 1;
	
	RETURN MaxLocation;
End //
	
-- Question 9
CREATE PROCEDURE ShowByGender (stateName VARCHAR(20))
BEGIN
	SELECT Sex, Result, COUNT(*) FROM Hospital 
	NATURAL JOIN TestResults NATURAL JOIN Patient
	WHERE State = stateName 
	GROUP BY Sex, Result;
END //

-- Question 10
CREATE PROCEDURE AverageRecovery (hospitalId INT)
BEGIN
	SELECT AVG(DATEDIFF(DischargeDate, ReportDate)) as ChildAvg FROM TestResults 
	NATURAL JOIN Patient 
	WHERE HID = hospitalId AND Result = 'POS' AND Age < 18;
	
	SELECT AVG(DATEDIFF(DischargeDate, ReportDate)) as AdultAvg FROM TestResults 
	NATURAL JOIN Patient 
	WHERE HID = hospitalId AND Result = 'POS' AND Age BETWEEN 18 AND 60;
	
	SELECT AVG(DATEDIFF(DischargeDate, ReportDate)) as SeniorAvg FROM TestResults 
	NATURAL JOIN Patient 
	WHERE HID = hospitalId AND Result = 'POS' AND Age > 60;
END //

DELIMITER ;

CALL GetPatientDetails(2);
CALL FindHighest('Tamil Nadu');
CALL FastestRecovery();
CALL DeleteIfNegative();
CALL ShowPatients();

SELECT MaxState();
SELECT Hotspot('Karnataka');

CALL ShowByGender('Tamil Nadu');
CALL AverageRecovery(1);
