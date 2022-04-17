SET SERVEROUTPUT ON

--1 audit table
CREATE TABLE audit_table
(action VARCHAR2(50),
user_name VARCHAR2(30) DEFAULT USER,
last_change_date TIMESTAMP DEFAULT SYSTIMESTAMP);

CREATE OR REPLACE TRIGGER add_emp_trigger
AFTER INSERT ON employees
BEGIN
    INSERT INTO audit_table
    VALUES ('inserting',default,default);
END;

select * from employees;
INSERT INTO employees
VALUES(210,'bob','bob','bob','123.123.1234','07-JUN-09','ST_MAN',2000,null,205,110);
--delete from employees where employee_id = 210
SELECT * FROM audit_table; --delete from audit_table

--2 check salary when its updated
CREATE OR REPLACE PROCEDURE check_salary(i_id IN employees.job_id%TYPE, i_salary IN employees.salary%TYPE)
IS 
    min_sal number;
    max_sal number;
    invalid_salary EXCEPTION;
BEGIN
    SELECT min_salary INTO min_sal FROM jobs WHERE job_id = i_id;
    SELECT max_salary INTO max_sal FROM jobs WHERE job_id = i_id;
    IF i_salary < min_sal OR i_salary > max_sal THEN RAISE invalid_salary;
    END IF;
EXCEPTION
    WHEN invalid_salary THEN
    dbms_output.put_line('invalid salary '||i_salary||' salaries for job '||i_id||' must be between '||min_sal||' and '||max_sal);
END;

CREATE OR REPLACE TRIGGER check_salary_trigger
BEFORE INSERT OR UPDATE ON employees FOR EACH ROW
DECLARE
BEGIN
    check_salary(:NEW.job_id, :NEW.salary);
END;

INSERT INTO employees
VALUES(210,'bob','bob','bob','123.123.1234','07-JUN-09','ST_MAN',8000,null,205,110);
--delete from employees where employee_id = 210
UPDATE employees
SET job_id = 'SB_MAN', salary = 800 WHERE employee_id = 210;

--3 check salary only when its really changing
CREATE OR REPLACE TRIGGER check_salary_trigger
BEFORE INSERT OR UPDATE ON employees FOR EACH ROW
DECLARE
BEGIN
    IF :OLD.job_id != :NEW.job_id OR :OLD.salary != :NEW.salary
        THEN check_salary(:NEW.job_id, :NEW.salary);
    END IF;
END;

-- 4 prevent employee deletion during certain hours
CREATE OR REPLACE TRIGGER safe_delete
BEFORE DELETE ON employees
BEGIN
    IF CURRENT_DATE() != '20-JUN-09' THEN
    RAISE_APPLICATION_ERROR(-20000, 'Deletion not supported during this time');
    END IF;
END;

-- 5 check range of salary after updating
CREATE OR REPLACE TRIGGER check_sal_range
BEFORE UPDATE ON jobs FOR EACH ROW
DECLARE
    invalid_range EXCEPTION;
BEGIN
    FOR emp IN (SELECT * FROM employees WHERE job_id = :NEW.job_id)
        LOOP
            IF emp.salary > :NEW.max_salary OR emp.salary < :NEW.min_salary THEN
            dbms_output.put_line('employee '||emp.employee_id||' is outside of range '||:NEW.min_salary||' and '||:NEW.max_salary||', with salary: '||emp.salary);
            RAISE invalid_range;
            END IF;
        END LOOP;
EXCEPTION
    WHEN invalid_range THEN dbms_output.put_line('error');
END;

CREATE TABLE jobs2 AS SELECT * FROM jobs;
select * FROM jobs2;
UPDATE jobs2 SET 
max_salary = 2000 WHERE job_id = 'AD_PRES';
