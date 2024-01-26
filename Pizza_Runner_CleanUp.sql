USE pizza_runner;

-- Clean Up of the Runner_Orders Table
-- Create a copy of the original Runner Order Table before clean up
CREATE TABLE runner_orders_copy (
  `order_id` INTEGER,
  `runner_id` INTEGER,
  `pickup_time` VARCHAR(19),
  `distance` VARCHAR(7),
  `duration` VARCHAR(10),
  `cancellation` VARCHAR(23)
);

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

-- convert 'null' to null values
UPDATE runner_orders
SET pickup_time = NULL
WHERE pickup_time = 'null';

UPDATE runner_orders
SET distance = NULL
WHERE distance = 'null';

UPDATE runner_orders
SET duration = NULL
WHERE duration = 'null';

UPDATE runner_orders
SET cancellation = NULL
WHERE cancellation = 'null';

UPDATE runner_orders
SET Distance = REPLACE(Distance, 'km', '')
WHERE Distance LIKE '%km';

UPDATE runner_orders
SET duration = REPLACE(Duration, 'minutes', '')
WHERE duration LIKE '%minutes';

UPDATE runner_orders
SET duration = REPLACE(Duration, 'mins', '')
WHERE duration LIKE '%mins';

UPDATE runner_orders
SET duration = REPLACE(Duration, 'minute', '')
WHERE duration LIKE '%minute';

UPDATE runner_orders
SET Cancellation = REPLACE(Cancellation, 'Cancellation', '')
WHERE Cancellation LIKE '% cancellation';

UPDATE runner_orders
SET Cancellation = null
WHERE Order_ID IN (1, 2);

-- Convert Data types of columns
ALTER TABLE runner_orders
MODIFY COLUMN pickup_time timestamp;

ALTER TABLE runner_orders
MODIFY COLUMN distance FLOAT;

ALTER TABLE runner_orders
MODIFY COLUMN duration FLOAT;

-- Clean Up of the Customer_Orders Table

-- Create a new table after filling in the missing 

-- convert 'null' and ' ' to null values then create a new table with the query
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


