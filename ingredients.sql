
-- What are the standard ingredients for each pizza?
SELECT Pizza_Name, GROUP_CONCAT(toppings_name) as Standard_ingredients
FROM(SELECT *
	FROM(SELECT * 
	FROM pizza_runner.pizza_recipe as recipe
	INNER JOIN pizza_runner.pizza_name as name
    USING (pizza_id)) as pizza
	INNER JOIN pizza_runner.pizza_toppings 
	USING (toppings)) as pizza_ingredients
GROUP BY pizza_name;
-- pizza_name, Standard_ingredients
 #'Meatlovers', 'Bacon,BBQ Sauce,Beef,Cheese,Chicken,Mushrooms,Pepperoni,Salami'
 # 'Vegetarian', 'Cheese,Mushrooms,Onions,Peppers,Tomatoes,Tomato Sauce'


-- What was the most commonly added extra?
SELECT PT.toppings_name, X.Number_of_Requests
FROM (SELECT extras as Requested_Extras, count(*) as Number_of_Requests
		FROM customer_order_temp
		WHERE Extras IS NOT NULL
		GROUP BY extras
		ORDER BY 2 DESC) AS x
INNER JOIN pizza_toppings as PT
ON x.Requested_Extras = PT.toppings
ORDER BY 3 DESC
LIMIT 1;
-- Bacon 5 times


-- What was the most common exclusion?

SELECT PT.toppings_name, X.Number_of_Requests
FROM (SELECT exclusions as Requested_Exclusions, count(*) as Number_of_Requests
		FROM customer_order_temp
		WHERE Exclusions IS NOT NULL
		GROUP BY exclusions
		ORDER BY 2 DESC) AS x
INNER JOIN pizza_toppings as PT
ON x.Requested_Exclusions = PT.toppings
ORDER BY 2 DESC
LIMIT 1;
-- Cheese 5 times