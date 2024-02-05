USE Foodie_Fi;

SELECT * FROM Foodie_Fi.Plans;
SELECT * FROM Foodie_Fi.Subscriptions;

  
-- Based off the 8 sample customers provided in the sample from the subscriptions table, 
-- write a brief description about each customer’s onboarding journey.
-- The sample customers used are Customer: 1, 2, 11, 13, 15, 16, 18 and 19
 
SELECT *
FROM Foodie_Fi.Subscriptions
JOIN Foodie_Fi.Plans
USING (Plan_Id)
WHERE customer_id = 13;

-- customer 13 began with a free trial. 7 days after the trial period the customer upgraded to basic monthly. 3 months after the upgrade, the customer upgraded to the pro monthly subscription.

SELECT *
FROM Foodie_Fi.Subscriptions
JOIN Foodie_Fi.Plans
USING (Plan_Id)
WHERE customer_id = 11;

-- Customer 11 did the 7 days free trial and then cancelled their subscription choosing not to upgrade or subscribing to the app

SELECT *
FROM Foodie_Fi.Subscriptions
JOIN Foodie_Fi.Plans
USING (Plan_Id)
WHERE customer_id = 2;
-- Customer 2 began with a free trial. 7 days after the trial period the customer upgraded to the pro annual package

SELECT *
FROM Foodie_Fi.Subscriptions
JOIN Foodie_Fi.Plans
USING (Plan_Id)
WHERE customer_id = 1;
-- customer 1 began with the 7 days free trial and then upgraded to the basic monthly plan 7 days after

SELECT *
FROM Foodie_Fi.Subscriptions
JOIN Foodie_Fi.Plans
USING (Plan_Id)
WHERE customer_id = 15;
-- customer 15 began with the 7 days free trial in March then upgraded to the pro monthly. However, the customer churned in April.

SELECT *
FROM Foodie_Fi.Subscriptions
JOIN Foodie_Fi.Plans
USING (Plan_Id)
WHERE customer_id = 16;
-- Customer 16 tried the app for 7 days then upgraded to the basic monthly plan, then 4 months after the customer upgraded to the pro annual plan

SELECT *
FROM Foodie_Fi.Subscriptions
JOIN Foodie_Fi.Plans
USING (Plan_Id)
WHERE customer_id = 18;
-- Customer 18 took advantage of the 7 days free trial and then subscribed to the pro monthly plan thereafter.

SELECT *
FROM Foodie_Fi.Subscriptions
JOIN Foodie_Fi.Plans
USING (Plan_Id)
WHERE customer_id = 19;

-- Customer 19 tried the app for 7days and then subscribed to the pro monthly plan. After 2 months, the customer upgraded to the pro annual plan
