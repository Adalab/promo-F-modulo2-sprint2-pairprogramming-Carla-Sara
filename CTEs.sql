-- Pair programming CTE's


USE northwind;

-- Extraer en una CTE todos los nombres de las compañias y los id de los clientes.
-- Para empezar nos han mandado hacer una CTE muy sencilla el id del cliente y el nombre de la compañia de la tabla Customers.
-- Los resultados de esta query serán:

WITH `info_cliente` 
AS (SELECT `customer_id`, `company_name`
FROM `customers`);


-- Selecciona solo los de que vengan de "Germany"
-- Ampliemos un poco la query anterior. En este caso, queremos un resultado similar al anterior, pero solo queremos los que pertezcan a "Germany".
-- Los resultados de esta query serán:

WITH `info_cliente` 
AS (SELECT `customer_id`, `company_name`, `country`
FROM `customers`)

SELECT `country`,  `customer_id`, `company_name`
FROM `info_cliente`
WHERE country = 'Germany';


-- Extraed el id de las facturas y su fecha de cada cliente.
-- En este caso queremos extraer todas las facturas que se han emitido a un cliente, su fecha y la compañia a la que pertenece.
-- 📌 NOTA En este caso tendremos columnas con elementos repetidos(CustomerID, y Company Name).
-- Los resultados de esta query serán:

WITH `facturas` 
AS (SELECT `order_date`, `order_id`, `customer_id` 
FROM `orders`)  

SELECT `customers`.`customer_id`, `company_name`,  `order_date`, `order_id`
FROM `customers` RIGHT JOIN `facturas`
ON `customers`.`customer_id` = `facturas`.`customer_id`;


-- Contad el número de facturas por cliente
-- Mejoremos la query anterior. En este caso queremos saber el número de facturas emitidas por cada cliente.
-- Los resultados de esta query serán:

WITH `facturas` 
AS (SELECT `order_date`, `order_id`, `customer_id` 
FROM `orders`)  

SELECT `customers`.`customer_id`, `company_name`,  `order_date`, COUNT(`order_id`)
FROM `customers` RIGHT JOIN `facturas`
ON `customers`.`customer_id` = `facturas`.`customer_id`
GROUP BY `company_name`;


-- Cuál la cantidad media pedida de todos los productos ProductID.
-- Necesitaréis extraer la suma de las cantidades por cada producto y calcular la media.
-- Los resultados de esta query serán:

WITH `sumaproductos`
AS (SELECT AVG(`quantity`) AS `media`,SUM(`quantity`) AS `suma`, `product_id`
FROM `order_details` 
GROUP BY `product_id`)

SELECT `product_name`,  `media`, `suma`, `products`.`product_id`
FROM `products` INNER JOIN `sumaproductos`
USING (`product_id`);


-- BONUS: Estos ejercicios no es obligatorio realizarlos. Los podéis hacer más adelante para poder practicar las CTE´s.
-- Usando una CTE, extraer el nombre de las diferentes categorías de productos, con su precio medio, máximo y mínimo.

WITH `precios_categoria` 
AS (SELECT `categories.category_name`, `categories.category_id`, MIN(`products.unit_price`) AS `Minimo`, MAX(`products.unit_price`) AS `Maximo`, AVG(`products.unit_price`) AS `Medio`
FROM `products` INNER JOIN `categories`
ON `categories.category_id = products.category_id`
GROUP BY `categories.category_name`)
SELECT * FROM `precios_categoria`;


-- La empresa nos ha pedido que busquemos el nombre de cliente, su teléfono y el número de pedidos que ha hecho cada uno de ellos.
WITH `info_clientes` AS (SELECT `company_name`, `phone`, `customer_id`
						  FROM `customers`) 
SELECT  `info_clientes`.`company_name`, `info_clientes`.`phone`, `orders`.`customer_id`, COUNT(`orders`.`order_id`) AS `Numero de pedidos`
FROM `orders` LEFT JOIN `info_clientes`
ON `orders`.`customer_id` = `info_clientes`.`customer_id`
GROUP BY `customer_id`;

-- Modifica la consulta anterior para obtener los mismos resultados pero con los pedidos por año que ha hecho cada cliente.
WITH `info_clientes` AS (SELECT `company_name`, `phone`, `customer_id`
						  FROM `customers`) 
SELECT  `info_clientes`.`company_name`, `info_clientes`.`phone`, `orders`.`customer_id`, `orders`.`order_id`, YEAR(`orders`.`order_date`) AS `año`
FROM `orders` LEFT JOIN `info_clientes`
ON `orders`.`customer_id` = `info_clientes`.`customer_id`;

WITH `info_clientes` AS (SELECT `company_name`, `phone`, `customer_id`
						  FROM `customers`) 
SELECT  `info_clientes`.`company_name`, `info_clientes`.`phone`, `orders`.`customer_id`, COUNT(`orders`.`order_id`) AS `Numero de pedidos`, YEAR(`orders`.`order_date`) AS `año`
FROM `orders` RIGHT JOIN `info_clientes`
ON `orders`.`customer_id` = `info_clientes`.`customer_id`
GROUP BY `año`, `company_name`, `phone`, `customer_id`;

-- Modifica la cte del ejercicio anterior, úsala en una subconsulta para saber el nombre del cliente y su teléfono, para aquellos clientes que hayan hecho más de 6 pedidos en el año 1998.
WITH `info_clientes` AS (SELECT `company_name`, `phone`, `customer_id`
						  FROM `customers`) 
SELECT  `info_clientes`.`company_name`, `info_clientes`.`phone`, COUNT(`orders`.`order_id`) AS `Numero de pedidos`, YEAR(`orders`.`order_date`) AS `año`
FROM `orders` RIGHT JOIN `info_clientes`
ON `orders`.`customer_id` = `info_clientes`.`customer_id`
GROUP BY `año`, `company_name`, `phone`
HAVING `Numero de pedidos` > 6 AND `año` = 1998;

-- Nos piden que obtengamos el importe total (teniendo en cuenta los descuentos) de cada pedido de la tabla orders y el customer_id asociado a cada pedido.
WITH `pedidos` AS (SELECT `order_id`, `customer_id`
				   FROM `orders`)
SELECT `customer_id`, `order_details`.`order_id`, SUM((`unit_price` - (`unit_price`*`discount`))*`quantity`) AS `importe total por pedido`
FROM `order_details` RIGHT JOIN `pedidos`
ON `order_details`.`order_id` = `pedidos`.`order_id`
GROUP BY `order_id`,  `customer_id`;                   