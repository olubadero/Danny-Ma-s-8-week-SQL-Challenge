
				-- D. Pricing and Ratings
-- If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - 
-- how much money has Pizza Runner made so far if there are no delivery fees?

SELECT pizza_name, CONCAT('$',SUM(CASE WHEN pizza_name = "Meatlovers" THEN 12
							ELSE 10
                            END))AS Total_Sales
FROM New_Customers_Order
JOIN  runner_orders
USING (Order_id)
JOIN pizza_names
USING (pizza_id)
WHERE Cancellation IS NULL
GROUP BY pizza_name;
-- pizza_name, 		Total_Sales
-- 'Meatlovers',		'$108'
-- 'Vegetarian',		'$30'


-- What if there was an additional $1 charge for any pizza extras?
-- Add cheese is $1 extra

WITH Price_List AS(
				SELECT *, CASE WHEN pizza_name = "Meatlovers" AND Extras IS NULL THEN 12
								WHEN pizza_name = "Meatlovers" AND Extras IS NOT NULL THEN 13
								WHEN pizza_name = "Vegetarian" AND Extras IS NULL THEN 10
								WHEN pizza_name = "Vegetarian" AND Extras IS NOT NULL THEN 11
											END AS Price_Range
				FROM split_Customer_Orders
				JOIN  runner_orders
				USING (Order_id)
				JOIN pizza_names
				USING (pizza_id)
				WHERE Cancellation IS NULL)

SELECT pizza_name, CONCAT('$',SUM(CASE WHEN EXtras = 4 THEN price_range + 1
						ELSE price_range END)) AS total_sales
FROM Price_lIST
GROUP BY pizza_name;
-- pizza_name, 		total_sales
-- 'Vegetarian',		'$31'
-- 'Meatlovers',		'$124'


-- If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled 
-- how much money does Pizza Runner have left over after these deliveries?
SELECT CONCAT("$", ROUND(SUM(CASE WHEN pizza_name = "Meatlovers" THEN 12
							ELSE 10
                            END) -
		SUM(ROUND(distance * 0.30, 2)), 2)) AS Post_Delivery_Sales
FROM New_Customers_Order
JOIN  runner_orders
USING (Order_id)
JOIN pizza_names
USING (pizza_id)
WHERE Cancellation IS NULL;
-- Post_Delivery_Sales
-- '$73.38'

-- The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, 
-- how would you design an additional table for this new dataset 
-- generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.



-- Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
-- customer_id
-- order_id
-- runner_id
-- rating
-- order_time
-- pickup_time
-- Time between order and pickup
-- Delivery duration
-- Average speed
-- Total number of pizzas





