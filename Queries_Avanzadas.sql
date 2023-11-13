
USE northwind;


-- 1. Pedidos por empresa en UK:
-- Desde las oficinas en UK nos han pedido con urgencia que realicemos una consulta a la base de datos con la que podamos conocer cuántos pedidos ha realizado cada empresa cliente de UK. Nos piden el ID del cliente y el nombre de la empresa y el número de pedidos.


	SELECT customers.company_name, customers.customer_id, customers.country, COUNT(orders.order_id) AS numeroPedidos
	FROM customers
		INNER JOIN orders
		ON  customers.customer_id = orders.customer_id
		GROUP BY orders.customer_id
	HAVING customers.country = "UK";


-- 2. Productos pedidos por empresa en UK por año:
-- La primera de ellas consiste en una query que nos sirva para conocer cuántos objetos ha pedido cada empresa cliente de UK durante cada año. Nos piden concretamente conocer el nombre de la empresa, el año, y la cantidad de objetos que han pedido. Para ello hará falta hacer 2 joins.

	SELECT customers.customer_id, company_name, YEAR(order_date) AS Año, country, orders.order_id, SUM(quantity) as numeroProductos
	FROM customers
		INNER JOIN orders
		ON customers.customer_id = orders.customer_id
		INNER JOIN order_details
		ON orders.order_id = order_details.order_id
		WHERE country = 'UK'
	GROUP BY YEAR(order_date), company_name;

-- 3. Lo siguiente que nos han pedido es la misma consulta anterior pero con la adición de la cantidad de dinero que han pedido por esa cantidad de objetos, teniendo en cuenta los descuentos, etc. Ojo que los descuentos en nuestra tabla nos salen en porcentajes, 15% nos sale como 0.15 .

	SELECT  company_name,  YEAR(order_date) AS Año, SUM(quantity) AS numeroProductos, SUM(quantity*unit_price - quantity*unit_price*discount) AS total
	FROM customers 
		INNER JOIN orders
		ON customers.customer_id = orders.customer_id
		INNER JOIN order_details
		ON orders.order_id = order_details.order_id 
		WHERE country = 'UK'
	GROUP BY YEAR(order_date), company_name;

-- 4. BONUS: Pedidos que han realizado cada compañía y su fecha: Después de estas solicitudes desde UK y gracias a la utilidad de los resultados que se han obtenido, desde la central nos han pedido una consulta que indique el nombre de cada compañia cliente junto con cada pedido que han realizado y su fecha.

	SELECT company_name, orders.order_id, order_date, country
	FROM customers 
		INNER JOIN orders
		ON customers.customer_id = orders.customer_id;

-- 5. BONUS: Tipos de producto vendidos:
-- Ahora nos piden una lista con cada tipo de producto que se han vendido, sus categorías, nombre de la categoría y el nombre del producto, y el total de dinero por el que se ha vendido cada tipo de producto (teniendo en cuenta los descuentos)


	SELECT products.product_id, categories.category_id, category_name, product_name, order_details.unit_price*quantity - (order_details.unit_price*quantity*discount) AS VendidoPor
	FROM categories 
		INNER JOIN products
		ON categories.category_id = products.category_id
		INNER JOIN order_details 
		ON products.product_id = order_details.product_id
	GROUP BY product_name;
	SELECT * FROM order_details;


-- 6. Qué empresas tenemos en la BBDD Northwind:
-- Lo primero que queremos hacer es obtener una consulta SQL que nos devuelva el nombre de todas las empresas cliente, los ID de sus pedidos y las fechas.

	SELECT customers.customer_id,company_name, orders.order_id, order_date
	FROM customers 
		INNER JOIN orders
		ON customers.customer_id = orders.customer_id;

-- 7. Pedidos por cliente de UK: nos solicitan información acerca del número de pedidos que ha realizado cada cliente del propio Reino Unido.Especificamente nos piden el nombre de cada compañía cliente junto con el número de pedidos.

	SELECT company_name, COUNT(order_id) AS numeroPedidos
	FROM customers
		NATURAL JOIN orders 
		WHERE country = "UK"
	GROUP BY company_name;

-- 8. Empresas de UK y sus pedidos:
-- También nos han pedido que obtengamos todos los nombres de las empresas cliente de Reino Unido (tengan pedidos o no) junto con los ID de todos los pedidos que han realizado y la fecha del pedido.

	SELECT company_name, orders.order_id, order_date
	FROM customers
		LEFT JOIN orders
		ON customers.customer_id = orders.customer_id
	WHERE country = 'UK';
        
        
-- 9. Ejercicio de SELF JOIN : Concretamente nos piden: la ubicación, nombre, y apellido tanto de las empleadas como de las jefas. Investiga el resultado, ¿sabes decir quién es el director? 
	
    SELECT employees1.city, employees1.first_name, employees1.last_name, employees2.city, employees2.first_name, employees2.last_name
	FROM employees AS employees1, employees AS employees2
	WHERE employees1.reports_to = employees2.employee_id;


-- 10.BONUS: FULL OUTER JOIN Pedidos y empresas con pedidos asociados o no:
-- Selecciona todos los pedidos, tengan empresa asociada o no, y todas las empresas tengan pedidos asociados o no. Muestra el ID del pedido, el nombre de la empresa y la fecha del pedido (si existe).

	SELECT order_id, customers.company_name, order_date
		FROM orders LEFT JOIN customers
		ON orders.customer_id = customers.customer_id;