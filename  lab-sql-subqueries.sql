USE sakila;

-- How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT count(inventory_id) FROM inventory
WHERE film_id = (
				SELECT film_id FROM film
				WHERE title = 'Hunchback Impossible'
                );


-- List all films whose length is longer than the average of all the films.
SELECT title, length FROM film
WHERE length > (
				SELECT avg(length) FROM film
                )
ORDER BY length ASC;


-- Use subqueries to display all actors who appear in the film Alone Trip.
SELECT film_actor.actor_id, first_name, last_name FROM film_actor
JOIN actor ON film_actor.actor_id = actor.actor_id
WHERE film_id IN (
				SELECT film_id FROM film
                WHERE title = 'Alone Trip'
                );


-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT title, film_id FROM film
WHERE film_id IN (
				SELECT film_id FROM film_category 
				WHERE category_id = (
									SELECT category_id FROM category 
									WHERE name = 'Family'
									)
				);


-- Get name and email from customers from Canada using subqueries. 
SELECT first_name, last_name, email FROM customer
WHERE address_id IN (
					SELECT address_id FROM address
					WHERE city_id IN (
									SELECT city_id FROM city
									WHERE country_id = (
														SELECT country_id FROM country
														WHERE country = 'Canada'
														)
									)
					);


-- Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
SELECT first_name, last_name, email FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ON a.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE country.country = 'Canada';


-- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT title, film_actor.actor_id, first_name, last_name FROM film
JOIN film_actor ON film.film_id = film_actor.film_id
JOIN actor ON actor.actor_id = film_actor.actor_id
WHERE film_actor.actor_id = (
							SELECT actor_id FROM film_actor
							GROUP BY actor_id
							ORDER BY count(film_id) DESC
							LIMIT 1
							);


-- Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
SELECT title, r.customer_id FROM rental r
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE customer_id = (
					SELECT customer_id FROM payment
					GROUP BY customer_id
					ORDER BY sum(amount) DESC
					LIMIT 1);


-- Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.
SELECT customer_id, sum(amount) FROM payment
GROUP BY customer_id
HAVING sum(amount) > (
					SELECT sum(amount)/ count(DISTINCT customer_id) AS avg_total_amount FROM payment
					);
