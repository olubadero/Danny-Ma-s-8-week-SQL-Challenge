SELECT * 
FROM `Data _Mart`.Data;

-- In a single query, perform the following operations and generate a new table in the data_mart 
-- schema named clean_weekly_sales:

-- Convert the week_date to a DATE format
SELECT *, str_to_date(week_date, '%d/%m/%Y') AS date
FROM `Data _Mart`.Data;

-- Add a week_number as the second column for each week_date value, 
-- for example any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2 etc
SELECT *, str_to_date(week_date, '%d/%m/%Y') as date, week(str_to_date(week_date, '%d/%m/%Y')) AS week_number 
FROM `Data _Mart`.Data;

-- Add a month_number with the calendar month for each week_date value as the 3rd column
SELECT *, str_to_date(week_date, '%d/%m/%Y'), month(str_to_date(week_date, '%d/%m/%Y')) AS month_number,
monthname(str_to_date(week_date, '%d/%m/%Y')) AS month_name
FROM `Data _Mart`.Data;
-- Add a calendar_year column as the 4th column containing either 2018, 2019 or 2020 values
SELECT *, str_to_date(week_date, '%d/%m/%Y') as date, year(str_to_date(week_date, '%d/%m/%Y')) AS year
FROM `Data _Mart`.Data;

-- Add a new column called age_band after the original segment column using the following 
-- mapping on the number inside the segment value
-- segment	age_band
-- 1	Young Adults
-- 2	Middle Aged
-- 3 or 4	Retirees
SELECT DISTINCT(segment)
FROM `Data _Mart`.Data;

SELECT segment, CASE WHEN RIGHT(Segment, 1) = '1' THEN 'Young Adults'
					WHEN RIGHT(Segment, 1) = '2' THEN 'Middle Aged'
                    WHEN RIGHT(Segment, 1) IN ('3', '4') THEN 'Retirees'
                    ELSE 'Unknown' END AS Age_band
FROM `Data _Mart`.Data;

-- Add a new demographic column using the following mapping for the first letter in the segment values:
-- segment	demographic
-- C	Couples
-- F	Families

SELECT segment, CASE WHEN LEFT(Segment, 1) = 'C' THEN 'Couples'
					WHEN LEFT(Segment, 1) = 'F' THEN 'Families'
                    ELSE 'Unknown' END AS demographic
FROM `Data _Mart`.Data;

-- Ensure all null string values with an "unknown" string value in the original segment column 
-- as well as the new age_band and demographic columns

-- Generate a new avg_transaction column as the sales value divided by transactions 
-- rounded to 2 decimal places for each record
SELECT ROUND(Sales/Transactions, 2) as avg_transaction
FROM `Data _Mart`.Data;

-- merging to create new table
SELECT str_to_date(week_date, '%d/%m/%Y') AS date, year(str_to_date(week_date, '%d/%m/%Y')) AS year, month(str_to_date(week_date, '%d/%m/%Y')) AS month_number, 
week(str_to_date(week_date, '%d/%m/%Y')) AS week_number, Region, Platform, Customer_type,
Sales, Transactions, ROUND(Sales/Transactions, 2) as avg_transaction,
CASE WHEN RIGHT(Segment, 1) = '1' THEN 'Young Adults'
					WHEN RIGHT(Segment, 1) = '2' THEN 'Middle Aged'
                    WHEN RIGHT(Segment, 1) IN ('3', '4') THEN 'Retirees'
                    ELSE 'Unknown' END AS Age_band,
CASE WHEN LEFT(Segment, 1) = 'C' THEN 'Couples'
					WHEN LEFT(Segment, 1) = 'F' THEN 'Families'
                    ELSE 'Unknown' END AS demographic
FROM `Data _Mart`.Data;

-- create new table with merged data

CREATE TABLE `Data _Mart`.New_Data AS(SELECT str_to_date(week_date, '%d/%m/%Y') AS date, year(str_to_date(week_date, '%d/%m/%Y')) AS year, month(str_to_date(week_date, '%d/%m/%Y')) AS month_number, 
week(str_to_date(week_date, '%d/%m/%Y')) AS week_number, Region, Platform, Customer_type,
Sales, Transactions, ROUND(Sales/Transactions, 2) as avg_transaction,
CASE WHEN RIGHT(Segment, 1) = '1' THEN 'Young Adults'
					WHEN RIGHT(Segment, 1) = '2' THEN 'Middle Aged'
                    WHEN RIGHT(Segment, 1) IN ('3', '4') THEN 'Retirees'
                    ELSE 'Unknown' END AS Age_band,
CASE WHEN LEFT(Segment, 1) = 'C' THEN 'Couples'
					WHEN LEFT(Segment, 1) = 'F' THEN 'Families'
                    ELSE 'Unknown' END AS demographic
FROM `Data _Mart`.Data);

SELECT * 
FROM `Data _Mart`.NEW_Data;

