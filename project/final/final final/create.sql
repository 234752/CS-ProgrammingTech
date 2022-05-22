DROP TABLE ORDERS;
DROP TABLE PRODUCTS;
DROP TABLE SUPPLIERS;
DROP TABLE CUSTOMERS;
DROP TABLE EMPLOYEES;

CREATE TABLE customers
(
	customer_id NUMBER(4) PRIMARY KEY,
	first_name VARCHAR2(20) NOT NULL,
	last_name VARCHAR2(20) NOT NULL,	
    gender VARCHAR2(8) CHECK (gender IN ('Male','Female','Other')),		
	customer_email VARCHAR2(32),	
    customer_phone VARCHAR2(12),
	premium NUMBER(1) 	
);

CREATE TABLE employees
(
    employee_id NUMBER(4) PRIMARY KEY,
    first_name VARCHAR2(20) NOT NULL,
    last_name VARCHAR2(20) NOT NULL,
    employee_email VARCHAR2(32),
    employee_phone VARCHAR2(12),
    commission NUMBER(4, 2) 
);

CREATE TABLE suppliers
(
	supplier_id NUMBER(4) PRIMARY KEY,
    supplier_name VARCHAR2(20) NOT NULL,
	supplier_country VARCHAR2(20)	
);

CREATE TABLE products
(
	product_id NUMBER(4) PRIMARY KEY,
	supplier_id NUMBER(4) NOT NULL,
    product_name VARCHAR2(20) NOT NULL,
    price_per_gram NUMBER(8, 2),
    colour VARCHAR2(20),
    
    CONSTRAINT FK1 FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

CREATE TABLE orders
(
	order_id NUMBER(4) PRIMARY KEY,
	product_id NUMBER(4) NOT NULL,
	customer_id NUMBER(4) NOT NULL,	
    employee_id NUMBER(4) NOT NULL,
	order_date DATE,
    weight NUMBER(8, 6),
    price NUMBER(8, 2),
    employee_commission NUMBER(8,2),
	
	CONSTRAINT FK2 FOREIGN KEY (product_id) REFERENCES products(product_id),
	CONSTRAINT FK3 FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT FK4 FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);