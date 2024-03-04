## 3. Product Funnel Analysis

Using a single SQL query - create a new output table which has the following details:

How many times was each product viewed?
How many times was each product added to cart?
How many times was each product added to a cart but not purchased (abandoned)?

```sql
CREATE TABLE product_info AS (
					WITH product_viewed AS (
						SELECT ph.page_id,
							sum(CASE WHEN event_type = 1 THEN 1 ELSE 0 END) AS page_views,
							sum(CASE WHEN event_type = 2 THEN 1 ELSE 0 END) AS added_to_cart
						FROM page_hierarchy AS ph
							JOIN events AS e ON ph.page_id = e.page_id
						WHERE ph.product_id IS NOT NULL
						GROUP BY ph.page_id),
					
					product_purchased AS (
						SELECT e.page_id,
							sum(CASE WHEN event_type = 2 THEN 1 ELSE 0 END) AS purchased_from_cart
						FROM page_hierarchy AS ph
							JOIN events AS e ON ph.page_id = e.page_id
						WHERE ph.product_id IS NOT NULL
							AND exists(
								SELECT visit_id
								FROM events
								WHERE event_type = 3
									AND e.visit_id = visit_id)
							AND ph.page_id NOT IN (1, 2, 12, 13)
						GROUP BY e.page_id),
						
					product_abandoned AS (
						SELECT e.page_id,
							sum(CASE WHEN event_type = 2 THEN 1 ELSE 0 END ) AS abandoned_in_cart
						FROM page_hierarchy AS ph
						JOIN events AS e ON ph.page_id = e.page_id
						WHERE ph.product_id IS NOT NULL
							AND NOT exists(
								SELECT visit_id
								FROM clique_bait.events
								WHERE event_type = 3
									AND e.visit_id = visit_id) -- not in the purchased items 
							AND ph.page_id NOT IN (1, 2, 12, 13)
						GROUP BY e.page_id)
    
SELECT ph.page_id,
		ph.page_name,
		ph.product_category,
		pv.page_views,
		pv.added_to_cart,
		pp.purchased_from_cart,
		pa.abandoned_in_cart
FROM page_hierarchy AS ph
		JOIN product_viewed AS pv ON pv.page_id = ph.page_id
		JOIN product_purchased AS pp ON pp.page_id = ph.page_id
		JOIN product_abandoned AS pa ON pa.page_id = ph.page_id
);
);
```

- Here is the created table
```sql
SELECT * 
FROM product_info;
```

![Screenshot 2024-03-04 at 10 32 42](https://github.com/olubadero/Danny_Mas_8-week_SQL_Challenge/assets/111298078/5516cbdd-6aad-451f-9750-f4550fc3422a)


How many times was each product purchased? Additionally, create another table which further aggregates the data for the above points but this time for each product category instead of individual products.

```sql
CREATE TABLE category_info AS (
	SELECT product_category,
		sum(page_views) AS total_page_views,
		sum(added_to_cart) AS total_cart_add,
		sum(purchased_from_cart) AS total_purchase,
		sum(abandoned_in_cart) AS total_abandoned
	FROM product_info
	GROUP BY product_category
);
```
- Here is the created table
  
```sql
SELECT * 
FROM Category_info;
```
<img width="452" alt="Screenshot 2024-03-04 at 10 34 26" src="https://github.com/olubadero/Danny_Mas_8-week_SQL_Challenge/assets/111298078/93ae89a6-7f67-4e60-a3bc-028d202793f0">


Use your 2 new output tables - answer the following questions:

1. Which product had the most views, cart adds and purchases?

```sql
SELECT page_name, 'Most Viewed' As Category_Won
FROM product_info
WHERE page_views =	(SELECT MAX(page_views) FROM product_info)
UNION
SELECT page_name, 'Most Added to Cart'
FROM product_info
WHERE added_to_cart =	(SELECT MAX(added_to_cart) FROM product_info)
UNION
SELECT page_name, 'Most Purchased'
FROM product_info
WHERE purchased_from_cart =	(SELECT MAX(purchased_from_cart) FROM product_info);
```
 | Product	| Category_Won |
 | ----------- | ----------- |
| Oyster	| Most Viewed |
| Lobster	Most | Added to Cart |
| Lobster	Most | Purchased |

2. Which product was most likely to be abandoned?
```sql
SELECT page_name, CONCAT(ROUND((1-(purchased_from_cart/added_to_cart)) *100,2), '%') AS Most_Likely_to_be_Abandoned
FROM product_info
ORDER BY Most_Likely_to_be_Abandoned DESC
LIMIT 1;
```

 | page_name	| Most_Likely_to_be_Abandoned |
 | ----------- | ----------- |
| Russian Caviar	| 26.32% |

3. Which product had the highest view to purchase percentage?
```sql
SELECT page_name, CONCAT(ROUND((purchased_from_cart/page_views)*100, 2), '%') AS View_purchase_percentage
FROM product_info
ORDER BY View_purchase_percentage DESC
LIMIT 1;
```
 | page_name	| View_purchase_percentage |
 | ----------- | ----------- |
| Lobster	| 48.74% |

4. What is the average conversion rate from view to cart add?

```sql
SELECT CONCAT(ROUND(AVG((added_to_cart/page_views)*100), 2), '%')  AS average_conversion_rate
FROM product_info;
```
| average_conversion_rate |
 | ----------- |
|  60.95% |



5. What is the average conversion rate from cart add to purchase?

```sql
SELECT CONCAT(ROUND(AVG((purchased_from_cart/added_to_cart)*100), 2), '%')  AS average_conversion_rate
FROM product_info;
```

| average_conversion_rate |
 | ----------- |
|  75.93% |
