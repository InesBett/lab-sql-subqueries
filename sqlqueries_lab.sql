USE SAKILA;

#1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system:
SELECT 
    COUNT(*) AS number_of_copies
FROM 
    inventory
JOIN 
    film ON inventory.film_id = film.film_id
WHERE 
    film.title = 'Hunchback Impossible';

#2. List all films whose length is longer than the average length of all the films in the Sakila database::
SELECT 
    title, 
    length
FROM 
    film
WHERE 
    length > (SELECT AVG(length) FROM film);

#3. Use a subquery to display all actors who appear in the film "Alone Trip"
SELECT 
    actor.first_name, 
    actor.last_name
FROM 
    actor
WHERE 
    actor.actor_id IN (
        SELECT 
            actor_id
        FROM 
            film_actor
        JOIN 
            film ON film_actor.film_id = film.film_id
        WHERE 
            film.title = 'Alone Trip'
    );

#4. Identify all movies categorized as family films
SELECT 
    film.title
FROM 
    film
JOIN 
    film_category ON film.film_id = film_category.film_id
JOIN 
    category ON film_category.category_id = category.category_id
WHERE 
    category.name = 'Family';

#5. Retrieve the name and email of customers from Canada using both subqueries and joins
SELECT 
    customer.first_name, 
    customer.last_name, 
    customer.email
FROM 
    customer
WHERE 
    customer.address_id IN (
        SELECT address_id 
        FROM address 
        WHERE city_id IN (
            SELECT city_id 
            FROM city 
            WHERE city.country_id = (
                SELECT country_id 
                FROM country 
                WHERE country = 'Canada'
            )
        )
    );

#6. Determine which films were starred by the most prolific actor in the Sakila database
SELECT 
    actor.actor_id, 
    COUNT(film_actor.film_id) AS film_count
FROM 
    actor
JOIN 
    film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY 
    actor.actor_id
ORDER BY 
    film_count DESC
LIMIT 1;

#7. Find the films rented by the most profitable customer in the Sakila database
SELECT 
    customer.customer_id, 
    SUM(payment.amount) AS total_spent
FROM 
    customer
JOIN 
    payment ON customer.customer_id = payment.customer_id
GROUP BY 
    customer.customer_id
ORDER BY 
    total_spent DESC
LIMIT 1;

#8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average total_amount spent by each client.
SELECT 
    customer_id, 
    SUM(amount) AS total_amount_spent
FROM 
    payment
GROUP BY 
    customer_id
HAVING 
    total_amount_spent > (SELECT AVG(total_amount) FROM (
        SELECT SUM(amount) AS total_amount FROM payment GROUP BY customer_id
    ) AS subquery);

