
USE Dannys_diner;

SELECT *
FROM members;

SELECT *
FROM menu;

SELECT *
FROM sales;

-- What is the total amount each customer spent at the restaurant?
SELECT customer_id, CONCAT('$', SUM(price)) AS total_spend
FROM sales
JOIN menu
USING (product_id)
GROUP BY customer_id
ORDER BY customer_id;
 -- A is $76, B is $74, C is $36
 

-- How many days has each customer visited the restaurant?
SELECT customer_id, COUNT(distinct Order_date) AS visit_days
FROM sales
GROUP BY customer_id;
-- A is 4, B is 6, C is 2

-- What was the first item from the menu purchased by each customer?
WITH purchase AS(
					SELECT customer_id, product_name, order_date,
							DENSE_RANK () OVER(PARTITION BY customer_id ORDER BY order_date) AS Orders
					FROM Sales
					JOIN menu
					USING (product_id))
SELECT customer_id, product_name
FROM purchase
WHERE Orders = 1;
-- A is Sushi and Curry; B is Curry; C is Ramen (2x)

-- What is the most purchased item on the menu and how many times was it purchased by all customers?
WITH customer_order AS (SELECT *
						FROM Sales
						JOIN menu
						USING (product_id)),
	most_purchased AS (SELECT product_name, count(*) AS X
						FROM Sales
						JOIN menu
						USING (product_id)
						GROUP BY product_name
						ORDER BY X DESC
						LIMIT 1)

SELECT customer_id, COUNT(*) AS total_ramen_purchased
FROM customer_order 
JOIN most_purchased
USING(product_name)
GROUP BY customer_id;
-- Most purchased item is Ramen and it was purchased 8 times, 
-- A and C ordered it 3x respectively and B ordered it 2x


-- Which item was the most popular for each customer?
WITH popularity AS(
				SELECT customer_id, product_name, COUNT(product_name) AS order_times,
						dense_rank() OVER(PARTITION BY Customer_id ORDER BY COUNT(product_name) DESC) AS order_ranking
				FROM Sales
				JOIN menu
				USING (product_id)
				GROUP BY customer_id, product_name)
SELECT customer_id, product_name
FROM popularity
WHERE order_ranking = 1;
-- The most popular item for A is Ramen; for B it is Curry, Sushi and Ramen; and for C is Ramen


-- Which item was purchased first by the customer after they became a member?
WITH First_order AS(				
                SELECT customer_id, join_date, order_date, product_name, 
						DENSE_RANK() OVER(partition by Customer_id ORDER BY order_date) AS order_standing
				FROM Sales
				LEFT JOIN menu
				USING (product_id)
				LEFT JOIN members
				USING (Customer_id)
				WHERE order_date >= join_date)
SELECT customer_id, product_name
FROM First_order
WHERE order_standing = 1;
-- Only A and B joined and their first orders were Curry and Sushi respectively


-- Which item was purchased just before the customer became a member?
WITH prior_purchase AS(
			SELECT customer_id, join_date, order_date, product_name, 
									DENSE_RANK() OVER(partition by Customer_id ORDER BY order_date DESC) AS order_standing
			FROM Sales
			LEFT JOIN menu
			USING (product_id)
			LEFT JOIN members
			USING (Customer_id)
			WHERE order_date < join_date)
SELECT customer_id, product_name
FROM prior_purchase
WHERE order_standing = 1;
-- The item purchased before joining by A is Sushi and Curry, whilst B is Sushi

-- What is the total items and amount spent for each member before they became a member?
SELECT customer_id, COUNT(DISTINCT product_id) AS total_item, CONCAT('$', SUM(price)) AS total_spend
FROM Sales
LEFT JOIN menu
USING (product_id)
LEFT JOIN members
USING (Customer_id)
WHERE order_date < join_date
GROUP BY customer_id;
-- A ordered twice and spent $25, B ordered twice and spent $40


-- If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT customer_id, SUM(CASE WHEN product_name = 'Sushi' THEN PRICE * 20
			ELSE PRICE * 10
            END) AS Points_Accrued
FROM Sales
JOIN menu
USING (product_id)
GROUP BY customer_id;
-- A has 860 points, B has 940 points, C has 360 points 


-- In the first week after a customer joins the program (including their join date) they earn 2x points on all items, 
-- not just sushi - how many points do customer A and B have at the end of January?
SELECT customer_id, SUM(CASE WHEN product_name = 'Sushi' THEN PRICE * 20
			WHEN datediff(join_date, order_date) <= 7 THEN PRICE * 20
            ELSE PRICE * 10
            END) AS Points_Accrued 
FROM Sales
JOIN menu
USING (product_id) 
JOIN members
USING (Customer_id)
WHERE MONTHNAME(order_date) = 'January'
GROUP BY customer_id
ORDER BY customer_id;
-- A has 1520 points, B has 1090 points. 


