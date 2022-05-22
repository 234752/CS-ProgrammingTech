-- Before adding orders if the customer made 3rd order make them premium
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
        
-- Prevent setting (both while adding and modifying) employee commission under 5% or above 30% 
CREATE OR REPLACE TRIGGER commission_check
BEFORE UPDATE OR INSERT ON employees FOR EACH ROW
BEGIN    
    IF :NEW.commission < 5 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Commission too low');
    END IF;
    
    IF :NEW.commission > 30 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Commission too high');
    END IF;
END;

-- Before removing supplier that has products, list all products that supplier has
CREATE OR REPLACE TRIGGER supplier_removal_check
BEFORE DELETE ON suppliers FOR EACH ROW
DECLARE
    CURSOR products_c IS SELECT product_id, product_name FROM products WHERE supplier_id = :OLD.supplier_id;
    n NUMBER(1);
BEGIN    
    SELECT COUNT(product_id) INTO n FROM products WHERE supplier_id = :OLD.supplier_id;
    IF (n > 0) THEN
        DBMS_OUTPUT.PUT_LINE('Supplier cannot be safetly deleted, it has following products:'); 
        FOR product IN products_c
        LOOP
            DBMS_OUTPUT.PUT_LINE('Product ID: ' || product.product_id || ', ' || 'Product name: ' || product.product_name); 
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Supplier can be safetly deleted'); 
    END IF;
END;