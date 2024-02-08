USE data_bank;
SELECT * FROM customer_nodes;
SELECT * FROM customer_transactions;
SELECT * FROM regions;


				-- A. Customer Nodes Exploration
-- How many unique nodes are there on the Data Bank system?
SELECT COUNT(DISTINCT node_id) AS unique_nodes
FROM customer_nodes;
-- There are 5 unique nodes  on the Data Bank system

-- What is the number of nodes per region?
SELECT region_name, COUNT(Node_id) AS total_nodes
FROM customer_nodes
JOIN regions
USING (region_id)
GROUP BY region_name
ORDER BY  total_nodes DESC;
-- There are 5 unique nodes in each region and they are distributed across all regions as follows:
-- region_name, total_nodes
-- 'Australia',		'770'
-- 'America',		'735'
-- 'Africa',		'714'
-- 'Asia',			'665'
-- 'Europe',		'616'


-- How many customers are allocated to each region?
SELECT region_name, COUNT(DISTINCT customer_id) AS total_customers
FROM customer_nodes
JOIN regions
USING (region_id)
GROUP BY region_name
ORDER BY Total_customers DESC;
-- region_name, total_customers
-- 'Australia', 	'110'
-- 'America', 		'105'
-- 'Africa', 		'102'
-- 'Asia', 			'95'
-- 'Europe', 		'88'



-- How many days on average are customers reallocated to a different node?

WITH reallocation AS( 
		SELECT *, LEAD(node_id) OVER(PARTITION BY customer_id) AS next_node_allocation
		FROM customer_nodes
		WHERE end_date != '9999-12-31'
		ORDER BY customer_id)
        
SELECT ROUND(AVG(timestampdiff(DAY, Start_date, end_date))) AS reallocation_average_day
FROM reallocation
WHERE node_id != next_node_allocation;
-- It takes an average of 15 days for customers to be reallocated a different node 


-- What is the median, 80th and 95th percentile for this same reallocation days metric for each region?



			