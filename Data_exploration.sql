SELECT * FROM `Data _Mart`.Data;
SELECT * 
FROM `Data _Mart`.NEW_Data;

-- What day of the week is used for each week_date value?
SELECT distinct(dayname(date)) as week_day
FROM `Data _Mart`.NEW_Data;

SELECT dayname(date) as week_day, count(dayname(date))
FROM `Data _Mart`.NEW_Data
GROUP BY dayname(date);
-- Monday

-- What range of week numbers are missing from the dataset?
SELECT distinct(week_number)
FROM `Data _Mart`.NEW_Data
ORDER BY week_number;
-- 1 to 11 and 36 to 52 are missing

-- How many total transactions were there for each year in the dataset?
SELECT year, SUM(transactions) as total_transactions
FROM `Data _Mart`.NEW_Data
GROUP BY year
ORDER BY year;
-- year, total_transactions
-- 2018, 346406460
-- 2019, 365639285
-- 2020, 375813651

-- What is the total sales for each region for each month?
SELECT Region, Month, total_sales
FROM(SELECT Region, month_number, monthname(date) as month, SUM(Sales) as total_sales
	FROM `Data _Mart`.NEW_Data
	GROUP BY Region, month_number, monthname(date)
	ORDER BY Region) as x;

-- What is the total count of transactions for each platform
SELECT platform, count(*) as transaction_count
FROM `Data _Mart`.NEW_Data
GROUP BY platform;

-- platform, Count(*)
-- Retail, 8568
-- Shopify, 8549

SELECT platform, SUM(transactions) as total_transaction
FROM `Data _Mart`.NEW_Data
GROUP BY platform;

-- platform, total_transaction
-- Retail, 1081934227
-- Shopify, 5925169


-- What is the percentage of sales for Retail vs Shopify for each month?
WITH X as(SELECT year, monthname(date) as Month, month_number, SUM(sales) as total_sales, SUM(CASE WHEN Platform = 'Retail' THEN sales ELSE 0 END) as Retail_Sales, 
	SUM(CASE WHEN Platform = 'Shopify' THEN sales ELSE 0 END) as Shopify_sales
	FROM `Data _Mart`.NEW_Data
	GROUP BY year, monthname(date), month_number
	ORDER BY month_number)
SELECT year, month, ROUND(Retail_sales/total_sales * 100, 2) as Retail_percentage, 
ROUND(shopify_sales/total_sales * 100, 2)as Shopify_percentage
FROM X
ORDER BY year;

# year, month, Retail_percentage, Shopify_percentage
-- 2018, March, 97.92, 2.08
-- 2018, April, 97.93, 2.07
-- 2018, May, 97.73, 2.27
-- 2018, June, 97.76, 2.24
-- 2018, July, 97.75, 2.25
-- 2018, August, 97.71, 2.29
-- 2018, September, 97.68, 2.32
-- 2019, March, 97.71, 2.29
-- 2019, April, 97.80, 2.20
-- 2019, May, 97.52, 2.48
-- 2019, June, 97.42, 2.58
-- 2019, July, 97.35, 2.65
-- 2019, August, 97.21, 2.79
-- 2019, September, 97.09, 2.91
-- 2020, March, 97.30, 2.70
-- 2020, April, 96.96, 3.04
-- 2020, May, 96.71, 3.29
-- 2020, June, 96.80, 3.20
-- 2020, July, 96.67, 3.33
-- 2020, August, 96.51, 3.49

-- What is the percentage of sales by demographic for each year in the dataset?
WITH X as(SELECT year, demographic, SUM(sales) as total_sales
			FROM `Data _Mart`.NEW_Data
			GROUP BY year, demographic), 
	Y as (SELECT year, Demographic, total_sales, SUM(x.total_sales) OVER(PARTITION BY YEAR) as DEMO
			FROM X)
SELECT Year, Demographic, ROUND(total_sales/demo * 100, 2)as Unknowns_percentage
FROM Y;


WITH X as(SELECT year, SUM(sales) as total_sales, 
SUM(CASE WHEN Demographic = 'Families' THEN sales ELSE 0 END) as families_Sales, 
	SUM(CASE WHEN Demographic = 'Couples' THEN sales ELSE 0 END) as couples_sales,
    SUM(CASE WHEN Demographic = 'unknown' THEN sales ELSE 0 END) as unknown_sales
	FROM `Data _Mart`.NEW_Data
	GROUP BY year)
SELECT year, ROUND(couples_sales/total_sales * 100, 2) as couples_percentage, 
ROUND(families_sales/total_sales * 100, 2) as families_percentage,
ROUND(unknown_sales/total_sales * 100, 2)as unknown_percentage
FROM X
ORDER BY year;

-- year, couples_percentage, families_percentage, unknown_percentage
-- 2018, 26.38, 31.99, 41.63
-- 2019, 27.28, 32.47, 40.25
-- 2020, 28.72, 32.73, 38.55

-- Which age_band and demographic values contribute the most to Retail sales?
SELECT Age_band, Demographic, ROUND(SUM(sales)/(SELECT SUM(sales) FROM `Data _Mart`.NEW_Data
					WHERE platform = 'Retail') * 100, 2) AS Distribution
FROM `Data _Mart`.NEW_Data
WHERE platform="Retail"
GROUP BY Age_band, Demographic
ORDER BY 3 DESC;



