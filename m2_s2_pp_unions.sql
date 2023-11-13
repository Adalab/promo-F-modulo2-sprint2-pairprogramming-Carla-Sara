-- Pair programming Operadores Especiales de Filtro

-- Para esta práctica te hara falta crear en algunos de los ejercicios una columna temporal. Para ver como funciona esta creación de columnas temporales prueba el siguiente código:
SELECT 'Hola!' AS 'tipo_nombre'
FROM `customers`;

USE northwind;
-- 1. Ciudades que empiezan con "A" o "B".
-- Por un extraño motivo, nuestro jefe quiere que le devolvamos una tabla con aquelas compañias que están afincadas en ciudades que empiezan por "A" o "B". Necesita que le devolvamos la ciudad, el nombre de la compañia y el nombre de contacto.
SELECT `city`, `company_name`, `contact_name`
FROM `customers`
WHERE `city` REGEXP '^[AB]+';
	
-- 2. Número de pedidos que han hecho en las ciudades que empiezan con L.
-- En este caso, nuestro objetivo es devolver los mismos campos que en la query anterior el número de total de pedidos que han hecho todas las ciudades que empiezan por "L".
SELECT `company_name`, `contact_name`,`city`
FROM `customers`
WHERE `city` LIKE 'L%';

SELECT `city`, COUNT(`orders`.`order_id`) AS 'Numero de pedidos por ciudad'
	FROM `customers` INNER JOIN `orders`
	ON `customers`.`customer_id` = `orders`.`customer_id`
	WHERE `city` LIKE 'L%'
	GROUP BY `city`;
    
SELECT `customers`.`city`, `company_name`, `contact_name`, `tabla_pedidos_por_ciudad`.`Numero de pedidos por ciudad`
FROM `customers` LEFT JOIN (SELECT `city`, COUNT(`orders`.`order_id`) AS `Numero de pedidos por ciudad`
	FROM `customers` INNER JOIN `orders`
	ON `customers`.`customer_id` = `orders`.`customer_id`
	WHERE `city` LIKE 'L%'
	GROUP BY `city`) AS `tabla_pedidos_por_ciudad`
ON `customers`.`city` = `tabla_pedidos_por_ciudad`.`city`
WHERE `customers`.`city` LIKE 'L%';

-- 3. Todos los clientes cuyo "contact_title" no incluya "Sales".
-- Nuestro objetivo es extraer los clientes que no tienen el contacto "Sales" en su "contact_title". Extraer el nombre de contacto, su posisión (contact_title) y el nombre de la compañia.
SELECT `contact_name`, `contact_title`, `company_name`
FROM `customers`
WHERE `contact_title` NOT LIKE 'Sales%';

-- 4. Todos los clientes que no tengan una "A" en segunda posición en su nombre.
-- Devolved unicamente el nombre de contacto. 
SELECT `contact_name`
FROM `customers`
WHERE `contact_name` NOT LIKE '_a%';

-- 5. Extraer toda la información sobre las compañias que tengamos en la BBDD
-- Nuestros jefes nos han pedido que creemos una query que nos devuelva todos los clientes y proveedores que tenemos en la BBDD. Mostrad la ciudad a la que pertenecen, el nombre de la empresa y el nombre del contacto, además de la relación (Proveedor o Cliente). Pero importante! No debe haber duplicados en nuestra respuesta. La columna Relationship no existe y debe ser creada como columna temporal. Para ello añade el valor que le quieras dar al campo y utilizada como alias Relationship .
-- Nota: Deberás crear esta columna temporal en cada instrucción SELECT.
SELECT `city`, `company_name`, `contact_name`, 'Cliente' AS 'Relationship'
FROM `customers`;

SELECT `city`, `company_name`, `contact_name`, 'Cliente' AS 'Relationship'
FROM `suppliers`;

-- 6. Extraer todas las categorías de la tabla categories que contengan en la descripción "sweet" o "Sweet".
SELECT `category_name`, `description`
FROM `categories`
WHERE `description` NOT LIKE '%sweet%' AND `description` NOT LIKE '%Sweet%';

-- 7. Extraed todos los nombres y apellidos de los clientes y empleados que tenemos en la BBDD:
--  Pista  ¿Ambas tablas tienen las mismas columnas para nombre y apellido? Tendremos que combinar dos columnas usando concat para unir dos columnas.