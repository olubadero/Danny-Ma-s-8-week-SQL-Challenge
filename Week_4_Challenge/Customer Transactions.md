# B. Customer Transactions

1. What is the unique count and total amount for each transaction type?
```sql
,SELECT DISTINCT txn_type AS transaction_type, COUNT(txn_type) AS total_count, CONCAT('$',SUM(txn_amount)) AS total_sum
FROM customer_transactions
GROUP BY txn_type;
```

| transaction_type | total_count | total_sum |
| ----------- | ----------- | ----------- |
| deposit | 2671 | $1359168 |
| withdrawal | 1580 | $793003 |
| purchase | 1617 | $806537 |

---- 

2. What is the average total historical deposit counts and amounts for all customers?
```sql
WITH details AS(SELECT customer_id, COUNT(customer_id) AS count, AVG(txn_amount) AS avg_sum
				FROM customer_transactions
				WHERE txn_type = 'deposit'
				GROUP BY customer_id
				ORDER BY customer_id)
SELECT ROUND(AVG(count)) AS average_count, CONCAT('$', Round(AVG(avg_sum), 2)) AS average_sum
FROM details;
```

| average_count | average_sum |
| ----------- | ----------- |
| 5 | $508.61 |

-- The average total deposit counts and amounts for all customers are:

----

 3.For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?
```sql
WITH transactions AS( SELECT customer_id, monthname(txn_date) AS month_name,
				SUM(CASE WHEN txn_type = 'Deposit' THEN 1 ELSE 0 END) AS deposit_transactions,
				SUM(CASE WHEN txn_type = 'Withdrawal' THEN 1 ELSE 0 END) AS withdrawal_transactions,
				SUM(CASE WHEN txn_type = 'purchase' THEN 1 ELSE 0 END) AS purchase_transactions
			FROM customer_transactions
			GROUP BY customer_id, monthname(txn_date)
            )
            
SELECT month_name, COUNT(DISTINCT customer_id) AS total_customers
FROM transactions
WHERE deposit_transactions > 1 AND  (purchase_transactions >= 1 OR withdrawal_transactions >= 1)
GROUP BY month_name
ORDER BY total_customers DESC;
```

| month_name | total_nodes |
| ----------- | ----------- |
| March | 192 |
| February | 181 |
| January | 168 |
| April | 70 |

### I recently learned to query using the IF syntax in place of the CASE WHEN and I decided to put it to practice here 
-- Calculating using IF syntax: 

```sql
WITH transactions AS( SELECT customer_id, monthname(txn_date) AS month_name,
				SUM(IF(txn_type = 'Deposit', 1, 0)) AS deposit_transactions,
				SUM(IF(txn_type = 'Withdrawal', 1, 0)) AS withdrawal_transactions,
				SUM(IF(txn_type = 'purchase',1, 0)) AS purchase_transactions
			FROM customer_transactions
			GROUP BY customer_id, monthname(txn_date)
            )
            
SELECT month_name, COUNT(DISTINCT customer_id) AS total_customers
FROM transactions
WHERE deposit_transactions > 1 AND  (purchase_transactions >= 1 OR withdrawal_transactions >= 1)
GROUP BY month_name
ORDER BY total_customers DESC;
```

| month_name | total_nodes |
| ----------- | ----------- |
| March | 192 |
| February | 181 |
| January | 168 |
| April | 70 |

----
-- What is the closing balance for each customer at the end of the month?
```sql
WITH txn_monthly_balance_cte AS
			  (SELECT customer_id, txn_amount, month(txn_date) AS txn_month,
					  SUM(CASE WHEN txn_type= "deposit" THEN txn_amount
							  ELSE - txn_amount END) AS net_transaction_amt
			   FROM customer_transactions
			   GROUP BY customer_id, txn_amount, month(txn_date)
			   ORDER BY customer_id)
SELECT customer_id, txn_month, net_transaction_amt,
       sum(net_transaction_amt) over(PARTITION BY customer_id ORDER BY txn_month ROWS BETWEEN UNBOUNDED preceding AND CURRENT ROW) AS closing_balance
FROM txn_monthly_balance_cte
GROUP BY customer_id, txn_month, net_transaction_amt;
```

- Here is an excerpt of the results:

<img width="335" alt="Screenshot 2024-02-27 at 10 14 41" src="https://github.com/olubadero/Danny_Mas_8-week_SQL_Challenge/assets/111298078/e0aaca36-3078-4f21-ace0-f41d52a988f9">


----

-- What is the percentage of customers who increase their closing balance by more than 5%?
		
