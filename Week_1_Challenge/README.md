![week 1](https://github.com/olubadero/how_to_document_project/assets/111298078/06dbe3f1-113f-4359-bb14-5985f2628c3d)

# Introduction
Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 3 favourite foods: sushi, curry and ramen.

Danny’s Diner is in need of your assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business.

# Problem Statement
Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.

He plans on using these insights to help him decide whether he should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.

Danny has provided you with a sample of his overall customer data due to privacy issues - but he hopes that these examples are enough for you to write fully functioning SQL queries to help him answer his questions!

Danny has shared with you 3 key datasets for this case study:

- sales
- menu
- members

**You Can view and copy the [Data Schema](https://github.com/olubadero/Danny_Mas_8-week_SQL_Challenge/blob/main/Week_1_Challenge/Dannys_Diner%20Schema.sql) to practice**

---

## Case Study Questions

![answer_questions](https://github.com/olubadero/Danny_Mas_8-week_SQL_Challenge/assets/111298078/99614ad3-dc19-4ca9-bf16-0212f8ff4bcb)

**I will be executing my SQL queries using the MySQL workbench.**

---

Each of the following case study questions can be answered using a single SQL statement:

1. What is the total amount each customer spent at the restaurant?
```sql
SELECT customer_id, CONCAT('$', SUM(price)) AS total_spend
FROM sales
JOIN menu
USING (product_id)
GROUP BY customer_id
ORDER BY customer_id;
```

| Customer_ID| Total_Spend |
| ----------- | ----------- |
| A | $76 |
| B| $74|
| C | $36 |

-- A is $76, B is $74, C is $36

---

2. How many days has each customer visited the restaurant?

 ```sql
SELECT customer_id, COUNT(distinct Order_date) AS visit_days
FROM sales
GROUP BY customer_id;
```

| Customer_ID | Visit_Days |
| ----------- | ----------- |
| A | 4 |
| B | 6 |
| C | 2 |

-- A is 4, B is 6, C is 2

---

3. What was the first item from the menu purchased by each customer?

 ```sql
WITH purchase AS(
					SELECT customer_id, product_name, order_date,
							DENSE_RANK () OVER(PARTITION BY customer_id ORDER BY order_date) AS Orders
					FROM Sales
					JOIN menu
					USING (product_id))
SELECT customer_id, product_name
FROM purchase
WHERE Orders = 1;
```

| Customer_ID | Product_Name |
| ----------- | ----------- |
| A | Sushi |
| A | Curry |
| B | Curry |
| C | Ramen |
| C | Ramen |

-- A is Sushi and Curry; B is Curry; C is Ramen (2x)

---

4. What is the most purchased item on the menu and how many times was it purchased by all customers?

```sql
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
```
| Customer_ID | Total_Ramen_Purchased |
| ----------- | ----------- |
| A | 3 |
| B | 2 |
| C | 3 |


-- Most purchased item is Ramen and it was purchased 8 times, 
-- A and C ordered it 3x respectively and B ordered it 2x

---

5. Which item was the most popular for each customer?

```sql
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
```

| Customer_ID | Product_Name |
| ----------- | ----------- |
| A | Ramen |
| B | Curry |
| B | Sushi |
| B | Ramen |
| C | Ramen |

-- The most popular item for A is Ramen; for B it is Curry, Sushi and Ramen; and for C is Ramen

---

6. Which item was purchased first by the customer after they became a member?

```sql
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
```

| Customer_ID | Product_Name |
| ----------- | ----------- |
| A | Curry |
| B | Sushi |


-- Only A and B joined and their first orders were Curry and Sushi respectively

---

7. Which item was purchased just before the customer became a member?

```sql
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
```

| Customer_ID | Product_Name |
| ----------- | ----------- |
| A | Curry |
| A | Sushi |
| B | Sushi |

-- The item purchased before joining by A is Sushi and Curry, whilst B is Sushi

---

8. What is the total items and amount spent for each member before they became a member?

```sql
SELECT customer_id, COUNT(DISTINCT product_id) AS total_item, CONCAT('$', SUM(price)) AS total_spend
FROM Sales
LEFT JOIN menu
USING (product_id)
LEFT JOIN members
USING (Customer_id)
WHERE order_date < join_date
GROUP BY customer_id;
```

| Customer_ID | Total_Item | Total_Spend |
| ----------- | ----------- |----------- |
| A | 2 | $25 | 
| B | 2 | $40 | 

-- A ordered twice and spent $25, B ordered twice and spent $40

---
 
9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

```sql
SELECT customer_id, SUM(CASE WHEN product_name = 'Sushi' THEN PRICE * 20
			ELSE PRICE * 10
            END) AS Points_Accrued
FROM Sales
JOIN menu
USING (product_id)
GROUP BY customer_id;
```

| Customer_ID | Points_Accrued |
| ----------- | ----------- |
| A | 860 | 
| B | 940 | 
| C | 360 |

-- A has 860 points, B has 940 points, C has 360 points 

---

10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

```sql
SELECT S.Customer_ID,
		SUM(CASE WHEN S.product_id = 1 THEN Price * 20 
            WHEN  datediff(order_date, join_date) <=7  THEN Price * 20 
            ELSE Price * 10 END) AS Total_Points
FROM sales AS S
JOIN Menu AS X
	ON S.product_id = x.product_id
JOIN members AS M
	ON S.customer_id = M.customer_id
WHERE order_date >= join_date AND MONTH(Order_date) = 1
GROUP BY S.Customer_ID
ORDER BY S.Customer_ID;
```

| Customer_ID | Points_Accrued |
| ----------- | ----------- |
| A | 1020 | 
| B | 440 | 


-- A has 1020 points, B has 440 points. 

---

### Thank you for viewing this project, I hope it was straightforward and understandable. 

