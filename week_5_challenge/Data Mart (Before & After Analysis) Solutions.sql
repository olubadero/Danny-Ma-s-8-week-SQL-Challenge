USE data_mart;
				-- 3. Before & After Analysis
-- This technique is usually used when we inspect an important event and want to inspect the impact before and after a certain point in time.
-- Taking the week_date value of 2020-06-15 as the baseline week where the Data Mart sustainable packaging changes came into effect.
-- We would include all week_date values for 2020-06-15 as the start of the period after the change and the previous week_date values would be before
-- Using this analysis approach - answer the following questions:

-- What is the total sales for the 4 weeks before and after 2020-06-15? What is the growth or reduction rate in actual values and percentage of sales?
-- '2020-06-15' is week 24 so the analysis will be from week 20 to 27
WITH   analysis_period AS(SELECT week_number, new_date, SUM(CASE WHEN week_number BETWEEN 20 AND 27 THEN Sales END) as total_sales
		FROM clean_weekly_sales
		WHERE new_date BETWEEN date_add('2020-06-15', interval -4 week) AND date_add('2020-06-15', interval 4 week)
		GROUP BY week_number,new_date), 
        
		4_week_change_period AS(SELECT SUM(Total_sales) as T_sales, 
        SUM(CASE WHEN week_number BETWEEN  20 and 23 THEN Total_Sales END) as total_sales_before, 
	   SUM(CASE WHEN week_number BETWEEN  24 and 27 THEN Total_Sales END) as total_sales_after
		FROM analysis_period)
        
SELECT CONCAT('$',Total_sales_before) AS Total_sales_before, CONCAT('$',Total_sales_after) AS Total_sales_after, 
		(total_sales_after - total_sales_before) as Difference, 
		CONCAT(ROUND((total_sales_after - total_sales_before)/total_sales_before * 100, 2),'%') as Difference_percentage
FROM 4_week_change_period;

-- Total_sales_before, Total_sales_after, 	Difference, 	Difference_percentage
-- 	'$2345878357', 		'$2318994169', 		'-26884188', 			'-1.15%'


-- What about the entire 12 weeks before and after?


WITH analysis_period AS(
		SELECT new_date, week_number, SUM(sales) AS sales
		FROM clean_weekly_sales
		WHERE new_date BETWEEN date_add('2020-06-15', INTERVAL -12 WEEK) AND date_add('2020-06-15', INTERVAL 12 WEEK)
		GROUP BY new_date, week_number
		ORDER BY week_number),
        
	12_week_change_period AS
		(SELECT SUM(sales) AS all_sales,
        SUM(CASE WHEN week_number BETWEEN 12 AND 23 THEN SALES ELSE 0 END) AS before_changes, 
				SUM(CASE WHEN week_number BETWEEN 24 AND 35 THEN SALES ELSE 0 END) AS after_changes
		FROM analysis_period)
        
SELECT CONCAT('$',after_changes - before_changes) AS difference, CONCAT(ROUND((after_changes - before_changes)/before_changes * 100,2), '%') AS difference_percentage
FROM 12_week_change_period;

-- difference, 			difference_percentage
-- '$-152325394', 			'-2.14%'


-- How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?
-- This require the same 4 and 12 weeks before and after analysis done in 2020 to be done to both 2018 and 2019 to observe if there were any positive or negative differences 

WITH Analysis_period AS (SELECT year, week_number, new_date, SUM(sales) as total_sales
						FROM clean_weekly_sales
						WHERE week_number BETWEEN 20 AND 27 
						GROUP BY year, week_number,new_date
						ORDER BY year),
	yearly_change_period AS (SELECT year, SUM(CASE WHEN week_number BETWEEN  20 and 23 THEN Total_Sales END) as total_sales_before, 
									   SUM(CASE WHEN week_number BETWEEN  24 and 27 THEN Total_Sales END) as total_sales_after
							FROM analysis_period
							GROUP BY year)

SELECT  Year, CONCAT('$',Total_sales_before) AS Total_sales_before, CONCAT('$',Total_sales_after) AS Total_sales_after, 
		CONCAT('$',(total_sales_after - total_sales_before)) as Difference, 
		CONCAT(ROUND((total_sales_after - total_sales_before)/total_sales_before * 100, 2),'%') as Difference_percentage
FROM yearly_change_period;

-- Year,	Total_sales_before, Total_sales_after, Difference,	 Difference_percentage
-- 2018, 		'$2125140809', 	 '$2129242914',   '$4102105', 		'0.19%'
-- 2019,	    '$2249989796', 	 '$2252326390',   '$2336594', 		'0.10%'
-- 2020,	   '$2345878357',  	 '$2318994169',   '$-26884188', 	'-1.15%'

-- In the 4 weeks before and after analysis, the best year for sales difference is 2018, 
-- however there has been a downward trend since 2018, which has even resulted in a major loss in 2020 for the same time period.

-- Now lets analyse the 12 week before and after sales

WITH Analysis_period AS (SELECT year, week_number, new_date, SUM(sales) as total_sales
						FROM clean_weekly_sales
						WHERE week_number BETWEEN 12 AND 35 
						GROUP BY year, week_number,new_date
						ORDER BY year),
	yearly_change_period AS (SELECT year, SUM(CASE WHEN week_number BETWEEN  12 AND 23 THEN Total_Sales END) as total_sales_before, 
									   SUM(CASE WHEN week_number BETWEEN  24 and 35 THEN Total_Sales END) as total_sales_after
							FROM analysis_period
							GROUP BY year)

SELECT  Year, CONCAT('$',Total_sales_before) AS Total_sales_before, CONCAT('$',Total_sales_after) AS Total_sales_after, 
		CONCAT('$',(total_sales_after - total_sales_before)) as Difference, 
		CONCAT(ROUND((total_sales_after - total_sales_before)/total_sales_before * 100, 2),'%') as Difference_percentage
FROM yearly_change_period; 

-- Year, 	Total_sales_before, 	Total_sales_after, 	Difference,	 Difference_percentage
-- '2018', 		'$6396562317', 		  '$6500818510', 	'$104256193', 	'1.63%'
-- '2019', 		'$6883386397', 		  '$6862646103', 	'$-20740294', 	'-0.30%'
-- '2020',		'$7126273147', 		  '$6973947753', 	'$-152325394', 	'-2.14%'

-- The same trend of decrease/loss as the 4 weeks analysis 