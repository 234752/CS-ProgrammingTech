-- 1 Calculate price (takes product id and weight), calculates price of crystal, returns 0 (or -1) if problem occurred. Handles an exception when product id is invalid. 


-- 2 Count income of given employee (takes employee id) returns commission of total order price for given employee. Handles an exception when employee id is invalid
CREATE OR REPLACE FUNCTION emp_income(E_ID employees.employee_id%TYPE)
RETURN number
IS
    invalid_id EXCEPTION;
    amount number;
    total_income number :=0;
    provision_pct number;
BEGIN
    SELECT COUNT(employee_id) INTO amount FROM employees WHERE employee_id = E_ID;
    
    IF amount != 1 
        THEN RAISE invalid_id;
    END IF;
    
    SELECT provision INTO provision_pct FROM employees WHERE employee_id = E_ID;
    provision_pct := provision_pct /100;
    
    FOR ord IN (SELECT price FROM orders WHERE employee_id = E_ID)
    LOOP
        total_income := total_income + ord.price * provision_pct;
    END LOOP;
    RETURN total_income;

EXCEPTION    
    WHEN invalid_id THEN dbms_output.put_line('no such employee');
    RETURN -1;
END;
            
