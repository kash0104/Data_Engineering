-- 1. Create a new database and schema in any database engine(i.e. SQL server, PostgreSQL)

	--FOR CREATING DATABASE 
	 	CREATE DATABASE Assignments;
	--FOR CREATING SCHEMA
		CRATE SCHEMA assignment1;
		
------------------------------------------------------------------------------------------------------------------		
--2. Create two tables with primary and foreign key constraints. Define relationship in the table.
	
	CREATE TABLE simform (
		s_id SERIAL PRIMARY KEY,
		dept NOT NULL,
		email VARCHAR(30),
		phone INT NOT NULL,
	);
	
	CREATE TABLE employee (
		id NOT NULL REFERENCES simform(s_id) ON DELETE CASCADE,  
		f_name TEXT NOT NULL,
		l_name TEXT NOT NULL,
		mentor TEXT NOT NULL,
		course TEXT NOT NULL
		UNIQUE(mentor)
	);
	
	
	/*so here we have created twpo table namely simform and employee and 
	s_id 
	is primary key for simform table and
	id
	is foreign key for employee table,
	so this two have realtion between them because of foreign key....*/
	
-------------------------------------------------------------------------------------------------------------------------------	
--3. Perform CRUD operation on the table.
 
--CREATING A TABLE

	CREATE TABLE simform (
		s_id SERIAL PRIMARY KEY,
		dept TEXT NOT NULL,
		email VARCHAR(30),
		phone INT NOT NULL
	);
	
	CREATE TABLE employee (
		id INT NOT NULL REFERENCES simform(s_id) ON DELETE CASCADE,  
		f_name TEXT NOT NULL,
		l_name TEXT NOT NULL,
		mentor TEXT NOT NULL,
		course TEXT NOT NULL,
		join_date DATE DEFAULT NOW(),
		time TIMESTAMP NOT NULL DEFAULT NOW(),
		UNIQUE(mentor)
	);

--INSERTING DATA INTO IT.

	INSERT INTO simform (dept,email,phone)
			VALUES
			('Data Engineering','de@sim.com',99098),
			('Front-end','front@sim.com',09089),
			('Backend','back@sim.com',09099),
			('Full stack','full@sim.com',95154),
			('Scrum','scrum@sim.com',09080),
			('HR','hr@sim.com',090990),
			('Admin','adm@sim.com',00909),
			('BA','ba@sim.com',09988),
			('Python','py@sim.com',80099),
			('Php','php@sim.com',09879),
			('Java','ja@sim.com',09099);
			
	INSERT INTO employee (id,f_name,l_name,mentor,course)
		VALUES
		(1,'ok','david','zakir','DE'),
		(2,'zs','fuel','mehul','DS'),
		(3,'kd','rose','bhumika','ML'),
		(10,'bg','naik','rani','AI'),
		(6,'abhg','maru','virat','SQL'),
		(4,'abj','pandey','rohut','BA'),
		(5,'abf','shinde','anukna','ARTS'),
		(7,'abu','bhat','raj','DESIGN'),
		(8,'tgb','kohli','kushal','DE'),
		(9,'gb','sharma','fill','WEB-DEVELOPMENT');
		
		
--FETCHING DATA
		
		SELECT * FROM simform;
		SELECT * FROM employee;
		SELECT COUNT(*) FROM simform;
		SELECT MAX(id) FROM employee;
		
--DELETING OR DROPING 

		DELETE FROM simform WHERE s_id=1;
		DROP TABLE employee;
		
-------------------------------------------------------------------------------------------
--4. Demonstrate use of stored procedure, trigger, index objects using the SQL queries. 

-- i) STORED PROCEDURE 
    /* USER DEFINE FUNCTION
	   WE CAN REUSE THIS IN DATABASE WHENEVER WE NEED*/
	   
	   CREATE TABLE accounts(
		   id SERIAL PRIMARY KEY,
		   name TEXT NOT NULL,
		   balance DEC(10,2) NOT NULL
	   );
	   
	   INSERT INTO accounts (name,balance)
       		VALUES
			('spiderman',90000),
			('capamerica',100000),
			('ironman',987000),
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


-----------------------------------------------------------------------------------------------------
-- ii) TRIGGER
		/* TO ADD,DELETE,UPDATE(CHANGES IN DATA) IN ONE TABLE TO ANOTHER(IT REFLECT THE DATA FROM ONE TO ANOTHER)*/
		
CREATE TABLE race (
   make VARCHAR,
   model VARCHAR,
   year INTEGER,
   price INTEGER
);


INSERT INTO race (make, model, year, price)
	VALUES
	('Nissan', 'Stanza', 1990, 2000),
	('Dodge', 'Neon', 1995, 800),
	('Dodge', 'Neon', 1998, 2500),
	('Dodge', 'Neon', 1999, 3000),
	('Ford', 'Mustang', 2001, 1000),
	('Ford', 'Mustang', 2005, 2000),
	('Subaru', 'Impreza', 1997, 1000),
	('Mazda', 'Miata', 2001, 5000),
	('Mazda', 'Miata', 2001, 3000),
	('Mazda', 'Miata', 2001, 2500),
	('Mazda', 'Miata', 2002, 5500),
	('Opel', 'GT', 1972, 1500),
	('Opel', 'GT', 1969, 7500),
	('Opel', 'Cadet', 1973, 500)
;

CREATE TABLE race_audit (
	operation CHAR(1) NOT NULL,
	stamp TIMESTAMP NOT NULL,
	make VARCHAR(20),
	model VARCHAR(128),
	year INT,
	price INT
);

CREATE OR REPLACE FUNCTION race_audit() RETURNS TRIGGER AS $race_audi$
BEGIN
	IF(TG_OP = 'INSERT') THEN
		INSERT INTO race_audit SELECT 'I',now(),NEW.*;
		RETURN NEW;
	ELSEIF (TG_OP ='DELETE') THEN
		INSERT INTO race_audit SELECT 'D',now(),OLD.*;
		RETURN OLD;
	ELSEIF (TG_OP = 'UPDATE') THEN
		INSERT INTO race_audit SELECT 'U',now(),NEW.*;
		RETURN NEW;
	END IF;
	RETURN NULL;
END
$race_audi$ LANGUAGE plpgsql;

--CREATING A TRIGGER

CREATE TRIGGER race_audi
	AFTER INSERT OR DELETE OR UPDATE ON race
	FOR EACH ROW EXECUTE PROCEDURE race_audit();
		
SELECT * FROM race;
SELECT * FROM race_audit;


--CHEKING

INSERT INTO race
	VALUES
		('Audi','A3',2010,15000);
		
---------------------------------------		
--2ND TRIGGER(SIMPLE TRIGGER)

CREATE TABLE racing1 (
	make VARCHAR(20),
	model VARCHAR(128),
	year INT,
	price INT
);


CREATE FUNCTION func() RETURNS TRIGGER AS $race_inf_trg$
	BEGIN
	 INSERT INTO racing1(make,model,year,price) VALUES (NEW.make,NEW.model,NEW.year,NEW.price);
	 RETURN NEW;
	END;
	 $race_inf_trg$ LANGUAGE plpgsql;
	 
CREATE TRIGGER race_inf_trg AFTER INSERT ON race
FOR EACH ROW EXECUTE PROCEDURE func();


SELECT * FROM race;
SELECT * FROM racing1;

INSERT INTO race VALUES('Ford','Efg',1987,409800); 


--------------------------------------------------------------------------------------------------------
--5. Demo the use of concurrency, transaction isolation, ACID properties with the use of SQL query.
 
 
--1. CONCURRENCY AND TRANSACTION

CREATE TABLE account (
	id SERIAL,
	email VARCHAR(128) UNIQUE,
	created_at DATE NOT NULL DEFAULT NOW(),
	updated_at DATE NOT NULL DEFAULT NOW(),
	PRIMARY KEY(id)
);
CREATE TABLE post (
	id SERIAL,
	title VARCHAR(128) UNIQUE NOT NULL,
	content VARCHAR(1024), 
	account_id INTEGER REFERENCES account(id) ON DELETE CASCADE,
	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	PRIMARY KEY(id)
);


CREATE TABLE fav (
	id SERIAL,
	oops TEXT, -- Will remove later with ALTER
	post_id INTEGER REFERENCES post(id) ON DELETE CASCADE,
	account_id INTEGER REFERENCES account(id) ON DELETE CASCADE,
	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	UNIQUE(post_id, account_id),
	PRIMARY KEY(id)
);


ALTER TABLE fav DROP COLUMN oops;
ALTER TABLE post ALTER COLUMN content TYPE TEXT;
ALTER TABLE fav ADD COLUMN howmuch INTEGER;





INSERT INTO account(email) VALUES 
('ed@umich.edu'), ('sue@umich.edu'), ('sally@umich.edu');

INSERT INTO post (title, content, account_id) VALUES
( 'Dictionaries', 'Are fun', 3),  -- sally@umich.edu
( 'BeautifulSoup', 'Has a complex API', 1), -- ed@mich.edu
( 'Many to Many', 'Is elegant', (SELECT id FROM account WHERE email='sue@umich.edu' ));


-- CONCURRENCY

DELETE FROM fav;

INSERT INTO fav (post_id,account_id,howmuch)
	VALUES
	(1,1,1)
	ON CONFLICT (post_id,account_id)   --(ON CONFLICT -- PREVENT FROM DUPLICATE KEY VALUE ERROR)
	DO UPDATE SET howmuch=fav.howmuch+1
RETURNING *;  


-- IF THIS PROCESS OR TRANSACTION ARE GOING ON BY 2 USER THEN IT WILL CREATE CONCURRENCY HERE AND VALUE OF HOWMUCH WILL INCRESE ACCORDINGLY.


SELECT * FROM fav;


INSERT INTO fav (post_id,account_id,howmuch)
	VALUES
	(1,1,1)
	ON CONFLICT (post_id,account_id) 
	DO UPDATE SET howmuch=fav.howmuch+1
RETURNING *;


-- TRANSACTION.....

BEGIN;
	SELECT  howmuch FROM fav WHERE account_id=1 AND post_id=1;
ROLLBACK;

SELECT * FROM fav

BEGIN;
	SELECT  howmuch FROM fav WHERE account_id=1 AND post_id=1;
	UPDATE fav SET howmuch=889 WHERE account_id=1 AND post_id=1;
	SELECT * FROM fav;     --(IT WILL SHOW 899)
ROLLBACK;
SELECT * FROM fav   --(AFTER DOING ROLL BACK IT WILL SHOW THE EARLIER VALUE)



BEGIN;
	SELECT howmuch FROM fav WHERE account_id=1 AND post_id=1 FOR UPDATE OF fav;
	
	/* IF AT THE SAME TIME 2 TRANSACTIION ARE GOING ON, SO THEN AFTER THE COMPLETION OF TRNSACTION(T1),
	IT WILL PERFORM TARNSACTION(T2) OR WE CAN SAY IT WILL PERFORM T2 AT THE ABOVE LINE AND THEN WAIT FOR T1 TO COMPLETE*/
	
	UPDATE fav SET howmuch=999 WHERE account_id=1 AND post_id=1;
	SELECT howmuch FROM fav WHERE account_id=1 AND post_id=1;
ROLLBACK;
	SELECT howmuch FROM fav WHERE account_id=1 AND post_id=1;
	SELECT * FROM fav;


BEGIN;
	SELECT howmuch FROM fav WHERE post_id=1 AND account_id=1;
	UPDATE fav SET howmuch=898 WHERE account_id=1 AND post_id=1;
	SELECT howmuch FROM fav WHERE account_id=1 AND post_id=1;
COMMIT;    -- (IT WILL SAVE VALUE FOREVER)
ROLLBACK;  --(IT GIVES KIND OF ERROR,BECAUSE WE ALREADY COMMIT TRANSACTION)

SELECT * FROM fav;






		
		


	
	
	
	
	
	
	
	
	
	
