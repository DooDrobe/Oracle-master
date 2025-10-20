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