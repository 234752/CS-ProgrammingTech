-- 1 List how many different crystals of each colour are
SELECT colour, COUNT(product_id) as AMOUNT FROM products
GROUP BY colour;

-- 2 List supplier(s) that provide the most expensive product (print product name and price per gram)
SELECT suppliers.supplier_name, products.crystal_name, products.price_per_gram FROM suppliers
JOIN products ON suppliers.supplier_id = products.supplier_id
WHERE products.price_per_gram = (SELECT MAX(price_per_gram) FROM products);

-- 3 List the cheapest and the most expensive crystal(s) for each colour
SELECT product_id, crystal_name, price_per_gram, colour FROM products p1
WHERE p1.price_per_gram = 
    (SELECT MIN(price_per_gram) FROM products p2 WHERE p2.colour = p1.colour) 
OR price_per_gram = 
    (SELECT MAX(price_per_gram) FROM products p2 WHERE p2.colour = p1.colour)
ORDER BY colour ASC, price_per_gram ASC;

-- 4 List crystal that is the most expensive from crystals that are cheaper than the average (exact average included)
SELECT product_id, crystal_name, price_per_gram, colour FROM products
WHERE price_per_gram <= (SELECT AVG(price_per_gram) FROM products)
ORDER BY price_per_gram DESC
FETCH FIRST 1 ROW ONLY;

-- 5 List average, maximal and minimal order price for each customer
SELECT customer_id, MAX(price) AS MAX_ORDER, MIN(price) AS MIN_ORDER, ROUND(AVG(price),1) AS AVG_ORDER FROM orders
GROUP BY customer_id ORDER BY customer_id;

-- 6 List total sales of employees and their provision, calculate income (Use Function 2) 
SELECT employee_id, 
        (SELECT SUM(price) FROM orders WHERE orders.employee_id = employees.employee_id) AS TOTAL_SALES, 
        provision, 
        emp_income(employee_id) AS INCOME 
FROM employees;

-- 7 List non-premium customer(s) who has the most expensive order 
--(MAY NOT WORK IF MOST EXPENSIVE ORDER IS MADE BY PREMIUM CUSTOMER)
SELECT * FROM customers
WHERE premium = 0 AND customer_id IN 
    (SELECT customer_id FROM orders WHERE price = 
        (SELECT MAX(price) FROM orders));

-- 7 List non-premium customer(s) who has the most expensive order 
--(INNER JOIN superior)
SELECT * FROM customers
JOIN orders ON orders.customer_id = customers.customer_id
WHERE customers.premium = 0
ORDER BY orders.price DESC
FETCH FIRST 1 ROWS ONLY;

-- 8 List most frequently bought product (name and total weight) for each gender
SELECT C1.gender, P1.crystal_name, SUM(O1.product_weight) AS TOTAL_WEIGHT FROM products P1
JOIN orders O1 ON O1.product_id = P1.product_id
JOIN customers C1 ON C1.customer_id = O1.customer_id
HAVING ( C1.gender, P1.crystal_name, SUM(O1.product_weight) ) = (
    SELECT C2.gender, P2.crystal_name, SUM(O2.product_weight) AS TOTAL_WEIGHT FROM products P2
    JOIN orders O2 ON O2.product_id = P2.product_id
    JOIN customers C2 ON C2.customer_id = O2.customer_id
    WHERE C2.gender = C1.gender
    GROUP BY C2.gender, P2.crystal_name
    ORDER BY TOTAL_WEIGHT DESC
    FETCH FIRST 1 ROW ONLY
    )
GROUP BY C1.gender, P1.crystal_name;


-- 9 List total price of orders for each gender
SELECT customers.gender, SUM(orders.price) AS TOTAL_PRICE FROM customers
JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customers.gender;

-- 10 List the most expensive order (product name, price (calculated by Function 1)) for each country
SELECT suppliers.supplier_country, products.crystal_name, orders.price AS BIGGEST_ORDER FROM products
JOIN orders ON orders.product_id = products.product_id
JOIN suppliers ON suppliers.supplier_id = products.product_id
WHERE (suppliers.supplier_country, orders.price) IN
    (
    SELECT suppliers.supplier_country, MAX(orders.price) AS BIGGEST_ORDER FROM products
    JOIN orders ON orders.product_id = products.product_id
    JOIN suppliers ON suppliers.supplier_id = products.product_id
    GROUP BY suppliers.supplier_country); 
