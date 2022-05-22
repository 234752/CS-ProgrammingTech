CREATE OR REPLACE PROCEDURE add_order
(p_id IN products.product_id%TYPE, c_id IN customers.customer_id%TYPE, e_id IN employees.employee_id%TYPE, o_weight IN orders.weight%TYPE)
IS
    o_price orders.price%TYPE;
    p_price products.price_per_gram%TYPE;
    c_premium customers.premium%TYPE;
    e_commission employees.commission%TYPE;
    o_commission orders.employee_commission%TYPE;
    n NUMBER(1);
    no_employee EXCEPTION;
    no_product EXCEPTION;
    no_customer EXCEPTION;
BEGIN
    SELECT COUNT(employee_id) INTO n FROM employees WHERE employee_id = e_id;
    IF n != 1 THEN
        RAISE no_employee;
    END IF;
    SELECT COUNT(product_id) INTO n FROM products WHERE product_id = p_id;
    IF n != 1 THEN
        RAISE no_product;
    END IF;
    SELECT COUNT(customer_id) INTO n FROM customers WHERE customer_id = c_id;
    IF n != 1 THEN
        RAISE no_customer;
    END IF;
    SELECT premium INTO c_premium FROM customers WHERE customer_id = c_id;
    SELECT commission INTO e_commission FROM employees WHERE employee_id = e_id;
    e_commission := e_commission / 100;
    o_commission := calculate_order_price(p_id, o_weight) * (e_commission / (1.00 - e_commission));
    o_price := calculate_order_price(p_id, o_weight) + o_commission;
    IF c_premium = 1 THEN 
        o_price := o_price * 0.95;
    END IF;
    INSERT INTO orders VALUES (orders_seq.NEXTVAL, p_id, c_id, e_id, SYSDATE, o_weight, o_price, o_commission); 
EXCEPTION
    WHEN no_employee THEN
    DBMS_OUTPUT.PUT_LINE('Employee does not exisit');  
    WHEN no_product THEN
    DBMS_OUTPUT.PUT_LINE('Product does not exisit');  
    WHEN no_customer THEN
    DBMS_OUTPUT.PUT_LINE('Customer does not exisit'); 
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;


CREATE OR REPLACE PROCEDURE display_products
(p_colour IN products.colour%TYPE)
IS
    CURSOR products_c IS SELECT product_id, supplier_id, product_name, price_per_gram FROM products WHERE colour = p_colour
    ORDER BY price_per_gram;
    n NUMBER(1);
    no_colour EXCEPTION;
BEGIN
    SELECT COUNT(product_id) INTO n FROM products WHERE colour = p_colour;
    IF n = 0 THEN
        RAISE no_colour;
    END IF;
    FOR product IN products_c
    LOOP
        DBMS_OUTPUT.PUT_LINE('Product ID: ' || product.product_id || ', ' || 'Supplier ID: ' || product.supplier_id || ', ' ||
                             'Name: ' || product.product_name || ', ' || 'Price per gram: ' || product.price_per_gram); 
    END LOOP;
EXCEPTION
    WHEN no_colour THEN
    DBMS_OUTPUT.PUT_LINE('Colour does not exist'); 
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

CREATE OR REPLACE PROCEDURE modify_employee_commission
(e_id IN employees.employee_id%TYPE, new_commission IN employees.commission%TYPE)
IS
    e_income NUMBER(8, 2);
    avg_income NUMBER(8, 2);
    employee employees%ROWTYPE;
    no_employee EXCEPTION;
    invalid_commission EXCEPTION;
    PRAGMA EXCEPTION_INIT(invalid_commission, -20000);
BEGIN
    e_income := calculate_employee_income(e_id);
    IF e_income = -1 THEN
        RAISE no_employee;
    END IF;
    UPDATE employees
    SET commission = new_commission
    WHERE employee_id = e_id;
    e_income := calculate_employee_income(e_id);
    SELECT ROUND(AVG(calculate_employee_income(employee_id)), 2) INTO avg_income FROM employees;
    SELECT employee_id, first_name, last_name, employee_email, employee_phone, commission INTO employee 
    FROM employees WHERE employee_id = e_id;
    IF(e_income > avg_income) THEN
        DBMS_OUTPUT.PUT_LINE(employee.first_name || ' ' || employee.last_name || ' has income greater than the average');
    ELSIF(e_income < avg_income) THEN
        DBMS_OUTPUT.PUT_LINE(employee.first_name || ' ' || employee.last_name || ' has income smaller than the average');
    ELSE
        DBMS_OUTPUT.PUT_LINE(employee.first_name || ' ' || employee.last_name || ' has average income');
    END IF;
EXCEPTION
    WHEN no_employee THEN
    DBMS_OUTPUT.PUT_LINE('Provide valid employee id'); 
    WHEN invalid_commission THEN
    DBMS_OUTPUT.PUT_LINE('Invalid commision value'); 
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;