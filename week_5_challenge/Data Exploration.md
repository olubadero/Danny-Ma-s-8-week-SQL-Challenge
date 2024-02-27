# 2. Data Exploration
1. What day of the week is used for each week_date value?
```sql
SELECT DISTINCT DAYNAME(NEW_DATE) AS Week_DAY
FROM clean_weekly_sales;
```
| Week_Day | 
| ----------- | 
| Monday | 

- The day of the week used is Monday 

----

2. What range of week numbers are missing from the dataset?
```sql
SELECT DISTINCT WEEK(new_date)
FROM clean_weekly_sales
ORDER BY WEEK(new_date);
```
Results:

<img width="79" alt="Screenshot 2024-02-27 at 12 04 42" src="https://github.com/olubadero/Danny_Mas_8-week_SQL_Challenge/assets/111298078/ebe82dba-ab92-419a-83a3-4b4b13d09651">


- Week 1 to 11 and 36 to 52 are missing

----

3. How many total transactions were there for each year in the dataset?
```sql
SELECT Year AS Transaction_Year, CONCAT('$', SUM(transactions)) AS Total_Transaction
FROM clean_weekly_sales
GROUP BY Transaction_Year
ORDER BY Transaction_Year;
```
| Transaction_Year | Total_Transactions | 
| ----------- | ----------- |
| 2018 | $346406460 | 
| 2019 | $365639285 |
| 2020 | $375813651 |

----

4.  What is the total sales for each region for each month?
```sql
SELECT Region, MONTHNAME(new_date) AS Month, CONCAT('$', SUM(Sales)) AS Total_Monthly_Sales
FROM clean_weekly_sales
GROUP BY Region, MONTHNAME(new_date)
ORDER BY Region;
```

Results:

<img width="355" alt="Screenshot 2024-02-27 at 12 10 30" src="https://github.com/olubadero/Danny_Mas_8-week_SQL_Challenge/assets/111298078/7ed9e495-7c3a-4510-91c6-34a735597247">


<img width="362" alt="Screenshot 2024-02-27 at 12 11 17" src="https://github.com/olubadero/Danny_Mas_8-week_SQL_Challenge/assets/111298078/11396c3f-4968-4bcf-8d51-daa03f308f96">



----
5. What is the total count of transactions for each platform
```sql
SELECT Platform, COUNT(*) AS Total_Transactions
FROM clean_weekly_sales
GROUP BY Platform;
```

| Platform | Total_Transactions | 
| ----------- | ----------- |
| Retail | 8568 | 
| Shopify | 8549 |


----

6. What is the percentage of sales for Retail vs Shopify for each month?
```sql
WITH transactions AS(SELECT Platform, MONTHNAME(new_date) AS Month, 
						SUM(Sales) AS Total_Transactions,
						SUM(CASE WHEN Platform = 'Retail' THEN Sales ELSE 0 END) AS Retail_Transactions,
						SUM(CASE WHEN Platform = 'Shopify' THEN Sales ELSE 0 END) AS Shopify_Transactions
					FROM clean_weekly_sales
					GROUP BY Platform, new_date
					ORDER BY platform)
SELECT Month, CONCAT(ROUND(100*SUM(Retail_Transactions)/SUM(Total_Transactions), 2), '%') AS Retail_percentage, 
			CONCAT(ROUND(100*SUM(Shopify_Transactions)/SUM(Total_Transactions), 2), '%') AS Shopify_percentage
FROM transactions
GROUP BY Month;
```

| Month | Retail_Percentage | Shopify_Percentage |
| ----------- | ----------- |----------- | 
| March | 97.54% | 2.46% | 
| April | 97.59%  | 2.41% |
| May | 97.30% | 2.70% | 
| June | 97.27% | 2.73% | 
| July | 97.29%  | 2.71% |
| August | 97.08% | 2.92% | 
| September | 97.38% | 2.62% |

----

7. What is the percentage of sales by demographic for each year in the dataset?
```sql
WITH Sales AS(SELECT Demographic, YEAR(new_date) AS YEAR, 
					SUM(Sales) AS Total_Sales,   
					SUM(CASE WHEN Demographic = 'Families' THEN sales ELSE 0 END) as families_Sales, 
					SUM(CASE WHEN Demographic = 'Couples' THEN sales ELSE 0 END) as couples_sales,
					SUM(CASE WHEN Demographic = 'unknown' THEN sales ELSE 0 END) as unknown_sales
			FROM clean_weekly_sales
			GROUP BY Demographic, new_date
			ORDER BY Demographic)
SELECT Year, CONCAT(ROUND(100*SUM(families_Sales)/SUM(Total_Sales), 2), '%') AS Families_Percentage,
			CONCAT(ROUND(100*SUM(couples_Sales)/SUM(Total_Sales), 2), '%') AS Couples_Percentage,
            CONCAT(ROUND(100*SUM(unknown_Sales)/SUM(Total_Sales), 2), '%') AS Unknown_Percentage
FROM Sales
GROUP BY Year;
```


| Year | Families_Percentage | Couples_Percentage | Unknown_Percentage |
| ----------- | ----------- |----------- | ----------- |
| 2018 | 31.99% | 26.38% | 41.63% |
| 2019 | 32.47% | 27.28% | 40.25% |
| 2020 | 32.73% | 28.72% | 38.55% |


----

8. Which age_band and demographic values contribute the most to Retail sales?
```sql SELECT age_band,demographic, CONCAT('$', SUM(IF(Platform = 'Retail', Sales, 0))) AS Retail_Sales
FROM clean_weekly_sales
GROUP BY age_band,demographic
ORDER BY Retail_Sales DESC
LIMIT 1;
```

| age_band | demographic | Retail_Sales | 
| ----------- | ----------- |----------- | 
| Unknown | Unknown | $16067285533 |


----

9. Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? 
-- If not - how would you calculate it instead?
