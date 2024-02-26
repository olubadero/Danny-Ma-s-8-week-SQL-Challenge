### Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.


<img width="267" alt="Screenshot 2024-02-26 at 21 06 13" src="https://github.com/olubadero/Danny_Mas_8-week_SQL_Challenge/assets/111298078/91418d77-60d3-4c1f-a507-0d0ed154c6b0">


-- The sample customers used are Customer: 1, 2, 11, 13, 15, 16, 18 and 19

----
 
```sql
SELECT *
FROM Foodie_Fi.Subscriptions
JOIN Foodie_Fi.Plans
USING (Plan_Id)
WHERE customer_id = 13;
```

<img width="252" alt="Screenshot 2024-02-26 at 21 13 18" src="https://github.com/olubadero/Danny_Mas_8-week_SQL_Challenge/assets/111298078/c0ed1796-5dff-4aa0-96d9-36d7b8c2b489">


-- customer 13 began with a free trial. 7 days after the trial period the customer upgraded to basic monthly. 3 months after the upgrade, the customer upgraded to the pro monthly subscription.

----

```sql
 SELECT *
FROM Foodie_Fi.Subscriptions
JOIN Foodie_Fi.Plans
USING (Plan_Id)
WHERE customer_id = 11;
```

<img width="234" alt="Screenshot 2024-02-26 at 21 18 38" src="https://github.com/olubadero/Danny_Mas_8-week_SQL_Challenge/assets/111298078/894e5aee-bc86-4ec7-93cd-ec6f563d838f">


-- Customer 11 did the 7 days free trial and then cancelled their subscription choosing not to upgrade or subscribing to the app

----

```sql
SELECT *
FROM Foodie_Fi.Subscriptions
JOIN Foodie_Fi.Plans
USING (Plan_Id)
WHERE customer_id = 2;
```

<img width="241" alt="Screenshot 2024-02-26 at 21 19 14" src="https://github.com/olubadero/Danny_Mas_8-week_SQL_Challenge/assets/111298078/bbbb2ded-1eb8-4c02-b478-a4eaa2f5c2d3">

-- Customer 2 began with a free trial. 7 days after the trial period the customer upgraded to the pro annual package


----

```sql
SELECT *
FROM Foodie_Fi.Subscriptions
JOIN Foodie_Fi.Plans
USING (Plan_Id)
WHERE customer_id = 1;
```

<img width="250" alt="Screenshot 2024-02-26 at 21 19 38" src="https://github.com/olubadero/Danny_Mas_8-week_SQL_Challenge/assets/111298078/182539bb-7bab-422a-8234-9a6338a2ab51">


-- customer 1 began with the 7 days free trial and then upgraded to the basic monthly plan 7 days after


----

```sql
SELECT *
FROM Foodie_Fi.Subscriptions
JOIN Foodie_Fi.Plans
USING (Plan_Id)
WHERE customer_id = 15;
```

<img width="239" alt="Screenshot 2024-02-26 at 21 22 08" src="https://github.com/olubadero/Danny_Mas_8-week_SQL_Challenge/assets/111298078/4f8f0f81-3c46-4758-8ce6-2187c65443a7">

-- customer 15 began with the 7 days free trial in March then upgraded to the pro monthly. However, the customer churned in April.

----

```sql
SELECT *
FROM Foodie_Fi.Subscriptions
JOIN Foodie_Fi.Plans
USING (Plan_Id)
WHERE customer_id = 16;
```

<img width="250" alt="Screenshot 2024-02-26 at 21 22 30" src="https://github.com/olubadero/Danny_Mas_8-week_SQL_Challenge/assets/111298078/aeca8093-138f-4362-988f-49450e866887">


-- Customer 16 tried the app for 7 days then upgraded to the basic monthly plan, then 4 months after the customer upgraded to the pro annual plan

----

```sql
SELECT *
FROM Foodie_Fi.Subscriptions
JOIN Foodie_Fi.Plans
USING (Plan_Id)
WHERE customer_id = 18;
```

<img width="238" alt="Screenshot 2024-02-26 at 21 22 54" src="https://github.com/olubadero/Danny_Mas_8-week_SQL_Challenge/assets/111298078/12aa49f8-7433-42f7-a55e-23c25e4645ab">


-- Customer 18 took advantage of the 7 days free trial and then subscribed to the pro monthly plan thereafter.

----
```sql
SELECT *
FROM Foodie_Fi.Subscriptions
JOIN Foodie_Fi.Plans
USING (Plan_Id)
WHERE customer_id = 19;
```

<img width="239" alt="Screenshot 2024-02-26 at 21 23 23" src="https://github.com/olubadero/Danny_Mas_8-week_SQL_Challenge/assets/111298078/776dfe40-0db5-4a45-833b-881771d94cb1">


-- Customer 19 tried the app for 7days and then subscribed to the pro monthly plan. After 2 months, the customer upgraded to the pro annual plan
