CREATE SCHEMA dannys_diner;
SET search_path = dannys_diner;

CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
  
  
 /* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?

SELECT 
	s.customer_id, 
	SUM(m.price) AS total_amount_spent
FROM 
	sales s 
JOIN 
	menu m
ON 
	s.product_id = m.product_id
GROUP BY 
	s.customer_id
ORDER BY 
	total_amount_spent DESC;
	
	

-- 2. How many days has each customer visited the restaurant?

SELECT 
	s.customer_id,
	COUNT(DISTINCT s.order_date) AS total_days_visited_by_customer
FROM 
	sales s
GROUP BY 
	s.customer_id
ORDER BY 
	s.customer_id;
	
	
	
-- 3. What was the first item from the menu purchased by each customer?

SELECT x.customer_id,m.product_name FROM(
	SELECT 
		s.*,
	ROW_NUMBER()
	OVER(
		PARTITION BY s.customer_id ORDER BY s.customer_id
		) AS rnk_c_id
	FROM
		sales s) x
JOIN
	menu m
ON
	x.product_id = m.product_id
WHERE 
	x.rnk_c_id < 2
GROUP BY
	x.customer_id,m.product_name
ORDER BY
	x.customer_id;




-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT
	s.product_id,
	m.product_name,
	COUNT(s.product_id) AS total_purchased_by_customer
FROM 
	sales s
JOIN 
	menu m
ON
	s.product_id = m.product_id
GROUP BY 
	s.product_id,
	m.product_name
FETCH
	FIRST ROW ONLY;



-- 5. Which item was the most popular for each customer?
	
CREATE VIEW vmtable AS	
SELECT
	s.customer_id,
	s.product_id,
	m.product_name,
	COUNT(s.product_id) AS total_purchased
FROM 
	sales s
JOIN 
	menu m
ON
	s.product_id = m.product_id
GROUP BY 
	s.customer_id,
	s.product_id,
	m.product_name

SELECT * 
FROM 
	vmtable;

CREATE VIEW vmfinal AS
SELECT v.*,
RANK()
OVER(PARTITION BY customer_id ORDER BY total_purchased DESC) AS rnk
FROM vmtable v


SELECT * 
FROM 
	vmfinal;

SELECT 
	vf.customer_id,
	STRING_AGG(CAST(vf.product_id AS CHAR),',') AS most_popular_item
FROM
	vmfinal vf
WHERE 
	rnk = 1
GROUP BY
	vf.customer_id;



-- 6. Which item was purchased first by the customer after they became a member?

CREATE VIEW vsmem AS
SELECT
	s.customer_id,
	s.product_id,
	s.order_date
FROM
	sales s
JOIN 
	members m
ON
	s.customer_id = m.customer_id
	AND
	s.order_date > m.join_date 
/*(IF WE PUT s.order_date >= m.join_date THEN FINAL RESULT VARY
--BUT I TAKE RESSULT FOR AFTER THE JOINING SO I EXCULDED THE DAY OF JOINING ORDER 
IF WE TAKE THIS THEN RESULT IS
A -- 2 -- CURRY
B -- 1 -- SUSHI)*/

ORDER BY 
	s.customer_id
	
SELECT *
FROM
	vsmem

CREATE VIEW vmresult as
	SELECT v.*,
	RANK()
	OVER(
		PARTITION BY v.customer_id ORDER BY v.order_date
		) AS rnk
	FROM
		vsmem v;
	
SELECT
	x.customer_id,
	x.product_id,
	x.order_date,
	m.product_name
FROM
	(
	SELECT 
		vr.customer_id,
		vr.product_id,
		vr.order_date
	FROM 
		vmresult vr
	WHERE
		rnk = 1) x
JOIN 
	menu m
ON
	x.product_id = m.product_id
ORDER BY
	customer_id;
	



-- 7. Which item was purchased just before the customer became a member?

SELECT 
	customer_id,
	STRING_AGG(CAST(product_id AS CHAR),',') AS purchased_item_before_member
FROM(
	WITH sale AS(
		SELECT
			s.customer_id,
			s.product_id,
			s.order_date
		FROM
			sales s
		JOIN 
			members m
		ON
			s.customer_id = m.customer_id
			AND
			s.order_date < m.join_date 
		ORDER BY 
			s.customer_id
		)
		SELECT
			customer_id,
			product_id,
			order_date,
		RANK()
		OVER(PARTITION BY customer_id ORDER BY order_date ASC) AS rnk
		FROM sale) AS result
	WHERE rnk=1
	GROUP BY 
		customer_id;
	
	

-- 8. What is the total items and amount spent for each member before they became a member?

SELECT 
	customer_id,
	COUNT(product_id),
	SUM(price) AS total_spent
FROM(
	WITH amount_spent AS(
		SELECT
			s.customer_id,
			s.product_id,
			s.order_date,
			mu.price
		FROM
			sales s
		JOIN 
			members m
		ON
			s.customer_id = m.customer_id
	    	AND
			s.order_date < m.join_date 
		JOIN 
			menu mu
		ON
			s.product_id = mu.product_id
		ORDER BY 
			s.customer_id
		)
		SELECT
			customer_id,
			product_id,
			order_date,
			price,
		RANK()
		OVER(PARTITION BY customer_id ORDER BY price ASC) AS rnk
		FROM amount_spent) AS final_result
	WHERE rnk IN (1,2)
	GROUP BY 
		customer_id 




-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT 
	x.customer_id,
	SUM(CASE WHEN x.product_name = 'sushi' THEN price*20 ELSE price*10 END) as points
FROM(
	SELECT
		s.customer_id,
		s.product_id,
		s.order_date,	
		mu.price,
		mu.product_name
	FROM
		sales s
	JOIN 
		menu mu
	ON
		s.product_id = mu.product_id
	ORDER BY 
		s.customer_id
	) x
GROUP BY 
	x.customer_id 
ORDER BY
	x.customer_id 




/* 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, 
       not just sushi - how many points do customer A and B have at the end of January? */
	   
SELECT
	x.customer_id,
	SUM(CASE WHEN week_1 = 'applied' THEN x.price*20 END) AS points
FROM
	(	   
	SELECT
		s.customer_id,
		s.product_id,
		s.order_date,
		mu.price,
		mu.product_name,
		CASE WHEN(s.order_date - m.join_date)BETWEEN 0 AND 7 THEN 'applied' ELSE 'N applied' END week_1 
	FROM
		sales s
	JOIN
		members m 
	ON
		s.customer_id = m.customer_id
		AND
		s.order_date >= m.join_date
	JOIN
		menu mu
	ON
		s.product_id = mu.product_id
	ORDER BY
		s.customer_id) x
GROUP BY
	x.customer_id


 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 