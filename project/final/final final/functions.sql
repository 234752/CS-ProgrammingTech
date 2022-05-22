CREATE OR REPLACE FUNCTION calculate_order_price
(p_id in orders.product_id%TYPE, o_weight IN orders.weight%TYPE)
RETURN orders.price%TYPE
IS
p_price products.price_per_gram%TYPE;
n NUMBER(1);
no_product EXCEPTION;
BEGIN
    SELECT COUNT(product_id) INTO n FROM products WHERE product_id = p_id;
    IF n != 1 THEN
        RAISE no_product;
    END IF;
    SELECT price_per_gram INTO p_price FROM products WHERE product_id = p_id;
    RETURN p_price * o_weight;
EXCEPTION
    WHEN no_product THEN
    DBMS_OUTPUT.PUT_LINE('Product does not exist');
    RETURN -1;
END;


CREATE OR REPLACE FUNCTION calculate_employee_income
(e_id employees.employee_id%TYPE)
RETURN NUMBER
IS
    income NUMBER(8, 2);
    e_commission employees.commission%TYPE;
    n NUMBER(1);
    no_employee EXCEPTION;
BEGIN
    SELECT COUNT(employee_id) INTO n FROM employees WHERE employee_id = e_id;
    IF n != 1 
        THEN RAISE no_employee;
    END IF;
    
    SELECT SUM(employee_commission) INTO income FROM orders WHERE employee_id = e_id;
    
    RETURN income;
EXCEPTION    
    WHEN no_employee THEN
    DBMS_OUTPUT.PUT_LINE('Employee does not exist');
    RETURN -1;
END;