use wolt;

## there are existing user purchases not only first users in purchases

-- creat table
DROP TABLE IF EXISTS purchases;
CREATE TABLE purchases (
	purchase_date DATETIME,
    purchase_id VARCHAR (15) PRIMARY KEY UNIQUE,
    user_id INT,
    venue_id VARCHAR (11),
    product_line VARCHAR (20)
    );
    
    DROP TABLE IF EXISTS first_purchases;
    CREATE TABLE first_purchases (
    first_purchase_date DATETIME,
	purchase_id VARCHAR (15),
    user_id INT,
    venue_id VARCHAR (11),
    product_line VARCHAR (20)
    );
  

-- check if 'puchases' contain 'first_purchases': No, it doesn't contain first_purchases information.
  WITH earliest_purchases AS (
  SELECT 
	user_id, 
    MIN(purchase_date) AS earliest_purchase_date
  FROM purchases
  GROUP BY user_id
  )
  SELECT 
	fp.user_id,
	fp.first_purchase_date,
    ep.earliest_purchase_date
  FROM first_purchases fp
  JOIN earliest_purchases ep USING (user_id)
  ;
  
  
-- merge first_purchases and purchases table (first_purchases data are not in purchases)
CREATE TEMPORARY TABLE all_purchases (
SELECT * FROM purchases
UNION
SELECT * FROM first_purchases
);
  
-- data period for first purchases: from 2020-03-12 to 2020-09-21
SELECT MIN(first_purchase_date), MAX(first_purchase_date)
FROM first_purchases;
  
-- data period for purchases: from 2020-04-21 to 2020-10-31
SELECT MIN(purchase_date), MAX(purchase_date)
FROM purchases;
  
-- Calculate retention rate
## cohort new user by first_purchase_month
WITH first_purchases_cohorts AS (
SELECT 	
	user_id,
    DATE_FORMAT(first_purchase_date, '%Y-%m') AS first_purchase_month,
	product_line
FROM first_purchases
GROUP BY 
	user_id,
	first_purchase_month,
    product_line),
## monthly purchases
monthly_purchases AS (
SELECT 
	user_id,
	DATE_FORMAT(purchase_date, '%Y-%m') AS purchase_month,
    product_line
FROM all_purchases),
## total new users by month
cohort_size AS (
SELECT 	
    DATE_FORMAT(first_purchase_date, '%Y-%m') AS first_purchase_month, 
	product_line,
    COUNT(*) AS total_first_purchase 
FROM first_purchases
GROUP BY 
	first_purchase_month,
	product_line),
## retained user subsequent month
retention AS (
SELECT 
	fpc.product_line,
    fpc.first_purchase_month,
    mp.purchase_month,
    COUNT(DISTINCT mp.user_id) AS retained_users
FROM first_purchases_cohorts fpc
JOIN monthly_purchases mp
	ON fpc.user_id = mp.user_id
    AND fpc.product_line = mp.product_line
GROUP BY 
	fpc.product_line,
    fpc.first_purchase_month,
    mp.purchase_month)
SELECT 
	r.product_line,
    r.first_purchase_month,
    r.purchase_month,
    r.retained_users,
    cs.total_first_purchase,
    (r.retained_users / cs.total_first_purchase) * 100 AS retention_rate
FROM retention r
JOIN cohort_size cs
	ON r.product_line = cs.product_line
    AND r.first_purchase_month = cs.first_purchase_month;
