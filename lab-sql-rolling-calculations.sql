USE sakila;

-- Get number of monthly active customers.
WITH cte_monthly_active_customers AS (SELECT *, DATE_FORMAT(CONVERT(rental_date,DATE), '%Y-%m') AS month FROM rental)
SELECT month, COUNT(month) AS active_customers FROM cte_monthly_active_customers
GROUP BY month;

-- Active users in the previous month.
WITH cte_monthly_active_customers AS (
									SELECT *, DATE_FORMAT(CONVERT(rental_date,DATE), '%Y-%m') AS month 	
                                    FROM rental
                                    ORDER BY month ASC
                                    )
SELECT month, COUNT(month) AS active_this_month, LAG(COUNT(month),1) OVER (ORDER BY month) AS active_last_month 
FROM cte_monthly_active_customers
GROUP BY month;

-- Percentage change in the number of active customers.
WITH cte_monthly_active_customers AS (
									SELECT *, DATE_FORMAT(CONVERT(rental_date,DATE), '%Y-%m') AS month 	
                                    FROM rental
                                    )
SELECT month, COUNT(month) AS active_this_month, 
				LAG(COUNT(month),1) OVER (ORDER BY month) AS active_last_month,
                (COUNT(month)-(LAG(COUNT(month),1) OVER (ORDER BY month)))/COUNT(month)*100 AS percentage_change
FROM cte_monthly_active_customers
GROUP BY month;

-- Retained customers every month.
-- create a view which has distinct active customer and month
CREATE OR REPLACE VIEW sakila.customer_activity AS 
		SELECT DISTINCT customer_id, DATE_FORMAT(CONVERT(rental_date,DATE), '%Y-%m') AS month
		FROM rental
		ORDER BY month ASC;
        
SELECT * FROM customer_activity;

-- create a view in which the client is active this month, and another month before that (retained customers)
CREATE OR REPLACE VIEW sakila.retained_customers AS
		SELECT c1.customer_id, c1.month, c2.month as previous_month
        FROM customer_activity c1 
        JOIN customer_activity c2
		ON c1.customer_id = c2.customer_id
        AND c2.month < c1.month;
        
SELECT * FROM retained_customers;

-- count from the retained_customers view to have total number of retained customers
SELECT month, COUNT(customer_id) as recurrent_customers 
FROM retained_customers
GROUP BY month;