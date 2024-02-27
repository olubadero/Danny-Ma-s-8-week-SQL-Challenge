# 1. Data Cleansing Steps

1. In a single query, perform the following operations and generate a new table in the data_mart schema named clean_weekly_sales:

-- Convert the week_date to a DATE format
```sql
SELECT *, str_to_date(week_date, '%d/%m/%Y') AS new_date
FROM weekly_sales;
```
- Excerpt:

<img width="473" alt="Screenshot 2024-02-27 at 10 55 17" src="https://github.com/olubadero/Danny_Mas_8-week_SQL_Challenge/assets/111298078/67ec9c38-52ff-4902-b472-007ed524210d">


----

2. Add a week_number as the second column for each week_date value, for example any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2 etc
```sql
SELECT *, str_to_date(week_date, '%d/%m/%Y') AS new_date, WEEK(str_to_date(week_date, '%d/%m/%Y')) AS week_number
FROM weekly_sales;
```
- Excerpt:

<img width="529" alt="Screenshot 2024-02-27 at 10 55 47" src="https://github.com/olubadero/Danny_Mas_8-week_SQL_Challenge/assets/111298078/bb9657a1-4ddd-4708-a1ec-71b28e40f5cf">


3. Add a month_number with the calendar month for each week_date value as the 3rd column
```sql
SELECT *, str_to_date(week_date, '%d/%m/%Y') AS new_date, 
			WEEK(str_to_date(week_date, '%d/%m/%Y')) AS week_number, 
            MONTH(str_to_date(week_date, '%d/%m/%Y')) AS Month
            
FROM weekly_sales;
```

- Excerpt:

<img width="559" alt="Screenshot 2024-02-27 at 10 56 17" src="https://github.com/olubadero/Danny_Mas_8-week_SQL_Challenge/assets/111298078/4e8b5cc4-dd4a-4fa5-87ee-697590a4d732">


----

4. Add a calendar_year column as the 4th column containing either 2018, 2019 or 2020 values
```sql
SELECT *, str_to_date(week_date, '%d/%m/%Y') AS new_date, 
			WEEK(str_to_date(week_date, '%d/%m/%Y')) AS week_number, 
            MONTH(str_to_date(week_date, '%d/%m/%Y')) AS Month,
            YEAR(str_to_date(week_date, '%d/%m/%Y')) AS Year
FROM weekly_sales;
```

- Excerpt:

<img width="593" alt="Screenshot 2024-02-27 at 11 00 29" src="https://github.com/olubadero/Danny_Mas_8-week_SQL_Challenge/assets/111298078/4868a9ac-5cde-45cd-abb6-14178f5fcadc">

----

5. Add a new column called age_band after the original segment column using the following mapping on the number inside the segment value
-- segment	age_band
-- 1	Young Adults
-- 2	Middle Aged
-- 3 or 4	Retirees
   
```sql
SELECT *, str_to_date(week_date, '%d/%m/%Y') AS new_date, 

			WEEK(str_to_date(week_date, '%d/%m/%Y')) AS week_number, 
            MONTH(str_to_date(week_date, '%d/%m/%Y')) AS Month,
            YEAR(str_to_date(week_date, '%d/%m/%Y')) AS Year, 
            
            CASE WHEN RIGHT(Segment, 1) = 1 THEN 'Young Adults' 
			WHEN RIGHT(Segment, 1) = 2 THEN 'Middle Aged' 
            WHEN RIGHT(Segment, 1) = 3 OR 4 THEN 'Retirees' 
			ELSE 'Unknown'END AS age_band
            
FROM weekly_sales;
```

- Excerpt:

<img width="683" alt="Screenshot 2024-02-27 at 11 01 09" src="https://github.com/olubadero/Danny_Mas_8-week_SQL_Challenge/assets/111298078/4ddfac16-4c11-47b2-9ef8-e7746688d604">

----

6. Add a new demographic column using the following mapping for the first letter in the segment values:
-- segment	demographic
-- C	Couples
-- F	Families
```sql
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
```

- Excerpt:

<img width="799" alt="Screenshot 2024-02-27 at 11 01 36" src="https://github.com/olubadero/Danny_Mas_8-week_SQL_Challenge/assets/111298078/6c114df2-7ddd-4cc3-ae6f-03a782c5edd9">


----

7. Generate a new avg_transaction column as the sales value divided by transactions rounded to 2 decimal places for each record
```sql
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
```

- Excerpt:

![Screenshot 2024-02-27 at 11 02 11](https://github.com/olubadero/Danny_Mas_8-week_SQL_Challenge/assets/111298078/cd850ac4-23d2-4b98-85be-9e4376ebb9fa)



----

8. In a single query, perform the following operations and generate a new table in the data_mart schema named clean_weekly_sales:

```sql                     
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
```

- Here is an excerpt of the newly cleaned and created table:

<img width="637" alt="Screenshot 2024-02-27 at 11 05 01" src="https://github.com/olubadero/Danny_Mas_8-week_SQL_Challenge/assets/111298078/9c134656-d67a-416b-bf2e-f166595d68e0">



		
            
            
