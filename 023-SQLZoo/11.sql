DROP TABLE IF EXISTS registration;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS module;


/* Create students table */
CREATE TABLE student (
  matric_no char(8) NOT NULL,
  first_name varchar(50) NOT NULL,
  last_name varchar(50) NOT NULL,
  date_of_birth date DEFAULT NULL,
  PRIMARY KEY (matric_no));

/* Create module table */
CREATE TABLE module (
  module_code char(8) NOT NULL,
  module_title varchar(50) NOT NULL,
  level int NOT NULL,
  credits int NOT NULL DEFAULT '20',
  PRIMARY KEY (module_code));

/* Create registration table */
CREATE TABLE registration (
	matric_no CHAR(8), 
	module_code CHAR(8), 
	result DECIMAL(4,1),
	PRIMARY KEY (matric_no,module_code), 
	FOREIGN KEY (matric_no) REFERENCES student(matric_no), 
	FOREIGN KEY (module_code) REFERENCES module(module_code)
);

/* Fill table students with test data */
INSERT INTO student VALUES 
('40001010', 'Daniel', 'Radcliffe', '1989-07-23'), 
('40001011', 'Emma', 'Watson', '1990-04-15'), 
('40001012', 'Rupert', 'Grint', '1988-10-24');

/* FIll table module with test data */
INSERT INTO module(module_code,module_title, level) 
VALUES ('HUF07101','Herbology',7),
('SLY07102','Defense Against the Dark Arts',8), 
('HUF08102','History of Magic',8);

/* Fill registration table with test data */
INSERT INTO registration 
	VALUES 	('40001010','SLY07102',90),
		('40001010','HUF07101',40),
		('40001010','HUF08102',null),
		('40001011','SLY07102',99),
		('40001011','HUF08102',null),
		('40001012','SLY07102',20),
		('40001012','HUF07101',20);

/* Test query */
SELECT last_name, 
	first_name, 
	result, 
	CASE    WHEN result <40 THEN 'F' 
		WHEN result<70 THEN 'P' 
		WHEN result > 70 THEN 'M' 
		ELSE NULL END as Mark 
FROM student 
JOIN registration USING(matric_no) 
JOIN module USING(module_code)
WHERE module_code='SLY07102';

