SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE product_info AS
    PROCEDURE find_avg_price_per_gram;
    PROCEDURE find_max_price_per_gram;
END product_info;

CREATE OR REPLACE PACKAGE BODY product_info AS  
   
    PROCEDURE find_avg_price_per_gram IS 
    avg_price products.price_per_gram%TYPE; 
    BEGIN 
        SELECT AVG(price_per_gram) INTO avg_price
        FROM products;
        dbms_output.put_line('Average price per gram = '|| avg_price); 
    END find_avg_price_per_gram;
    
    PROCEDURE find_max_price_per_gram IS 
    max_price products.price_per_gram%TYPE; 
    BEGIN 
        SELECT MAX(price_per_gram) INTO max_price
        FROM products;
        dbms_output.put_line('Max price per gram =  '|| max_price); 
    END find_max_price_per_gram;

END product_info;

DECLARE
BEGIN
    product_info.find_avg_price_per_gram;
    product_info.find_max_price_per_gram;
END;


