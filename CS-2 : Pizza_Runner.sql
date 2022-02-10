CREATE SCHEMA pizza_runner;
SET search_path = pizza_runner;

DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
  "runner_id" INTEGER,
  "registration_date" DATE
);
INSERT INTO runners
  ("runner_id", "registration_date")
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_time" TIMESTAMP
);

INSERT INTO customer_orders
  ("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_time")
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  "order_id" INTEGER,
  "runner_id" INTEGER,
  "pickup_time" VARCHAR(19),
  "distance" VARCHAR(7),
  "duration" VARCHAR(10),
  "cancellation" VARCHAR(23)
);

INSERT INTO runner_orders
  ("order_id", "runner_id", "pickup_time", "distance", "duration", "cancellation")
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');


DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  "pizza_id" INTEGER,
  "pizza_name" TEXT
);
INSERT INTO pizza_names
  ("pizza_id", "pizza_name")
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');


DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  "pizza_id" INTEGER,
  "toppings" TEXT
);
INSERT INTO pizza_recipes
  ("pizza_id", "toppings")
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  "topping_id" INTEGER,
  "topping_name" TEXT
);
INSERT INTO pizza_toppings
  ("topping_id", "topping_name")
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  
  
CREATE VIEW vmrnorder AS
SELECT 
	order_id,
	runner_id,
	CASE 
        WHEN pickup_time = 'null' THEN NULL
        ELSE pickup_time 
	END AS pickup_time,
	CASE 
        WHEN distance = 'null' THEN NULL
        ELSE distance 
	END AS distance,
	CASE 
		WHEN duration = '' THEN NULL
        WHEN duration = 'null' THEN NULL
        ELSE duration 
	END AS duration,
	CASE 
		WHEN cancellation = '' THEN NULL
        WHEN cancellation = 'null' THEN NULL
        ELSE cancellation 
	END AS cancellation
FROM 
	runner_orders;



CREATE VIEW vmcorder AS
SELECT
	order_id,
	customer_id,
	pizza_id,
	CASE 
		WHEN exclusions = '' THEN NULL
        WHEN exclusions = 'null' THEN NULL
        ELSE exclusions
	END AS exclusions,
	CASE 
	 	WHEN extras = '' THEN NULL
        WHEN extras = 'null' THEN NULL
        ELSE extras 
	END AS extras,
	order_time
FROM 
	customer_orders;
	
  
  
  
  
                                            --  A. Pizza Metrics
-----------------------------------------------------------------------------------------------------------------------------------------------------											
--1. How many pizzas were ordered?

SELECT
	COUNT(pizza_id) AS total_pizza_order
FROM
	pizza_runner.customer_orders;



--2. How many unique customer orders were made?

SELECT 
	COUNT(DISTINCT order_id) AS unique_order
FROM 
	pizza_runner.customer_orders;



--3. How many successful orders were delivered by each runner?

SELECT * FROM vmrnorder
SELECT
	COUNT(v.order_id) AS successful_order
FROM
	vmrnorder v
WHERE
	cancellation IS NULL;

	

--4. How many of each type of pizza was delivered?

SELECT
	COUNT(vc.pizza_id) AS successful_delivered_pizza
FROM
	 vmcorder vc
JOIN
	vmrnorder vr
ON
	vc.order_id = vr.order_id
WHERE 
	vr.cancellation IS NULL
GROUP BY
	vc.pizza_id;



--5. How many Vegetarian and Meatlovers were ordered by each customer?

SELECT
	vc.pizza_id,
	COUNT(vc.pizza_id) AS pizza_order,
	p.pizza_name
FROM
	vmcorder vc
JOIN
	pizza_runner.pizza_names p
ON
	vc.pizza_id = p.pizza_id
GROUP BY
	vc.pizza_id,
	p.pizza_name
ORDER BY	
	vc.pizza_id;



--6. What was the maximum number of pizzas delivered in a single order?
WITH pizza_in_single_order AS(
	SELECT 
		vc.order_id,
		COUNT(vc.pizza_id) as pizzas_delivered
	FROM 
		vmcorder vc
	GROUP BY 
		vc.order_id
	)
SELECT 
	MAX(pizzas_delivered)
FROM
	pizza_in_single_order;
	
--2ND SOLUTION
SELECT 
	vc.order_id,
	COUNT(vc.pizza_id) as pizzas_delivered
FROM 
	vmcorder vc
GROUP BY 
	vc.order_id
ORDER BY
		pizzas_delivered DESC
LIMIT 1;                                --IF WE NOT ADD THIS THEN IT WILL GIVE RESULT FOR MAXIMUM PIZZA DELIVERED BY EACH ORDER



--7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

SELECT 
	vc.customer_id,
	SUM(CASE 
			WHEN(
				vc.exclusions IS NULL
				AND vc.extras IS NULL
			) THEN 1 
			ELSE 0
		END
	) AS unchanged,
	SUM(CASE 
			WHEN(
				vc.exclusions IS NOT NULL
				OR vc.extras IS NOT NULL
			) THEN 1 
			ELSE 0
		END
	) AS changed
FROM
	vmcorder vc
GROUP BY 
	vc.customer_id
ORDER BY
	vc.customer_id;



--8. How many pizzas were delivered that had both exclusions and extras?

SELECT
	COUNT(vc.pizza_id) AS pizza_delivered_having_changed
FROM
	vmrnorder vr
JOIN
	vmcorder vc
ON
	vr.order_id = vc.order_id
WHERE
	vc.exclusions IS NOT NULL
	AND 
	vc.extras IS NOT NULL
	AND
	vr.cancellation IS NULL;
	


--9. What was the total volume of pizzas ordered for each hour of the day?

SELECT
  EXTRACT(HOUR FROM order_time) AS hour_of_day,
  COUNT(pizza_id) AS pizzas_order
FROM
  vmcorder 
GROUP BY
  hour_of_day
ORDER BY
  hour_of_day;



--10. What was the volume of orders for each day of the week?

SELECT
	EXTRACT(DOW from order_time) AS week_day,
	COUNT(pizza_id) AS pizzas_order
FROM 
	vmcorder
GROUP BY 
	week_day
ORDER BY
	week_day
 
---------------------------------------

                                        --B. Runner and Customer Experience
-----------------------------------------------------------------------------------------------------------------------------------------
--1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

--SELECT to_char(registration_date, 'ww') AS week FROM pizza_runner.runners

WITH registration AS(
	SELECT
		ru.runner_id,
		to_char(ru.registration_date,'ww') as week_of_month
	FROM
		pizza_runner.runners ru
	)
SELECT 
	week_of_month,
	COUNT(DISTINCT re.runner_id) AS signed_up_runner_acc_week
FROM 
	registration re
GROUP BY
	week_of_month
ORDER BY
	week_of_month




--2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

WITH pickup AS(
	SELECT
		vr.order_id,
		vr.runner_id,
		(DATE_PART('HOUR', vr.pickup_time :: TIMESTAMP - vc.order_time)*60 + 
		DATE_PART('MINUTE', vr.pickup_time :: TIMESTAMP - vc.order_time)
		) AS order_minute
	FROM
		vmcorder vc
	JOIN 
		vmrnorder vr
	ON
		vc.order_id = vr.order_id
	)

SELECT 
	p.runner_id,
	ROUND(CAST(AVG(p.order_minute)AS DEC),1) AS avg_time_to_pickup
FROM
	pickup p
GROUP BY
	p.runner_id
ORDER BY
	p.runner_id
	


--3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

WITH time AS(
	SELECT
		vr.order_id,
		COUNT(vc.pizza_id) AS pizza_order,
		(DATE_PART('HOUR', vr.pickup_time :: TIMESTAMP - vc.order_time)*60 + 
		DATE_PART('MINUTE', vr.pickup_time :: TIMESTAMP - vc.order_time)
		) AS pre_time
	FROM
		vmcorder vc
	JOIN 
		vmrnorder vr
	ON
		vc.order_id = vr.order_id
	GROUP BY
		vr.order_id,
		pre_time
	)
SELECT 
	t.pizza_order,
	AVG(t.pre_time) AS avg_pre_time
FROM
	time t
GROUP BY
	t.pizza_order	
	
	
	
	
--4. What was the average distance travelled for each customer?

--tryyy
-- SELECT
-- 	vc.customer_id,
-- 	ROUND(CAST(AVG(vr.distance) AS DECIMAL),2) AS avg_distance_km
-- FROM
--  vmcorder vc
-- JOIN
-- 	vmrnorder vr
-- ON
-- 	vc.order_id = vr.order_id
-- GROUP BY 
-- 	vc.customer_id
	
	
CREATE TEMP TABLE updated_runner_orders AS (
  SELECT
    order_id,
    runner_id,
    CASE WHEN pickup_time LIKE 'null' THEN null ELSE pickup_time END::timestamp AS pickup_time,
    NULLIF(regexp_replace(distance, '[^0-9.]','','g'), '')::numeric AS distance,
    NULLIF(regexp_replace(duration, '[^0-9.]','','g'), '')::numeric AS duration,
    CASE WHEN cancellation IN ('null', 'NaN', '') THEN null ELSE cancellation END AS cancellation
  FROM pizza_runner.runner_orders);
 


SELECT
  runner_id,
  ROUND(AVG(distance), 2) AS avg_distance
FROM 
	updated_runner_orders
GROUP BY 
	runner_id
ORDER BY 
	runner_id;



--5. What was the difference between the longest and shortest delivery times for all orders?

SELECT 
	max_duration - min_duration
	AS diffrence_max_min
FROM(
	SELECT
		MAX(duration) AS max_duration,
		MIN(duration)AS min_duration
	FROM 
		updated_runner_orders vr) x



--6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

-- select * from updated_runner_orders
SELECT
	order_id,
	runner_id,
	ROUND((distance/duration*60),2) AS avg_delivery_speed
FROM
	updated_runner_orders
WHERE
	cancellation IS NULL
GROUP BY
	order_id,
	runner_id,
	avg_delivery_speed;




--7. What is the successful delivery percentage for each runner?  

WITH deliver AS(
	SELECT
		runner_id,
		COUNT(order_id) AS total_orders,
		SUM(
			CASE
			WHEN cancellation IS NOT NULL THEN 0
				ELSE 1
			END
			) AS delivered_orders
	FROM
		vmrnorder
	GROUP BY
		runner_id
)
SELECT 
	runner_id,
	ROUND(100*delivered_orders/(total_orders),2) AS successful_order_percentage
FROM
	deliver
ORDER BY 
	runner_id

---WITH UPDATED_RUNNER_ORDERS TABLE
SELECT
  runner_id,
  COUNT(pickup_time) as delivered,
  COUNT(order_id) AS total,
  ROUND(100 * COUNT(pickup_time) / COUNT(order_id)) AS delivery_percent
FROM updated_runner_orders
GROUP BY runner_id
ORDER BY runner_id;

------------------------------

                                                      --C. Ingredient Optimisation 
----------------------------------------------------------------------------------------------------------------------------------------------------


CREATE TEMP TABLE pizza_ingredients AS
  SELECT pr.pizza_id, regexp_split_to_table(pr.toppings, E',')::INTEGER AS topping_id
    FROM pizza_runner.pizza_recipes pr;

SELECT * FROM pizza_ingredients

CREATE TEMP TABLE cust_orders AS
  SELECT *
    FROM vmcorder
    ORDER BY order_id;

ALTER TABLE cust_orders ADD COLUMN id SERIAL PRIMARY KEY;


CREATE TEMP TABLE exclusions AS
  SELECT id, order_id, regexp_split_to_table(exclusions, E',')::INTEGER AS exclusion_id
    FROM cust_orders;

SELECT * FROM exclusions;
    
CREATE TEMP TABLE extras AS
  SELECT id, order_id, regexp_split_to_table(extras, E',')::INTEGER AS extra_id
    FROM cust_orders;

SELECT * FROM extras;

--------------

-- 1. What are the standard ingredients for each pizza?   

SELECT 
	pn.pizza_name,
	pt.topping_name
FROM 
	pizza_ingredients pi
JOIN
	pizza_toppings pt
ON
	pi.topping_id = pt.topping_id
JOIN
	pizza_names pn
ON
	pi.pizza_id = pn.pizza_id



-- 2. What was the most commonly added extra?

SELECT
	ex.extra_id,
	pt.topping_name
FROM
	extras ex
JOIN
	pizza_toppings pt
ON
	ex.extra_id = pt.topping_id
GROUP BY
	ex.extra_id,
	pt.topping_name
ORDER BY
	ex.extra_id DESC
LIMIT 1;



-- 3. What was the most common exclusion?

SELECT
	exc.exclusion_id,
	pt.topping_name
FROM
	exclusions exc
JOIN
	pizza_toppings pt
ON
	exc.exclusion_id = pt.topping_id
GROUP BY
	exc.exclusion_id,
	pt.topping_name
ORDER BY 
	exc.exclusion_id
LIMIT 1;


/* 4. Generate an order item for each record in the customers_orders table in the format of one of the following:
       Meat Lovers
       Meat Lovers - Exclude Beef
       Meat Lovers - Extra Bacon
       Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers  */
	   
	   
SELECT * FROM EXCLUSIONS;   
SELECT * FROM EXTRAS;
select * from cust_orders

WITH cteExclusion AS(
	SELECT
		c.id,
		c.pizza_id,
		pn.pizza_name,
		(SELECT 
			topping_name
		 FROM 
			pizza_toppings
		 WHERE 
			topping_id = exc.exclusion_id
			) AS exclu
	FROM
		cust_orders c
	LEFT JOIN
		pizza_runner.pizza_names pn
	ON
		c.pizza_id = pn.pizza_id
	LEFT JOIN 
		exclusions exc
	ON 
		c.id = exc.id
	),
agg_exclusion AS(
	SELECT 
		ce.id,
		ce.pizza_id,
		ce.pizza_name,
		STRING_AGG(exclu, ',') AS excluded
	FROM 
		cteExclusion ce
	GROUP BY
		ce.id,
		ce.pizza_id,
		ce.pizza_name
	),
cteExtra AS (
	SELECT
		ax.id,
		ax.pizza_name,
		ax.excluded,
		(SELECT
			topping_name
		 FROM
			pizza_toppings pt
		 WHERE
			pt.topping_id = ax.id
			) AS extr
	FROM
		agg_exclusion ax
	LEFT JOIN
		extras ext
	ON	
		ax.id = ext.id
	),
agg_extra AS(
	SELECT 
		cxt.id,
		cxt.pizza_name,
		cxt.excluded,
		STRING_AGG(extr,',') AS extras
	FROM
		cteExtra cxt
	GROUP BY
		cxt.id,
		cxt.pizza_name,
		cxt.excluded
	)
SELECT 
	axt.id,
	CASE
		WHEN excluded IS NULL AND extras IS NOT NULL
			THEN CONCAT(pizza_name,  '-Extra',extras)
		WHEN excluded IS NOT NULL AND extras IS NULL
			THEN CONCAT(pizza_name,  '-Excluded',excluded)  
		WHEN excluded IS NOT NULL AND extras IS NOT NULL
			THEN CONCAT(pizza_name,  '-Excluded',excluded,'-Extra',extras) 
		ELSE pizza_name
	END AS datail_orders
FROM
	agg_extra axt;

	   
	         
/* 5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
       For example: "Meat Lovers: 2xBacon, Beef, ... , Salami" */
	   
select * from pizza_ingredients	   
select * from cust_orders

WITH pizza AS(
	SELECT
		c.id,
		c.order_id,
		c.pizza_id,
		pn.pizza_name,
		pt.topping_name,
		CASE
			WHEN pt.topping_id IN (SELECT extra_id FROM extras WHERE id = c.id) THEN '2x'
			ELSE NULL
		END AS two_times
	FROM
		cust_orders c
	JOIN
		pizza_names pn
	ON
		c.pizza_id = pn.pizza_id
	JOIN
		pizza_ingredients pi
	ON
		c.pizza_id = pi.pizza_id	
	JOIN
		pizza_toppings pt
	ON
		pi.topping_id = pt.topping_id  
	WHERE 
		pt.topping_id NOT IN(SELECT exclusion_id FROM exclusions WHERE id = c.id)
	ORDER BY
		c.id,
		pt.topping_name
)
SELECT
	id,
	order_id,
	CONCAT(
		pizza_name,'-',
		STRING_AGG(CONCAT
			  	(two_times,topping_name),',') ) AS detail
FROM
	pizza
GROUP BY
	id,
	order_id,
	pizza_id,
	pizza_name
ORDER BY
	id;
		
	
	 
	 

-- 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?


WITH pizza AS(
	SELECT
		c.id,
		c.order_id,
		c.pizza_id,
		pn.pizza_name,
		pt.topping_name,
		CASE
			WHEN pt.topping_id IN (SELECT extra_id FROM extras WHERE id = c.id) THEN 2
			ELSE 1
		END AS quantity
	FROM
		cust_orders c
	JOIN
		pizza_names pn
	ON
		c.pizza_id = pn.pizza_id
	JOIN
		pizza_ingredients pi
	ON
		c.pizza_id = pi.pizza_id	
	JOIN
		pizza_toppings pt
	ON
		pi.topping_id = pt.topping_id  
	WHERE 
		pt.topping_id NOT IN(SELECT exclusion_id FROM exclusions WHERE id = c.id)
	ORDER BY
		c.id,
		pt.topping_name
)
SELECT
	topping_name,
	SUM(quantity) AS total_ingredients
FROM
	pizza
GROUP BY
	topping_name
ORDER BY
	total_ingredients; 


--                                                D. Pricing and Ratings
------------------------------------------------------------------------------------------------------------------------------------------------------------
/* 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - 
      how much money has Pizza Runner made so far if there are no delivery fees? 
*/



select * from updated_runner_orders
select * from cust_orders

WITH pricing AS(
	SELECT
		c.pizza_id,
		pn.pizza_name,
		CASE
			WHEN pizza_name = 'Meatlovers' THEN 12
			ELSE 10
		END price

	FROM
		cust_orders c
	JOIN
		pizza_names pn
	ON
		c.pizza_id = pn.pizza_id
	JOIN
		updated_runner_orders ro
	ON
		c.order_id = ro.order_id
	WHERE 
		cancellation IS NULL
)
SELECT 
	SUM(price)
FROM
	pricing;
	



/* 2. What if there was an additional $1 charge for any pizza extras?
      Add cheese is $1 extra
*/	  
	  
WITH pricing AS(
	SELECT
		c.id,
		pn.pizza_name,
		CASE
			WHEN pizza_name = 'Meatlovers' THEN 12
			ELSE 10
		END price

	FROM
		cust_orders c
	JOIN
		pizza_names pn
	ON
		c.pizza_id = pn.pizza_id
	JOIN
		updated_runner_orders ro
	ON
		c.order_id = ro.order_id
	WHERE 
		cancellation IS NULL
),
extra_price AS(
	SELECT
		pr.*,
		pt.topping_name,
		CASE
			WHEN pt.topping_name = 'Cheese' THEN 2
			WHEN pt.topping_name IS NOT NULL THEN 1
			ELSE 0
		END AS extra_price
	FROM
		pricing pr
	LEFT JOIN
		extras ext
	ON
		pr.id = ext.id
	LEFT JOIN
		pizza_toppings pt
	ON
		pt.topping_id = ext.id
	ORDER BY
		id
),
last_pricing AS(
SELECT 
	id,
	pizza_name,
	MAX(price) AS price ,SUM(extra_price) AS extra_price
FROM 
	extra_price
GROUP BY
	id,
	pizza_name
)
SELECT 
	(SUM(price) + SUM(extra_price)) AS total
FROM 
	last_pricing;


	  
 
/* 3. The Pizza Runner team now wants to add an additional ratings system that allows customers 
	  to rate their runner, how would you design an additional table for this new dataset - 
 	  generate a schema for this new table and insert your own data for 
	  ratings for each successful customer order between 1 to 5.
*/

DROP TABLE IF EXISTS customer_ratings;

CREATE TABLE customer_ratings (
	"order_id" INTEGER,
	"rating" INTEGER,
	"additional_comments" VARCHAR(150),
	"rating_time" TIMESTAMP
);

INSERT INTO customer_ratings
      ("order_id", "rating", "additional_comments", "rating_time")
    VALUES
      ('1', '4', 'A little late but very polite runner!', '2020-01-01 18:57:54'),
      ('2', '5', NULL, '2020-01-01 22:01:32'),
      ('3', '5','Excellent!', '2020-01-04 01:11:09'),
      ('4', '2', 'Late and didnt even told me good afternoon', '2020-01-04 14:37:14'),
      ('5', '5', NULL, '2020-01-08 21:59:44'),
      ('7', '5', 'Please promote this guy!', '2020-01-08 21:58:22'),
      ('8', '5', NULL, '2020-01-12 13:20:01'),
      ('10', '5', 'Perfect!', '2020-01-11 21:22:57');

SELECT * FROM customer_ratings;



/*4.Using your newly generated table - can you join all of the information 
   together to form a table which has the 
   following information for successful deliveries?
	customer_id
	order_id
	runner_id
	rating
	order_time
	pickup_time
	Time between order and pickup
	Delivery duration
	Average speed
	Total number of pizzas 
*/


SELECT
	c.customer_id,
	ro.order_id,
	ro.runner_id,
	r.rating,
	c.order_time,
	ro.pickup_time,
	ro.duration,
	(DATE_PART('HOUR', ro.pickup_time :: TIMESTAMP - c.order_time)*60 + 
	DATE_PART('MINUTE', ro.pickup_time :: TIMESTAMP - c.order_time)
	) AS time_bw_order_pickup,
	ROUND((ro.distance/ro.duration*60),2) AS avg_delivery_speed,
	COUNT(c.order_id)
FROM
	updated_runner_orders ro
JOIN
	cust_orders c
ON
	ro.order_id = c.id
JOIN
	customer_ratings r
ON
	r.order_id = ro.order_id
WHERE
	cancellation IS NULL
GROUP BY 
	c.customer_id,
    ro.order_id,
    ro.runner_id,
	r.rating,
    c.order_time,
    ro.pickup_time,
    time_bw_order_pickup,
    ro.duration,
    avg_delivery_speed
ORDER BY 
	c.customer_id, 
	ro.order_id;





/*5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre 
	traveled - how much money does Pizza Runner have 
	left over after these deliveries?
*/

WITH del_charge AS(
	SELECT 
		ro.order_id,
		ro.distance,
		(ro.distance*0.3)AS charge
	FROM
		updated_runner_orders ro
	WHERE
		cancellation IS NULL
	ORDER BY 
		ro.order_id
	),
agg_charge AS (
	SELECT 
		dc.*,
		pn.pizza_name,
		CASE 
			WHEN pn.pizza_name =  'Meatlovers' THEN 12
			ELSE 10
		END AS price
	FROM
		del_charge dc
	JOIN
		cust_orders c
	ON
		c.order_id = dc.order_id
	JOIN
		pizza_names pn
	ON	
		pn.pizza_id = c.pizza_id
	ORDER BY
		dc.order_id
	),
final AS (
	SELECT
		ag.order_id,
		MAX(ag.charge) AS runner_del_charge,
		SUM(ag.price) AS total
	FROM
		agg_charge ag
	GROUP BY
		ag.order_id
	ORDER BY
		ag.order_id
	)
SELECT
	SUM(total) AS total_earned,
	SUM(runner_del_charge) AS total_cost,
	(SUM(total) - SUM(runner_del_charge)) AS total_profit
FROM
	final;
	










