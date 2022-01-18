--CREATING SCHEMA
CREATE SCHEMA unidb;

SET SCHEMA 'unidb';


--DROPPING THE TABLE
/* DELETE EVENTUALLLY ALREADY EXISTING TABLE
*/

DROP TABLE IF EXISTS Transcript;
DROP TABLE IF EXISTS Lecture;
DROP TABLE IF EXISTS UoSOffering;
DROP TABLE IF EXISTS Requires;
DROP TABLE IF EXISTS Classroom;
DROP TABLE IF EXISTS WhenOffered;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Teaching;
DROP TABLE IF EXISTS AcademicStaff;
DROP TABLE IF EXISTS Faculty;
DROP TABLE IF EXISTS Professor;
DROP TABLE IF EXISTS UnitOfStudy;

--CREATING TABLES
CREATE TABLE Student (
  studId        INTEGER,
  name          VARCHAR(20) NOT NULL,             --NOT NULL CONSTRAINT
  password      VARCHAR(10) NOT NULL,
  address       VARCHAR(50),
  PRIMARY KEY (studId)                            --PRIMARY KEY CONSTRAINT
);
CREATE TABLE AcademicStaff (
  id            CHAR(9),
  name          VARCHAR(20) NOT NULL,
  deptId        Char(3)  NOT NULL,
  password      VARCHAR(10) NOT NULL,
  address       VARCHAR(50),
  salary        INTEGER,
  PRIMARY KEY (id)
);
CREATE TABLE UnitOfStudy (
  uoSCode       CHAR(8),
  deptId        CHAR(3)  NOT NULL,
  uoSName       VARCHAR(40) NOT NULL,
  credits       INTEGER  NOT NULL,
  PRIMARY KEY (uoSCode),
  UNIQUE (deptId, uoSName)
);
CREATE TABLE WhenOffered (
  uoSCode       CHAR(8),
  semester      CHAR(2),
  PRIMARY KEY (uoSCode, semester)
);
CREATE TABLE ClassRoom (
  classroomId   VARCHAR(8),
  seats         INTEGER NOT NULL,
  type          VARCHAR(7) ,
  PRIMARY KEY (classroomId)
);
CREATE TABLE Requires (
  uoSCode       CHAR(8),
  prereqUoSCode CHAR(8),
  enforcedSince DATE NOT NULL,
  PRIMARY KEY (uoSCode, prereqUoSCode),
  FOREIGN KEY (uoSCode) REFERENCES UnitOfStudy(uoSCode),                --FOREIGN KEY CONSTARINT
  FOREIGN KEY (prereqUoSCode) REFERENCES UnitOfStudy(uoSCode)
);
CREATE TABLE UoSOffering (
  uoSCode       CHAR(8), 
  semester      CHAR(2),
  year          INTEGER,
  textbook      VARCHAR(50),
  enrollment    INTEGER,
  maxEnrollment INTEGER,
  instructorId  CHAR(9),
  PRIMARY KEY (UoSCode, Semester, Year),
  FOREIGN KEY (UoSCode)          REFERENCES UnitOfStudy(UoSCode),
  FOREIGN KEY (UoSCode,Semester) REFERENCES WhenOffered(UoSCode,Semester),
  FOREIGN KEY (InstructorId)     REFERENCES AcademicStaff(Id)
);
CREATE TABLE Lecture (
  uoSCode       CHAR(8), 
  semester      CHAR(2),
  year          INTEGER,
  classTime     CHAR(5),
  classroomId   VARCHAR(8),
  PRIMARY KEY (UoSCode, Semester, Year, ClassroomId),
  FOREIGN KEY (UoSCode, Semester, Year) REFERENCES UoSOffering,
  FOREIGN KEY (ClassroomId)             REFERENCES Classroom
);
CREATE TABLE Transcript (
  studId        INTEGER,
  uoSCode       CHAR(8),
  Semester      CHAR(2),
  year          INTEGER,
  grade         VARCHAR(2),
  PRIMARY KEY (StudId,UoSCode,Semester,Year),
  FOREIGN KEY (StudId) REFERENCES Student(studId),
  FOREIGN KEY (UoSCode,Semester,Year) REFERENCES UoSOffering
);

--INSERTING THE DATA INTO TABLES
INSERT INTO Student VALUES (307088592, 'John Smith', 'Green', 'Newtown');
INSERT INTO Student VALUES (305422153, 'Sally Waters', 'Purple', 'Coogee');
INSERT INTO Student VALUES (305678453, 'Pauline Winters', 'Turkey', 'Bondi');
INSERT INTO Student VALUES (316424328, 'Matthew Long', 'Space', 'Camperdown');
INSERT INTO Student VALUES (309145324, 'Victoria Tan', 'Grapes', 'Maroubra');
INSERT INTO Student VALUES (309187546, 'Niang Jin Phan', 'Robot', 'Kingsford');


INSERT INTO AcademicStaff VALUES ('6339103', 'Uwe Roehm',    'SIT', 'sailing', 'Cremorne', 90000);
INSERT INTO AcademicStaff VALUES ('1234567', 'Jon Patrick',  'SIT', 'english', 'Glebe',  135000);
INSERT INTO AcademicStaff VALUES ('7891234', 'Sanjay Chawla','SIT', 'cricket', 'Neutral Bay', 140000);
INSERT INTO AcademicStaff VALUES ('1237890', 'Joseph Davis', 'SIT', 'abcd',    NULL, 120000);
INSERT INTO AcademicStaff VALUES ('4657890', 'Alan Fekete',  'SIT', 'opera',   'Cameray', 120000);
INSERT INTO AcademicStaff VALUES ('0987654', 'Simon Poon',   'SIT', 'pony',    'Sydney', 75000);
INSERT INTO AcademicStaff VALUES ('1122334', 'Irena Koprinska','SIT','volleyball', 'Glebe', 90000);


INSERT INTO Classroom VALUES ('BoschLT1',270, 'tiered');
INSERT INTO Classroom VALUES ('BoschLT2',267, 'tiered');
INSERT INTO Classroom VALUES ('BoschLT3',300, 'tiered');
INSERT INTO Classroom VALUES ('BoschLT4',300, 'tiered');
INSERT INTO Classroom VALUES ('CheLT1',  300, 'tiered');
INSERT INTO Classroom VALUES ('CheLT2',  145, 'tiered');
INSERT INTO Classroom VALUES ('CheLT3',  300, 'tiered');
INSERT INTO Classroom VALUES ('CheLT4',  145, 'tiered');
INSERT INTO Classroom VALUES ('CAR157',  290, 'tiered');
INSERT INTO Classroom VALUES ('CAR159',  290, 'tiered');
INSERT INTO Classroom VALUES ('CAR173',  127, 'tiered');
INSERT INTO Classroom VALUES ('CAR175',  160, 'tiered');
INSERT INTO Classroom VALUES ('CAR273',  160, 'tiered');
INSERT INTO Classroom VALUES ('CAR275',  160, 'tiered');
INSERT INTO Classroom VALUES ('CAR373',  160, 'tiered');
INSERT INTO Classroom VALUES ('CAR375',  160, 'tiered');
INSERT INTO Classroom VALUES ('EAA',     500, 'sloping');
INSERT INTO Classroom VALUES ('EALT',    200, 'sloping');
INSERT INTO Classroom VALUES ('EA403',    40, 'flat');
INSERT INTO Classroom VALUES ('EA404',    40, 'flat');
INSERT INTO Classroom VALUES ('EA405',    40, 'flat');
INSERT INTO Classroom VALUES ('EA406',    40, 'flat');
INSERT INTO Classroom VALUES ('FarrelLT',190, 'tiered');
INSERT INTO Classroom VALUES ('MechLT',  100, 'tiered');
INSERT INTO Classroom VALUES ('QuadLT',  261, 'tiered');
INSERT INTO Classroom VALUES ('SITLT',    50, 'sloping');


INSERT INTO UnitOfStudy  VALUES ('INFO1003', 'SIT', 'Introduction to IT', 6);
INSERT INTO UnitOfStudy  VALUES ('INFO2120', 'SIT', 'Database Systems I', 6);
INSERT INTO UnitOfStudy  VALUES ('INFO3404', 'SIT', 'Database Systems II', 6);
INSERT INTO UnitOfStudy  VALUES ('COMP5046', 'SIT', 'Statistical Natural Language Processing', 6);
INSERT INTO UnitOfStudy  VALUES ('COMP5138', 'SIT', 'Database Management Systems', 6);
INSERT INTO UnitOfStudy  VALUES ('COMP5338', 'SIT', 'Advanced Data Models', 6);
INSERT INTO UnitOfStudy  VALUES ('INFO2005', 'SIT', 'Database Management Introductory', 3);
INSERT INTO UnitOfStudy  VALUES ('INFO3005', 'SIT', 'Organisational Database Systems', 3);
INSERT INTO UnitOfStudy  VALUES ('MATH1002', 'MAT', 'Linear Algebra', 3);

INSERT INTO Requires VALUES('INFO2120', 'INFO1003', '01-Jan-2002');
INSERT INTO Requires VALUES('INFO3404', 'INFO2120', '01-Nov-2004');
INSERT INTO Requires VALUES('COMP5046', 'COMP5138', '01-Nov-2006');
INSERT INTO Requires VALUES('COMP5338', 'COMP5138', '01-Jan-2004');
INSERT INTO Requires VALUES('COMP5338', 'INFO2120', '01-Jan-2004');
INSERT INTO Requires VALUES('INFO2005', 'INFO1003', '01-Jan-2002');
INSERT INTO Requires VALUES('INFO3005', 'INFO2005', '01-Jan-2002');

INSERT INTO WhenOffered VALUES ('INFO1003', 'S1');
INSERT INTO WhenOffered VALUES ('INFO1003', 'S2');
INSERT INTO WhenOffered VALUES ('INFO2120', 'S1');
INSERT INTO WhenOffered VALUES ('INFO3404', 'S2');
INSERT INTO WhenOffered VALUES ('INFO2005', 'S2');
INSERT INTO WhenOffered VALUES ('INFO3005', 'S1');
INSERT INTO WhenOffered VALUES ('COMP5046', 'S1');
INSERT INTO WhenOffered VALUES ('COMP5138', 'S1');
INSERT INTO WhenOffered VALUES ('COMP5138', 'S2');
INSERT INTO WhenOffered VALUES ('COMP5138', 'SS');
INSERT INTO WhenOffered VALUES ('COMP5338', 'S1');
INSERT INTO WhenOffered VALUES ('COMP5338', 'S2');
INSERT INTO WhenOffered VALUES ('MATH1002', 'S1');
INSERT INTO WhenOffered VALUES ('MATH1002', 'S2');

INSERT INTO UoSOffering VALUES ('INFO1003', 'S1', 2006, 'Snyder', 150,200, '0987654');
INSERT INTO UoSOffering VALUES ('INFO1003', 'S2', 2006, 'Snyder',  80,200, '0987654');
INSERT INTO UoSOffering VALUES ('INFO2120', 'S1', 2006, 'Kifer/Bernstein/Lewis', 140, 200, '6339103');
INSERT INTO UoSOffering VALUES ('INFO2120', 'S1', 2009, 'Kifer/Bernstein/Lewis', 178, 200, '6339103');
INSERT INTO UoSOffering VALUES ('INFO2120', 'S1', 2010, 'Kifer/Bernstein/Lewis', 181, 200, '6339103');
INSERT INTO UoSOffering VALUES ('INFO3404', 'S2', 2008, 'Ramakrishnan/Gehrke',    80, 150, '6339103');
INSERT INTO UoSOffering VALUES ('COMP5138', 'S2', 2006, 'Ramakrishnan/Gehrke',    60, 100, '1237890');
INSERT INTO UoSOffering VALUES ('COMP5138', 'S1', 2010, 'Ramakrishnan/Gehrke',    56, 100, '1234567');
INSERT INTO UoSOffering VALUES ('COMP5046', 'S1', 2010, NULL,                     15,  40, '1234567');
INSERT INTO UoSOffering VALUES ('COMP5338', 'S1', 2006, 'none',  32, 50,  '6339103');
INSERT INTO UoSOffering VALUES ('COMP5338', 'S2', 2006, 'none',  30, 50,  '7891234');
INSERT INTO UoSOffering VALUES ('INFO2005', 'S2', 2004, 'Hoffer', 370, 400,  '6339103');
INSERT INTO UoSOffering VALUES ('INFO3005', 'S1', 2005, 'Hoffer', 100, 150,  '1122334');

INSERT INTO Lecture     VALUES ('INFO1003', 'S1', 2006, 'Mon12', 'CheLT4' );
INSERT INTO Lecture     VALUES ('INFO1003', 'S2', 2006, 'Mon12', 'CheLT4' );
INSERT INTO Lecture     VALUES ('INFO2120', 'S1', 2006, 'Mon11', 'CAR175' );
INSERT INTO Lecture     VALUES ('INFO2120', 'S1', 2009, 'Mon09', 'EALT'   );
INSERT INTO Lecture     VALUES ('INFO2120', 'S1', 2009, 'Tue13', 'CAR159' );
INSERT INTO Lecture     VALUES ('INFO2120', 'S1', 2010, 'Mon09', 'QuadLT' );
INSERT INTO Lecture     VALUES ('INFO2120', 'S1', 2010, 'Tue13', 'BoschLT2' );
INSERT INTO Lecture     VALUES ('INFO3404', 'S2', 2008, 'Mon09', 'CheLT4' );
INSERT INTO Lecture     VALUES ('COMP5046', 'S1', 2010, 'Tue14', 'SITLT'  );
INSERT INTO Lecture     VALUES ('COMP5138', 'S2', 2006, 'Mon18', 'SITLT'  );
INSERT INTO Lecture     VALUES ('COMP5138', 'S1', 2010, 'Thu18', 'FarrelLT');
INSERT INTO Lecture     VALUES ('COMP5338', 'S1', 2006, 'Tue18', 'EA404'  );
INSERT INTO Lecture     VALUES ('INFO2005', 'S2', 2004, 'Mon09', 'CAR159' );
INSERT INTO Lecture     VALUES ('INFO3005', 'S1', 2005, 'Wed09', 'EALT'   );


INSERT INTO Transcript VALUES (316424328,'INFO2120', 'S1', 2010,'D');
INSERT INTO Transcript VALUES (305678453,'INFO2120', 'S1', 2010,'HD');
INSERT INTO Transcript VALUES (316424328,'INFO3005', 'S1', 2005,'CR');
INSERT INTO Transcript VALUES (305422153,'INFO3404', 'S2', 2008,'P');
INSERT INTO Transcript VALUES (316424328,'COMP5338', 'S1', 2006,'D');
INSERT INTO Transcript VALUES (309145324,'INFO2120', 'S1', 2010,'F');
INSERT INTO Transcript VALUES (309187546,'INFO2005', 'S2', 2004,'D');

COMMIT;


------------------------------

SELECT * FROM Transcript;
SELECT * FROM classroom;
SELECT * FROM student;
SELECT * FROM academicstaff;
SELECT * FROM lecture;
SELECT * FROM requires;
SELECT * FROM unitofstudy;
SELECT * FROM uosoffering;
SELECT * FROM whenoffered;

--DISTINCT(IT WILL FILTER UNIQUE VALUE FOR GIVEN COLUMN)

SELECT DISTINCT(semester) FROM transcript;

--WHERE,AND,OR,NOT

SELECT * FROM transcript
WHERE semester = 'S1';

SELECT * FROM student
WHERE password = 'Green';

SELECT * FROM classroom
WHERE seats = 300 AND classroomid = 'BoschLT3';

SELECT * FROM uosoffering
WHERE year=2006 AND enrollment=80;   --AND OPERATOR

SELECT * FROM uosoffering
WHERE year=2006 OR enrollment=80;    --OR OPERATOR

SELECT * FROM lecture
WHERE NOT year = 2006;   --(= OPERATOR)

--ORDER BY (The ORDER BY keyword is used to sort the result-set in ascending or descending order.)

SELECT * 
FROM lecture
ORDER BY year;

SELECT * 
FROM lecture
ORDER BY year DESC;

SELECT *
FROM uosoffering
ORDER BY year DESC,textbook ASC;

--NULL VALUES(FIELD WITH NO VALUE)

SELECT *
FROM academicstaff
WHERE address IS NULL;

SELECT *
FROM academicstaff
WHERE address IS NOT NULL;


--UPDATE(The UPDATE statement is used to modify the existing records in a table.)

UPDATE student
SET password='Yellow'
WHERE address = 'Coogee';


--DELETE(The DELETE statement is used to delete existing records in a table.)

DELETE FROM lecture
WHERE semester='S1';

DELETE FROM lecture;
SELECT * FROM lecture;

--LIMIT,OFFSET,FETCH

--IT WILL SHOW ONLY FIRST 3 ROW OF STIDENT TABLE
SELECT * 
FROM student
LIMIT 3;

--IT WILL SHOW 3 ROW(LIMIT 3) FROM THE 4TH ROW(OFFSET 3) 
SELECT * 
FROM student
LIMIT 3 OFFSET 3;

SELECT *
FROM lecture
WHERE year=2006
FETCH FIRST 2 ROWS ONLY;


--MIN() , MAX()

SELECT MAX(year)
FROM lecture;

SELECT MIN(enrollment)
FROM uosoffering;

--COUNT(),AVG(),SUM()
SELECT COUNT(*)
FROM lecture;

SELECT ROUND(AVG(maxenrollment),2) 
FROM uosoffering;

SELECT SUM(enrollment)
FROM uosoffering;


--LIKE(The LIKE operator is used in a WHERE clause to search for a specified pattern in a column.)
--WILDCARDS

--MATCH FIRST CHARACTER  ---(LIKE OPERATOR)
SELECT * 
FROM student
WHERE name LIKE 'P%';

--MATCH LAST CHARACTER
SELECT * 
FROM student
WHERE name LIKE '%n';

--MATCH PATTERN AT ANY POSITION
SELECT * 
FROM student
WHERE name LIKE '%an%';

--ILIKE(PREVENT FRO CASE SENSETIVE CASE)
SELECT * 
FROM student
WHERE name ILIKE 'p%';

--CHECKING 2ND POSITION
SELECT * 
FROM student
WHERE name LIKE '_a%';

--START WITH S AND ENDS WITH s
SELECT * 
FROM student
WHERE name LIKE 'S%s';


--IN()--(The IN operator allows you to specify multiple values in a WHERE clause.)
SELECT * 
FROM classroom
WHERE seats IN (200,300);   ---(IN OPERATOR)

SELECT * 
FROM classroom
WHERE seats NOT IN (200,300);

SELECT * 
FROM whenoffered
WHERE uoscode IN (SELECT uoscode FROM unitofstudy);


--BETWEEN() --(The BETWEEN operator selects values within a given range. The values can be numbers, text, or dates.)

SELECT * 
FROM classroom
WHERE seats BETWEEN 200 AND 300; --(BETWEEN OPERATOR)


SELECT * 
FROM classroom
WHERE seats NOT BETWEEN 200 AND 300;

SELECT * 
FROM UOSOFFERING
WHERE enrollmEnt BETWEEN 100 AND 200
AND year IN(2006,2008);


SELECT * 
FROM uosoffering
WHERE enrollment BETWEEN 150 AND 200
ORDER BY textbook;


--ALIAS

SELECT MAX(seats) AS max_seats
FROM classroom;

SELECT classtime, MIN(year) AS min_year
FROM lecture
GROUP BY classtime;

SELECT * FROM lecture;

SELECT semester AS sem , year AS joining_year
FROM lecture;


--JOINS()

--INNER JOIN() --- TRY TO FETCH THOSE RECORDS WHICH ARE PRESENT IN BOTH THE TABLES,

--FETCH THE SEMESTER, NAME AND STUDENT_ID THEY BELONG TO.

SELECT s.studid, s.name, t.semester
FROM student s
JOIN transcript t 
ON s.studid = t.studid;

--FETCH UOSNAME AND PREREQUOSCODE THEY BELONG TO.

SELECT u.uosname, r.prerequoscode
FROM unitofstudy u
JOIN requires r 
ON u.uoscode = r.uoscode;

--LEFT JOIN() :: INNER JOIN + ANY ADDITIONAL RECORDS IN THE LEFT TABLE

--FETCH ALL UOSNAME AND THEIR PREREQUOSCODE

SELECT u.uosname, r.prerequoscode
FROM unitofstudy u
LEFT JOIN requires r 
ON u.uoscode = r.uoscode;

--RIGHT JOIN() :: INNER JOIN + ANY ADDITIONAL RECORDS IN THE RIGHT TABLE

SELECT u.textbook,l.classtime
FROM uosoffering u
RIGHT JOIN lecture l
ON u.uoscode = l.uoscode AND u.semester = l.semester;


--FETCH ALL THE STUDENT NAME,THEIR SEMESTER AND UOSNAME

SELECT s.name,t.semester,u.uosname
FROM student s
LEFT JOIN transcript t
ON s.studid = t.studid
JOIN unitofstudy u
ON t.uoscode = u.uoscode;

--FULL JOIN() -- INNER JOIN + ANY ADDITIONAL RECORDS IN THE LEFT TABLE
--							+ ANY ADDITIONAL RECORDS IN THE RIGHT TABLE

SELECT s.name, t.semester
FROM student s
FULL JOIN transcript t 
ON s.studid = t.studid;

--CROSS JOIN() -- RETURNS CARTESIAN PRODUCT

SELECT s.name,t.semester
FROM student s
CROSS JOIN transcript t;

CREATE TABLE course(
	c_id VARCHAR(10) PRIMARY KEY,
	c_name VARCHAR(25)
);

INSERT INTO course
	VALUES
	('AFG154','Data_Engineering');
	
SELECT * FROM course;

--FETCH THE SEMESTER AND NAME THEY BELONG TO.
--ALSO RETURN THEIR COURSEID AND COURSE NAME

SELECT s.name,t.semester,c.c_id,c.c_name
FROM student s
INNER JOIN transcript t
ON s.studid = t.studid
CROSS JOIN course c;

--SELF JOIN() --

SELECT u1.uoscode AS uc,
	   u2.instructorid AS ic
FROM uosoffering AS u1,uosoffering AS u2
WHERE u1.year <> u2.year
AND u1.semester = u2.semester;


---UNION()

SELECT uoscode 
	FROM uosoffering
UNION
SELECT uoscode 
	FROM transcript;

SELECT name,address
	FROM student
UNION ALL
SELECT name,address 
	FROM academicstaff;
	

SELECT uoscode,semester
	FROM lecture
	WHERE semester='S1'
UNION
SELECT uoscode,semester
	FROM uosoffering
	WHERE semester = 'S1'
	ORDER BY uoscode;


--GROUP BY()

SELECT semester,classtime
	FROM lecture
	GROUP BY semester,classtime
	ORDER BY classtime;
	
SELECT MAX(enrollment) AS max,year
	FROM uosoffering
	GROUP BY year
	ORDER BY max;

SELECT s.name, t.semester
	FROM student s
	JOIN transcript t 
	ON s.studid = t.studid
	WHERE semester = 'S1'
	GROUP BY semester,name;

	

--HAVING

SELECT MAX(enrollment),year
	FROM uosoffering
	GROUP BY year
	HAVING MAX(enrollment) > 100;
	

--EXISTS()---The EXISTS operator is used to test for the existence of any record in a subquery.
	
SELECT year
	FROM lecture l
	WHERE EXISTS                                   --(EXISTS OPERATOR)
		(SELECT u.textbook
			FROM uosoffering u
		 	WHERE u.semester <> l.semester
		);

--ANY

SELECT name
	FROM student
	WHERE studid = ANY                     --(ANY OPERATOR)
		(SELECT studid 
			FROM transcript
		    WHERE year = 2010
		);
		
--ALL

SELECT name
	FROM student
	WHERE studid = ALL                     --(ALL OPERATOR)
		(SELECT studid 
			FROM transcript
		    WHERE year = 2010
		);
-- IT IS RETURNING FALSE OR WE CAN SAY NULL BECAUSE OF IN THE TRANSCRIPT TABLE NOT ALL THE RECORD HAVE YEAR 2010


--SELECT INTO() -- The SELECT INTO statement copies data from one table into a new table.

SELECT * 
	INTO lecb
	FROM lecture;
	
SELECT * FROM lecb;

SELECT * 
	INTO lecb IN (ANOTHER DATABASE NAME--WHERE YOU WANT TO CREATE COPY OF THE TABLE)
	FROM lecture;
				  
--IF YOU WANT TO COPY SOME COLUMNS FROM THE TABLE THEN

SELECT uoscode,year 
	INTO leca
	FROM lecture;

SELECT * FROM leca;
				  
--WE CAN ALSO CREATE EMPTY TABLE WITH SELECT INTO
				  
SELECT *
	INTO lecd
	FROM lecture
	WHERE 1 = 0;

SELECT * FROM lecd;
				  
--CASE

--(<,>,= :: OPERATOR)
				  
SELECT u.*,
LAG(enrollment) OVER(PARTITION BY semester ORDER BY year) AS prev_price,
CASE WHEN u.enrollment > LAG(enrollment) OVER(PARTITION BY semester ORDER BY year) then 'Higher than previous'    
	 WHEN u.enrollment < LAG(enrollment) OVER(PARTITION BY semester ORDER BY year) then 'Lower than previous'
	 WHEN u.enrollment = LAG(enrollment) OVER(PARTITION BY semester ORDER BY year) then 'Equal to previous'
	 END en_
FROM uosoffering u;


--NULLIF()

CREATE TABLE posts (
  id serial primary key,
	title VARCHAR (255) NOT NULL,
	excerpt VARCHAR (150),
	body TEXT,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP
);
				  
INSERT INTO posts (title, excerpt, body)
VALUES
      ('test post 1','test post excerpt 1','test post body 1'),
      ('test post 2','','test post body 2'),
      ('test post 3', null ,'test post body 3');

SELECT
	ID,
	title,
	excerpt
FROM
	posts;
	
				  
SELECT
	id,
	title,
	COALESCE (excerpt, LEFT(body, 40))
FROM
	posts;
				  
				  
SELECT
	id,
	title,
	COALESCE (
		NULLIF (excerpt, ''),
		LEFT (body, 40)
	)
FROM
	posts;
				  
				  
--STORE PROCEDURE
/* USER DEFINE FUNCTION
	   WE CAN REUSE THIS IN DATABASE WHENEVER WE NEED*/

CREATE TABLE department1(id INT , name VARCHAR);

CREATE PROCEDURE Insert_dept1(INT,VARCHAR)
LANGUAGE 'plpgsql'
AS $$
BEGIN

	INSERT INTO department1(id,name) VALUES ($1,$2);
	COMMIT;

END;
$$

-- CALLING THE PROCEDURE

CALL Insert_dept1(1,'Raj');

SELECT * FROM department1;
				  
--2
				  
CREATE TABLE accounts(
		   id SERIAL PRIMARY KEY,
		   name TEXT NOT NULL,
		   balance DEC(10,2) NOT NULL
	   );
	   
INSERT INTO accounts (name,balance)
	VALUES
		('spiderman',90000),
		('capamerica',100000),
		('ironman',987000)
		('sami',10000);

SELECT * FROM accounts;
		
CREATE PROCEDURE pro_table(
			sender TEXT,
			receiver TEXT,
			amount DEC
		)
LANGUAGE 'plpgsql'
AS $$
BEGIN
		
		UPDATE accounts
			SET balance = balance - amount
				WHERE name = sender;
		
		UPDATE accounts
			SET balance = balance + amount
				WHERE name = receiver;
		
END;
$$
		
--CALLING THE STORE PROCEDURE
CALL pro_table('spiderman','ironman',9898);
		
SELECT * FROM accounts ORDER BY id;

				  
--COMMENTS

--SINGLE LINE CPOMMENTS
/* MULTILINE
			COMMENTS*/
				  
				  
--OPERATORS (I HAVE MENTIONED ALL OPEARTOR WHERE IT IS USED AS A COMMENT)
--1.ARITHMETIC OPEARTOR
				  --  (+, -, *, /)

--2.LOGICAL OPPEARTOR
				  -- (AND,OR,NOT,ANY,ALL,LIKE,IN,BETWEEN)
				  
--3.COMPARISON OPEARTOR
				  -- (=, <, >, <=, >=)
				  
				  
--CREATING DATABASE
CREATE DATABASE ddd;(--DATABASE_NAME)
	

--DROPPPING DATABASE
DROP DATABASE ddd;
	

--ALTER TABLE
ALTER TABLE whenoffered
ADD email VARCHAR(40);
	
SELECT * FROM whenoffered;
	
ALTER TABLE whenoffered
DROP COLUMN email;
	

--CONSTRAINTS
FOLLOWING CONSTRAINTS ARE MENTIONED WHERE IT IS USED
	--NOT NULL - Ensures that a column cannot have a NULL value
	--PRIMARY KEY - A combination of a NOT NULL and UNIQUE. Uniquely identifies each row in a table
	--FOREIGN KEY - Prevents actions that would destroy links between tables
	
--REMAINING CONSTARINTS
	
CREATE TABLE home(
	h_no SERIAL PRIMARY KEY ,
	name TEXT UNIQUE,
	build_date DATE DEFAULT NOW(),
	city TEXT,
	duration(age) INT,
	CONSTRAINT chk_home CHECK (duration(age) > 10 AND city = 'Gandhinagar'),
	price INT
)
	
	--UNIQUE - Ensures that all values in a column are different
	--DEFAULT - Sets a default value for a column if no value is specified
	--SERIAL - it means auto increment
	--CHECK - Ensures that the values in a column satisfies a specific condition

ALTER TABLE home
ADD CHECK (price > 80000);
	
--CREATING INDEX 
SELECT * FROM student;

EXPLAIN ANALYZE SELECT * FROM student;
/* Seq Scan on student  (cost=0.00..13.30 rows=330 width=218) (actual time=0.006..0.007 rows=6 loops=1)
	Execution Time: 0.021 ms */
	
CREATE INDEX name_in ON student(name);

EXPLAIN ANALYZE SELECT * FROM student;
/* Seq Scan on student  (cost=0.00..1.06 rows=6 width=218) (actual time=0.005..0.006 rows=6 loops=1) 
	Execution Time: 0.018 ms */

--DECREASE THE EXECUTION TIME
	

--VIEW
	
CREATE VIEW vmst AS
SELECT name,address
	FROM student;

SELECT * FROM vmst;

--
CREATE VIEW vmyearvise AS 
SELECT * 
	FROM uosoffering
	WHERE year=2010;

SELECT * FROM vmyearvise;
	
DROP VIEW vmst;



























































