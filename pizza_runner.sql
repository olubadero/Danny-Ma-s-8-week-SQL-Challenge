SELECT * FROM pizza_runner.runners;
SELECT * FROM pizza_runner.customer_order;
SELECT * FROM pizza_runner.pizza_name;
SELECT * FROM pizza_runner.pizza_recipe;
SELECT * FROM pizza_runner.pizza_toppings;
SELECT * FROM pizza_runner.runner_orders;

USE pizza_runner;


INSERT INTO runners
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');
  
INSERT INTO customer_order
VALUES
  ('1', '101', '1', NULL, NULL, '2020-01-01 18:05:02'),
  ('2', '101', '1', NULL, NULL, '2020-01-01 19:00:52'),
  ('3', '102', '1', NULL, NULL, '2020-01-02 23:51:23'),
  ('3', '102', '2', NULL, NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', NULL, '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', NULL, '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', NULL, '2020-01-04 13:23:46'),
  ('5', '104', '1', NULL, '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', NULL, NULL, '2020-01-08 21:03:13'),
  ('7', '105', '2', NULL, '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', NULL, NULL, '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', NULL, NULL, '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');
  
  
INSERT INTO runner_orders
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', NULL),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', NULL),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 minutes', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4km', '40 minutes', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10km', '15 minutes', NULL),
  ('6', '3', NULL, NULL, NULL, 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25minutess', NULL),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minutes', NULL),
  ('9', '2', NULL, NULL, NULL, 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', NULL);
  
INSERT INTO pizza_name
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');
  
INSERT INTO pizza_recipe
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


INSERT INTO pizza_toppings
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
  
-- How many pizzas were ordered?
SELECT count(pizza_id) as Total_pizza_ordered
FROM customer_order;
-- 14 pizza orders

-- How many unique customer orders were made?
SELECT count(distinct(order_id)) as Unique_Orders
FROM customer_order;
-- 10 orders

-- How many successful orders were delivered by each runner?
SELECT runner_id, count(order_id) 
FROM runner_orders 
WHERE cancellation is null
GROUP BY runner_id;
-- Runner 1 made 4 successful delivery, Runner 2 made 3 successful delivery and Runner 3 made 1 delivery

-- How many of each type of pizza was delivered?
SELECT x.pizza_id, pn.pizza_name, x.Number_Delivered
FROM(SELECT pizza_id, count(pizza_id) as Number_Delivered
	FROM(SELECT co.order_id, ro.runner_id, co.pizza_id, ro.cancellation
	FROM customer_order AS co
	JOIN runner_orders AS ro
	ON co.order_id = ro.order_id
	WHERE ro.cancellation IS NULL) AS CV
	GROUP BY pizza_iD) AS X
JOIN pizza_name as pn
ON x.pizza_id = pn.pizza_id;
;
-- 9 Meat lovers were delivered, 3 vegetarians were delivered

-- How many Vegetarian and Meat lovers were ordered by each customer?
SELECT customer_id, pn.pizza_name, count(co.pizza_id) as Number_ordered
FROM customer_order as co
JOIN pizza_name as pn
ON co.pizza_id = pn.pizza_id
GROUP BY customer_id, pn.pizza_id
ORDER BY customer_id;
-- counting them in different columns
SELECT customer_id, 
SUM(CASE WHEN pizza_id = 1 THEN 1 ELSE 0 END) as Ordered_Meatlovers, 
SUM(CASE WHEN pizza_id = 2 THEN 1 ELSE 0 END) as Ordered_Vegetarian
FROM customer_order
GROUP BY customer_id
ORDER BY customer_id;

-- What was the maximum number of pizzas delivered in a single order?
SELECT co.customer_id, co.order_id, co.order_time, count(co.order_id) as Number_of_Pizzas
FROM customer_order AS co
JOIN runner_orders AS ro
ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL
GROUP BY co.customer_id, co.order_id, co.order_time
ORDER BY Number_of_Pizzas DESC
LIMIT 1;

-- For each customer, how many delivered pizzas had at least 1 change 
-- and how many had no changes?

SELECT co.customer_id, 
sum(case when (exclusions is not null or extras is  not null) then 1 else 0 end) as changes_made,
sum(case when (exclusions is null and extras is null) then 1 else 0 end) as no_changes_made
FROM customer_order AS co
JOIN runner_orders AS ro
ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL
GROUP BY co.customer_id
ORDER BY co.customer_id;


-- How many pizzas were delivered that had both exclusions and extras?
SELECT customer_id,  Delivered_pizzas.Number_of_Pizzas
FROM(SELECT co.order_id, co.customer_id, co.exclusions, co.extras, count(co.pizza_id) as Number_of_Pizzas
	FROM customer_order AS co
	JOIN runner_orders AS ro
	ON co.order_id = ro.order_id
	WHERE ro.cancellation IS NULL
	GROUP BY co.order_id, co.customer_id, co.exclusions, co.extras) AS Delivered_pizzas
WHERE exclusions IS NOT NULL AND extras IS NOT NULL;


-- What was the total volume of pizzas ordered for each hour of the day?
-- pizza orders by hours
SELECT hour(order_time), count(co.order_id) as Number_of_Pizzas
FROM customer_order AS co
GROUP BY 1
ORDER BY 1;

-- pizza orders daily
SELECT day(order_time), count(co.order_id) as Number_of_Pizzas
FROM customer_order AS co
GROUP BY 1
ORDER BY 1;

-- What was the volume of orders for each day of the week?
SELECT dayname(order_time), count(co.order_id) as Number_of_Pizzas
FROM customer_order AS co
GROUP BY 1
ORDER BY 2 Desc;
