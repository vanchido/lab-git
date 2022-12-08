USE sakila;

# List the number of films per category.
SELECT name as category, count(name) as nb_films FROM category cat
JOIN film_category fc
ON fc.category_id = cat.category_id
GROUP BY name;

# Display the first and the last names, as well as the address, of each staff member.
SELECT first_name, last_name, address, district FROM staff JOIN address WHERE staff.address_id = address.address_id;

# Display the total amount rung up by each staff member in August 2005.
SELECT payment.staff_id, first_name, last_name, sum(amount) FROM payment
JOIN staff WHERE staff.staff_id = payment.staff_id
GROUP BY payment.staff_id;

# List all films and the number of actors who are listed for each film.
SELECT title, count(actor_id) FROM film f
JOIN film_actor fa WHERE f.film_id = fa.film_id
GROUP BY title;

# Using the payment and the customer tables as well as the JOIN command, 
# list the total amount paid by each customer. List the customers alphabetically by their last names.
SELECT first_name, last_name, count(amount) as total_amount FROM customer
JOIN payment WHERE customer.customer_id = payment.customer_id
GROUP BY payment.customer_id
ORDER BY last_name ASC;