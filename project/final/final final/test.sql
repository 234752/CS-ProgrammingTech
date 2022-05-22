SET SERVEROUTPUT ON;

EXEC add_order (420,1,1,1);
EXEC add_order (1,420,1,1);
EXEC add_order (1,1,420,1);
EXEC add_order (1,1,1,0.42);

EXEC display_products('White');
EXEC display_products('');

EXEC modify_employee_commission(0, 10);
EXEC modify_employee_commission(1, 1);
EXEC modify_employee_commission(1, 10);
EXEC modify_employee_commission(1, 99);

DELETE FROM suppliers WHERE supplier_id = 1;

INSERT INTO suppliers VALUES (11, 'test', 'test');
DELETE FROM suppliers WHERE supplier_id = 11;