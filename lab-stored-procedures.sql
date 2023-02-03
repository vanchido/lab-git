USE sakila;

-- stored procedures 
DROP PROCEDURE customer_by_category;

DELIMITER //
CREATE PROCEDURE customer_by_category(param1 CHAR(20))
BEGIN
SELECT DISTINCT c.first_name, c.last_name, c.email FROM rental r
LEFT JOIN customer c ON r.customer_id = c.customer_id
LEFT JOIN inventory i ON r.inventory_id = i.inventory_id
LEFT JOIN film_category fc ON i.film_id = fc.film_id
LEFT JOIN category cat ON fc.category_id = cat.category_id
WHERE cat.name = param1;
END //
DELIMITER ;

CALL customer_by_category('Action');

-- Write a query to check the number of movies released in each movie category.
USE sakila;

SELECT name, COUNT(film.film_id) count_movies FROM category
LEFT JOIN film_category ON category.category_id = film_category.category_id
LEFT JOIN film ON film.film_id = film_category.film_id
GROUP BY name
HAVING count_movies > 60;

-- Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
-- Pass that number as an argument in the stored procedure.
DROP PROCEDURE movies_by_category;

DELIMITER //
CREATE PROCEDURE movies_by_category(param2 INT)
BEGIN
SELECT name, COUNT(film.film_id) count_movies FROM category
LEFT JOIN film_category ON category.category_id = film_category.category_id
LEFT JOIN film ON film.film_id = film_category.film_id
GROUP BY name
HAVING count_movies > param2;
END //
DELIMITER ;

CALL movies_by_category(40);
