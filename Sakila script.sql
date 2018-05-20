USE sakila;

-- 1a
SELECT first_name,last_name FROM actor;

-- 1b
SELECT CONCAT(first_name," ",last_name) AS "Actor Name" FROM actor;

-- 2a
SELECT actor_id,first_name,last_name FROM actor WHERE first_name="Joe";

-- 2b
SELECT actor_id,first_name,last_name FROM actor WHERE last_name like "%GEN%";

-- 2c
SELECT actor_id,first_name,last_name FROM actor WHERE last_name like "%LI%" order by last_name,first_name;

-- 2d
SELECT country_id, country FROM country WHERE country IN ("Afghanistan","Bangladesh","China");

-- 3a
ALTER TABLE actor ADD COLUMN middle_name VARCHAR(50) AFTER first_name;
SELECT * FROM actor;

-- 3b
ALTER TABLE actor MODIFY middle_name BLOB;
DESCRIBE actor;

-- 3c
ALTER TABLE actor DROP middle_name;
select * from actor;

-- 4a
SELECT last_name,count(last_name) AS last_name_frequency 
FROM actor 
group by last_name;

-- 4b
SELECT last_name,count(last_name) AS last_name_frequency 
FROM actor 
group by last_name
HAVING count(last_name) > 1;

-- 4c
UPDATE actor SET first_name = "HARPO" WHERE last_name = "Williams";
SELECT actor_id,first_name,last_name FROM actor WHERE first_name IN ("GROUCHO");

-- 4d
UPDATE actor 
SET first_name = CASE
	WHEN first_name = 'HARPO' THEN 'GROUCHO' 
	ELSE 'MUCHO GROUCHO'
END
WHERE last_name =172;
SELECT actor_id,first_name,last_name FROM actor WHERE first_name IN ('GROUCHO');

-- 5a
DESCRIBE actor;

-- 6a
SELECT first_name,last_name,staff_id FROM staff;
SELECT address_id ,address FROM address;

SELECT s.first_name, s.last_name, a.address
FROM staff s
JOIN address a
ON s.staff_id=a.address_id;

-- 6b
SELECT first_name,last_name,staff_id FROM staff;
SELECT staff_id,amount FROM payment;

SELECT s.first_name, s.last_name, sum(p.amount) as total_sales_aug_2005
FROM staff s
JOIN payment p
ON s.staff_id=p.staff_id
WHERE YEAR(p.payment_date)=2005
AND Month(p.payment_date) = 8
group by s.first_name, s.last_name;

-- 6c
SELECT title, film_id FROM film;
SELECT film_id,actor_id FROM film_actor;

SELECT f.title, count(a.actor_id) as actor_count
FROM film f
JOIN film_actor a
ON f.film_id=a.film_id
group by f.title;

-- 6d
SELECT title,film_id FROM film;
SELECT film_id, inventory_id FROM inventory;

SELECT f.title, count(i.inventory_id) as total_in_stock
FROM film f
JOIN inventory i
ON f.film_id=i.film_id
WHERE f.title = "Hunchback Impossible"
group by f.title;

-- 6e
SELECT first_name,last_name,customer_id FROM customer;
SELECT customer_id,amount FROM payment;

SELECT c.first_name, c.last_name, sum(p.amount) as total_spent
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
group by c.customer_id
order by last_name;

-- 7a
SELECT title FROM film 
WHERE title Like ("K%")
OR title LIKE ("Q%")
AND language_id = (
SELECT language_id FROM language 
WHERE name="English");

-- 7b  TO FIX
SELECT * FROM actor;
SELECT 	first_name,last_name FROM actor
WHERE actor_id IN (
SELECT actor_id FROM film_actor
WHERE film_id = (
SELECT film_id FROM film
WHERE title = "ALONE TRIP"
));

-- 7C
SELECT first_name,last_name,email,customer_id FROM Customer;
SELECT address_id,city_id FROM address;
SELECT city_id,country_id FROM city;
SELECT country_id,country FROM country;

SELECT cu.first_name, cu.last_name, cu.email
FROM customer cu
JOIN address a
  ON cu.address_id=a.address_id
JOIN city cty
  ON a.city_id=cty.city_id
JOIN country ctry
  ON cty.country_id=ctry.country_id
WHERE country="CANADA";

-- 7d
SELECT title,film_id FROM film;
SELECT film_id,category_id FROM film_category;
SELECT category_id,name FROM category;

SELECT f.title, c.name AS genre
FROM film f
JOIN film_category fc
  ON f.film_id=fc.film_id
JOIN category c
  ON fc.category_id=c.category_id
WHERE c.name = "Family"
or c.name = "Children"  -- added because relevant to the use case.
ORDER BY f.title;

-- 7e
SELECT title, film_id FROM film;
SELECT film_id,inventory_ID FROM inventory;
SELECT inventory_id,rental_id FROM rental;

SELECT f.title, count(r.rental_id) as total_times_rented
FROM film f
JOIN inventory i
  ON f.film_id=i.film_id
JOIN rental r
  ON i.inventory_id=r.rental_id
group by f.title
order by total_times_rented desc;

-- 7f
SELECT store_id FROM store;
SELECT store_id,inventory_id FROM inventory;
SELECT inventory_id,customer_id FROM rental;
SELECT customer_id,amount FROM payment;

SELECT s.store_id, sum(p.amount) as store_total_sales
FROM store s
JOIN inventory i
  ON s.store_id = i.store_id
JOIN rental r
  ON i.inventory_id=r.inventory_id
JOIN payment p
  ON r.customer_id=p.customer_id
GROUP BY store_id;

-- 7g
SELECT store_id FROM store;
SELECT address_id,city_id FROM address;
SELECT city_id,city,country_id FROM city;
SELECT country_id,country FROM country;

SELECT s.store_id, cty.city, ctry.country
FROM store s
JOIN address a
  ON s.store_id=a.address_id
JOIN city cty
  ON a.city_id=cty.city_id
JOIN country ctry
  ON cty.country_id=ctry.country_id
;

-- 7h
SELECT name, category_id FROM category;
SELECT category_id, film_id FROM film_category;
SELECT film_id,inventory_id FROM inventory;
SELECT inventory_id, rental_id FROM rental;
SELECT rental_id, amount FROM payment;

SELECT c.name as Genre, sum(p.amount) as Total_Sales
FROM category c
JOIN film_category as fc
  ON c.category_id=fc.category_id
JOIN inventory i
  ON fc.film_id=i.film_id
JOIN rental r
  ON i.inventory_id=r.inventory_id
JOIN payment p
  ON r.rental_id=p.rental_id
GROUP BY Genre
ORDER BY Total_Sales DESC;

-- 8a
SELECT name, category_id FROM category;
SELECT category_id, film_id FROM film_category;
SELECT film_id,inventory_id FROM inventory;
SELECT inventory_id, rental_id FROM rental;
SELECT rental_id, amount FROM payment;

SELECT c.name as Genre, sum(p.amount) as Total_Sales
FROM category c
JOIN film_category as fc
  ON c.category_id=fc.category_id
JOIN inventory i
  ON fc.film_id=i.film_id
JOIN rental r
  ON i.inventory_id=r.inventory_id
JOIN payment p
  ON r.rental_id=p.rental_id
GROUP BY Genre
ORDER BY Total_Sales DESC limit 5;

-- 8b
CREATE VIEW top_5_genres AS
SELECT c.name as Genre, sum(p.amount) as Total_Sales
FROM category c
JOIN film_category as fc
  ON c.category_id=fc.category_id
JOIN inventory i
  ON fc.film_id=i.film_id
JOIN rental r
  ON i.inventory_id=r.inventory_id
JOIN payment p
  ON r.rental_id=p.rental_id
GROUP BY Genre
ORDER BY Total_Sales DESC limit 5;

-- 8c
DROP VIEW top_5_genres;
