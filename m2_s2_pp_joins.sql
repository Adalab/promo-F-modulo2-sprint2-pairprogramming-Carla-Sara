-- 1. Pedidos por empresa en UK:
-- Desde las oficinas en UK nos han pedido con urgencia que realicemos una consulta a la base de datos con la que podamos conocer cuántos pedidos ha realizado cada empresa cliente de UK. Nos piden el ID del cliente y el nombre de la empresa y el número de pedidos.

-- Sara  --> 2, 6, 8
-- Carla --> 3,7,9
-- 2. Productos pedidos por empresa en UK por año:
-- Desde Reino Unido se quedaron muy contentas con nuestra rápida respuesta a su petición anterior y han decidido pedirnos una serie de consultas adicionales. La primera de ellas consiste en una query que nos sirva para conocer cuántos objetos ha pedido cada empresa cliente de UK durante cada año. Nos piden concretamente conocer el nombre de la empresa, el año, y la cantidad de objetos que han pedido. Para ello hará falta hacer 2 joins.

SELECT customers.customer_id, company_name, YEAR(order_date) AS Año, country, orders.order_id, SUM(quantity) as numeroProductos
FROM customers INNER JOIN orders
ON customers.customer_id = orders.customer_id
INNER JOIN order_details
ON orders.order_id = order_details.order_id
WHERE country = 'UK'
GROUP BY YEAR(order_date), company_name;

-- 3. Mejorad la query anterior:
-- Lo siguiente que nos han pedido es la misma consulta anterior pero con la adición de la cantidad de
-- dinero que han pedido por esa cantidad de objetos, teniendo en cuenta los descuentos, etc. Ojo que
-- los descuentos en nuestra tabla nos salen en porcentajes, 15% nos sale como 0.15 .


-- 4. BONUS: Pedidos que han realizado cada compañía y su fecha:
-- Después de estas solicitudes desde UK y gracias a la utilidad de los resultados que se han obtenido, desde la central nos han pedido una consulta que indique el nombre de cada compañia cliente junto con cada pedido que han realizado y su fecha.
SELECT company_name, orders.order_id, order_date, country
FROM customers INNER JOIN orders
ON customers.customer_id = orders.customer_id;

-- 5. BONUS: Tipos de producto vendidos:
-- Ahora nos piden una lista con cada tipo de producto que se han vendido, sus categorías, nombre de la categoría y el nombre del producto, y el total de dinero por el que se ha vendido cada tipo de producto (teniendo en cuenta los descuentos).
SELECT products.product_id, categories.category_id, category_name, product_name, order_details.unit_price*quantity - (order_details.unit_price*quantity*discount) AS VendidoPor
FROM categories INNER JOIN products
ON categories.category_id = products.category_id
INNER JOIN order_details 
ON products.product_id = order_details.product_id
GROUP BY product_name;

SELECT * FROM order_details;
-- 6. Qué empresas tenemos en la BBDD Northwind:
-- Lo primero que queremos hacer es obtener una consulta SQL que nos devuelva el nombre de todas las empresas cliente, los ID de sus pedidos y las fechas.
SELECT customers.customer_id,company_name, orders.order_id, order_date
FROM customers INNER JOIN orders
ON customers.customer_id = orders.customer_id;

-- 7. Pedidos por cliente de UK:
-- Desde la oficina de Reino Unido (UK) nos solicitan información acerca del número de pedidos que
-- ha realizado cada cliente del propio Reino Unido de cara a conocerlos mejor y poder adaptarse al
-- mercado actual. Especificamente nos piden el nombre de cada compañía cliente junto con el número
-- de pedidos.
-- La tabla resultante será:
-- sql72
-- 8. Empresas de UK y sus pedidos:
-- También nos han pedido que obtengamos todos los nombres de las empresas cliente de Reino Unido (tengan pedidos o no) junto con los ID de todos los pedidos que han realizado y la fecha del pedido.
SELECT company_name, orders.order_id, order_date
FROM customers LEFT JOIN orders
ON customers.customer_id = orders.customer_id
WHERE country = 'UK';

-- 9. Ejercicio de SELF JOIN : Desde recursos humanos nos piden realizar una consulta que muestre por pantalla los datos de todas las empleadas y sus supervisoras. Concretamente nos piden: la ubicación, nombre, y apellido tanto de las empleadas como de las jefas. Investiga el resultado, ¿sabes decir quién es el director? 


-- ESTE EJERCICIO NO SE EVALUARÁ SI NO ES ENTREGADO
-- 10.BONUS: FULL OUTER JOIN Pedidos y empresas con pedidos asociados o no:
-- Selecciona todos los pedidos, tengan empresa asociada o no, y todas las empresas tengan pedidos asociados o no. Muestra el ID del pedido, el nombre de la empresa y la fecha del pedido (si existe).
-- La tabala resultado deberá similar a: 
-- ![sql75](https://github.com/Adalab/data_imagenes/blob/main/Modulo-1/sql/SQL-capturas-pair/Pair-SQL7-5.png?raw=true)
SELECT order_id, customers.company_name, order_date
FROM orders LEFT JOIN customers
ON orders.customer_id = customers.customer_id;