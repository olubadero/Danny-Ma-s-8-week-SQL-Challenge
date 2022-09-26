SELECT *
FROM `Data _Mart`.NEW_Data;

-- This technique is usually used when we inspect an important event and want to inspect the impact before and after a certain point in time.
-- Taking the week_date value of 2020-06-15 as the baseline week where the Data Mart sustainable packaging changes came into effect.
-- We would include all week_date values for 2020-06-15 as the start of the period after the change and the previous week_date values would be before
-- Using this analysis approach - answer the following questions:

-- What is the total sales for the 4 weeks before and after 2020-06-15? What is the growth 
-- or reduction rate in actual values and percentage of sales?

SELECT date, week_number                                         
FROM `Data _Mart`.NEW_Data
WHERE  date = '2020-06-15';
-- '2020-06-15', '24'
																
WITH analysis_period AS(SELECT week_number, date, SUM(CASE WHEN week_number BETWEEN 20 AND 27 THEN Sales END) as total_sales
		FROM `Data _Mart`.NEW_Data
		WHERE date BETWEEN date_add('2020-06-15', interval -4 week) AND date_add('2020-06-15', interval 4 week)
		GROUP BY week_number, date), 
	change_period AS(SELECT SUM(Total_sales) as T_sales, SUM(CASE WHEN week_number BETWEEN  20 and 23 THEN Total_Sales END) as sales_before, 
	   SUM(CASE WHEN week_number BETWEEN  24 and 27 THEN Total_Sales END) as sales_after
		FROM analysis_period)
SELECT sales_before, sales_after, (sales_after - sales_before) as Difference, 
ROUND((sales_after - sales_before)/Sales_before * 100, 2) as sales_percentage
FROM change_period;

-- sales_before, sales_after, Difference, sales_percentage
-- 2345878357, 2318994169, -26884188, -1.15


-- What about the entire 12 weeks before and after?
WITH analysis_period AS(SELECT week_number, date, SUM(CASE WHEN week_number BETWEEN 12 AND 36 THEN Sales END) as total_sales
		FROM `Data _Mart`.NEW_Data
        WHERE date BETWEEN date_add('2020-06-15', interval -12 week) AND date_add('2020-06-15', interval 12 week)
		GROUP BY week_number, date), 
	change_period AS(SELECT SUM(CASE WHEN week_number BETWEEN  12 and 23 THEN Total_Sales END) as sales_before, 
	   SUM(CASE WHEN week_number BETWEEN  24 and 36 THEN Total_Sales END) as sales_after
		FROM analysis_period)
SELECT sales_before, sales_after, (sales_after - sales_before) as Difference, 
ROUND((sales_after - sales_before)/Sales_before * 100, 2) as sales_percentage
FROM change_period;

-- sales_before, sales_after, Difference, sales_percentage
-- 7126273147, 6973947753, -152325394, -2.14

-- How do the sale metrics for these 2 periods before and after compare with the previous 
-- years in 2018 and 2019?


WITH analysis_period AS(SELECT year,
			SUM(CASE WHEN week_number BETWEEN  20 and 23 THEN Sales END) as sales_before_4wks, 
			SUM(CASE WHEN week_number BETWEEN  24 and 27 THEN Sales END) as sales_after_4wks,
			SUM(CASE WHEN week_number BETWEEN  12 and 23 THEN Sales END) as sales_before_12wks, 
			SUM(CASE WHEN week_number BETWEEN  24 and 36 THEN Sales END) as sales_after_12wks
        FROM `Data _Mart`.NEW_Data
        GROUP BY year)
SELECT year, sales_before_4wks, sales_after_4wks, (sales_after_4wks - sales_before_4wks) as Difference_4wks,
	ROUND((sales_after_4wks - sales_before_4wks)/Sales_before_4wks * 100, 2) as sales_percentage_4wks,
	sales_before_12wks, sales_after_12wks, (sales_after_12wks - sales_before_12wks) as Difference_12wks,
	ROUND((sales_after_12wks - sales_before_12wks)/Sales_before_12wks * 100, 2) as sales_percentage_12wks
FROM analysis_period
ORDER BY Year;

-- year, sales_before_4wks, sales_after_4wks, Difference_4wks, sales_percentage_4wks, sales_before_12wks, sales_after_12wks, Difference_12wks, sales_percentage_12wks
-- 2018, 2125140809, 2129242914, 4102105, 0.19, 6396562317, 6500818510, 104256193, 1.63
-- 2019, 2249989796, 2252326390, 2336594, 0.10, 6883386397, 6862646103, -20740294, -0.30
-- 2020, 2345878357, 2318994169, -26884188, -1.15, 7126273147, 6973947753, -152325394, -2.14
