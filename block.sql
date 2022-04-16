SET SERVEROUTPUT ON

DECLARE
x varchar(50) := 102;
BEGIN
dbms_output.put_line('pog');
dbms_output.put_line(x);
END;

-- 5 date
DECLARE
date_today DATE := CURRENT_DATE();
greeting varchar(50) := 'hello, there';
BEGIN
dbms_output.put_line(greeting || date_today || (date_today+1));
END;

-- 6 user input
DECLARE
uid varchar(50) := &give_id;
e_name varchar(50);
BEGIN
SELECT first_name INTO e_name FROM employees WHERE employee_id = uid
FETCH FIRST 1 ROW ONLY;
dbms_output.put_line('hello, ' || e_name);
END;

--7 create table
CREATE TABLE depts AS SELECT * FROM departments;
SELECT * FROM depts;

--8 max dep id
DECLARE
v_max_depno number;
BEGIN 
SELECT max(department_id) INTO v_max_depno FROM departments;
dbms_output.put_line(v_max_depno);
END;

--9 add education to depts
DECLARE
current_max_id number;
BEGIN
SELECT max(department_id) INTO current_max_id FROM departments;
INSERT INTO depts
VALUES (current_max_id +10, 'Education', null, null);
END;

--10  set location id of Education in depts
DECLARE
v_dept_id number := 280;
BEGIN
UPDATE depts
SET location_id = 3000 WHERE department_id = v_dept_id;
END;

--11 delete education
BEGIN
DELETE FROM depts WHERE department_id = 280;
END;

--12 loop, 4 variables output
BEGIN
FOR i IN 1..4
LOOP
    dbms_output.put_line('variable' || i);
END LOOP;
END;
--12 same with while
DECLARE
i number:=1;
BEGIN
WHILE i<=4
LOOP
    dbms_output.put_line('variable' || i);
    i:=i+1;
END LOOP;
END;

--13 loop from 3 to 7
BEGIN
FOR i IN 3..7
LOOP
    IF i = 3 THEN
    dbms_output.put_line('start'||i);
    ELSIF i = 5 THEN
    dbms_output.put_line('middle'||i);
    ELSIF i = 7 THEN
    dbms_output.put_line('end'||i);
    ELSE dbms_output.put_line(i);
    END IF;
END LOOP;
END;

--14 new table, add column
CREATE TABLE emps AS SELECT * FROM employees;
SELECT * FROM emps;
ALTER TABLE emps
ADD stars varchar2(50);

--15 add star for every 1000 in salary
DECLARE
sal number :=1000;
BEGIN
FOR i IN (SELECT * FROM employees)
    LOOP
        WHILE sal<=i.salary
        LOOP
            UPDATE emps
            SET stars = CONCAT(stars, '*') WHERE employee_id = i.employee_id;
            sal:=sal+1000;
        END LOOP;
        sal:=1000;
    END LOOP;
END;

--16 
DROP TABLE depts;
DROP TABLE emps;
