## 4. Campaigns Analysis

**Generate a table that has 1 single row for every unique visit_id record and has the following columns:**

- user_id
- visit_id
- visit_start_time: the earliest event_time for each visit
- page_views: count of page views for each visit
- cart_adds: count of product cart add events for each visit
- purchase: 1/0 flag if a purchase event exists for each visit
- campaign_name: map the visit to a campaign if the visit_start_time falls between the start_date and end_date
- impression: count of ad impressions for each visit
- click: count of ad clicks for each visit
- (Optional column) cart_products: a comma separated text value with products added to the cart sorted by the order they were added to the cart (hint: use the sequence_number)
- Use the subsequent dataset to generate at least 5 insights for the Clique Bait team - bonus: prepare a single A4 infographic that the team can use for their management reporting sessions, be sure to emphasise the most important points from your findings.

**Some ideas you might want to investigate further include:**

- Identifying users who have received impressions during each campaign period and comparing each metric with other users who did not have an impression event
- Does clicking on an impression lead to higher purchase rates?
- What is the uplift in purchase rate when comparing users who click on a campaign impression versus users who do not receive an impression? What if we compare them with users who just an impression but do not click?
- What metrics can you use to quantify the success or failure of each campaign compared to eachother?


```sql
CREATE TABLE campaign_analysis AS (
	WITH purchase_check AS (
			SELECT visit_id,
				CASE WHEN n_flag >= 1 THEN TRUE ELSE false
				END AS purchase_flag
			from (SELECT visit_id,
						sum(CASE WHEN event_type = 3 THEN 1 ELSE 0 END ) AS n_flag
					FROM events
					GROUP BY visit_id) AS tmp),
	get_cart_items AS (
			SELECT e.visit_id,
			group_concat(ph.page_name, ', '
			ORDER BY sequence_number) AS cart_items
			FROM events AS e
			JOIN page_hierarchy AS ph 
				ON ph.page_id = e.page_id
			WHERE e.event_type = 2
			GROUP BY e.visit_id)
            
SELECT e.visit_id,
		u.user_id,
		min(u.start_date) AS visit_start,
		sum(CASE WHEN event_type = 1 THEN 1 ELSE 0 END) AS page_views,
		sum(CASE WHEN event_type = 2 THEN 1 ELSE 0 END) AS cart_adds,
		pc.purchase_flag AS purchase_flag,
		ci.campaign_name,
		sum(CASE WHEN event_type = 4 THEN 1 ELSE 0 END ) AS ad_impressions,
		sum(CASE WHEN event_type = 5 THEN 1 ELSE 0 END) AS ad_clicks,
		CASE WHEN gci.cart_items IS NULL THEN '' ELSE gci.cart_items END AS cart_items
FROM events AS e
JOIN users AS u 
	ON u.cookie_id = e.cookie_id
JOIN purchase_check AS pc 
	ON pc.visit_id = e.visit_id
LEFT JOIN campaign_identifier AS ci 
	ON u.start_date BETWEEN ci.start_date AND ci.end_date
LEFT JOIN get_cart_items AS gci 
	ON gci.visit_id = e.visit_id
GROUP BY e.visit_id, u.user_id, pc.purchase_flag, ci.campaign_name, gci.cart_items
ORDER BY user_id
);
```


- 3564 rows were created and here is an excerpt of the table:

```sql
SELECT *
FROM campaign_analysis
LIMIT 20;
```

<img width="869" alt="Screenshot 2024-03-04 at 11 01 00" src="https://github.com/olubadero/Danny_Mas_8-week_SQL_Challenge/assets/111298078/480b3344-79de-4d2a-ab43-1cf26d36a380">
