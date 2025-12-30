CODE: B-Tree Indexes in Details

    CREATE TABLE employees_copy AS SELECT * FROM employees;
     
    SELECT * FROM employees_copy WHERE employee_id = 120;
     
    CREATE INDEX emp_id_idx ON employees_copy(employee_id) COMPUTE STATISTICS;
     
    SELECT * FROM employees_copy WHERE employee_id = 120;
     
    EXEC dbms_stats.gather_table_stats (ownname=>'HR',tabname => 'EMPLOYEES_COPY',CASCADE => TRUE);
     
    SELECT * FROM employees_copy WHERE employee_id = 120;
     
    ALTER TABLE employees_copy ADD CONSTRAINT unique_emps UNIQUE (employee_id);
     
    SELECT * FROM employees_copy WHERE employee_id = 120;
     
    ALTER INDEX emp_id_idx REBUILD;
     
    SELECT * FROM employees_copy WHERE employee_id = 120;
     
    ALTER TABLE employees_copy DROP CONSTRAINT unique_emps;
     
    ALTER TABLE employees_copy ADD CONSTRAINT unique_emps UNIQUE (employee_id)
    USING INDEX emp_id_idx;
     
    SELECT * FROM employees_copy WHERE employee_id = 120;
     
    ALTER TABLE employees_copy DROP CONSTRAINT unique_emps;
    DROP INDEX emp_id_idx;
     
    ALTER TABLE employees_copy ADD CONSTRAINT unique_emps UNIQUE (employee_id);
     
    SELECT * FROM employees_copy WHERE employee_id = 120;
     
    DROP TABLE employees_copy;


CODE: Bitmap Indexes in Details

    SELECT * FROM employees WHERE department_id IS NOT NULL;
    SELECT department_id FROM employees WHERE department_id IS NOT NULL;
    SELECT department_id FROM employees WHERE department_id IS NULL;
     
    SELECT * FROM customers WHERE cust_marital_status IS NOT NULL;
    SELECT cust_marital_status FROM customers WHERE cust_marital_status IS NOT NULL;
    SELECT cust_marital_status FROM customers WHERE cust_marital_status IS NULL;
    SELECT COUNT(cust_marital_status) FROM customers WHERE cust_marital_status IS NULL;
     
    CREATE TABLE customers_temp AS SELECT * FROM customers;
     
    CREATE INDEX cust_mar_stat_ix ON customers_temp(cust_marital_status);
     
    SELECT * FROM customers_temp WHERE cust_marital_status = 'married';
     
    CREATE INDEX cust_gender_ix ON customers_temp(cust_gender);
     
    SELECT * FROM customers_temp WHERE cust_gender = 'M';
    SELECT * FROM customers_temp WHERE cust_gender = 'M' AND cust_marital_status = 'married';
     
    DROP INDEX cust_gender_ix;
    DROP INDEX cust_mar_stat_ix;
     
    CREATE BITMAP INDEX cust_mar_stat_bix ON customers_temp(cust_marital_status);
     
    SELECT * FROM customers_temp WHERE cust_marital_status = 'married';
     
    CREATE BITMAP INDEX cust_gender_bix ON customers_temp(cust_gender);
     
    SELECT * FROM customers_temp WHERE cust_gender = 'M';
    SELECT * FROM customers_temp WHERE cust_gender = 'M' AND cust_marital_status = 'married';
     
    DROP TABLE customers_temp;

CODE: Composite Indexes and Order of Indexed Columns

    CREATE TABLE sales_temp AS SELECT * FROM sales;
     
    CREATE INDEX sales_idx ON sales_temp(prod_id,cust_id,time_id);
     
    SELECT * FROM sales_temp WHERE prod_id = 13 AND cust_id = 2380 AND time_id = '10-JUL-98';
     
    SELECT * FROM sales_temp WHERE prod_id = 13 AND cust_id = 2380;
     
    SELECT * FROM sales_temp WHERE prod_id = 13 AND time_id = '10-JUL-98';
     
    SELECT * FROM sales_temp WHERE cust_id = 2380 AND time_id = '10-JUL-98';
     
    DROP INDEX sales_idx;
    CREATE INDEX sales_idx ON sales_temp(cust_id,prod_id,time_id);
     
    SELECT * FROM sales_temp WHERE cust_id = 2380 AND time_id = '10-JUL-98';
     
    DROP TABLE sales_temp;


CODE: Covering Indexes

    CREATE TABLE sales_temp AS SELECT * FROM sales;
     
    CREATE INDEX sales_idx ON sales_temp(prod_id,cust_id,time_id);
     
    SELECT prod_id,cust_id FROM sales_temp
    WHERE prod_id = 13;
     
    SELECT prod_id,cust_id,time_id FROM sales_temp
    WHERE prod_id = 13;
     
    SELECT prod_id,cust_id,time_id,amount_sold FROM sales_temp
    WHERE prod_id = 13;
     
    DROP INDEX sales_idx;
    CREATE INDEX sales_idx ON sales_temp(prod_id,cust_id,time_id,amount_sold);
     
    SELECT prod_id,cust_id,time_id,amount_sold FROM sales_temp
    WHERE prod_id = 13;
     
    DROP TABLE sales_temp;


CODE: Bitmap Join Indexes

    ALTER TABLE customers ENABLE VALIDATE CONSTRAINT customers_pk;

    ALTER TABLE products ENABLE VALIDATE CONSTRAINT products_pk;


    SELECT AVG(S.quantity_sold)

    FROM sales S, products P, customers C

    WHERE S.prod_id = P.prod_id

    AND S.cust_id = C.cust_id

    AND P.prod_subcategory = 'CD-ROM'

    AND C.cust_city = 'Manchester';


    CREATE BITMAP INDEX sales_temp_bjx ON sales(P.prod_subcategory, C.cust_city)

    FROM sales S, products P, customers C

    WHERE S.prod_id = P.prod_id

    AND S.cust_id = C.cust_id

    LOCAL;


    DROP INDEX sales_temp_bjx;


    SELECT DISTINCT C.cust_postal_code

    FROM sales S, products P, customers C

    WHERE S.prod_id = P.prod_id

    AND S.cust_id = C.cust_id

    AND C.cust_city = 'Manchester';


    CREATE BITMAP INDEX sales_temp_bjx ON sales(C.cust_city)

    FROM sales S, products P, customers C

    WHERE S.prod_id = P.prod_id

    AND S.cust_id = C.cust_id

    LOCAL;


    SELECT DISTINCT S.channel_id

    FROM sales S, products P, customers C

    WHERE S.prod_id = P.prod_id

    AND S.cust_id = C.cust_id

    AND C.cust_city = 'Manchester';


    SELECT COUNT(*)

    FROM sales S, products P, customers C

    WHERE S.prod_id = P.prod_id

    AND S.cust_id = C.cust_id

    AND C.cust_city = 'Manchester';


    DROP INDEX sales_temp_bjx;

    ALTER TABLE customers ENABLE NOVALIDATE CONSTRAINT customers_pk;

    ALTER TABLE products ENABLE NOVALIDATE CONSTRAINT products_pk;

    CODE: Combining Bitmap Indexes

    CREATE TABLE customers_temp AS SELECT * FROM customers;
     
    CREATE INDEX cust_city_ix ON customers_temp(cust_city);
    CREATE INDEX cust_name_ix ON customers_temp(cust_first_name,cust_last_name);
     
    SELECT * FROM customers_temp WHERE cust_city IN ('Aachen','Abingdon','Bolton','Santos');
    SELECT * FROM customers_temp WHERE cust_city IN ('Aachen','Abingdon','Bolton','Santos','Barry','Westminster','Tilburg');
    SELECT * FROM customers_temp WHERE cust_city IN ('Aachen','Abingdon','Bolton','Santos') AND cust_first_name = 'Abigail';
    SELECT /*+ index(c cust_name_ix, cust_name_ix)*/* FROM customers_temp C WHERE cust_city IN ('Aachen','Abingdon','Bolton','Santos') AND cust_first_name = 'Abigail';
     
    DROP INDEX cust_city_ix;
    DROP INDEX cust_name_ix;
    CREATE BITMAP INDEX cust_city_bix ON customers_temp(cust_city);
    CREATE BITMAP INDEX cust_name_bix ON customers_temp(cust_first_name,cust_last_name);
     
    SELECT * FROM customers_temp WHERE cust_city IN ('Aachen','Abingdon','Bolton','Santos');
    SELECT * FROM customers_temp WHERE cust_city IN ('Aachen','Abingdon','Bolton','Santos','Barry','Westminster','Tilburg');
    SELECT * FROM customers_temp WHERE cust_city IN ('Aachen','Abingdon','Bolton','Santos') AND cust_first_name = 'Abigail';
     
    DROP TABLE customers_temp;

    CODE: Function-Based Indexes

    SELECT * FROM employees;
    SELECT * FROM employees WHERE last_name = 'KING';
    SELECT * FROM employees WHERE UPPER(last_name) = 'KING';
     
    CREATE INDEX last_name_fix ON employees (UPPER(last_name));
    SELECT * FROM employees WHERE UPPER(substr(last_name,1,1)) = 'K';
    DROP INDEX last_name_fix;
     
    CREATE INDEX last_name_fix ON employees (UPPER(substr(last_name,1,1)));
    SELECT * FROM employees WHERE UPPER(substr(last_name,1,1)) = 'K';
    SELECT * FROM employees WHERE UPPER(substr(last_name,1,2)) = 'KI';
    DROP INDEX last_name_fix;
     
    CREATE INDEX annual_salary_fix ON employees(salary*12-300);
    SELECT * FROM employees WHERE salary > 10000;
    SELECT * FROM employees WHERE salary*12 > 10000;
    SELECT * FROM employees WHERE salary*12-300 > 10000;
    SELECT * FROM employees WHERE salary*12-301 > 10000+1;
    DROP INDEX annual_salary_fix;

    CODE: Index-Organized Tables

    CREATE TABLE customers_temp AS
    SELECT cust_id,cust_first_name,cust_last_name,cust_gender,cust_year_of_birth,
    cust_marital_status,cust_postal_code,cust_city_id,cust_credit_limit FROM customers;
     
    CREATE INDEX cus_ix ON customers_temp(cust_id);
     
    CREATE TABLE customers_iot (cust_id NUMBER,
    cust_first_name VARCHAR2(20),
    cust_last_name VARCHAR2(40),
    cust_gender CHAR(1),
    cust_year_of_birth NUMBER(4,0),
    cust_marital_status VARCHAR2(20),
    cust_postal_code VARCHAR2(10),
    cust_city_id NUMBER,
    cust_credit_limit NUMBER,
    CONSTRAINT cid_pk PRIMARY KEY (cust_id))
    ORGANIZATION INDEX
    PCTTHRESHOLD 40;
     
    INSERT INTO customers_iot SELECT cust_id,cust_first_name,cust_last_name,cust_gender,cust_year_of_birth,
    cust_marital_status,cust_postal_code,cust_city_id,cust_credit_limit FROM customers;
     
    /
    SELECT * FROM customers_temp WHERE cust_id = 47006;
    SELECT * FROM customers_iot WHERE cust_id = 47006;
    SELECT * FROM customers_temp WHERE cust_id BETWEEN 5000 AND 5050;
    SELECT * FROM customers_iot WHERE cust_id BETWEEN 5000 AND 5050;
    SELECT * FROM customers_temp WHERE cust_id BETWEEN 5000 AND 10000;
    SELECT * FROM customers_iot WHERE cust_id BETWEEN 5000 AND 10000;
    SELECT * FROM customers_temp WHERE cust_year_of_birth = 1978;
    SELECT * FROM customers_iot WHERE cust_year_of_birth = 1978;
     
    DROP TABLE customers_temp;
    DROP TABLE customers_iot;