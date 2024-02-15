USE data_mart;	

SELECT *
FROM clean_weekly_sales;
    
    -- 2. Data Exploration
-- What day of the week is used for each week_date value?
SELECT DISTINCT DAYNAME(NEW_DATE)
FROM clean_weekly_sales;
-- The day of the week used is Monday 

-- What range of week numbers are missing from the dataset?
SELECT DISTINCT WEEK(new_date)
FROM clean_weekly_sales
ORDER BY WEEK(new_date);
-- Week 1 to 11 and 36 to 52 are missing

-- How many total transactions were there for each year in the dataset?
SELECT Year AS Transaction_Year, CONCAT('$', SUM(transactions)) AS Total_Transaction
FROM clean_weekly_sales
GROUP BY Transaction_Year
ORDER BY Transaction_Year;

-- Transaction_Year, Total_Transaction
-- 		'2018', 		'$346406460'
-- 		'2019', 		'$365639285'
-- 		'2020', 		'$375813651'

--  What is the total sales for each region for each month?
SELECT Region, MONTHNAME(new_date) AS Month, CONCAT('$', SUM(Sales)) AS Total_Monthly_Sales
FROM clean_weekly_sales
GROUP BY Region, MONTHNAME(new_date)
ORDER BY Region;

-- Region, 			Month, 			Total_Monthly_Sales
-- 'AFRICA', 		'April', 			'$1911783504'
-- 'AFRICA', 		'August', 			'$1809596890'
-- 'AFRICA', 		'July', 			'$1960219710'
-- 'AFRICA', 		'June', 			'$1767559760'
-- 'AFRICA', 		'March', 			'$567767480'
-- 'AFRICA', 		'May', 				'$1647244738'
-- 'AFRICA', 		'September', 		'$276320987'
-- 'ASIA', 			'April', 			'$1804628707'
-- 'ASIA', 			'August', 			'$1663320609'
-- 'ASIA', 			'July', 			'$1768844756'
-- 'ASIA', 			'June', 			'$1619482889'
-- 'ASIA', 			'March', 			'$529770793'
-- 'ASIA', 			'May', 				'$1526285399'
-- 'ASIA', 			'September', 		'$252836807'
-- 'CANADA', 		'April',			'$484552594'
-- 'CANADA', 		'August', 			'$447073019'
-- 'CANADA', 		'July', 			'$477134947'
-- 'CANADA', 		'June', 			'$443846698'
-- 'CANADA', 		'March', 			'$144634329'
-- 'CANADA', 		'May', 				'$412378365'
-- 'CANADA', 		'September', 		'$69067959'
-- 'EUROPE', 		'April', 			'$127334255'
-- 'EUROPE', 		'August', 			'$122102995'
-- 'EUROPE', 		'July', 			'$136757466'
-- 'EUROPE', 		'June', 			'$122813826'
-- 'EUROPE', 		'March', 			'$35337093'
-- 'EUROPE', 		'May', 				'$109338389'
-- 'EUROPE', 		'September', 		'$18877433'
-- 'OCEANIA', 		'April', 			'$2599767620'
-- 'OCEANIA', 		'August', 			'$2432313652'
-- 'OCEANIA', 		'July', 			'$2563459400'
-- 'OCEANIA', 		'June', 			'$2371884744'
-- 'OCEANIA', 		'March', 			'$783282888'
-- 'OCEANIA', 		'May', 				'$2215657304'
-- 'OCEANIA', 		'September', 		'$372465518'
-- 'SOUTH AMERICA', 'April', 			'$238451531'
-- 'SOUTH AMERICA', 'August', 			'$221166052'
-- 'SOUTH AMERICA', 'July', 			'$235582776'
-- 'SOUTH AMERICA', 'June', 			'$218247455'
-- 'SOUTH AMERICA', 'March', 			'$71023109'
-- 'SOUTH AMERICA', 'May', 				'$201391809'
-- 'SOUTH AMERICA', 'September', 		'$34175583'
-- 'USA', 			'April', 			'$759786323'
-- 'USA', 			'August', 			'$712002790'
-- 'USA', 			'July', 			'$760331754'
-- 'USA', 			'June', 			'$703878990'
-- 'USA', 			'March', 			'$225353043'
-- 'USA', 			'May', 				'$655967121'
-- 'USA', 			'September', 		'$110532368'

-- What is the total count of transactions for each platform
SELECT Platform, COUNT(*) AS Total_Transactions
FROM clean_weekly_sales
GROUP BY Platform;

-- Platform, Total_Transactions
-- 'Retail', 	'8568'
-- 'Shopify', 	'8549'


-- What is the percentage of sales for Retail vs Shopify for each month?
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

-- Month, 	Retail_percentage, Shopify_percentage
-- 'March', 	'97.54%', 			'2.46%'
-- 'April', 	'97.59%', 			'2.41%'
-- 'May', 		'97.30%', 			'2.70%'
-- 'June', 		'97.27%', 			'2.73%'
-- 'July', 		'97.29%', 			'2.71%'
-- 'August', 	'97.08%', 			'2.92%'
-- 'September', '97.38%', 			'2.62%'


-- What is the percentage of sales by demographic for each year in the dataset?
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
-- Year, 	Families_Percentage, Couples_Percentage, Unknown_Percentage
-- '2018', 		'31.99%', 			'26.38%', 			'41.63%'
-- '2019', 		'32.47%', 			'27.28%', 			'40.25%'
-- '2020', 		'32.73%', 			'28.72%', 			'38.55%'


-- Which age_band and demographic values contribute the most to Retail sales?
SELECT age_band,demographic, CONCAT('$', SUM(IF(Platform = 'Retail', Sales, 0))) AS Retail_Sales
FROM clean_weekly_sales
GROUP BY age_band,demographic
ORDER BY Retail_Sales DESC
LIMIT 1;
-- age_band, demographic, Retail_Sales
-- 'Unknown', 'Unknown', '$16067285533'



-- Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? 
-- If not - how would you calculate it instead?

