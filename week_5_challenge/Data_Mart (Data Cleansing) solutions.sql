
								-- 1. Data Cleansing Steps
-- In a single query, perform the following operations and generate a new table in the data_mart schema named clean_weekly_sales:

-- Convert the week_date to a DATE format
SELECT *, str_to_date(week_date, '%d/%m/%Y') AS new_date
FROM weekly_sales;

-- Add a week_number as the second column for each week_date value, for example any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2 etc
SELECT *, str_to_date(week_date, '%d/%m/%Y') AS new_date, WEEK(str_to_date(week_date, '%d/%m/%Y')) AS week_number
FROM weekly_sales;

-- Add a month_number with the calendar month for each week_date value as the 3rd column
SELECT *, str_to_date(week_date, '%d/%m/%Y') AS new_date, 
			WEEK(str_to_date(week_date, '%d/%m/%Y')) AS week_number, 
            MONTH(str_to_date(week_date, '%d/%m/%Y')) AS Month
            
FROM weekly_sales;

-- Add a calendar_year column as the 4th column containing either 2018, 2019 or 2020 values
SELECT *, str_to_date(week_date, '%d/%m/%Y') AS new_date, 
			WEEK(str_to_date(week_date, '%d/%m/%Y')) AS week_number, 
            MONTH(str_to_date(week_date, '%d/%m/%Y')) AS Month,
            YEAR(str_to_date(week_date, '%d/%m/%Y')) AS Year
FROM weekly_sales;


-- Add a new column called age_band after the original segment column using the following mapping on the number inside the segment value
-- segment	age_band
-- 1	Young Adults
-- 2	Middle Aged
-- 3 or 4	Retirees
SELECT *, str_to_date(week_date, '%d/%m/%Y') AS new_date, 

			WEEK(str_to_date(week_date, '%d/%m/%Y')) AS week_number, 
            MONTH(str_to_date(week_date, '%d/%m/%Y')) AS Month,
            YEAR(str_to_date(week_date, '%d/%m/%Y')) AS Year, 
            
            CASE WHEN RIGHT(Segment, 1) = 1 THEN 'Young Adults' 
			WHEN RIGHT(Segment, 1) = 2 THEN 'Middle Aged' 
            WHEN RIGHT(Segment, 1) = 3 OR 4 THEN 'Retirees' 
			ELSE 'Unknown'END AS age_band
            
FROM weekly_sales;

-- Add a new demographic column using the following mapping for the first letter in the segment values:
-- segment	demographic
-- C	Couples
-- F	Families
SELECT *, str_to_date(week_date, '%d/%m/%Y') AS new_date, 

			WEEK(str_to_date(week_date, '%d/%m/%Y')) AS week_number, 
            MONTH(str_to_date(week_date, '%d/%m/%Y')) AS Month,
            YEAR(str_to_date(week_date, '%d/%m/%Y')) AS Year, 
            
            CASE WHEN RIGHT(Segment, 1) = 1 THEN 'Young Adults' 
			WHEN RIGHT(Segment, 1) = 2 THEN 'Middle Aged' 
            WHEN RIGHT(Segment, 1) = 3 OR 4 THEN 'Retirees' 
			ELSE 'Unknown'END AS age_band,
            
            CASE WHEN LEFT(Segment, 1) = 'C' THEN 'Couples' 
			WHEN LEFT(Segment, 1) = 'F' THEN 'Families' 
			ELSE 'Unknown'END AS Demographic
            
FROM weekly_sales;

-- Generate a new avg_transaction column as the sales value divided by transactions rounded to 2 decimal places for each record
SELECT *, str_to_date(week_date, '%d/%m/%Y') AS new_date, 

			WEEK(str_to_date(week_date, '%d/%m/%Y')) AS week_number, 
            MONTH(str_to_date(week_date, '%d/%m/%Y')) AS Month,
            YEAR(str_to_date(week_date, '%d/%m/%Y')) AS Year, 
            
            CASE WHEN RIGHT(Segment, 1) = 1 THEN 'Young Adults' 
			WHEN RIGHT(Segment, 1) = 2 THEN 'Middle Aged' 
            WHEN RIGHT(Segment, 1) = 3 OR 4 THEN 'Retirees' 
			ELSE 'Unknown'END AS age_band,
            
            CASE WHEN LEFT(Segment, 1) = 'C' THEN 'Couples' 
			WHEN LEFT(Segment, 1) = 'F' THEN 'Families' 
			ELSE 'Unknown'END AS Demographic
            , 
            
            ROUND(sales/transactions, 2) AS avg_transaction
FROM weekly_sales;


-- In a single query, perform the following operations and generate a new table in the data_mart 
-- schema named clean_weekly_sales:

                     
CREATE TABLE clean_weekly_sales AS(SELECT str_to_date(week_date, '%d/%m/%Y') AS new_date, YEAR(str_to_date(week_date, '%d/%m/%Y')) AS Year, MONTH(str_to_date(week_date, '%d/%m/%Y')) AS Month, 
							WEEK(str_to_date(week_date, '%d/%m/%Y')) AS week_number, Region, Platform, Customer_type,
							Sales, Transactions, ROUND(Sales/Transactions, 2) as avg_transaction,
							CASE WHEN RIGHT(Segment, 1) = '1' THEN 'Young Adults'
												WHEN RIGHT(Segment, 1) = '2' THEN 'Middle Aged'
												WHEN RIGHT(Segment, 1) IN ('3', '4') THEN 'Retirees'
												ELSE 'Unknown' END AS Age_band,
							CASE WHEN LEFT(Segment, 1) = 'C' THEN 'Couples'
												WHEN LEFT(Segment, 1) = 'F' THEN 'Families'
												ELSE 'Unknown' END AS demographic
FROM weekly_sales);

SELECT * 
FROM clean_weekly_sales;


		
            
            