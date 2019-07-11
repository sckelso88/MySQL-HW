use sakila;

SELECT first_name, last_name
FROM	actor;

SELECT UPPER(CONCAT(FIRST_NAME, ' ', LAST_NAME)) AS 'Actor Name'
FROM actor;

SELECT first_name, last_name, actor_id
FROM	actor
WHERE first_name= "Joe";

SELECT first_name, last_name, actor_id
FROM	actor
WHERE last_name LIKE '%GEN%';

SELECT first_name, last_name, actor_id
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;
  
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');  

ALTER TABLE actor
ADD COLUMN description blob AFTER last_name;

ALTER TABLE actor
DROP COLUMN description;

SELECT last_name, count(last_name) AS 'last_name_frequency'
FROM actor
GROUP BY last_name
HAVING `last_name_frequency` >= 1;
 
SELECT last_name, count(last_name) AS 'last_name_frequency'
FROM actor
GROUP BY last_name
  Having `last_name_frequency` >= 2;

UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO'
  and last_name = 'WILLIAMS';

UPDATE actor
SET first_name =
CASE
 WHEN first_name = 'HARPO'
  THEN 'GROUCHO'
 ELSE 'MUCHO GROUCHO'
END
WHERE actor_id = 172;

SELECT s.first_name, s.last_name, a.address
FROM staff s
INNER JOIN address a
ON (s.address_id = a.address_id);

SELECT s.first_name, s.last_name, SUM(p.amount)
FROM staff AS s
INNER JOIN payment AS p
ON p.staff_id = s.staff_id
WHERE MONTH(p.payment_date) = 08 AND YEAR(p.payment_date) = 2005
GROUP BY s.staff_id;
  
SELECT f.title, COUNT(fa.actor_id) AS 'Actors'
FROM film_actor AS fa
INNER JOIN film as f
ON f.film_id = fa.film_id
GROUP BY f.title
ORDER BY Actors desc;

SELECT title, COUNT(inventory_id) AS '# of copies'
FROM film
INNER JOIN inventory
USING (film_id)
WHERE title = 'Hunchback Impossible'
GROUP BY title;

SELECT c.first_name, c.last_name, SUM(p.amount) AS 'Total Amount Paid'
FROM payment AS p
INNER JOIN customer AS c
ON p.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name;

 SELECT title FROM film
WHERE title LIKE 'K%'
OR title LIKE 'Q%'
AND language_id IN
  (
   SELECT language_id
   FROM language
   WHERE name = 'English'
   );
   
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
       WHERE title = 'Alone Trip'
      )
   );

SELECT first_name, last_name, email, country
FROM customer cus
INNER JOIN address a
ON (cus.address_id = a.address_id)
INNER JOIN city cit
ON (a.city_id = cit.city_id)
INNER JOIN country ctr
ON (cit.country_id = ctr.country_id)
WHERE ctr.country = 'canada';

SELECT title, c.name
FROM film f
INNER JOIN film_category fc
ON (f.film_id = fc.film_id)
INNER JOIN category c
ON (c.category_id = fc.category_id)
WHERE name = 'family';

SELECT title, COUNT(title) as 'Rentals'
FROM film
INNER JOIN inventory
ON (film.film_id = inventory.film_id)
INNER JOIN rental
ON (inventory.inventory_id = rental.inventory_id)
GROUP by title
ORDER BY rentals desc;  

SELECT s.store_id, SUM(amount) AS Gross
FROM payment p
INNER JOIN rental r
ON (p.rental_id = r.rental_id)
INNER JOIN inventory i
ON (i.inventory_id = r.inventory_id)
INNER JOIN store s
ON (s.store_id = i.store_id)
GROUP BY s.store_id;

SELECT store_id, city, country
FROM store s
INNER JOIN address a
ON (s.address_id = a.address_id)
INNER JOIN city cit
ON (cit.city_id = a.city_id)
INNER JOIN country ctr
ON(cit.country_id = ctr.country_id); 
  
SELECT SUM(amount) AS 'Total Sales', c.name AS 'Genre'
FROM payment p
INNER JOIN rental r
ON (p.rental_id = r.rental_id)
INNER JOIN inventory i
ON (r.inventory_id = i.inventory_id)
INNER JOIN film_category fc
ON (i.film_id = fc.film_id)
INNER JOIN category c
ON (fc.category_id = c.category_id)
GROUP BY c.name
ORDER BY SUM(amount) DESC;  

CREATE VIEW top_five_genres AS
SELECT SUM(amount) AS 'Total Sales', c.name AS 'Genre'
FROM payment p
INNER JOIN rental r
ON (p.rental_id = r.rental_id)
INNER JOIN inventory i
ON (r.inventory_id = i.inventory_id)
INNER JOIN film_category fc
ON (i.film_id = fc.film_id)
INNER JOIN category c
ON (fc.category_id = c.category_id)
GROUP BY c.name
ORDER BY SUM(amount) DESC
LIMIT 5;

SELECT *
FROM top_five_genres;

DROP VIEW top_five_genres;