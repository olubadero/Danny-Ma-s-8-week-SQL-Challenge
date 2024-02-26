## A. Pizza Metrics

1. How many pizzas were ordered?
```sql
SELECT CONCAT(COUNT(*),' Pizzas ordered') AS Total_Ordered_Pizzas
FROM new_customers_order;
```
-- 14 pizzas have been ordered so far

---

2, How many unique customer orders were made?
```sql
SELECT CONCAT(COUNT(distinct order_id),' unique customer orders') AS Unique_Customer_Orders
FROM new_customers_order;
```
-- There are 10 unique customer orders

---

3. How many successful orders were delivered by each runner?
```sql
SELECT runner_id, CONCAT(COUNT(*), ' successful deliveries') AS successful_deliveries
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id;
```
-- Each Rider made the following successful deliveries:
-- Runner 1 made 4, Runner 2 made 3 and Runner 3 made 1 delivery.

---

-- How many of each type of pizza was delivered?
```sql
SELECT pizza_id, COUNT(*) AS Pizza_Types_Delivered
FROM New_Customers_Order
JOIN runner_orders
USING (Order_id)
WHERE cancellation IS NULL
GROUP BY pizza_id;
```
-- 9 Meatlover were delivere and 3 Vegetarians 

---

-- How many Vegetarian and Meatlovers were ordered by each customer?
```sql
SELECT customer_id, pizza_name,COUNT(pizza_name) AS Orders
FROM New_Customers_Order
JOIN pizza_names
USING (Pizza_id)
GROUP BY customer_id, pizza_name
ORDER BY customer_id;
-- 101 and 102 both ordered 2 Meatlovers and 1 Vegetarian Pizza
-- 103 ordered 3 Meatlovers and 1 Vegetarian Pizza
-- 104 ordered 3 Meatlovers pizza
-- 105 ordered 1 Vegetarian Pizza. 
```
---

-- What was the maximum number of pizzas delivered in a single order?
```sql
SELECT Customer_id, order_id, date(order_time) AS order_date, COUNT(*) AS orders
FROM New_Customers_Order
JOIN runner_orders
USING (Order_id)
WHERE cancellation IS NULL
GROUP BY Customer_id, order_id, Order_time
ORDER BY Orders DESC
LIMIT 1;
```
-- Customer 103 ordered 3 pizzas on the 4th of January

---

-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
```sql
SELECT customer_id, 
				SUM(CASE WHEN exclusions IS NOT NULL OR extras IS NOT NULL THEN 1
					 ELSE 0
                     END) AS Changes, 
				SUM(CASE WHEN exclusions IS NULL AND extras IS NULL THEN 1
					 ELSE 0
                     END) AS NO_Changes
FROM New_Customers_Order
JOIN runner_orders
USING (Order_id)
WHERE cancellation IS NULL
GROUP BY customer_id;
```

-- number of pizzas that had changes and those that had no changes

-- customer_id, Changes, NO_Changes
-- 	'101',		  '0',		'2'
-- 	'102',		  '0',		'3'
-- 	'103',		  '3',		'0'
-- 	'104',		  '2',		'1'
-- 	'105',		  '1',		'0'

---

-- How many pizzas were delivered that had both exclusions and extras?
```sql
SELECT Customer_id, COUNT(*) Number_of_Pizzas
FROM New_Customers_Order
JOIN runner_orders
USING (Order_id)
WHERE cancellation IS NULL AND exclusions IS NOT NULL AND extras IS NOT NULL
GROUP BY Customer_id;
```
-- Customer 104 ordered 1 pizza that had both exclusions and extras 

---

-- What was the total volume of pizzas ordered for each hour of the day?
```sql
SELECT date(Order_Time) AS order_date, HOUR(Order_Time) AS order_hour, COUNT(Order_ID) AS order_volume
FROM new_customers_order
GROUP BY date(Order_Time), HOUR(Order_Time)
ORDER BY ORDER_DATE;
```

-- The total volume of pizza orders by date and hour is distributed as follows
-- order_date, 	order_hour, order_volume
-- '2020-01-11', 	'18', 		'2'
-- '2020-01-10', 	'11', 		'1'
-- '2020-01-09', 	'23', 		'1'
-- '2020-01-08', 	'21', 		'3'
-- '2020-01-04', 	'13', 		'3'
-- '2020-01-02', 	'23', 		'2'
-- '2020-01-01', 	'18', 		'1'
-- '2020-01-01', 	'19', 		'1'

---

-- What was the volume of orders for each day of the week?
```sql
SELECT DAYNAME(Order_Time) AS order_day, COUNT(Order_ID) AS order_volume
FROM new_customers_order
GROUP BY DAYNAME(Order_Time);
```

-- The daily pizza orders are distributed as follows
-- order_day	order_volume
-- Wednesday		5
-- Thursday			3
-- Friday			1
-- Saturday			5

---
