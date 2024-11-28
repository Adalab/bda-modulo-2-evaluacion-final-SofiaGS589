-- EVALUACIÓN FINAL DEL MÓDULO 2 --

USE sakila;


-- EJERCICIO 1 --
-- Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT
DISTINCT title
FROM film;


-- EJERCICIO 2 --
-- Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT
title
FROM film
WHERE rating = 'PG-13';


-- EJERCICIO 3 --
-- Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT
title,
description
FROM film
WHERE description LIKE '%amazing%';


-- EJERCICIO 4 --
-- Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT
title
FROM film
WHERE length > 120;


-- EJERCICIO 5 --
-- Recupera los nombres de todos los actores.

SELECT
first_name
FROM actor;


-- EJERCICIO 6 --
-- Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT
first_name,
last_name
FROM actor
WHERE last_name = 'GIBSON';


-- EJERCICIO 7 --
-- Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT
first_name
FROM actor
WHERE actor_id BETWEEN 10 AND 20;


-- EJERCICIO 8 --
-- Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.

SELECT
title
FROM film
WHERE rating NOT IN ('R', 'PG-13');


-- EJERCICIO 9 -- 
-- Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
# tabla:  film  [rating  +  title].
# agrupar:  rating.
# mostrar:  'Recuento'  +  'Clasificación'.

SELECT
rating AS 'Clasificación',
COUNT(DISTINCT title) AS 'Recuento'
FROM film
GROUP BY rating;


-- EJERCICIO 10 --
-- Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, 
-- su nombre y apellido junto con la cantidad de películas alquiladas.
# agrupar:  customer_id.
# mostrar:  'Id del cliente'  +  'Nombre del cliente'  +  'Apellido del cliente'  +  'Número de películas'. 
# tablas:  customer  [customer_id  +  first_name  +  last_name].
# tablas:  rental  [inventory_id/rental_id  +  customer_id].
# unión:  customer  --  rental  (LEFT JOIN)

SELECT
c.customer_id AS 'Id del cliente',
c.first_name AS 'Nombre del cliente',
c.last_name AS 'Apellido del cliente',
COUNT(inventory_id) AS 'Número de películas'
FROM customer AS c
LEFT JOIN rental AS r
ON c.customer_id = r.customer_id
GROUP BY c.customer_id;


-- EJERCICIO 11 --
-- Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría 
-- junto con el recuento de alquileres.
# agrupar:  name.
# mostrar:  'Nombre de categoría'  +  'Recuento de alquileres'.
# tablas:  category  [name  +  category_id].
# tablas:  film_category  [category_id  +  film_id].
# unión:  category  --  film_category  (LEFT JOIN).

SELECT
c.name AS 'Nombre de categoría',
COUNT(fc.film_id) AS 'Recuento de alquileres'
FROM category AS c
LEFT JOIN film_category AS fc
ON c.category_id = fc.category_id
GROUP BY
c.name;


-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la
-- clasificación junto con el promedio de duración.
# agrupar:  film.rating.
# mostrar:   "Clasificación"  +  "Promedio de duración".
# tablas:  film  [rating  +  length].

SELECT
f.rating AS 'Clasificación',
ROUND(AVG(f.length), 2) AS 'Promedio de duración'
FROM film AS f
GROUP BY f.rating;

# He encontrado una manera de que me devuelva sólo 2 decimales.


-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
# mostrar:  'Nombre de actor'  +  'Apellido de actor'.
# tablas:  actor  [first_name  +  last_name  +  actor_id].
# tablas:  film_actor  [actor_id  +  film_id].
# tablas:  film  [film_id  +  title].
# unión:  actor --  film_actor  --  film  (LEFT JOIN).

SELECT
a.first_name AS 'Nombre de actor',
a.last_name AS 'Apellido de actor'
FROM actor AS a
LEFT JOIN film_actor AS fa
ON a.actor_id = fa.actor_id
LEFT JOIN film AS f
ON fa.film_id = f.film_id
WHERE f.title = 'INDIAN LOVE';


-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
# mostrar:  'Título de película'.
# tablas:  film  [title  +  description].

SELECT
f.title
FROM film AS f
WHERE f.description LIKE '%dog%' AND 
	f.description LIKE '%cat%';


-- 15. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
# mostrar:  'Título de película'.
# tablas:  film  [title  +  release_year].

SELECT
f.title
FROM film AS f
WHERE f.release_year BETWEEN 2005 AND 2010;


-- 16. Encuentra el título de todas las películas que son de la misma categoría que "Family".
# mostrar:  'Título de película'.
# tablas:  film   [title  +  film_id].
# tablas:  film_category  [film_id   +  category_id].
# tablas:  category [category_id  +  name].
# unión:  film  --  film_category  --  category  (LEFT JOIN).

SELECT
f.title AS 'Título de película'
FROM film AS f
LEFT JOIN film_category AS fc
ON f.film_id = fc.film_id
LEFT JOIN category AS c
ON fc.category_id = c.category_id
WHERE c.name = 'Family';


-- 17. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 
-- 2 horas en la tabla film.
# mostrar:  'Título de película'.
# tablas:  film  [title  +  rating  +  length].

SELECT
f.title AS 'Título'
FROM film AS f
WHERE f.rating = 'R' AND f.length > 120;


-- BONUS --

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
# mostrar:  'Nombre del actor'  +  'Apellido del actor'.
# tablas:  actor  [first_name  +  last_name  +  actor_id].
# tablas:  film_actor  [actor_id  +  film_id].

SELECT
a.first_name AS 'Nombre del actor',
a.last_name AS 'Apellido del actor'
FROM actor AS a
WHERE a.actor_id IN (
	SELECT
	COUNT(DISTINCT fa.film_id) AS 'Número de películas'
	FROM film_actor AS fa
	GROUP BY fa.actor_id
	HAVING COUNT(DISTINCT fa.film_id) > 10
    );


-- 19. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.
# tablas:  film_actor  [actor_id  +  film_id].
# tablas:  actor  [actor_id  +  first_name  +  last_name].
# mostrar:  'Nombre del actor'  +  'Apellido del actor'.
# unión:  actor  --  film_actor  (LEFT JOIN).

SELECT
a.first_name AS 'Nombre del actor',
a.last_name AS 'Apellido del actor'
FROM actor AS a
LEFT JOIN film_actor AS fa
ON a.actor_id = fa.actor_id
WHERE fa.actor_id IS NULL;


-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior 
-- a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.
# mostrar:  'Nombre de categoría'  +  'Promedio de duración'.
# tablas:  category  [name  +  category_id].
# tablas:  film_category  [film_id  +  category_id].
# tablas:  film  [film_id  +  length].
# unión:  category  --  film_category  --  film  (LEFT JOIN).

SELECT
c.name AS 'Nombre de categoría',
ROUND(AVG(f.length),2) AS 'Promedio de duración'
FROM category AS c
LEFT JOIN film_category AS fc
ON c.category_id = fc.category_id
LEFT JOIN film AS f
ON fc.film_id = f.film_id
GROUP BY c.name
HAVING AVG(f.length) > 120;


-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del 
-- actor junto con la cantidad de películas en las que han actuado.
# mostrar:  'Nombre del actor'  +  'Número de películas'.
# tablas:  actor  [first_name  +  last_name  +  actor_id].
# tablas:  film_actor  [actor_id  +  film_id]. 
# unión:  actor  --  film_actor  (LEFT JOIN).

SELECT
a.first_name AS 'Nombre del actor',
a.last_name AS 'Apellido del actor',
COUNT(fa.film_id) AS 'Número de películas'
FROM actor AS a
LEFT JOIN film_actor AS fa
ON a.actor_id = fa.actor_id
GROUP BY a.first_name, a.last_name
HAVING COUNT(fa.film_id) >= 5;


-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. 
-- Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días
--  y luego selecciona las películas correspondientes.
# mostrar:  'Título de película'.
# tablas:  film  [title  +  film_id].
# tablas:  inventory  [inventory_id  +  film_id].
# tablas:   rental  [rental_id  +  inventory_id  +  return_date  +  rental_date].
# unión:  film  --  inventory  --  rental  (LEFT JOIN).

SELECT
DISTINCT f.title AS 'Título de película'
FROM film AS f
LEFT JOIN inventory AS i
ON f.film_id = i.film_id
LEFT JOIN rental AS r
ON i.inventory_id = r.inventory_id
WHERE r.rental_id IN (
	SELECT
	r.rental_id AS 'Id del alquiler'
	FROM rental AS r
	WHERE DATEDIFF(r.return_date, r.rental_date) > 5
	);


-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película 
-- de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han 
-- actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.
# mostrar:  'Nombre del actor'  +  'Apellido del actor'.
# tablas:  actor  [first_name  +  last_name  +  actor_id].
# tablas:  film_actor  [actor_id  +  film_id].
# tablas:  film_category  [film_id  +  category_id].
# tablas:  category  [name  +  category_id].
# unión:  actor  --  film_actor  --  film_category  --  category  (LEFT JOIN).

SELECT
a.first_name AS 'Nombre del actor',
a.last_name AS 'Apellido del actor'
FROM actor AS a
WHERE a.actor_id NOT IN (
	SELECT
	fa.actor_id
	FROM film_actor AS fa
	LEFT JOIN film_category AS fc
	ON fa.film_id = fc.film_id
	LEFT JOIN category AS c
	ON fc.category_id = c.category_id
	WHERE c.name = 'Horror'
    );


-- 24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 
-- 180 minutos en la tabla film.
# mostrar:  'Título de película'.
# tablas:  film  [film_id  +  title  +  length].
# tablas:  film_category  [film_id  +  category_id]
# tablas:  category  [name  +  category_id]
# unión:  actor  --  film_category  --  category  (LEFT JOIN).

SELECT
f.title AS 'Título de película'
FROM film AS f
WHERE f.film_id IN (
	SELECT
	fc.film_id
	FROM film_category AS fc
	LEFT JOIN category AS c
	ON fc.category_id = c.category_id
	WHERE c.name = 'Comedy'
	) AND length > 180;

-- 25. Encuentra todos los actores que han actuado juntos en al menos una película. 
-- La consulta debe mostrar el nombre y apellido de los actores y el número de películas
-- en las que han actuado juntos.
# mostrar:  'Nombre del actor'  +  'Apellido del actor'  +  'Número de películas'.
# tabla:  actor  [actor_id  +  first_name  +  last_name].
# tabla:  film_actor  [actor_id  +  film_id].

SELECT
a.first_name AS 'Nombre del actor',
a.last_name AS 'Apellido del actor',
COUNT(fa.film_id) AS 'Número de películas'
FROM actor AS a
LEFT JOIN film_actor AS fa
ON a.actor_id = fa.actor_id
WHERE fa.actor_id IN (	
    SELECT
	fa.actor_id AS 'Id del actor'
	FROM film_actor AS fa
	GROUP BY fa.actor_id
	HAVING fa.actor_id IN (
		SELECT
		film_id AS 'Id de peli'
		FROM film_actor
		GROUP BY film_id
		HAVING COUNT(actor_id) > 1
		)
	)
GROUP BY a.actor_id;