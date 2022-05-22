-- How many different crystals of each colour are
SELECT colour, COUNT(product_id) as number_of_crystals FROM products
GROUP BY colour;

-- Supplier(s) that provide the most expensive product
SELECT suppliers.supplier_name, products.product_name, products.price_per_gram FROM suppliers
JOIN products ON suppliers.supplier_id = products.supplier_id
WHERE products.price_per_gram = (SELECT MAX(price_per_gram) FROM products);

-- The cheapest and the most expensive crystal(s) for each colour
SELECT DISTINCT colour, (SELECT product_name FROM products p2
     WHERE p2.colour = p1.colour AND p2.price_per_gram = 
        (SELECT MAX(price_per_gram) FROM products p3 WHERE p2.colour = p3.colour)) AS most_expensive_crystal,
    (SELECT product_name FROM products p2
     WHERE p2.colour = p1.colour AND p2.price_per_gram = 
        (SELECT MIN(price_per_gram) FROM products p3 WHERE p2.colour = p3.colour)) AS least_expensive_crystal
FROM products p1;

-- Crystal that is the most expensive from crystals that are cheaper than the average
SELECT product_id, product_name, price_per_gram, colour FROM products
WHERE price_per_gram <= (SELECT AVG(price_per_gram) FROM products)
ORDER BY price_per_gram DESC
FETCH FIRST 1 ROW ONLY;

-- Average, maximal and minimal order price for each customer
SELECT customer_id, MAX(price) AS greatest_price, MIN(price) AS smallest_price, ROUND(AVG(price),1) AS average_price FROM orders
GROUP BY customer_id ORDER BY customer_id;

-- Total sales of employees, their provision and income
SELECT employee_id, 
        (SELECT SUM(price) FROM orders WHERE orders.employee_id = employees.employee_id) AS total_sales, 
        commission, calculate_employee_income(employee_id) AS income 
FROM employees
ORDER BY employee_id;

-- Non-premium customer(s) who has the most expensive order 
SELECT first_name, last_name, order_id, price FROM customers
JOIN orders ON orders.customer_id = customers.customer_id
WHERE customers.premium = 0 AND orders.price = (
    SELECT MAX(price) FROM orders);

-- Most frequently bought product (name and total weight) for each gender
SELECT DISTINCT gender, (SELECT product_name FROM customers c2
    JOIN orders ON orders.customer_id = c2.customer_id
    JOIN products ON products.product_id = orders.product_id
    WHERE c2.gender = c1.gender
    GROUP BY product_name
    ORDER BY SUM(weight) DESC
    FETCH FIRST 1 ROW ONLY) AS most_popular_product,
    (SELECT SUM(weight) AS total_weight FROM customers c2
    JOIN orders ON orders.customer_id = c2.customer_id
    JOIN products ON products.product_id = orders.product_id
    WHERE c2.gender = c1.gender
    GROUP BY product_name
    ORDER BY total_weight DESC
    FETCH FIRST 1 ROW ONLY) AS total_weight
FROM customers c1 ORDER BY total_weight DESC;

-- Total price of orders for each gender
SELECT customers.gender, SUM(orders.price) AS TOTAL_PRICE FROM customers
JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customers.gender;

-- The most expensive order for each country
SELECT suppliers.supplier_country, products.product_name, orders.price AS most_expensive_order FROM products
JOIN orders ON orders.product_id = products.product_id
JOIN suppliers ON suppliers.supplier_id = products.product_id
WHERE (suppliers.supplier_country, orders.price) IN
    (
    SELECT suppliers.supplier_country, MAX(orders.price) AS most_expensive_order FROM products
    JOIN orders ON orders.product_id = products.product_id
    JOIN suppliers ON suppliers.supplier_id = products.product_id
    GROUP BY suppliers.supplier_country); 