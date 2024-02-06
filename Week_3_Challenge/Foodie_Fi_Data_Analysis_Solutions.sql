
        -- B. Data Analysis Questions
-- How many customers has Foodie-Fi ever had?
SELECT COUNT(DISTINCT Customer_id) AS Total_Foodie_Fi_Customers
FROM Subscriptions
JOIN Plans
USING (Plan_Id);
-- Total_Foodie_Fi_Customers
-- '1000'

-- What is the monthly distribution of trial plan start_date values for our dataset 
--  use the start of the month as the group by value
SELECT MONTH(Start_date) AS Month, MONTHNAME(Start_date) AS Monthname, COUNT(DISTINCT Customer_id) AS Distribution
FROM Subscriptions
JOIN Plans
USING (Plan_Id)
WHERE plan_name = 'Trial'
GROUP BY MONTH(Start_date), MONTHNAME(Start_date);
-- Month, 	Monthname, Distribution
-- '1', 	'January', 		'88'
-- '2', 	'February', 	'68'
-- '3', 	'March', 		'94'
-- '4', 	'April', 		'81'
-- '5', 	'May', 			'88'
-- '6', 	'June', 		'79'
-- '7', 	'July', 		'89'
-- '8', 	'August', 		'88'
-- '9', 	'September', 	'87'
-- '10', 	'October', 		'79'
-- '11', 	'November', 	'75'
-- '12', 	'December',		'84'


-- What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
SELECT plan_name, COUNT(DISTINCT customer_id) AS Count_Events
FROM Subscriptions
JOIN Plans
USING (Plan_Id)
WHERE YEAR(start_date) > 2020
GROUP BY plan_name;

-- plan_name, 		Count_Events
-- 'basic monthly', 	'8'
-- 'churn', 			'71'
-- 'pro annual', 		'63'
-- 'pro monthly', 		'60'


-- What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

SELECT (SELECT COUNT(DISTINCT customer_id) FROM Subscriptions 
		JOIN Plans 
		USING (Plan_Id) 
		WHERE plan_name = 'churn')AS total_churned_customers, 
        
        CONCAT(ROUND((SELECT COUNT(*) FROM Foodie_Fi.Subscriptions JOIN Foodie_Fi.Plans USING (Plan_Id) WHERE plan_name = 'churn')/COUNT(DISTINCT customer_id) *100,1), '%') AS Churned_percentage
FROM Foodie_Fi.Subscriptions
JOIN Foodie_Fi.Plans
USING (Plan_Id);

-- 307 customers churned, which represents 30.7% of Foodie_Fi's customer base

-- How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
WITH actions AS(
			SELECT customer_id, start_date, plan_name, 
					LEAD(Plan_name) OVER (PARTITION BY Customer_id ORDER BY Start_date) AS subsequent_action
			FROM Foodie_Fi.Subscriptions
			JOIN Foodie_Fi.Plans
			USING (Plan_Id)), 
	  Churners AS (
			SELECT *
			FROM Actions
			WHERE Plan_name = 'trial' and subsequent_action = 'churn')    -- 92 customers churned after their trial period
            
SELECT CONCAT(ROUND((SELECT COUNT(*) FROM Churners)/COUNT(distinct customer_id) * 100), '%') AS churned_percentage
FROM actions;
-- This represents 9% of the entire customer base


-- What is the number and percentage of customer plans after their initial free trial?

WITH actions AS (
  SELECT 
    customer_id, plan_name, plan_id, 
    LEAD(plan_name) OVER(
      PARTITION BY customer_id 
      ORDER BY plan_id) as subsequent_action
  FROM subscriptions
  JOIN Plans
			USING (Plan_Id)
)

SELECT 
  subsequent_action, COUNT(customer_id) AS total_customers,
  CONCAT(ROUND(100 * 
    COUNT(customer_id)
    / (SELECT COUNT(DISTINCT customer_id) 
      FROM foodie_fi.subscriptions)
  ,2), '%') AS customer_percentage
FROM actions
WHERE subsequent_action IS NOT NULL 
  AND plan_name = 'trial'
GROUP BY subsequent_action
ORDER BY total_customers DESC;
-- subsequent_action, total_customers, customer_percentage
-- 'basic monthly', 		'546', 			'54.60%'
-- 'pro monthly', 			'325', 			'32.50%'
-- 'churn', 				'92', 			'9.20%'
-- 'pro annual', 			'37', 			'3.70%'

-- What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
WITH Dates AS (
  SELECT 
    customer_id, plan_name, plan_id, 
    LEAD(start_date) OVER(
      PARTITION BY customer_id 
      ORDER BY start_date) as subsequent_date
  FROM subscriptions
  JOIN Plans
			USING (Plan_Id)
WHERE start_date <= '2020-12-31'
)
SELECT plan_name, COUNT(DISTINCT customer_id) AS total_customers,
	CONCAT(ROUND(COUNT(DISTINCT customer_id)/(SELECT COUNT(DISTINCT customer_id) FROM subscriptions)* 100, 2), '%') AS Percentage
FROM Dates
WHERE subsequent_date IS NULL
GROUP BY plan_name;
--  plan_name,		 total_customers, Percentage
-- 'basic monthly', 		'224', 		'22.40%'
-- 'churn', 				'236', 		'23.60%'
-- 'pro annual', 			'195', 		'19.50%'
-- 'pro monthly', 			'326', 		'32.60%'
-- 'trial', 				'19', 		'1.90%'


-- How many customers have upgraded to an annual plan in 2020?
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM Foodie_Fi.Subscriptions
JOIN Foodie_Fi.Plans
USING (Plan_Id)
WHERE YEAR(start_date) = 2020 AND plan_name = 'pro annual';
-- total of '195' customers upgraded to Pro Annual plan in 2020

-- How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
WITH Trial AS (
			SELECT customer_id, plan_name AS Trial_Plan, start_date AS Trial_Dates
			FROM Subscriptions
			JOIN Plans
			USING (Plan_Id)
            WHERE Plan_name = 'trial'),
	Annual AS (
			SELECT customer_id, plan_name AS Annual_Plan, start_date AS Annual_Dates
			FROM Subscriptions
			JOIN Plans
			USING (Plan_Id)
            WHERE Plan_name = 'pro annual')
SELECT ROUND(AVG(TIMESTAMPDIFF(DAY, Trial_Dates, Annual_Dates))) Average_Annual_Subscription_Day
FROM trial
JOIN annual
USING (Customer_ID);
-- The average number of days it takes for a customer to subscribe to an annual plan after trial is 105 day

-- Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
SELECT *
FROM Foodie_Fi.Subscriptions
JOIN Foodie_Fi.Plans
USING (Plan_Id);


-- How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
WITH actions AS(
				SELECT *,  LEAD(plan_name) OVER(
					  PARTITION BY customer_id 
					  ORDER BY start_date) as subsequent_subscription
				FROM Foodie_Fi.Subscriptions
				JOIN Foodie_Fi.Plans
				USING (Plan_Id)
                WHERE YEAR(start_date) = 2020)
                
SELECT COUNT(*) Total_Customers
FROM actions
WHERE plan_name = 'pro monthly' AND subsequent_subscription = 'basic monthly';
-- 0 customers downgraded from a pro monthly to a basic monthly plan in 2020
