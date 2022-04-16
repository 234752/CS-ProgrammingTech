SET SERVEROUTPUT ON

--1 print info about a country
SELECT * FROM countries;

DECLARE
v_countryid varchar(50) := 'CA';
v_record countries%ROWTYPE;
BEGIN
SELECT * INTO v_record FROM countries WHERE country_id = v_countryid;
dbms_output.put_line(v_record.country_id);
dbms_output.put_line(v_record.country_name);
dbms_output.put_line(v_record.region_id);
END;

--2  for loop with cursor
SELECT * FROM employees;
DECLARE
    v_depno varchar(50) := &give_department;
    CURSOR c_emp_cursor IS SELECT last_name, salary, manager_id FROM employees WHERE department_id = v_depno;
BEGIN
FOR emp IN c_emp_cursor
LOOP
    IF emp.salary < 5000 AND (emp.manager_id = 101 OR emp.manager_id = 124) THEN
    dbms_output.put_line(emp.last_name || '  ' || emp.manager_id || '  ' || emp.salary || ' RAISE');
    ELSE dbms_output.put_line(emp.last_name || '  ' || emp.manager_id || '  ' || emp.salary);
    END IF;
END LOOP;
END;

--3 top n salaries
DECLARE
n number := &give_amount;
CURSOR c_salaries IS SELECT salary FROM employees ORDER BY salary DESC FETCH FIRST n ROWS ONLY; 
BEGIN
    FOR sal IN c_salaries
    LOOP
    dbms_output.put_line(sal.salary);
    END LOOP;
END;

--4 cursor with parameters
DECLARE
CURSOR depts IS SELECT department_id, department_name FROM departments WHERE department_id < 100;
CURSOR emps(dep_id number) IS SELECT last_name, job_id, salary, department_id FROM employees WHERE department_id = dep_id AND employee_id <120;
BEGIN
    FOR dept IN depts
    LOOP
    dbms_output.put_line('dept  ' || dept.department_id || '--------------------');
        FOR emp IN emps(dept.department_id)
        LOOP
        dbms_output.put_line(emp.department_id || ' '|| emp.last_name||' '|| emp.job_id||' '|| emp.salary);
        END LOOP;
    END LOOP;
END;

--5 find name based on salary
select * from employees;
DECLARE
nam varchar(50);
sal number := &give_salary;
BEGIN
SELECT first_name INTO nam FROM employees WHERE salary = sal;
dbms_output.put_line(nam);
EXCEPTION
    WHEN NO_DATA_FOUND THEN dbms_output.put_line('no data');
    WHEN TOO_MANY_ROWS THEN dbms_output.put_line('too much');
END;




    
    