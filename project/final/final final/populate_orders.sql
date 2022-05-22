DROP SEQUENCE orders_seq;

CREATE SEQUENCE orders_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE
    NOCYCLE
    CACHE 20;
    
DELETE FROM orders;
    
EXEC add_order(1,1,1,1); 
EXEC add_order(20,20,1,0.5); 
EXEC add_order(6,19,1,2); 
EXEC add_order(4,18,1,1); 
EXEC add_order(12,17,2,0.5); 
EXEC add_order(3,16,2,1); 
EXEC add_order(17,5,2,2); 
EXEC add_order(15,4,3,2); 
EXEC add_order(17,3,3,0.5); 
EXEC add_order(16,2,3,2);
EXEC add_order(1,1,4,1); 
EXEC add_order(2,20,4,0.5); 
EXEC add_order(3,1,4,1); 
EXEC add_order(4,2,5,0.5); 
EXEC add_order(5,3,5,1); 
EXEC add_order(6,4,6,1); 
EXEC add_order(19,5,6,0.5); 
EXEC add_order(20,19,7,2); 
EXEC add_order(20,18,7,0.5); 
EXEC add_order(18,17,8,1);
EXEC add_order(1,16,9,1); 
EXEC add_order(17,15,9,0.5); 
EXEC add_order(16,14,10,1); 
EXEC add_order(15,13,11,2); 
EXEC add_order(1,12,12,1); 
EXEC add_order(7,11,13,0.5); 
EXEC add_order(8,10,14,1); 
EXEC add_order(9,12,15,1); 
EXEC add_order(1,13,16,0.5); 
EXEC add_order(2,14,17,1);
EXEC add_order(3,1,18,2); 
EXEC add_order(10,12,19,0.5); 
EXEC add_order(14,13,20,1); 
EXEC add_order(13,14,21,1); 
EXEC add_order(12,1,22,0.5); 
EXEC add_order(1,2,23,1); 
EXEC add_order(2,3,24,1); 
EXEC add_order(3,4,25,0.5); 
EXEC add_order(20,5,26,2); 
EXEC add_order(19,6,27,1);
EXEC add_order(1,7,27,0.5); 
EXEC add_order(11,8,28,1); 
EXEC add_order(1,9,28,1); 
EXEC add_order(6,10,28,1); 
EXEC add_order(7,19,29,2); 
EXEC add_order(8,1,29,1); 
EXEC add_order(9,11,30,0.5); 
EXEC add_order(13,3,30,1); 
EXEC add_order(14,7,30,1); 
EXEC add_order(1,20,30,2);

SELECT * FROM orders;