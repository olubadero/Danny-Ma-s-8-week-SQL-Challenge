
USE balanced_tree;

-- High Level Sales Analysis

-- What was the total quantity sold for all products?
SELECT SUM(qty) as total_quantity
FROM sales;

# total_quantity
-- '45216';

SELECT s.prod_id, pd.product_name, SUM(s.qty) as Quantity_sold
FROM sales as s
JOIN product_details as pd
ON s.prod_id = pd.product_id
GROUP BY s.prod_id, pd.product_name
ORDER BY Quantity_sold DESC;

-- # prod_id	product_name				Quantity_sold
-- 9ec847	Grey Fashion Jacket - Womens	3876
-- c4a632	Navy Oversized Jeans - Womens	3856
-- 2a2353	Blue Polo Shirt - Mens			3819
-- 5d267b	White Tee Shirt - Mens			3800
-- f084eb	Navy Solid Socks - Mens			3792
-- e83aa3	Black Straight Jeans - Womens	3786
-- 2feb6b	Pink Fluro Polkadot Socks - Mens	3770
-- 72f5d4	Indigo Rain Jacket - Womens		3757
-- d5e9a6	Khaki Suit Jacket - Womens		3752
-- e31d39	Cream Relaxed Jeans - Womens	3707
-- b9a74d	White Striped Socks - Mens		3655
-- c8d436	Teal Button Up Shirt - Mens		3646


-- What is the total generated revenue for all products before discounts?
SELECT SUM(qty * price) as total_revenue
FROM sales;
-- # total_revenue
-- 1289453

-- Generated Revenue by product 
SELECT s.prod_id, pd.product_name, SUM(s.qty * s.price) as Generated_Revenue
FROM sales as s
JOIN product_details as pd
ON s.prod_id = pd.product_id
GROUP BY s.prod_id, pd.product_name
ORDER BY Generated_Revenue DESC;

-- # prod_id	product_name			Generated_Revenue
-- 2a2353	Blue Polo Shirt - Mens			217683
-- 9ec847	Grey Fashion Jacket - Womens	209304
-- 5d267b	White Tee Shirt - Mens			152000
-- f084eb	Navy Solid Socks - Mens			136512
-- e83aa3	Black Straight Jeans - Womens	121152
-- 2feb6b	Pink Fluro Polkadot Socks - Mens	109330
-- d5e9a6	Khaki Suit Jacket - Womens		86296
-- 72f5d4	Indigo Rain Jacket - Womens		71383
-- b9a74d	White Striped Socks - Mens		62135
-- c4a632	Navy Oversized Jeans - Womens	50128
-- e31d39	Cream Relaxed Jeans - Womens	37070
-- c8d436	Teal Button Up Shirt - Mens		36460


-- What was the total discount amount for all products?
SELECT ROUND(SUM(discount * qty * price)/100, 2)  as total_discount
FROM sales;
-- # total_discount
-- 156229.14

-- Discount by product 
SELECT s.prod_id, pd.product_name, ROUND(SUM(s.discount * s.qty * s.price)/100, 2)  as product_discount
FROM sales as s
JOIN product_details as pd
ON s.prod_id = pd.product_id
GROUP BY s.prod_id, pd.product_name
ORDER BY product_discount DESC;

-- # prod_id	product_name			product_discount
-- 2a2353	Blue Polo Shirt - Mens			26819.07
-- 9ec847	Grey Fashion Jacket - Womens	25391.88
-- 5d267b	White Tee Shirt - Mens			18377.60
-- f084eb	Navy Solid Socks - Mens			16650.36
-- e83aa3	Black Straight Jeans - Womens	14744.96
-- 2feb6b	Pink Fluro Polkadot Socks - Mens	12952.27
-- d5e9a6	Khaki Suit Jacket - Womens		10243.05
-- 72f5d4	Indigo Rain Jacket - Womens		8642.53
-- b9a74d	White Striped Socks - Mens		7410.81
-- c4a632	Navy Oversized Jeans - Womens	6135.61
-- e31d39	Cream Relaxed Jeans - Womens	4463.40
-- c8d436	Teal Button Up Shirt - Mens		4397.60


-- Transaction Analysis
-- How many unique transactions were there?
SELECT COUNT(DISTINCT txn_id) AS unique_transactions
FROM sales;
-- # unique_transactions
-- 2500


-- What is the average unique products purchased in each transaction?
WITH count AS (SELECT txn_id, COUNT(DISTINCT prod_id) as unique_products
		FROM sales
		GROUP BY txn_id)
SELECT FLOOR(AVG(unique_products)) AS average_unique_products
FROM count;

-- # average_unique_products
-- 6


-- What are the 25th, 50th and 75th percentile values for the revenue per transaction?


-- What is the average discount value per transaction?
WITH total_revenue AS(SELECT txn_id,  SUM(discount/100 * qty * price) AS discount_revenue
		FROM sales
		GROUP BY txn_id)
SELECT ROUND(AVG(discount_revenue), 2) average_per_transaction
FROM total_revenue;

-- # average_per_transaction
-- 62.49

-- What is the percentage split of all transactions for members vs non-members?

SELECT CASE WHEN member = "T" THEN "Member"
		WHEN member = "F" THEN "Non-Member" 
        END as Membership,
        ROUND(COUNT(DISTINCT Txn_id)/(SELECT COUNT(DISTINCT txn_id) FROM sales) * 100, 2) AS percentage
FROM sales
GROUP BY member
ORDER BY percentage DESC;

-- # Membership	percentage
-- Member		60.20
-- Non-Member	39.80

-- What is the average revenue for member transactions and non-member transactions?
-- Before discount
WITH Revenue AS (SELECT CASE WHEN member = "T" THEN "Member"
		WHEN member = "F" THEN "Non-Member" 
		END as Membership, txn_id, SUM(qty * price) as total_revenue
		FROM sales
		GROUP BY 1, 2)
SELECT membership, ROUND(AVG(total_revenue), 2) as Average_Revenue
FROM Revenue
GROUP BY 1;
-- # membership	Average_Revenue
-- Member		516.27
-- Non-Member	515.04


-- After discount
WITH Revenue AS (SELECT CASE WHEN member = "T" THEN "Member"
		WHEN member = "F" THEN "Non-Member" 
		END as Membership, txn_id, SUM((1 - discount/100) * qty * price) as discount
		FROM sales
		GROUP BY 1, 2)
SELECT membership, ROUND(AVG(discount), 2) as Average_Revenue
FROM Revenue
GROUP BY 1;

-- # membership	Average_Revenue
-- Member		454.14
-- Non-Member	452.01

-- Product Analysis
-- What are the top 3 products by total revenue before discount?

SELECT s.prod_id, pd.product_name, SUM(s.qty * s.price) AS total_revenue
FROM sales as s
JOIN product_details as pd
ON s.prod_id = pd.product_id
GROUP BY 1, 2
ORDER BY total_revenue DESC
LIMIT 3;

-- # prod_id	product_name			total_revenue
-- 2a2353	Blue Polo Shirt - Mens			217683
-- 9ec847	Grey Fashion Jacket - Womens	209304
-- 5d267b	White Tee Shirt - Mens			152000


-- What is the total quantity, revenue and discount for each segment?
SELECT pd.segment_id, pd.segment_name, SUM(s.qty) AS total_quantity, 
		ROUND(SUM(s.qty * s.price * (1 - discount/100)), 2) AS total_revenue, ROUND(SUM((discount/100) * s.qty * s.price), 2) as total_discount
FROM sales as s
JOIN product_details as pd 
ON s.prod_id = pd.product_id
GROUP BY 1, 2
ORDER BY 1;

-- # segment_id	segment_name	total_quantity	total_revenue	total_discount
-- 		3		Jeans			11349			183006.03			25343.97
-- 		4		Jacket			11385			322705.54			44277.46
-- 		5		Shirt			11265			356548.73			49594.27
-- 		6		Socks			11217			270963.56			37013.44


-- What is the top selling product for each segment?
-- Top sellin by Quantity sold
WITH Ranks AS (SELECT pd.segment_id, pd.segment_name, s.prod_id, pd.product_name, 
	SUM(s.qty) AS total_sales, 
    RANK() OVER(PARTITION BY pd.segment_name ORDER BY SUM(s.qty) DESC) AS Ranking
	FROM sales as s
	JOIN product_details as pd
	ON s.prod_id = pd.product_id
	GROUP BY 1, 2, 3, 4)
SELECT segment_id, segment_name, product_name, total_sales
FROM Ranks
WHERE Ranking = 1
ORDER BY 1;

-- # segment_id	segment_name	product_name			total_sales
-- 	3			Jeans		Navy Oversized Jeans - Womens	3856
-- 	4			Jacket		Grey Fashion Jacket - Womens	3876
-- 	5			Shirt		Blue Polo Shirt - Mens			3819
-- 	6			Socks		Navy Solid Socks - Mens			3792

-- Top selling by revenue
WITH Ranks AS (SELECT pd.segment_id, pd.segment_name, s.prod_id, pd.product_name, 
	ROUND(SUM(s.qty * s.price * (1 - discount/100)), 2) AS total_revenue, 
    RANK() OVER(PARTITION BY pd.segment_name ORDER BY SUM(s.qty * s.price * (1 - discount/100)) DESC) AS Ranking
	FROM sales as s
	JOIN product_details as pd
	ON s.prod_id = pd.product_id
	GROUP BY 1, 2, 3, 4)
SELECT segment_id, segment_name, product_name, total_revenue
FROM Ranks
WHERE Ranking = 1
ORDER BY 1;

-- # segment_id	segment_name	product_name		total_revenue
-- 	3			Jeans	Black Straight Jeans - Womens	106407.04
-- 	4			Jacket	Grey Fashion Jacket - Womens	183912.12
-- 	5			Shirt	Blue Polo Shirt - Mens			190863.93
-- 	6			Socks	Navy Solid Socks - Mens			119861.64


-- What is the total quantity, revenue and discount for each category?
SELECT pd.category_id, pd.category_name, SUM(s.qty) AS total_quantity, 
		SUM(s.qty * s.price) AS total_revenue, ROUND(SUM((discount/100) * s.qty * s.price), 2) as total_discount
FROM sales as s
JOIN product_details as pd
ON s.prod_id = pd.product_id
GROUP BY 1, 2
ORDER BY 1;

-- # category_id	category_name	total_quantity	total_revenue	total_discount
-- 	1			Womens				22734			575333		69621.43
-- 	2			Mens				22482			714120		86607.71


-- What is the top selling product for each category?
WITH Ranks AS (SELECT pd.category_id, pd.category_name, s.prod_id, pd.product_name, 
	SUM(s.qty) AS total_sales, 
    RANK() OVER(PARTITION BY pd.category_name ORDER BY SUM(s.qty) DESC) AS Ranking
	FROM sales as s
	JOIN product_details as pd
	ON s.prod_id = pd.product_id
	GROUP BY 1, 2, 3, 4)
SELECT category_id, category_name, product_name, total_sales
FROM Ranks
WHERE Ranking = 1
ORDER BY 1;

-- # category_id	category_name	product_name		total_sales
-- 	1			Womens	Grey Fashion Jacket - Womens	3876
-- 	2			Mens	Blue Polo Shirt - Mens			3819

-- What is the percentage split of revenue by product for each segment?
WITH revenue AS (SELECT pd.segment_id, pd.segment_name, s.prod_id, pd.product_name, ROUND(SUM((1 - discount/100) * s.qty * s.price), 2) AS product_revenue
		FROM sales as s
		JOIN product_details as pd
		ON s.prod_id = pd.product_id
		GROUP BY 1, 2, 3, 4)
SELECT segment_id, segment_name, prod_id, product_name, product_revenue,
		ROUND(product_revenue/SUM(product_revenue) OVER(PARTITION BY segment_id) *100, 2) AS percentage_split
FROM revenue 
GROUP BY 1, 2, 3, 4
ORDER BY 1, 6 DESC;

-- segment_id	segment_name	prod_id	product_name					product_revenue	percentage_split
-- 3			Jeans			e83aa3	Black Straight Jeans - Womens	106407.04		58.14
-- 3			Jeans			c4a632	Navy Oversized Jeans - Womens	43992.39		24.04
-- 3			Jeans			e31d39	Cream Relaxed Jeans - Womens	32606.60		17.82
-- 4			Jacket			9ec847	Grey Fashion Jacket - Womens	183912.12		56.99
-- 4			Jacket			d5e9a6	Khaki Suit Jacket - Womens		76052.95		23.57
-- 4			Jacket			72f5d4	Indigo Rain Jacket - Womens		62740.47		19.44
-- 5			Shirt			2a2353	Blue Polo Shirt - Mens			190863.93		53.53
-- 5			Shirt			5d267b	White Tee Shirt - Mens			133622.40		37.48
-- 5			Shirt			c8d436	Teal Button Up Shirt - Mens		32062.40		8.99
-- 6			Socks			f084eb	Navy Solid Socks - Mens			119861.64		44.24
-- 6			Socks			2feb6b	Pink Fluro Polkadot Socks - Mens	96377.73	35.57
-- 6			Socks			b9a74d	White Striped Socks - Mens		54724.19		20.20


-- What is the percentage split of revenue by segment for each category?
WITH revenue AS (SELECT pd.category_id, pd.category_name, pd.segment_id, pd.segment_name, ROUND(SUM((1 - discount/100) * s.qty * s.price), 2) AS product_revenue
		FROM sales as s
		JOIN product_details as pd
		ON s.prod_id = pd.product_id
		GROUP BY 1, 2, 3, 4)
SELECT segment_id, segment_name, category_id, category_name, product_revenue,
		ROUND(product_revenue/SUM(product_revenue) OVER(PARTITION BY category_id) *100, 2) AS percentage_split
FROM revenue 
GROUP BY 1, 2, 3, 4
ORDER BY 1, 6 DESC;

-- segment_id	segment_name	category_id	category_name	product_revenue	percentage_split
-- 	3		Jeans				1		Womens				183006.03		36.19
-- 	4		Jacket				1		Womens				322705.54		63.81
-- 	5		Shirt				2		Mens				356548.73		56.82
-- 	6		Socks				2		Mens				270963.56		43.18

-- What is the percentage split of total revenue by category?
WITH revenue AS (SELECT pd.category_id, pd.category_name, ROUND(SUM((1 - discount/100) * s.qty * s.price), 2) AS revenue
		FROM sales as s
		JOIN product_details as pd
		ON s.prod_id = pd.product_id
		GROUP BY 1, 2)
SELECT category_name, revenue,
		ROUND(revenue/(SELECT SUM(revenue) FROM revenue) *100, 2) AS percentage_split
FROM revenue 
GROUP BY 1, 2
ORDER BY 3 DESC;

-- category_name	revenue		percentage_split
-- Mens				627512.29	55.37
-- Womens			505711.57	44.63

-- What is the total transaction “penetration” for each product?
-- (hint: penetration = number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions)
WITH COUNT AS (SELECT pd.product_id, pd.product_name, count(DISTINCT txn_id) AS unique_transactions,
			(SELECT count(DISTINCT txn_id)FROM balanced_tree.sales) AS total_transactions
		FROM balanced_tree.sales AS s
		JOIN balanced_tree.product_details AS pd ON pd.product_id = s.prod_id
		GROUP BY pd.product_id,
			pd.product_name)
SELECT product_name,
	unique_transactions AS n_items_sold,
	round(100 * (unique_transactions/ total_transactions), 2) AS penetration
from COUNT
GROUP BY product_name, n_items_sold, penetration
ORDER BY penetration DESC;

-- product_name				n_items_sold	penetration
-- Navy Solid Socks - Mens			1281	51.24
-- Grey Fashion Jacket - Womens		1275	51.00
-- Navy Oversized Jeans - Womens	1274	50.96
-- Blue Polo Shirt - Mens			1268	50.72
-- White Tee Shirt - Mens			1268	50.72
-- Pink Fluro Polkadot Socks - Mens	1258	50.32
-- Indigo Rain Jacket - Womens		1250	50.00
-- Khaki Suit Jacket - Womens		1247	49.88
-- Black Straight Jeans - Womens	1246	49.84
-- White Striped Socks - Mens		1243	49.72
-- Cream Relaxed Jeans - Womens		1243	49.72
-- Teal Button Up Shirt - Mens		1242	49.68


-- What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?
