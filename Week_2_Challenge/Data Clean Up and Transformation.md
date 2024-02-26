- Clean Up of the Runner_Orders Table
- Create a copy of the original Runner Order Table before clean up
  
```sql
CREATE TABLE runner_orders_copy (
  `order_id` INTEGER,
  `runner_id` INTEGER,
  `pickup_time` VARCHAR(19),
  `distance` VARCHAR(7),
  `duration` VARCHAR(10),
  `cancellation` VARCHAR(23)
);
```

```sql
INSERT INTO runner_orders_copy
  (`order_id`, `runner_id`, `pickup_time`, `distance`, `duration`, `cancellation`)
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');
```
  
---
- The first step is to convert all Varchar 'null' to null values
```sql
UPDATE runner_orders
SET pickup_time = NULL
WHERE pickup_time = 'null';
```

```sql
UPDATE runner_orders
SET distance = NULL
WHERE distance = 'null';
```

```sql
UPDATE runner_orders
SET duration = NULL
WHERE duration = 'null';
```

```sql
UPDATE runner_orders
SET cancellation = NULL
WHERE cancellation = 'null';
```

```sql
UPDATE runner_orders
SET Cancellation = null
WHERE Order_ID IN (1, 2);
```

- Then, I will clean up replace the Distance, Duration and Cancellation columns replacing words within it with blank spaces
```sql
UPDATE runner_orders
SET Distance = REPLACE(Distance, 'km', '')
WHERE Distance LIKE '%km';
```

```sql
UPDATE runner_orders
SET duration = REPLACE(Duration, 'minutes', '')
WHERE duration LIKE '%minutes';
```

```sql
UPDATE runner_orders
SET duration = REPLACE(Duration, 'mins', '')
WHERE duration LIKE '%mins';
```

```sql
UPDATE runner_orders
SET duration = REPLACE(Duration, 'minute', '')
WHERE duration LIKE '%minute';
```

```sql
UPDATE runner_orders
SET Cancellation = REPLACE(Cancellation, 'Cancellation', '')
WHERE Cancellation LIKE '% cancellation';
```

---

- Then I convert Data types of different columns from Varchar to their correct data type to make it easier to perform queries henceforth
  
```sql
ALTER TABLE runner_orders
MODIFY COLUMN pickup_time timestamp;
```

```sql
ALTER TABLE runner_orders
MODIFY COLUMN distance FLOAT;
```

```sql
ALTER TABLE runner_orders
MODIFY COLUMN duration FLOAT;
```

---

## Clean Up of the Customer_Orders Table
- Actions:
1. Create a new table after filling in the missing
2. convert 'null' and ' ' to null values then create a new table with the query

```sql
CREATE TABLE New_Customers_Order AS

  SELECT Order_id, Customer_id, Pizza_ID,

		  CASE WHEN Exclusions = 'Null' then NULL
		  WHEN Exclusions = '' then NULL
		  ELSE Exclusions
        END AS Exclusions, 
        
        CASE WHEN Extras = 'Null' then NULL
		    WHEN Extras = '' then NULL
		    ELSE Extras
          END AS Extras, Order_Time
  FROM customer_orders;
```
