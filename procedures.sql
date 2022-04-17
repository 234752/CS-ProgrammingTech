SET SERVEROUTPUT ON;
-- delete from jobs where job_id = 'IT_DBA'
-- delete from jobs where job_id = 'ST_MAN'


--1 add job
SELECT * FROM jobs;
CREATE OR REPLACE PROCEDURE add_job(a_id IN jobs.job_id%TYPE, a_title IN jobs.job_title%TYPE )
IS 
BEGIN
    INSERT INTO jobs
    VALUES (a_id, a_title, null, null);
END;

EXEC add_job('IT_DBA', 'Database Administrator');

--2 add exception
EXEC add_job('ST_MAN', 'Stock Manager');
CREATE OR REPLACE PROCEDURE add_job(a_id IN jobs.job_id%TYPE, a_title IN jobs.job_title%TYPE )
IS 
BEGIN
    INSERT INTO jobs
    VALUES (a_id, a_title, null, null);
EXCEPTION
    WHEN OTHERS THEN dbms_output.put_line(SQLERRM);
END;

--3 change title of added job
CREATE OR REPLACE PROCEDURE upd_job(u_id IN jobs.job_id%TYPE, u_title IN jobs.job_title%TYPE)
IS 
    no_job EXCEPTION;
    amount number;
BEGIN
    SELECT count(job_id) INTO amount FROM jobs WHERE job_id = u_id;
    
    IF amount != 1
        THEN RAISE no_job;
    END IF;
    
    UPDATE jobs
    SET job_title = u_title WHERE job_id = u_id;
EXCEPTION
    WHEN no_job THEN dbms_output.put_line(SQLERRM);
END;

EXEC upd_job('IT_DBA', 'Data Administrator');
EXEC upd_job('pog', 'Data Administrator');

--4 delete job
CREATE OR REPLACE PROCEDURE del_job(d_id IN jobs.job_id%TYPE)
IS
amount number;
no_job EXCEPTION;
BEGIN
    SELECT count(job_id) INTO amount FROM jobs WHERE job_id = d_id;
    
    IF amount != 1 THEN RAISE no_job;
    END IF;
    
    DELETE FROM jobs WHERE job_id = d_id;
EXCEPTION
    WHEN no_job THEN dbms_output.put_line(SQLERRM);
END;
    
EXEC del_job('IT_WEB');

--5 output salary and job_id based on emp ID
CREATE OR REPLACE PROCEDURE  get_data(g_job OUT employees.job_id%TYPE, g_sal OUT employees.salary%TYPE, in_id IN employees.employee_id%TYPE)
IS
BEGIN
SELECT job_id INTO g_job FROM employees WHERE employee_id=in_id;
SELECT salary INTO g_sal FROM employees WHERE employee_id=in_id;
END;

DECLARE
t_job employees.job_id%TYPE;
t_salary employees.salary%TYPE;
BEGIN
    get_data(t_job, t_salary, 120);
    dbms_output.put_line(t_job || ' ' || t_salary);
END;
SELECT * FROM employees;

--6 function for annual salary
CREATE OR REPLACE FUNCTION get_annual_comp(i_sal IN employees.salary%TYPE, i_com IN employees.commission_pct%TYPE)
RETURN employees.salary%TYPE
IS 
BEGIN
    IF i_com IS NULL THEN
        RETURN i_sal*12;
    ELSE RETURN i_sal*12 + i_com*1000;
    END IF;
END;

SELECT first_name,salary,commission_pct, get_annual_comp(salary, commission_pct) FROM employees;

--7 add new row to employees table
CREATE OR REPLACE PROCEDURE add_employee(first_name IN employees.first_name%TYPE, 
                                        last_name IN employees.last_name%TYPE, 
                                        email IN employees.email%TYPE, 
                                        job_id IN employees.job_id%TYPE DEFAULT 'SA_REP',
                                        manager_id IN employees.manager_id%TYPE DEFAULT 145,
                                        salary IN employees.salary%TYPE DEFAULT 1000,
                                        commission_pct IN employees.commission_pct%TYPE DEFAULT 0,
                                        department_id IN employees.department_id%TYPE DEFAULT 30)
IS
    no_dep_id EXCEPTION;
BEGIN
    IF valid_deptid(department_id) !=1 THEN RAISE no_dep_id;
    END IF;
    
    INSERT INTO employees
    VALUES(EMPLOYEES_SEQ.nextval, first_name, last_name, email, '515.123.4657', TRUNC(SYSDATE), job_id, salary, commission_pct, manager_id, department_id);
EXCEPTION
    WHEN no_dep_id THEN dbms_output.put_line('there is no such department');
    WHEN others THEN dbms_output.put_line(SQLERRM);
END;

select * from employees;


CREATE OR REPLACE FUNCTION valid_deptid(i_id IN departments.department_id%TYPE)
RETURN number
IS
    amount number;
BEGIN
    SELECT count(department_id) INTO amount FROM departments WHERE department_id = i_id;
    RETURN amount;
END;

EXEC add_employee('Jane','Harris','JAHARRIS',department_id => 110);
