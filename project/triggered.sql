-- 1 After adding orders if the customer made 3rd order make them premium
CREATE OR REPLACE TRIGGER premium_customer
BEFORE INSERT ON orders FOR EACH ROW
DECLARE
    orders_amount number;
BEGIN
    SELECT COUNT(order_id) INTO orders_amount FROM orders WHERE customer_id = :NEW.customer_id;
    
    IF orders_amount = 2 THEN
        UPDATE customers
        SET premium = 1 WHERE customer_id = :NEW.customer_id;
    END IF;
END;

        
-- 2 Prevent setting (both while adding and modifying) employee commission under 5% or above 30% 
CREATE OR REPLACE TRIGGER provision_check
BEFORE UPDATE OR INSERT ON employees FOR EACH ROW
BEGIN    
    IF :NEW.provision < 5 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Provision too low');
    END IF;
    
    IF :NEW.provision > 30 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Provision too high');
    END IF;
END;

