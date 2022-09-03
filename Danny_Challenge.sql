SELECT * FROM Danny.memberships;
INSERT INTO Danny.memberships 
VALUES ('A', '2021-01-07'), ('B', '2021-01-09');

SELECT * FROM Danny.menu;
INSERT INTO menu
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  
SELECT * FROM Danny.sales;
INSERT INTO sales
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
  
  
  SELECT * FROM Danny.sales;
  SELECT * FROM Danny.menu;
  SELECT * FROM Danny.memberships;


-- What is the total amount each customer spent at the restaurant?
  SELECT customer_id, SUM(DM.price) as Total_Spent
  FROM Danny.sales as DS
  RIGHT JOIN Danny.Menu as DM
  ON DS.product_id = DM.product_id
  GROUP BY customer_id
  ORDER BY Total_Spent DESC;
  -- A is $76, B is $74, C is $36
  
-- How many days has each customer visited the restaurant?
SELECT customer_id, count(distinct(order_date)) as Number_of_Visits
FROM Danny.sales
GROUP BY customer_id
ORDER BY Number_of_visits DESC;
-- A is 4, B is 6, C is 2

-- What was the first item from the menu purchased by each customer?
 SELECT Customer_id, product_name as first_purchased_item
 FROM(SELECT customer_id, order_date, ds.product_id, product_name, 
 DENSE_RANK() OVER(PARTITION BY CUSTOMER_ID ORDER BY order_date) as Purchases
  FROM Danny.sales as DS
  RIGHT JOIN Danny.Menu as DM
  ON DS.product_id = DM.product_id) as x
  where x.purchases = 1
  GROUP BY CUSTOMER_ID, first_purchased_item;
-- A is Sushi and Curry; B is Curry; C is Ramen

-- What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT ds.product_id, product_name, count(product_name) as Most_purchased_item
FROM Danny.sales as DS
RIGHT JOIN Danny.Menu as DM
ON DS.product_id = DM.product_id
GROUP BY ds.product_id, product_name
ORDER BY most_purchased_item DESC
LIMIT 1;
-- Most purchased item is Ramen, purchased 8 times

-- Which item was the most popular for each customer?
SELECT Customer_id, product_name, orders
FROM (SELECT customer_id, product_name, count(ds.product_id) as orders,
	Dense_Rank() OVER(PARTITION BY customer_id ORDER BY count(ds.product_id) DESC) as Popular_item
	FROM Danny.sales as DS
	RIGHT JOIN Danny.Menu as DM
	ON DS.product_id = DM.product_id
	GROUP BY customer_id, product_name) AS X
WHERE X.Popular_item = 1;
-- A is Ramen; B is every product; C is Ramen
    
-- Which item was purchased first by the customer after they became a member?
SELECT customer_id, product_name, order_date
FROM(SELECT customer_id, product_id, order_date, join_date
	FROM(SELECT ds.customer_id, ds.product_id, ds.order_date, dm.join_date, 
	Row_number() OVER(PARTITION BY ds.customer_id order by ds.order_date) as purchased_item
	FROM Danny.sales as DS
	RIGHT JOIN Danny.Memberships as DM
	ON DS.customer_id = DM.customer_id
	WHERE ds.order_date >= dm.join_date) AS X
	WHERE X.purchased_item = 1) as first_purchase
JOIN Danny.Menu as menu
ON first_purchase.product_id = menu.product_id;
-- Only A and B joined and their first order is Curry and Sushi respectively

-- Which item was purchased just before the customer became a member?
SELECT customer_id, product_name, order_date
FROM(SELECT customer_id, product_id, order_date, join_date
FROM(SELECT ds.customer_id, ds.product_id, ds.order_date, dm.join_date, 
	Dense_Rank() OVER(PARTITION BY ds.customer_id order by ds.order_date DESC) as purchased_item
	FROM Danny.sales as DS
	RIGHT JOIN Danny.Memberships as DM
	ON DS.customer_id = DM.customer_id
	WHERE ds.order_date < dm.join_date) AS X
WHERE X.purchased_item = 1) as order_before
JOIN Danny.Menu as DM
ON order_before.product_id = DM.product_id;

SELECT Customer_id, product_name, order_date
FROM(SELECT ds.customer_id, ds.product_id, ds.order_date, dm.join_date, 
Dense_Rank() OVER(PARTITION BY ds.customer_id order by ds.order_date DESC) as purchased_item
FROM Danny.sales as DS
RIGHT JOIN Danny.Memberships as DM
ON DS.customer_id = DM.customer_id
WHERE ds.order_date < dm.join_date) AS Order_before
JOIN Danny.Menu as DM
ON Order_before.product_id = DM.product_id
WHERE Order_before.purchased_item = 1;

-- What is the total items and amount spent for each member before they became a member?
WITH Orders AS(SELECT ds.customer_id, ds.product_id, ds.order_date, dm.join_date
FROM Danny.sales as DS
RIGHT JOIN Danny.Memberships as DM
ON DS.customer_id = DM.customer_id
WHERE ds.order_date < dm.join_date)

SELECT orders.customer_id, count(distinct(orders.product_id)) as total_orders, sum(menu.price) as Spend 
FROM Orders
JOIN DANNY.MENU as menu
ON Orders.product_id = menu.product_id
GROUP BY orders.customer_id;
-- A ordered twice and spent $25, B ordered twice and spent $40

-- If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT customer_id, sum(X.customer_points) AS Total_points
FROM(SELECT ds.customer_id, ds.product_id, dm.product_name, dm.price,
	CASE WHEN ds.product_id = 1 THEN price * 20
	ELSE price * 10
	END AS Customer_points
	FROM Danny.Sales as DS
	JOIN Danny.Menu as DM
	ON ds.product_id = dm.product_id) AS X
GROUP BY customer_id
ORDER BY Total_points DESC;
-- A has 860 points, B has 940 points, C has 360 points 
