## B. Runner and Customer Experience

1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

```sql
SELECT WEEK(registration_date) AS registration_week, COUNT(runner_id) AS number_of_signups
FROM runners
GROUP BY WEEK(registration_date);
```

-- registration_week, number_of_signups
-- 	'0',				'1'
-- 	'1',				'2'
-- 	'2',				'1'

---

2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
```sql
WITH arrival_period AS(
				SELECT DISTINCT Order_ID, runner_id, Order_Time, pickup_time, 
						timestampdiff(minute, Order_Time, pickup_time) AS arrival_time
				FROM runner_orders
				JOIN New_Customers_Order
				USING (order_id)
				WHERE Cancellation IS NULL
				ORDER BY runner_id)

SELECT runner_id, ROUND(AVG(Arrival_time), 2) AS average_pickup_time
FROM arrival_period 
GROUP BY runner_id;
```

-- This is the average pick up time of each runner
-- runner_id, Average_time
-- 	  '1',		'14.00'
-- 	  '2',		'19.67'
-- 	  '3',		'10.00'

---

3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
```sql
WITH Orders AS(
			SELECT order_id, timestampdiff(minute, Order_Time, pickup_time) AS preparation_time, 
					COUNT(Order_id) AS total_pizzas
			FROM runner_orders
			JOIN New_Customers_Order
			USING (order_id)
			WHERE Cancellation IS NULL
			GROUP BY order_id,  preparation_time
			ORDER BY order_id)
SELECT Total_Pizzas, ROUND(AVG(preparation_time)) AS average_prep_time
FROM Orders
GROUP BY Total_Pizzas;
```

-- From the above, it appears the average time to prepare 1 pizza is 12 mins; 16 mins to prepare 2 pizzas i.e 8mins per pizza.
-- Whilst it takes 29 mins to prepare 3 pizzas
-- Thus, it can be said that as the number of pizza orders increases, preparation time decreases.

---

4. What was the average distance travelled for each customer?
```sql
WITH travel AS(
				SELECT DISTINCT customer_id, distance, Order_time
				FROM runner_orders
				JOIN New_Customers_Order
				USING (order_id)
				WHERE Cancellation IS NULL
				ORDER BY customer_id)
SELECT customer_id, CONCAT(ROUND(AVG(distance),2), 'km') AS Average_Distance_travelled
FROM travel
GROUP BY customer_id;
```

-- The breakdown of the average distance travelled to each customers to deliver their pizza is as follows
-- customer_id, Average_Distance_travelled
-- 	'101',				'20km'
-- 	'102',				'16.73km'
-- 	'103',				'23.4km'
-- 	'104',				'10km'
-- 	'105',				'25km'
-- From the above customer 104 is the closest to the pizzeria,whilst 105 is the furthest

---

5. What was the difference between the longest and shortest delivery times for all orders?
```sql
SELECT CONCAT(MAX(duration) - MIN(duration),'mins') AS delivery_time_difference
FROM runner_orders
JOIN New_Customers_Order
USING (order_id)
WHERE Cancellation IS NULL;
```

-- The difference between the longest and shortest delivery times for all orders is 30 minutes

---

6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
```sql
SELECT DISTINCT customer_id, runner_id, distance, duration, order_time, ROUND(distance/duration*60, 2) AS avg_speed_per_delivery
FROM runner_orders
JOIN New_Customers_Order
USING (order_id)
WHERE Cancellation IS NULL
ORDER BY runner_id, avg_speed_per_delivery;
```
-- The average speed for each runner is spread as follows:
-- Runner 1 is between 37.5kmph - 60kmph, whilst Runner 2 is between 35.1kmph - 93.6kmph and Runner 3 is 40kmph.
-- Danny may wish to investigate why Runner 2s delivery time contradicts so significantly despite the distances being close in value

---

7. What is the successful delivery percentage for each runner?
```sql
WITH successful_delivery AS(
			SELECT runner_id, order_id, pickup_time
			FROM runner_orders
			JOIN New_Customers_Order
			USING (order_id)
			WHERE Cancellation IS NULL)
SELECT runner_id, CONCAT(ROUND(COUNT(*)/(SELECT COUNT(*) FROM successful_delivery)*100, 2), '%') AS  successful_delivery_percentage
FROM successful_delivery
GROUP BY runner_id;
```

-- the percentage of each riders delivery in all deliveries successfully made are as follows:
-- runner_id, successful_delivery_percentage 
-- 		'1',		'50.00%'
-- 		'2',		'41.67%'
-- 		'3',		'8.33%'
