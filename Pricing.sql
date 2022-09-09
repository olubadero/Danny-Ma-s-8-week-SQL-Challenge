SELECT * FROM pizza_runner.customer_order;
SELECT * FROM pizza_runner.customer_order_temp;
SELECT * FROM pizza_runner.runners;
SELECT * FROM pizza_runner.customer_order;
SELECT * FROM pizza_runner.pizza_name;
SELECT * FROM pizza_runner.pizza_recipe;
SELECT * FROM pizza_runner.pizza_toppings;
SELECT * FROM pizza_runner.runner_orders;


-- If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes 
-- how much money has Pizza Runner made so far if there are no delivery fees?
SELECT sum(CASE WHEN pizza_id = 1 THEN 12 ELSE 10 END) as Total_Revenue
FROM customer_order
JOIN runner_orders
USING (order_id)
WHERE cancellation IS NULL;

-- Total Revenue of $138 


-- The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset 
-- generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
CREATE TABLE `pizza_runner`.`Customer_Review` (
  `Order_ID` INT NOT NULL,
  `Customer_Rating` INT NULL,
  `Customer_Review` VARCHAR(50) NULL);

INSERT INTO Customer_review 
VALUES
(1, 2, 'Delivery was slow'), 
(2, 2, 'Pizza arrived late'),
(3, 3, 'Good service, delivery time is not bad'),
(4, 1, 'Pizza arrived cold because delivery took too long'),
(5, 5, 'Pizza was delivered promptly'),
(7, 3, 'Pizza was nice but delivery time could be better'),
(8, 4, 'Impressive delivery time'),
(10, 5, 'Rider was courteous and delivery was swift');


-- Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
-- customer_id, order_id, runner_id, rating, order_time, pickup_time, Time between order and pickup
-- Delivery duration, Average speed, Total number of pizzas

SELECT customer_id, x.order_id, runner_id, customer_rating, Customer_review, order_time, pickup_time, timestampdiff(minute, order_time, pickup_time) AS Prep_time, duration, ROUND(distance/duration*60, 2) as average_speed, count(pizza_id) as Total_orders
FROM(SELECT *
FROM customer_order
JOIN runner_orders
USING (order_id)
WHERE cancellation IS NULL) as X
JOIN customer_review as CR
ON x.Order_id = CR.order_id
GROUP BY 1, 2, 3, 4 , 5, 6
ORDER BY 1;

-- If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled 
-- how much money does Pizza Runner have left over after these deliveries?
SELECT SUM(X.Total_Revenue - X.Delivery_Charges) as Pizza_Runners_Revenue
FROM(SELECT 
SUM(CASE WHEN pizza_id = 1 THEN 12 ELSE 10 END) AS Total_Revenue,
SUM(CASE WHEN cancellation is NULL THEN 0.30 * distance ELSE 0 END) AS Delivery_Charges
FROM customer_order as CO
JOIN runner_orders as RO
ON CO.order_id = RO.order_id
WHERE cancellation IS NULL) AS X;

-- $74.10

-- If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?
INSERT INTO pizza_name VALUES(3, 'Supreme');

INSERT INTO pizza_recipe
VALUES
  (3, "1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12");


