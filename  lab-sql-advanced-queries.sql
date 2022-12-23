USE sakila;

-- List each pair of actors that have worked together.
SELECT fa1.film_id, fa1.actor_id, fa2.actor_id 
FROM film_actor fa1
JOIN film_actor fa2
ON fa1.actor_id != fa2.actor_id
AND fa1.film_id = fa2.film_id
ORDER BY fa1.film_id, fa1.actor_id;

-- For each film, list actor that has acted in more films.
SELECT film_id, actor_id, count_film, ranking 
FROM (
		WITH cte_count_view AS (
						SELECT actor_id, count(film_id) as count_film
                        FROM film_actor
                        GROUP BY actor_id
                        )
        SELECT fa.film_id, fa.actor_id, count_film, row_number() over (partition by film_id order by count_film desc) as ranking
		FROM film_actor fa
		JOIN cte_count_view cte
		ON fa.actor_id = cte.actor_id
		ORDER BY fa.film_id, ranking
        ) AS sub
WHERE ranking < 10;
