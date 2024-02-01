USE pizza_runner;

SELECT * FROM runners;
SELECT * FROM New_Customers_Order;
SELECT * FROM pizza_names;
SELECT * FROM pizza_recipes;
SELECT * FROM pizza_toppings;
SELECT * FROM runner_orders;
SELECT * FROM Toppings_Split;
SELECT * FROM split_customer_orders;

			-- C. Ingredient Optimisation
            
-- Split the merged columns and create a new table

CREATE TABLE Toppings_Split AS(
		SELECT t.pizza_id,
			   trim(j.topping) AS topping_id
		FROM pizza_recipes AS t
		JOIN json_table(trim(replace(json_array(t.toppings), ',', '","')),
						'$[*]' columns (topping varchar(50) PATH '$')) j );
                        
          
CREATE TABLE split_customer_orders AS(                
SELECT Order_id, Customer_id, Pizza_ID, Order_Time, c1.exclusions, c2.extras
				FROM New_Customers_Order
				INNER JOIN json_table(trim(replace(json_array(exclusions), ',', '","')),
									  '$[*]' columns (exclusions varchar(50) PATH '$')) AS c1
				INNER JOIN json_table(trim(replace(json_array(extras), ',', '","')),
									  '$[*]' columns (extras varchar(50) PATH '$')) AS c2);  
                                      
-- There is a need to update the newly created table to remove duplicates and change some field information

DELETE FROM split_customer_orders
WHERE Extras = 4 AND Exclusions = 6;

DELETE FROM split_customer_orders
WHERE Extras = 1 AND Exclusions = 6;

UPDATE split_customer_orders
SET Exclusions = 6 
WHERE Extras = 4 AND Exclusions = 2;

UPDATE split_customer_orders
SET Exclusions = NULL 
WHERE Extras = 5 AND Exclusions = 4;
                        
-- What are the standard ingredients for each pizza?
SELECT Pizza_name, REPLACE(GROUP_CONCAT(topping_NAME), ',',', ') AS Standard_Ingredients
FROM Toppings_Split
JOIN pizza_toppings AS PT
	using (topping_id)
JOIN pizza_names AS PN
	using (Pizza_id)
GROUP BY pizza_name;

-- The standard ingredients for both types of pizza are:
-- Pizza_name, 								Standard_Ingredients
-- 'Meatlovers'				'Bacon, BBQ Sauce, Beef, Cheese, Chicken, Mushrooms, Pepperoni, Salami'
-- 'Vegetarian'				'Cheese, Mushrooms, Onions, Peppers, Tomatoes, Tomato Sauce'


-- What was the most commonly added extra?

SELECT DISTINCT topping_name, COUNT(*) AS Most_Common_Extra
FROM split_customer_orders AS cs
JOIN pizza_toppings AS pt
	ON cs.extras = pt.topping_id
WHERE Extras IS NOT NULL
GROUP BY topping_name
ORDER BY Most_Common_Extra DESC
LIMIT 1;

-- Bacon is the most commonly requested extra

-- What was the most common exclusion?

SELECT topping_name, COUNT(*) AS Most_Common_Exclusion
FROM split_customer_orders AS cs
JOIN pizza_toppings AS pt
	ON cs.exclusions = pt.topping_id
WHERE Exclusions IS NOT NULL
GROUP BY topping_name
ORDER BY Most_Common_Exclusion DESC
LIMIT 1;
-- Cheese is the most commonly requested exclusion topping

-- Generate an order item for each record in the customers_orders table in the format of one of the following:
-- Meat Lovers
-- Meat Lovers - Exclude Beef
-- Meat Lovers - Extra Bacon
-- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers



-- Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
-- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"


-- What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

