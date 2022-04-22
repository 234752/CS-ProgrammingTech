

--1
DECLARE
    CURSOR emps IS SELECT first_name, last_name, department_id FROM employees;
    CURSOR depts(dep_id in departments.department_id%TYPE) IS SELECT department_name FROM departments WHERE department_id = dep_id;
    
BEGIN
    FOR emp IN emps
        LOOP
            FOR dep IN depts(emp.department_id)
            LOOP
                dbms_output.put_line(emp.first_name||' ' ||emp.last_name||' works in '||dep.department_name);
            END LOOP;
        END LOOP;
END;

--2
CREATE OR REPLACE PROCEDURE PROC_1(l_name IN employees.last_name%TYPE)
IS
    not_found EXCEPTION;
    amount number;
    new_salary number := 24001;
BEGIN
SELECT count(last_name) INTO amount FROM employees WHERE last_name = l_name;
    IF amount < 1 THEN RAISE not_found;
    END IF;
    UPDATE employees
    SET salary = salary *1.1 WHERE last_name = l_name;
EXCEPTION
    WHEN not_found THEN dbms_output.put_line('employee not found');
END;

exec PROC_1('aaaaa');
select * from employees;
exec PROC_1('King');

--3
CREATE OR REPLACE FUNCTION FUN_1(dep_name IN departments.department_name%TYPE)
RETURN number
IS
    not_found EXCEPTION;
    amount number;
    CURSOR depts(dep_name in departments.department_name%TYPE) IS SELECT department_id FROM departments WHERE department_name = dep_name;
    total number := 0;
BEGIN
    SELECT count(department_id) INTO amount FROM departments WHERE department_name = dep_name;
    IF amount <1 THEN RAISE not_found;
    END IF;
    FOR dep IN depts(dep_name)
    LOOP
        FOR sal IN (SELECT salary from employees WHERE department_id = dep.department_id)
        LOOP
        total := total + sal.salary;
        END LOOP;
    END LOOP;
RETURN total;
EXCEPTION
    WHEN not_found THEN dbms_output.put_line('department not found');
END;

select * from departments;
BEGIN
dbms_output.put_line(FUN_1('IT'));
END;
BEGIN
dbms_output.put_line(FUN_1('aaaa'));
END;

--4
CREATE TABLE empl_history AS SELECT * FROM employees;
delete from empl_history

CREATE OR REPLACE TRIGGER TRIG_1
BEFORE UPDATE ON employees FOR EACH ROW
BEGIN
    INSERT INTO empl_history
    VALUES(EMPLOYEES_SEQ.nextval, :OLD.first_name, :OLD.last_name, :OLD.email, :OLD.phone_number, :OLD.hire_date, :OLD.job_id, :OLD.salary, :OLD.commission_pct, :OLD.manager_id, :OLD.department_id);
END;
select *from employees