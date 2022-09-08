SELECT * FROM pizza_runner.customer_order_temp;
SELECT * FROM pizza_runner.runners;
SELECT * FROM pizza_runner.customer_order;
SELECT * FROM pizza_runner.pizza_name;
SELECT * FROM pizza_runner.pizza_recipe;
SELECT * FROM pizza_runner.pizza_toppings;
SELECT * FROM pizza_runner.runner_orders;



-- How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT WEEK(registration_date) as Registration_Week, count(runners_id) as Number_of_runners
FROM runners
GROUP BY 1;
-- 1 runner in week 0 and 2 respectively and 2 runners signed up  in week 1

-- Runner registration by weekdays
SELECT dayname(registration_date) as Registration_Week, count(runners_id) as Number_of_runners
FROM runners
GROUP BY 1;
# Registration_Week, Number_of_runners
-- 'Friday', '3'
-- 'Sunday', '1'

-- What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
SELECT runner_id,
round(avg(TIMESTAMPDIFF(MINUTE, order_time, pickup_time)), 2) as average_pickup_time
FROM Customer_order AS co
JOIN runner_orders AS ro
ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL
GROUP BY runner_id;

SELECT runner_id,
round(avg(TIMESTAMPDIFF(MINUTE, order_time, pickup_time)), 2) as average_pickup_time
FROM Customer_order AS co
JOIN runner_orders AS ro 
USING (order_id)
WHERE ro.cancellation IS NULL
GROUP BY runner_id;
# runner_id, average_pickup_time
-- '1', '15.33'
-- '2', '23.40'
-- '3', '10.00'

-- Is there any relationship between the number of pizzas and how long the order takes to prepare?
SELECT co.order_id, count(co.order_id) AS Number_of_Pizzas,
	TIMESTAMPDIFF(MINUTE, order_time, pickup_time) as preparation_time
FROM Customer_order AS co
JOIN runner_orders AS ro
ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL
GROUP BY order_id, 3
ORDER BY 2 DESC;
-- From the query results, 1 pizza mostly had 10minutes preparation time except order 8 which took 20mins, 2 pizza order was 15-21mins prep time, 3 pizzas was prepared for 29 mins
-- now lets look at the average prep time for number of pizzas
SELECT X.Number_of_pizzas, ROUND(Avg(x.preparation_time), 1) AS Average_Prep_Time
FROM(SELECT co.order_id, count(co.order_id) AS Number_of_Pizzas,
	TIMESTAMPDIFF(MINUTE, order_time, pickup_time) as preparation_time
	FROM Customer_order AS co
	JOIN runner_orders AS ro
	ON co.order_id = ro.order_id
	WHERE ro.cancellation IS NULL
	GROUP BY order_id, 3
	ORDER BY 2 DESC) AS X
GROUP BY 1
ORDER BY 1;

-- Number_of_pizzas, Average_Prep_Time)
-- '1', '12.0'
-- '2', '18.0'
-- '3', '29.0'


-- What was the average distance travelled for each customer?
SELECT customer_id, round(avg(distance), 2) as average_distance
FROM Customer_order AS co
JOIN runner_orders AS ro 
USING (order_id)
WHERE cancellation IS NULL
GROUP BY customer_id;
-- # customer_id, average_distance
-- '101', '20.00'
-- '102', '16.33'
-- '103', '23.00'
-- '104', '10.00'
-- '105', '25.00'

-- What was the difference between the longest and shortest delivery times for all orders?
SELECT MAX(duration), MIN(duration), MAX(duration) - MIN(duration) as difference
FROM runner_orders;
-- 30mins

-- What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT order_id, runner_id, distance, ROUND(duration/60, 2) AS Time_per_Hour, ROUND(distance/duration*60, 2) AS Average_speed
FROM runner_orders
WHERE distance IS NOT NULL
GROUP BY order_id, runner_id
ORDER BY 2;

-- What is the successful delivery percentage for each runner?
SELECT runner_id, count(pickup_time) AS deliveries_made, 
ROUND(count(pickup_time)/count(*) * 100) as Delivery_percentage
FROM runner_orders
GROUP BY runner_id