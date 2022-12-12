USE sakila;

-- Get all pairs of actors that worked together.
SELECT fa1.film_id, fa1.actor_id, fa2.actor_id 
FROM film_actor fa1
JOIN film_actor fa2
ON fa1.actor_id != fa2.actor_id
AND fa1.film_id = fa2.film_id
ORDER BY fa1.film_id, fa1.actor_id;

-- Get all pairs of customers that have rented the same film more than 1 time.
SELECT m1.film_id, m1.customer_id, m2.customer_id
FROM (SELECT film_id, customer_id, count(rental_id)
	FROM inventory i
	JOIN rental r
	ON i.inventory_id = r.inventory_id
	GROUP BY customer_id, film_id
	HAVING count(rental_id) > 1
	ORDER BY film_id ASC) AS m1
JOIN (SELECT film_id, customer_id, count(rental_id)
	FROM inventory i
	JOIN rental r
	ON i.inventory_id = r.inventory_id
	GROUP BY customer_id, film_id
	HAVING count(rental_id) > 1
	ORDER BY film_id ASC) AS m2
ON m1.film_id = m2.film_id
AND m1.customer_id != m2.customer_id
ORDER BY m1.customer_id ASC;

-- Get all possible pairs of actors and films.
SELECT * FROM (
	SELECT DISTINCT film_id FROM film_actor) sub1
CROSS JOIN (
	SELECT DISTINCT actor_id FROM film_actor) sub2;