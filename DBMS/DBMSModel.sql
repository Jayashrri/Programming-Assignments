DROP DATABASE Institute;
CREATE DATABASE Institute;
USE Institute;

CREATE TABLE Department (
	dept_no INT NOT NULL, 
	dept_name VARCHAR(255), 
	PRIMARY KEY(dept_no)
);

CREATE TABLE Student (
	student_id INT NOT NULL, 
	student_name VARCHAR(255), 
	gender VARCHAR(10), 
	DoB DATE, 
	city VARCHAR(255), 
	dept_no INT NOT NULL, 
	PRIMARY KEY (student_id), 
	FOREIGN KEY (dept_no) REFERENCES Department(dept_no)
);

CREATE TABLE Faculty (
	faculty_id INT NOT NULL, 
	faculty_name VARCHAR(255), 
	designation VARCHAR(255), 
	salary INT, 
	city VARCHAR(255), 
	dept_no INT NOT NULL, 
	PRIMARY KEY (faculty_id), 
	FOREIGN KEY (dept_no) REFERENCES Department(dept_no)
);

CREATE TABLE Course (
	course_id INT NOT NULL, 
	course_name VARCHAR(255), 
	credits INT, 
	dept_no INT NOT NULL, 
	PRIMARY KEY (course_id), 
	FOREIGN KEY (dept_no) REFERENCES Department(dept_no)
);

CREATE TABLE Registers (
	student_id INT NOT NULL, 
	course_id INT NOT NULL, 
	semester INT, 
	FOREIGN KEY (student_id) REFERENCES Student(student_id), 
	FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

CREATE TABLE Teaching (
	faculty_id INT NOT NULL, 
	course_id INT NOT NULL, 
	semester INT NOT NULL, 
	FOREIGN KEY(faculty_id) REFERENCES Faculty(faculty_id), 
	FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

CREATE TABLE Student_Log (
	time DATETIME,
	student_id INT NOT NULL,
	action VARCHAR(255)
);

INSERT INTO Department VALUES
	(1, 'CSE'),
	(2, 'Mathematics'),
	(3, 'EEE');

INSERT INTO Student VALUES 
	(1, 'Anu', 'F', '2000-05-13', 'Chennai', 1),
	(2, 'Jayashrri', 'M', '2000-05-14', 'Coimbatore', 1),
	(3, 'Anirudh', 'F', '2000-06-12', 'Delhi', 2),
	(4, 'Pavithra', 'M', '2000-01-11', 'Chennai', 2);

INSERT INTO Faculty VALUES 
	(1, 'Aananth', 'Professor', 100000, 'Chennai', 1),
	(2, 'Madhav', 'Professor', 100000, 'Trichy', 2),
	(3, 'Bala', 'Professor', 100000, 'Chennai', 3),
	(4, 'Smrithi', 'Professor', 100000, 'Trichy', 3);

INSERT INTO Course VALUES 
	(1, 'Database Management', 3, 1),
	(2, 'Software Engineering', 4, 1),
	(3, 'Pattern Recognition', 3, 2),
	(4, 'Soft Computing', 3, 3);

INSERT INTO Registers VALUES 
	(1, 1, 1),
	(2, 2, 2),
	(2, 3, 3),
	(4, 2, 5),
	(2, 1, 7),
	(3, 4, 8);

INSERT INTO Teaching VALUES 
	(1, 1, 1),
	(1, 2, 7),
	(1, 3, 2),
	(2, 4, 8),
	(4, 2, 3);

-- Question 1
SELECT faculty_name FROM Faculty NATURAL JOIN Department WHERE dept_name = 'Mathematics';

-- Question 2
SELECT faculty_name, city FROM Faculty NATURAL JOIN Teaching WHERE semester = 7;

-- Question 3
CREATE VIEW order_faculty AS
SELECT * FROM Faculty NATURAL JOIN Department ORDER BY dept_name ASC;

SELECT * FROM order_faculty;

-- Question 4
SELECT Faculty.*, COUNT(*) AS C FROM Teaching NATURAL JOIN Faculty NATURAL JOIN Department 
WHERE Department.dept_name='EEE' GROUP BY faculty_id ORDER BY C DESC LIMIT 1;

-- Question 5
DELIMITER //
CREATE PROCEDURE eighth_semester ()
BEGIN
	SELECT * FROM Student NATURAL JOIN Registers WHERE semester = 8;
END //

DELIMITER ;
CALL eighth_semester();

-- Question 6
CREATE TRIGGER log_insert
AFTER INSERT ON Student FOR EACH ROW
	INSERT INTO Student_Log VALUES (CURRENT_TIMESTAMP,  NEW.student_id, "INSERT");

CREATE TRIGGER log_update
AFTER UPDATE ON Student FOR EACH ROW
	INSERT INTO Student_Log VALUES (CURRENT_TIMESTAMP,  NEW.student_id, "UPDATE");

CREATE TRIGGER log_delete
AFTER DELETE ON Student FOR EACH ROW
	INSERT INTO Student_Log VALUES (CURRENT_TIMESTAMP,  OLD.student_id, "DELETE");

INSERT INTO Student VALUES (5, 'Abishek', 'M', '2000-05-13', 'Chennai', 3);
DELETE FROM Student WHERE student_id = 5;
SELECT * FROM Student_Log;

-- Question 7
DELIMITER //
CREATE PROCEDURE get_faculty_city (city_name VARCHAR(255))
BEGIN
		SELECT Course.* FROM (Course NATURAL JOIN Teaching) INNER JOIN Faculty ON Faculty.faculty_id = Teaching.faculty_id WHERE city = city_name;
END //

DELIMITER ;
CALL get_faculty_city ('Chennai');

-- Question 8
DELIMITER //
CREATE TRIGGER check_faculty BEFORE UPDATE ON Faculty FOR EACH ROW
BEGIN	
	IF NEW.faculty_id != OLD.faculty_id THEN
		SIGNAL SQLSTATE '45000' SET message_text = 'Faculty ID Cannot Be Changed';
	END IF;
END //

DELIMITER ;
-- UPDATE Faculty SET faculty_id = 5 WHERE faculty_id = 3;

-- Question 9
DELIMITER //
CREATE TRIGGER insert_cse BEFORE INSERT ON Student FOR EACH ROW 
BEGIN 
	DECLARE dept VARCHAR(20);
	SELECT dept_name INTO dept FROM Department WHERE Department.dept_no = NEW.dept_no;
	IF dept != 'CSE' THEN
		SIGNAL SQLSTATE '45000' SET message_text = 'Cannot Insert Non CSE';
	END IF;
END // 

DELIMITER ;
-- INSERT INTO Student VALUES (5, 'Abishek', 'M', '2000-05-13', 'Chennai', 3);

-- Question 10
DELIMITER //
CREATE FUNCTION many_course_faculties ()
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE faculty_count INT;
	SELECT COUNT(*) INTO faculty_count FROM (SELECT faculty_id, COUNT(*) FROM Faculty NATURAL JOIN Teaching 
		GROUP BY faculty_id HAVING COUNT(*) > 2) AS faculty_count;
	RETURN faculty_count;
END //

DELIMITER ;
SELECT many_course_faculties();

-- Question 11
DELIMITER //
CREATE PROCEDURE raise_salary (id INT, salary_raise INT)
BEGIN
	UPDATE Faculty SET salary = salary_raise WHERE faculty_id = id;
END //

DELIMITER ;
CALL raise_salary (3, 130000);
SELECT * FROM Faculty;

-- Question 12
SELECT student_id, student_name FROM Student INNER JOIN Faculty ON Faculty.dept_no = Student.dept_no WHERE Faculty.city = Student.city;

-- Question 13
SELECT faculty_name, course_name FROM Faculty NATURAL JOIN Course;
