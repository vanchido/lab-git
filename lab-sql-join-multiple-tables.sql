USE sakila;

-- Write a query to display for each store its store ID, city, and country.
SELECT store_id, address, city, country FROM address a
JOIN store s ON s.address_id = a.address_id
JOIN city ON a.city_id = city.city_id
JOIN country ON city.country_id = country.country_id;

-- Write a query to display how much business, in dollars, each store brought in.
SELECT store_id, sum(amount) FROM staff
JOIN payment where staff.staff_id = payment.staff_id
GROUP BY store_id;

-- What is the average running time of films by category?
SELECT name as category, avg(length) FROM film_category fc
JOIN film f ON fc.film_id = f.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY name;

-- Which film categories are longest? by max length
SELECT name as category, max(length) FROM film_category fc
JOIN film f ON fc.film_id = f.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY name
ORDER BY max(length) DESC
LIMIT 10;

-- Display the most frequently rented movies in descending order.
SELECT title, count(rental_id) FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY title
ORDER BY count(rental_id) DESC
LIMIT 10;

-- List the top five genres in gross revenue in descending order.
SELECT name as category, sum(amount) FROM film_category fc
JOIN film f ON fc.film_id = f.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY name
ORDER BY sum(amount) DESC
LIMIT 5;

-- Is "Academy Dinosaur" available for rent from Store 1?
SELECT DISTINCT title, i.inventory_id, store_id FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE title = "Academy Dinosaur"
AND store_id = 1
AND return_date IS NOT NULL;
