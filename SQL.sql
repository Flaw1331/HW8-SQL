-- USE SAKILA Database
USE SAKILA;
SHOW TABLES;

-- 1A --
SELECT first_name,last_name
FROM actor;

-- 1B--
SELECT UPPER(CONCAT(first_name,' ',last_name)) as ACTOR_NAME FROM Actor

-- 2A --
SELECT first_name, last_name, actor_id
FROM actor
WHERE first_name like "Joe";

-- 2B --
SELECT first_name, last_name, actor_id
FROM actor
WHERE last_name like "%GEN%";

-- 2C --
SELECT first_name, last_name, actor_id
FROM actor
WHERE last_name like "%LI%"
ORDER BY last_name, first_name;

-- 2D --
SELECT country_id, country
FROM country
WHERE country in ('Afghanistan','Bangladesh','China')

-- 3A --
ALTER TABLE actor
Add column middle_name VARCHAR(40)
AFTER first_name;

-- 3B --
ALTER TABLE Actor
MODIFY COLUMN middle_name blob;

-- 3C --
ALTER TABLE Actor
DROP COLUMN middle_name

-- 4A --
SELECT count(*) as count, last_name
FROM actor
GROUP BY last_name;

-- 4B --
SELECT *
FROM (
	SELECT count(*)as count, last_name
	FROM actor
	GROUP BY last_name
) as a
where a.count >= 2;

-- 4C --
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO'
and last_name = 'WILLIAMS';

-- 4D --
UPDATE Actor 
Set first_name = 
CASE
WHEN first_name = 'HARPO'
  THEN 'GROUCHO'
 ELSE 'MUCHO GROUCHO'
END
WHERE actor_id = 172;

-- 5A --
SHOW CREATE TABLE address;

-- 6A --
SELECT s.first_name, s.last_name, a.address
FROM staff s
INNER JOIN address a
ON (s.address_id = a.address_id);

-- 6B --
SELECT s.first_name, s.last_name, SUM(p.amount)
FROM staff as s
JOIN payment as p on s.staff_id = p.payment_id
WHERE MONTH(p.payment_date) = 08 AND YEAR(p.payment_date) = 2005
GROUP BY s.staff_id;

-- 6C --
SELECT f.title, COUNT(fa.actor_id) AS 'Actors'
FROM film_actor AS fa
INNER JOIN film as f
on f.film_id = fa.film_id
GROUP BY f.title
ORDER BY Actors desc;

-- 6D --
SELECT title, COUNT(inventory_id) AS '# of copies'
from film
INNER JOIN inventory
USING ( film_id)
WHERE title = 'Hunchback Impossible'
GROUP BY title;

-- 6E --
SELECT c.first_name, c.last_name, SUM(p.amount) AS 'Total Amount Paid'
FROM payment As p
JOIN customer As c
on p.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name;

-- 7A --
SELECT TITLE
FROM film
WHERE title LIKE 'K%'
OR title LIKE 'Q%'
AND language_id IN
(
 SELECT language_id
 FROM language
 WHERE name = 'English'
);

-- 7B --
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
	SELECT actor_id
	FROM film_actor
	WHERE film_id =
	(
		SELECT film_id
		FROM film
		WHERE title = "Alone Trip"
	)
);
 

-- 7C --
SELECT customer.first_name, last_name, email, country
FROM customer
	JOIN address
	ON (customer.address_id = address.address_id)
	JOIN city
	ON (address.city_id = city.city_id)
	JOIN country
	ON (city.country_id = country.country_id)
WHERE country.country = 'canada';

-- 7D --
SELECT title, category.name
FROM film
	JOIN film_category
	ON (film.film_id = film_category.film_id)
	JOIN category
	ON (category.category_id = film_category.category_id)
WHERE name = 'family';

-- 7E --
SELECT title, COUNT(title) as 'Rentals'
FROM film
JOIN inventory
on(film.film_id = inventory.film_id)
JOIN rental
ON (inventory.inventory_id = rental.inventory_id)
GROUP by title
ORDER BY rentals desc;

-- 7F --
SELECT store.store_id, SUM(amount) AS Gross
FROM payment
	JOIN rental
	ON (payment.rental_id = rental.rental_id)
	JOIN inventory
	ON ( inventory.inventory_id = rental.inventory_id)
	JOIN store
	ON (store.store_id = inventory.store_id)
GROUP BY store.store_id;

-- 7G --
SELECT store.store_id, city.city, country.country
FROM store
	JOIN address
	ON store.address_id = address.address_id
    JOIN city
    ON address.address_id = city.city_id
    JOIN country
    ON city.city_id = country.country_id;


-- 7H --
SELECT name AS Genre, SUM(amount) AS Gross_Revenue 
FROM category
	JOIN film_category 
    ON category.category_id=film_category.category_id
	JOIN inventory 
    ON film_category.film_id=inventory.film_id
	JOIN rental 
    ON inventory.inventory_id=rental.inventory_id
	JOIN payment 
    ON rental.rental_id=payment.rental_id
GROUP BY Genre
ORDER BY SUM(amount) DESC
LIMIT 5;


-- 8A --
CREATE VIEW top_five_genres AS
	SELECT SUM(amount) AS 'TOTAL Sales', c.name AS 'GENRE'
	FROM payment
		JOIN rental r
		on (payment.rental_id = r.rental_id)
		JOIN inventory i
		on (r.inventory_id = i.inventory_id)
		JOIN film_category fc  
		on(i.film_id = fc.film_id)
		JOIN category c
		ON (fc.category_id = c.category_id)
	GROUP BY c.name
	ORDER BY SUM(amount) DESC
	LIMIT 5;

-- 8B --
SELECT * FROM top_five_genres;

-- 8C --
DROP VIEW top_five_genres;