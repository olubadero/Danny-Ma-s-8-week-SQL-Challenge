## 2. Digital Analysis
Using the available datasets - answer the following questions using a single query for each one:

1. How many users are there?

```sql
SELECT  COUNT(DISTINCT user_id) AS Total_Users
FROM users;
```

| Total_Users | 
| ----------- | 
| 500 |

  
2. How many cookies does each user have on average?

 ```sql
WITH Cookie_Count AS (SELECT user_id, count(cookie_id)AS Total_Cookie_ID
					  FROM users
					  GROUP BY user_id)
SELECT ROUND(AVG(Total_Cookie_ID)) Average_Cookies
FROM Cookie_Count;
```

| Average_Cookies | 
| ----------- | 
| 4 |

 
3. What is the unique number of visits by all users per month?

 ```sql
SSELECT MONTHNAME(event_time) AS Month,  COUNT(DISTINCT visit_id) AS unique_visits
FROM events
GROUP BY MONTHNAME(event_time)
ORDER BY unique_visits DESC;
```

| Month | Unique_visits |
| ----------- | ----------- |
|February | 1488 |
| March | 916 |
| January | 876 |
| April | 248 |
| May | 36 |


4. What is the number of events for each event type?
 
 ```sql
SELECT event_type, event_name, COUNT(*) AS total_events
FROM events
JOIN event_identifier
USING (event_type)
GROUP BY event_type, event_name;
```
| event_type |	event_name | total_events | 
| ----------- | ----------- | -----------| 
| 1			| Page View		| 20928 | 
| 2			| Add to Cart	| 8451 | 
| 3			| Purchase | 	1777 | 
| 4			| Ad Impression	| 876 | 
| 5			| Ad Click	| 702 | 
 
5. What is the percentage of visits which have a purchase event?
- There are two ways this can be solved and they are:
- Method 1:

```sql
SELECT CONCAT(ROUND(COUNT(DISTINCT visit_id)/(SELECT COUNT(DISTINCT visit_id) FROM events) * 100, 2), '%') AS purchase_percentage
FROM events
JOIN event_identifier
USING(event_type)
WHERE event_name = 'Purchase';
```
- Method 2:

```sql
WITH all_events AS (SELECT * 
			FROM events
			JOIN event_identifier
			USING(event_type)),
            
	purchased_events AS (SELECT * 
			FROM events
			JOIN event_identifier
			USING(event_type)
			WHERE event_name = 'Purchase')
            
SELECT CONCAT(ROUND((SELECT COUNT(DISTINCT visit_id) FROM Purchased_events)/COUNT(DISTINCT visit_id) * 100, 2), '%') AS purchase_percentage
FROM all_events;
 ```

| purchase_percentage | 
| ----------- | 
| 49.86% |

6. What is the percentage of visits which view the checkout page but do not have a purchase event?
 
 ```sql
WITH Actions AS(SELECT  visit_id, 
				CASE WHEN event_name = 'Page View' AND page_name ='checkout' THEN 1 ELSE 0 END AS checkouts,
                CASE WHEN event_name = 'Purchase'  THEN 1 ELSE 0 END AS purchases
				FROM events
				RIGHT JOIN event_identifier
				USING (event_type)
				JOIN page_hierarchy
				USING (page_id))
                
SELECT CONCAT(ROUND((1 - SUM(purchases)/SUM(checkouts))*100, 2), '%') AS Checkout_no_purchase_percentage
FROM Actions;
```

| Checkout_no_purchase_percentage | 
| ----------- | 
| 15.50% |
 
7. What are the top 3 pages by number of views?
 
 ```sql
SELECT page_id, page_name, COUNT(*) AS views
FROM events 
JOIN event_identifier 
USING (event_type)
JOIN page_hierarchy 
USING(page_id)
WHERE event_name = 'Page View'
GROUP BY page_id, page_name
ORDER BY views DESC
LIMIT 3;
```

| page_id |	page_name | views | 
| ----------- | ----------- | -----------| 
| 2			| All Products		| 3174 | 
| 12			| Checkout	| 2103 | 
| 1			| Page | 	1782 | 
 
8. What is the number of views and cart adds for each product category?
 
```sql
SELECT Product_Category, 
		SUM(IF(event_name = 'Page View', 1, 0)) AS Total_Page_View, 
        SUM(IF(event_name = 'Add to Cart', 1, 0)) AS Total_Add_to_Cart
FROM events
JOIN event_identifier
USING (event_type)
JOIN page_hierarchy
USING (page_id)
WHERE product_id IS NOT NULL
GROUP BY product_category
ORDER BY product_category;
```

| Product_Category	| Total_Page_View	| Total_Add_to_Cart |
| ----------- | ----------- | ----------- | 
| Fish |			4633			| 2789 |
| Luxury			| 3032			| 1870 |
| Shellfish		| 6204			| 3792 |
 
9. What are the top 3 products by purchases?
 
 - There are two ways this can be solved and they are:
- Method 1:

```sql
WITH all_purchases AS (
			SELECT visit_id
			FROM events
			JOIN event_identifier
			USING (event_type)
			WHERE event_name = 'Purchase') -- First extract the visit_id of those that purchased as its unique
        
SELECT page_name, count(*) AS Top_3_Purchases
	FROM page_hierarchy AS ph
JOIN events AS e 
	ON e.page_id = ph.page_id
JOIN all_purchases AS ap 
	ON e.visit_id = ap.visit_id
WHERE ph.product_category IS NOT NULL -- These are null values  
	AND ph.page_id NOT in('1', '2', '12', '13') -- These are null values  
	AND ap.visit_id = e.visit_id 
    AND event_type = 2 -- Items added to cart
    GROUP BY page_name
    order by Top_3_Purchases DESC
    LIMIT 3;
```
- Method 2:

```sql
WITH all_purchases AS (
			SELECT visit_id
			FROM events
			JOIN event_identifier
			USING (event_type)
			WHERE event_name = 'Purchase')
        
SELECT ph.page_name,
	sum(CASE WHEN ei.event_name = 'Add to Cart' THEN 1 ELSE 0 END) AS top_3_purchased
FROM events AS e
JOIN page_hierarchy AS ph
	ON e.page_id = ph.page_id
JOIN all_purchases AS ap 
	ON e.visit_id = ap.visit_id
JOIN event_identifier as ei
	ON ei.event_type = e.event_type
WHERE ph.product_category IS NOT NULL
	AND ph.page_id NOT in('1', '2', '12', '13')
	AND ap.visit_id = e.visit_id
GROUP BY ph.page_name
ORDER BY top_3_purchased DESC
LIMIT 3;

 ```

| page_name	| top_3_purchased |
| ----------- | ----------- | 
| Lobster	| 754 |
| Oyster	| 726 |
| Crab	| 719 |


 
 
