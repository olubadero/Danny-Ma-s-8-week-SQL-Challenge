SELECT * FROM Foodie_Fi.Subscriptions;
SELECT * FROM Foodie_Fi.Plans;


SELECT *
FROM Foodie_Fi.Subscriptions
JOIN Foodie_Fi.Plans
USING (Plan_Id);

-- How many customers has Foodie-Fi ever had?

SELECT COUNT(distinct(customer_id))
FROM Foodie_Fi.Subscriptions;
-- 1000 Customers

-- What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

SELECT Month(Date), COUNT(date) as monthly_distribution
FROM Foodie_Fi.Subscriptions
JOIN Foodie_Fi.Plans
USING (Plan_Id)
WHERE Plan_name = 'trial'
GROUP BY Month(Date)
Order by 1;
# Month(Date), monthly_distribution
-- 1, 88
-- 2, 68
-- 3, 94
-- 4, 81
-- 5, 88
-- 6, 79
-- 7, 89
-- 8, 88
-- 9, 87
-- 10, 79
-- 11, 75
-- 12, 84


-- What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
SELECT Plan_id, Plan_name, count(plan_name) as Count_Events
FROM Foodie_Fi.Subscriptions
JOIN Foodie_Fi.Plans
USING (Plan_Id)
WHERE Year(date) > 2020
GROUP BY Plan_id
ORDER BY Plan_id;

# Plan_id, Plan_name, Count_Events
-- 1, basic monthly, 8
-- 2, pro monthly, 60
-- 3, pro annual, 63
-- 4, churn, 71


-- What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
SELECT *, ROUND(X.churned_customers/x.customer_count*100, 1) as Unsubscription_Percentage
FROM(SELECT COUNT(Distinct(customer_id)) as Customer_Count, 
		SUM(CASE WHEN Plan_id = 4 THEN 1 ELSE 0 END) as Churned_customers
	FROM Foodie_Fi.Subscriptions
	JOIN Foodie_Fi.Plans
	USING (Plan_Id)) as X;
-- 30.7% OF Customers unsubscribed 

-- How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
SELECT COUNT(Y.customer_id) as Customers_that_Churned, round(COUNT(Y.customer_id)/(SELECT COUNT(distinct(customer_id))
FROM Foodie_Fi.Subscriptions)*100, 2) as Percentage_that_churned
FROM(SELECT *
	FROM(SELECT *, lead(plan_id) over(PARTITION BY customer_id ORDER BY date) AS next_plan
	FROM Foodie_Fi.subscriptions) as x
	WHERE X.Next_Plan = 4 AND Plan_id = 0) AS Y;
-- Customers_that_Churned, Percentage_that_churned
-- 92, 9.20

-- What is the number and percentage of customer plans after their initial free trial?
SELECT Plan_name, Count(distinct(customer_id)) as total_customers, 
ROUND(Count(distinct(customer_id))/(SELECT Count(distinct(customer_id)) FROM Foodie_Fi.Subscriptions) *100, 2) as Customer_Plan_Percentage
FROM Foodie_Fi.Subscriptions as subscriptions
JOIN Foodie_Fi.Plans as plans
USING (Plan_Id)
WHERE Plan_id != 0 AND plan_id != 4
GROUP BY 1
ORDER BY 3 DESC;
# Plan_name, total_customers, Customer_Plan_Percentage
-- basic monthly, 546, 54.60
-- pro monthly, 539, 53.90
-- pro annual, 258, 25.80



-- What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

SELECT Plan_Name, Count(distinct(customer_id)) as Total_Customers, 
round(count(Customer_id)/(select count(distinct(customer_id)) from foodie_fi.subscriptions)*100, 2) as Percentage_distribution
From Foodie_Fi.subscriptions
JOIN Foodie_Fi.plans 
USING (plan_id)
WHERE date <='2020-12-31'
GROUP BY 1
ORDER BY 2;
   

-- How many customers have upgraded to an annual plan in 2020?
SELECT plan_id, COUNT(distinct(customer_id)) as 2020_subscription
FROM Foodie_fi.subscriptions
WHERE plan_id = '3' AND year(Date) = 2020;
-- plan_id, 2020_subscription
-- 3, 195



-- How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?


-- Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)


-- How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
SELECT COUNT(customer_id) as Number_of_Downgrades
FROM(SELECT *, LEAD(plan_id) over(PARTITION BY customer_id ORDER BY date) AS Customer_subscriptions
	FROM foodie_fi.subscriptions) as X
WHERE X.plan_id = 2 AND X.Customer_subscriptions = 1 AND Year(Date) = 2020
-- # Number_of_Downgrades
-- 0

