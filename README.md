# Sakila-Database-Advanced-SQL-Project
This project showcases my ability to write advanced SQL queries and perform data analysis using the Sakila Database, a popular MySQL sample database used for database management, data retrieval, and performance testing.

## Overview
In this project, I worked on a series of advanced SQL queries to manipulate and analyze data from the Sakila database. The queries covered a wide range of SQL topics including:

- Complex joins and subqueries
- Creating views for reusable SQL queries
- Aggregation functions like COUNT(), AVG(), SUM(), etc.
- Data transformation and filtering using WHERE, LIKE, IN, and other clauses
- Performance optimization through indexing and efficient query design
## Key Features:
1. ### Data Retrieval & Aggregation:

- Queries actors who appeared in more than 25 movies
- Retrieves customers who rented specific genres of movies, such as horror films
- Identifies films involving specific keywords in their descriptions (e.g., "Crocodile" and "Shark")

2. ### Subqueries & Views:

- Created a view called actors_portfolio, which combines actor, film, and category data for easy retrieval of actor portfolios.
- Used nested queries to fetch complex results based on multiple criteria.

3. ### Performance Optimization:

- Implemented indexing strategies for efficient data retrieval, especially when working with large datasets.

## Technologies Used:
- SQL (MySQL)
- MySQL Workbench
- Sakila Database

## Example Queries: 
1. ### Query to List Actors who Acted in More than 25 Movies:
```
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS movie_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING movie_count > 25;
```
2. ### Inserting a New Movie "Data Hero" starring Adam Grant into a View:
```
INSERT INTO film (title, language_id, rental_duration, rental_rate, replacement_cost)
VALUES ('Data Hero', 1, 7, 4.99, 19.99);

INSERT INTO film_actor (actor_id, film_id) 
VALUES ((SELECT actor_id FROM actor WHERE first_name = 'ADAM' AND last_name = 'GRANT'), LAST_INSERT_ID());

INSERT INTO film_category (film_id, category_id) 
VALUES (LAST_INSERT_ID(), (SELECT category_id FROM category WHERE name = 'Sci-Fi'));
```
