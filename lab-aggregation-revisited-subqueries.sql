USE sakila;

-- Select the first name, last name, and email address of all the customers who have rented a movie.
SELECT DISTINCT c.first_name, c.last_name, c.email FROM customer c
RIGHT JOIN rental r
ON c.customer_id = r.customer_id;

-- What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).
SELECT p.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, ROUND(AVG(amount),2) AS average_payment FROM payment p
LEFT JOIN customer c
ON p.customer_id = c.customer_id
GROUP BY customer_id;

-- Select the name and email address of all the customers who have rented the "Action" movies.
-- Write the query using multiple join statements
SELECT DISTINCT c.first_name, c.last_name, c.email FROM rental r
LEFT JOIN customer c ON r.customer_id = c.customer_id
LEFT JOIN inventory i ON r.inventory_id = i.inventory_id
LEFT JOIN film_category fc ON i.film_id = fc.film_id
LEFT JOIN category cat ON fc.category_id = cat.category_id
WHERE cat.name = 'Action';

-- Write the query using sub queries with multiple WHERE clause and IN condition
SELECT c.first_name, c.last_name, c.email FROM customer c
WHERE c.customer_id IN 
	(
	SELECT r.customer_id FROM rental r
	WHERE r.inventory_id IN 
		(
		SELECT i.inventory_id FROM inventory i
		WHERE i.film_id IN 
			(
			SELECT fc.film_id FROM film_category fc
			WHERE fc.category_id IN 
				(
				SELECT cat.category_id FROM category cat
				WHERE cat.name = 'Action'
                )
			)			
		)
	);

-- Verify if the above two queries produce the same results or not
-- YES

-- Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. 
-- If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, 
-- and if it is more than 4, then it should be high.
SELECT payment_id, customer_id, rental_id, amount, CONCAT(COALESCE(low,''),COALESCE(medium,''),COALESCE(high,'')) AS classifying
FROM (
		SELECT *, 
		(CASE WHEN amount < 2 THEN 'low' END) AS low, 
		(CASE WHEN amount >= 2 AND amount < 4 THEN 'medium' END) AS medium,
        (CASE WHEN amount >= 4 THEN 'high' END) AS high
		FROM payment
        ) SUB1;