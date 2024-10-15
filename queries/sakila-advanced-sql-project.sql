-- Advanced SQL Project: Sakila Database
-- Author: Tsegazeab Berhie


-- Lists all actors (firstName, lastName) who acted in more than 25 movies and count of movies against each actor.
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS movie_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING movie_count > 25;

-- Lists the actors who have worked in German language movies.
SET SQL_SAFE_UPDATES=0;
UPDATE film SET language_id=6 WHERE title LIKE "%ACADEMY%";
SELECT DISTINCT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.language_id = 6;

-- Lists actors who acted in horror movies, showing the count of movies.
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS horror_movie_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Horror'
GROUP BY a.actor_id;

-- Lists all customers who rented more than 3 horror movies.
SELECT c.first_name, c.last_name, COUNT(r.rental_id) AS horror_rentals
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
WHERE cat.name = 'Horror'
GROUP BY c.customer_id
HAVING horror_rentals > 3;

-- Lists all customers who rented a movie starring SCARLETT BENING.
SELECT DISTINCT c.first_name, c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE a.first_name = 'SCARLETT' AND a.last_name = 'BENING';

-- Lists customers residing at postal code 62703 who rented documentaries.
SELECT c.first_name, c.last_name
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
WHERE a.postal_code = '62703' AND cat.name = 'Documentary';

-- Finds all addresses where the second address line is not empty, sorted.
SELECT address2
FROM address
WHERE address2 IS NOT NULL AND address2 <> ''
ORDER BY address2;

-- Counts how many films involve a "Crocodile" and a "Shark" based on film description.
SELECT COUNT(*)
FROM film
WHERE description LIKE '%Crocodile%' AND description LIKE '%Shark%';

-- Lists actors who played in films involving both "Crocodile" and "Shark", along with the release year, sorted by the actors’ last names.
SELECT a.first_name, a.last_name, f.release_year
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.description LIKE '%Crocodile%' AND f.description LIKE '%Shark%'
ORDER BY a.last_name;

-- Finds all film categories with between 55 and 65 films, sorted by the number of films.
SELECT c.name, COUNT(f.film_id) AS film_count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.category_id
HAVING film_count BETWEEN 55 AND 65
ORDER BY film_count DESC;

-- Finds the categories where the average difference between the film replacement cost and rental rate is larger than $17.
SELECT c.name, AVG(f.replacement_cost - f.rental_rate) AS avg_diff
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.category_id
HAVING avg_diff > 17;

-- Lists all customers and staff given a store id, without removing duplicates.
SELECT first_name, last_name FROM customer WHERE store_id = 1
UNION
SELECT first_name, last_name FROM staff WHERE store_id = 1;

-- Lists actors and customers whose first name is the same as the actor with ID 8.
SELECT a.first_name, a.last_name FROM actor a WHERE a.first_name = (SELECT first_name FROM actor WHERE actor_id = 8)
UNION
SELECT c.first_name, c.last_name FROM customer c WHERE c.first_name = (SELECT first_name FROM actor WHERE actor_id = 8);

-- Lists customers and payment amounts where payments are greater than the average.
SELECT customer_id, amount FROM payment WHERE amount > (SELECT AVG(amount) FROM payment);

-- Lists customers who have rented movies at least once.
SELECT first_name, last_name FROM customer WHERE customer_id IN (SELECT DISTINCT customer_id FROM rental);

-- Finds the floor of the maximum, minimum, and average payment amounts.
SELECT FLOOR(MAX(amount)) AS max_payment, FLOOR(MIN(amount)) AS min_payment, FLOOR(AVG(amount)) AS avg_payment FROM payment;

-- Creates a view called actors_portfolio which contains information about actors and films (including titles and category).
CREATE VIEW actors_portfolio AS
SELECT a.actor_id, a.first_name, a.last_name, f.title, c.name AS category
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id;

-- Describes the structure of the view and queries information on the actor ADAM GRANT.
DESCRIBE actors_portfolio;
SELECT * FROM actors_portfolio WHERE first_name = 'ADAM' AND last_name = 'GRANT';

-- Inserts a new movie titled 'Data Hero' in the Sci-Fi category starring ADAM GRANT.
INSERT INTO film (title, language_id, rental_duration, rental_rate, replacement_cost)
VALUES ('Data Hero', 1, 7, 4.99, 19.99);

INSERT INTO film_actor (actor_id, film_id) 
VALUES ((SELECT actor_id FROM actor WHERE first_name = 'ADAM' AND last_name = 'GRANT'), LAST_INSERT_ID());

INSERT INTO film_category (film_id, category_id) 
VALUES (LAST_INSERT_ID(), (SELECT category_id FROM category WHERE name = 'Sci-Fi'));

-- Extracts the street number (characters 1 through 4) from customer addressLine1.
SELECT SUBSTRING(address, 1, 4) AS street_number FROM address;

-- Finds actors whose last name starts with the character A, B, or C.
SELECT first_name, last_name FROM actor WHERE last_name LIKE 'A%' OR last_name LIKE 'B%' OR last_name LIKE 'C%';

-- Finds film titles that contain exactly 10 characters.
SELECT title FROM film WHERE LENGTH(title) = 10;

-- Finds the number of days between two date values rental_date and return_date.
SELECT rental_id, DATEDIFF(return_date, rental_date) AS days_rented FROM rental;
