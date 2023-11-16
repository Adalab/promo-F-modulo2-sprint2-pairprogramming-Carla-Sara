-- Pair programming Subconsultas
USE northwind;
-- 1. Extraed los pedidos con el máximo "order_date" para cada empleado. Nuestro jefe quiere saber la fecha de los pedidos más recientes que ha gestionado cada empleado. Para eso nos pide que lo hagamos con una query correlacionada.
SELECT `order_id`, `customer_id`, `employee_id`, `order_date`, `required_date`
FROM `orders` AS `O1`
WHERE `O1`.`order_date` = ALL (
			SELECT MAX(`order_date`) AS `Máximo`
            FROM `orders` AS `O2`
			GROUP BY `employee_id`
            HAVING `O1`.`employee_id` =`O2`.`employee_id`);
            
-- 2. Extraed el precio unitario máximo (unit_price) de cada producto vendido. Supongamos que ahora nuestro jefe quiere un informe de los productos vendidos y su precio unitario. De nuevo lo tendréis que hacer con queries correlacionadas.

SELECT MAX(`unit_price`), `product_id` 
FROM `order_details` AS `OD1`
GROUP BY `product_id` 
HAVING MAX(`unit_price`) = ALL (
		SELECT MAX(`unit_price`) 
					FROM `order_details` AS `OD2`
					GROUP BY `product_id`
					HAVING `OD1`.`product_id` =`OD2`.`product_id`);
            

-- 3. Extraed información de los productos "Beverages". En este caso nuestro jefe nos pide que le devolvamos toda la información necesaria para identificar un tipo de producto. En concreto, tienen especial interés por los productos con categoría "Beverages". Devuelve el ID del producto, el nombre del producto y su ID de categoría.
SELECT `product_id`, `product_name`, `category_id`
FROM `products`
WHERE `category_id` = (
		SELECT `category_id`
		FROM `categories`
		WHERE `category_name` = 'Beverages');

-- 4. Extraed la lista de países donde viven los clientes, pero no hay ningún proveedor ubicado en ese país Suponemos que si se trata de ofrecer un mejor tiempo de entrega a los clientes, entonces podría dirigirse a estos países para buscar proveedores adicionales.
SELECT DISTINCT`country`
FROM `customers`
WHERE  `country` NOT IN (
		SELECT DISTINCT `country`
		FROM `suppliers`);

-- 5. Extraer los clientes que compraron mas de 20 articulos "Grandma's Boysenberry Spread" Extraed el OrderId y el nombre del cliente que pidieron más de 20 artículos del producto "Grandma's Boysenberry Spread" (ProductID 6) en un solo pedido.
SELECT `order_id`, `company_name`, `customers`.`customer_id`
FROM `customers` INNER JOIN `orders`
ON `customers`.`customer_id`= `orders`.`customer_id`
WHERE `order_id` IN (
		SELECT `order_id`
		FROM `order_details`
		WHERE `product_id` = 6 AND `quantity` > 20);

-- 6. Extraed los 10 productos más caros.  Nos siguen pidiendo más queries correlacionadas. En este caso queremos saber cuáles son los 10 productos más caros.
SELECT `product_name`, `unit_price`
FROM `products`
ORDER BY `unit_price` DESC
LIMIT 10;

-- ???????
SELECT `product_name`, `unit_price`
FROM `products`
WHERE `unit_price` IN (
		SELECT `product_name`, `unit_price`
		FROM `products`
		ORDER BY `unit_price` DESC
		LIMIT 10);
-- BONUS:
-- 7. Qué producto es más popular. Extraed cuál es el producto que más ha sido comprado y la cantidad que se compró.
SELECT `product_id`, MAX(`quantity`)
FROM `order_details`
GROUP BY `product_id`
HAVING MAX(`quantity`) >= ALL (
		SELECT MAX(`quantity`)
		FROM `order_details`
		GROUP BY `product_id`);