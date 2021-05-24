DROP DATABASE IF EXISTS Transport;
CREATE DATABASE Transport;
USE Transport;

CREATE TABLE Bus (
	Bus_No INT NOT NULL, 
	Source VARCHAR(30), 
	Destination  VARCHAR(30), 
	CouchType  VARCHAR(30), 
	PRIMARY KEY (Bus_No)
);

CREATE TABLE Reservation (
	PNR_No INT NOT NULL, 
	Journey_Date TIMESTAMP, 
	No_Seats INT , 
	Contact_No INT(20), 
	Bus_No INT, 
	PRIMARY KEY (PNR_NO),
	FOREIGN KEY (Bus_No) REFERENCES Bus(Bus_No)
);

CREATE TABLE Ticket (
	Ticket_No INT NOT NULL, 
	Journey_Date TIMESTAMP, 
	Dep_Time TIMESTAMP DEFAULT now(), 
	Arr_Time TIMESTAMP  DEFAULT now(), 
	Bus_No INT, 
	PRIMARY KEY (Ticket_No), 
	FOREIGN KEY (Bus_No) REFERENCES Bus(Bus_No)
);

CREATE TABLE Passenger (
	PNR_No INT, 
	Ticket_No INT, 
	Name VARCHAR(30), 
	Age INT, 
	Sex VARCHAR(10), 
	Contact_No INT(20), 
	FOREIGN KEY (Ticket_No) REFERENCES Ticket(Ticket_No),
	FOREIGN KEY (PNR_No) REFERENCES Reservation(PNR_No)
);

CREATE TABLE PassengerLog (
	Time TIMESTAMP, 
	Ticket_No INT, 
	Action VARCHAR(30)
);

CREATE TABLE PassengerBus (
	PNR_No INT, 
	Ticket_No INT, 
	Name VARCHAR(30), 
	Age INT, 
	Sex VARCHAR(10), 
	Contact_No INT
);

INSERT INTO Bus VALUES 
	(1,'Chennai','Bangalore', 'Gold'),
	(2,'Chennai','Coimbatore', 'Platinum'),
	(3,'Bangalore','Hyderabad', 'Bronze'),
	(4,'Hyderabad','Bangalore', 'Gold'),
	(5,'Chennai','Trichy', 'Silver');


INSERT  INTO Reservation VALUES 
	(1, "2020-12-12", 2, 123456789, 3),
	(2, "2020-12-6", 4, 123456788, 4),
	(3, "2020-12-13", 12, 123456787, 5),
	(4, "2020-11-30", 32, 123456786, 1),
	(5, "2020-12-13", 2, 123456785, 2),
	(6, "2020-12-13", 12, 123456784, 2);

INSERT INTO Ticket VALUES 
	(1, "2020-11-30", "2020-11-30T20:00:00", "2020-11-30T23:20:00", 1),
	(2, "2020-12-13", "2020-12-13T01:00:00", "2020-12-13T05:20:00", 2),
	(3, "2020-12-12", "2020-12-12T09:00:00", "2020-12-12T05:20:00", 3),
	(4, "2020-12-6", "2020-12-6T12:00:00", "2020-12-6T19:20:00", 4),
	(5, "2020-12-13", "2020-12-13T10:00:00", "2020-12-13T19:25:00", 5);

INSERT INTO Passenger VALUES 
	(1, 1, 'Anu', 28, 'F', 123456789),
	(2, 2, 'John', 27, 'M', 123456789),
	(3, 3, 'Ram', 21, 'F', 123456789),
	(4, 5, 'Shyam', 35, 'M', 123456789);

-- Question 1
SELECT Bus.*, (Arr_Time - Dep_Time) as Travel_Time FROM Bus NATURAL JOIN Ticket ORDER BY Travel_Time DESC LIMIT 1;

-- Question 2
CREATE VIEW passenger_names AS 
	SELECT * FROM Passenger ORDER BY name DESC;

SELECT * FROM passenger_names;

-- Question 3
SELECT Passenger.Name, COUNT(*) AS c FROM Passenger NATURAL JOIN Ticket GROUP BY Passenger.Name ORDER BY c LIMIT 1;

-- Question 4
DELIMITER //
CREATE FUNCTION count_tickets (contact INT) RETURNS INT DETERMINISTIC
BEGIN
	DECLARE count_seats INT;
	SELECT SUM(No_Seats) INTO count_seats FROM Reservation WHERE Contact_No=contact;
	RETURN count_seats;
END //
DELIMITER ;

SELECT count_tickets('123456789');

-- Question 5
DELIMITER //
CREATE PROCEDURE insert_log_passenger(IN roll_no INT, IN action_name VARCHAR(10))
BEGIN
    INSERT INTO PassengerLog VALUES (CURRENT_TIMESTAMP, roll_no, action_name);
END //

CREATE TRIGGER log_insert
AFTER INSERT ON Passenger FOR EACH ROW
BEGIN
	CALL insert_log_passenger(NEW.Ticket_No, 'insert');
END //

CREATE TRIGGER log_update
AFTER UPDATE ON Passenger FOR EACH ROW
BEGIN
	CALL insert_log_passenger(NEW.Ticket_No, 'update');
END //

CREATE TRIGGER log_delete
AFTER DELETE ON Passenger FOR EACH ROW
BEGIN
	CALL insert_log_passenger(OLD.Ticket_No, 'DELETE');
END //
DELIMITER ;

INSERT INTO Passenger VALUES (5, 4, 'Pavithra', 24, 'F', 123456543);
DELETE FROM Passenger WHERE PNR_No = 5 AND Ticket_No = 4;

SELECT * FROM PassengerLog;

-- Question 6
DELIMITER //
CREATE PROCEDURE passenger_list (IN journey DATE)
BEGIN
	SELECT Passenger.Name from Passenger 	
	INNER JOIN Ticket ON Passenger.Ticket_No = Ticket.Ticket_No
	WHERE Ticket.Journey_Date=journey;
END //
DELIMITER ;

CALL passenger_list("2020-11-30T20:00:00");

-- Question 7
DELIMITER //
CREATE TRIGGER check_pnr_no
BEFORE UPDATE ON Passenger FOR EACH ROW
BEGIN	
	IF NEW.PNR_No != OLD.PNR_No THEN
     		SIGNAL SQLSTATE '45000' SET message_text = 'Cannot Change PNR No';
	END IF;
END //
DELIMITER ;

-- UPDATE Passenger SET PNR_No = 6 WHERE PNR_No = 4;

-- Question 8
DELIMITER //
CREATE FUNCTION passenger_details (bus INT) RETURNS INT DETERMINISTIC
BEGIN
	INSERT INTO PassengerBus 
	SELECT Passenger.* FROM Passenger INNER JOIN Ticket ON Passenger.Ticket_No = Ticket.Ticket_No WHERE Ticket.Bus_No = bus;
	RETURN 0;
END //
DELIMITER ;

SELECT passenger_details(2);
SELECT * FROM PassengerBus;

-- Question 9
DELIMITER //
CREATE PROCEDURE get_ticket_count (IN bus INT)
BEGIN
	SELECT COUNT(*) FROM Ticket WHERE Bus_No = bus;
END //
DELIMITER ;

CALL get_ticket_count(5);

-- Question 10
SELECT Passenger.Name, Reservation.Journey_Date, Reservation.No_Seats FROM Passenger	
INNER JOIN Reservation ON Reservation.PNR_No = Passenger.PNR_No;

