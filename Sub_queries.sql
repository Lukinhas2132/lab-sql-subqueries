Use sakila

/**Number of copies of "Hunchback Impossible" in inventory**/
SELECT COUNT(*) AS total_copies
FROM inventory i
JOIN film f ON i.film_id = f.film_id
WHERE f.title = 'Hunchback Impossible';

/**List all films longer than the average length of all films**/
SELECT 
    title, 
    length 
FROM film
WHERE length > (SELECT AVG(length) FROM film);


/**Display all actors who appear in the film "Alone Trip"**/
SELECT 
    a.actor_id,
    a.first_name,
    a.last_name
FROM actor a
WHERE a.actor_id IN (
    SELECT fa.actor_id
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    WHERE f.title = 'Alone Trip'
);


-- BONUS ****----
/**Identifying all movies categorized as “Family” films**/
SELECT f.film_id, f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c       ON fc.category_id = c.category_id
WHERE c.name = 'Family';

/**Retrieving the name and email of customers from Canada , SUBQUERY***/
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE city_id IN (
        SELECT city_id
        FROM city
        WHERE country_id IN (
            SELECT country_id
            FROM country
            WHERE country = 'Canada'
        )
    )
);

/** Joins**/
SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address a   ON c.address_id = a.address_id
JOIN city ci     ON a.city_id    = ci.city_id
JOIN country co  ON ci.country_id = co.country_id
WHERE co.country = 'Canada';

/**Determine which films were starred by the most prolific actor**/
-- Finding the most prolific actor (the one who acted in the most films)--
SELECT actor_id, COUNT(*) AS film_count
FROM film_actor
GROUP BY actor_id
ORDER BY film_count DESC
LIMIT 1;

/**Retrieving actor’s films using a subquery**/
SELECT f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
WHERE fa.actor_id = (
    SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

/**Find the films rented by the most profitable customer**/
-- Identifying the most profitable customer (subquery) --
SELECT customer_id
FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 1;

/**Retrieving films rented by that customer**/
SELECT f.film_id, f.title
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f      ON i.film_id = f.film_id
WHERE r.customer_id = (
  SELECT customer_id
  FROM payment
  GROUP BY customer_id
  ORDER BY SUM(amount) DESC
  LIMIT 1
);

/**Retrieve the customer (client) ID and total amount spent only for those who spent more than the average total spent across all customers**/
SELECT 
    customer_id AS client_id,
    SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (
    SELECT AVG(total_by_customer)
    FROM (
        SELECT SUM(amount) AS total_by_customer
        FROM payment
        GROUP BY customer_id
    ) AS sub
);



