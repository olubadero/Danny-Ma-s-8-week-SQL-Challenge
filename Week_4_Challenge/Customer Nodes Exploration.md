## A. Customer Nodes Exploration

1. How many unique nodes are there on the Data Bank system?
```sql
SELECT COUNT(DISTINCT node_id) AS unique_nodes
FROM customer_nodes;
```
| unique_nodes | 
| ----------- | 
| 5 | 


-- There are 5 unique nodes  on the Data Bank system

----

2. What is the number of nodes per region?
```sql
SELECT region_name, COUNT(Node_id) AS total_nodes
FROM customer_nodes
JOIN regions
USING (region_id)
GROUP BY region_name
ORDER BY  total_nodes DESC;
```
-- There are 5 unique nodes in each region and they are distributed across all regions as follows:

| region_name | total_nodes |
| ----------- | ----------- |
| Australia | 770 |
| America | 735 |
| Africa | 714 |
| Asia | 665 |
| Europe | 616 |

----

3. How many customers are allocated to each region?
```sql
SELECT region_name, COUNT(DISTINCT customer_id) AS total_customers
FROM customer_nodes
JOIN regions
USING (region_id)
GROUP BY region_name
ORDER BY Total_customers DESC;
```

| region_name | total_nodes |
| ----------- | ----------- |
| Australia | 110 |
| America | 105 |
| Africa | 102 |
| Asia | 95 |
| Europe | 88 |

----

4. How many days on average are customers reallocated to a different node?

```sql
WITH reallocation AS( 
		SELECT *, LEAD(node_id) OVER(PARTITION BY customer_id) AS next_node_allocation
		FROM customer_nodes
		WHERE end_date != '9999-12-31'
		ORDER BY customer_id)
        
SELECT ROUND(AVG(timestampdiff(DAY, Start_date, end_date))) AS Reallocation_Average_Day
FROM reallocation
WHERE node_id != next_node_allocation;
```

| reallocation_average_day | 
| ----------- | 
| 15 |


-- It takes an average of 15 days for customers to be reallocated a different node 

----
5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?



			


