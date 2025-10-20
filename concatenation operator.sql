    select first_name, last_name, employee_id, salary from employees 
    where first_name||last_name = 'StevenKING';
     
    select first_name, last_name, employee_id, salary from employees 
    where first_name = 'Steven' and last_name = 'KING';


--arithmetic -- operators
        SELECT prod_id,cust_id,time_id FROM sales WHERE time_id+10 = '20-JAN-98';
     
    SELECT prod_id,cust_id,time_id FROM sales WHERE time_id = '10-JAN-98';
     
    SELECT prod_id, cust_id, time_id FROM sales 
    WHERE time_id = TO_DATE('20-JAN-98', 'DD-MON-RR')-10;


    -- CODE: Using Like Conditions

    select employee_id, first_name, last_name, salary from employees
    where last_name like '%on';
     
    select employee_id, first_name, last_name, salary from employees
    where last_name like '%on%';
     
    select employee_id, first_name, last_name, salary from employees
    where last_name like 'Ba%';
     
    create index last_name_reverse_index on employees(REVERSE(last_name));
     
    select employee_id, first_name, last_name, reverse(last_name), salary
    from employees
    where reverse(last_name) like 'rahh%';
     
    drop index last_name_reverse_index;

    -- \CODE: Using Functions on the Indexed Columns

    create index emp_date_temp_idx on employees (hire_date) compute statistics;
     
    select employee_id, first_name, last_name
    from employees where trunc(hire_date,'YEAR') = '01-JAN-2002';
     
    select employee_id, first_name, last_name
    from employees where hire_date between '01-JAN-2002' and '31-DEC-2002';
     
    drop index emp_date_temp_idx;
     
    select prod_id,prod_category,prod_subcategory from products
    where substr(prod_subcategory,1,2) = 'Po';
     
    select prod_id,prod_category,prod_subcategory from products
    where prod_subcategory like 'Po%';


    -- CODE: Handling NULL-Based Performance Problems

    CREATE TABLE employees_temp AS SELECT * FROM employees;
     
    CREATE INDEX comm_pct_idx ON employees_temp(commission_pct) COMPUTE STATISTICS;
     
    SELECT * FROM employees_temp WHERE commission_pct <> 1;
     
    SELECT * FROM employees_temp WHERE commission_pct <> 1 AND commission_pct IS NOT NULL;
     
    SELECT employee_id,commission_pct FROM employees_temp WHERE commission_pct IS NULL;
     
    SELECT /*+ index(employees_temp comm_pct_idx)*/employee_id,commission_pct 
    FROM employees_temp WHERE commission_pct IS NULL;
     
    UPDATE employees_temp SET commission_pct = 0 WHERE commission_pct IS NULL;
    COMMIT;
     
    SELECT employee_id,commission_pct FROM employees_temp WHERE commission_pct = 0;
     
    UPDATE employees_temp SET commission_pct = NULL WHERE commission_pct = 0;
    COMMIT;
     
    DROP INDEX comm_pct_idx;
    CREATE BITMAP INDEX comm_pct_idx ON employees_temp(commission_pct) COMPUTE STATISTICS;
     
    SELECT employee_id,commission_pct FROM employees_temp WHERE commission_pct IS NULL;
     
    SELECT /*+ index(employees_temp comm_pct_idx)*/employee_id,commission_pct 
    FROM employees_temp WHERE commission_pct IS NULL;
     
    DROP TABLE employees_temp;

    -- CODE: Using TRUNCATE instead of DELETE command

    create table sales_temp1 as select * from sales;
    create table sales_temp2 as select * from sales;
     
    delete from sales_temp1;
     
    truncate table sales_temp2;
     
    drop table sales_temp1;
    drop table sales_temp2;



    -- CODE: Data Type Mismatch

    SELECT cust_id, cust_first_name, cust_last_name FROM customers WHERE cust_id = 3228;
     
    SELECT cust_id, cust_first_name, cust_last_name FROM customers WHERE cust_id = '3228';
     
    CREATE INDEX cust_postal_code_idx ON customers (cust_postal_code);
     
    SELECT cust_id, cust_first_name, cust_last_name FROM customers WHERE cust_postal_code = 60332;
     
    SELECT cust_id, cust_first_name, cust_last_name FROM customers WHERE cust_postal_code = '60332';
     
    SELECT cust_id, cust_first_name, cust_last_name FROM customers WHERE to_number(cust_postal_code) = 60332;
     
    DROP INDEX cust_postal_code_idx;


    -- CODE: Tuning Ordered Queries

    select prod_id,cust_id,time_id from sales order by amount_sold;
    select prod_id,cust_id,time_id from sales order by cust_id;
    select prod_id,cust_id,time_id from sales where cust_id < 100 order by cust_id;
    select cust_id from sales order by cust_id;
    select cust_id from customers order by cust_id;
    select cust_id,cust_first_name, cust_last_name from customers where cust_id < 100 order by cust_id;
    select cust_id, cust_first_name, cust_last_name from customers order by cust_first_name;



    -- CODE: Retrieving the MIN & MAX Values

    select max(CUST_STREET_ADDRESS) from customers;
    select max(cust_year_of_birth) from customers;
    select cust_year_of_birth from customers;
    select max(cust_id) from customers;
    select cust_id from customers;
    select cust_id from customers where cust_id < 1000;
    select max(cust_id) from customers where cust_id < 1000;
    select min(cust_id) from customers;
    select min(cust_id), max(cust_id) from customers;
    SELECT MAX(cust_id), MAX(cust_id) FROM customers;
    select * from
     (select min(cust_id) min_cust from customers) min_customer,
     (select max(cust_id) max_cust from customers) max_customer;


    --  UNION and UNION ALL Operators (Which one is faster?)

    select prod_id,cust_id,time_id,amount_sold,channel_id from sales where channel_id = 3
    union
    select prod_id,cust_id,time_id,amount_sold,channel_id from sales where channel_id = 4;
     
    select prod_id,cust_id,time_id,amount_sold,channel_id from sales where channel_id = 3
    union all
    select prod_id,cust_id,time_id,amount_sold,channel_id from sales where channel_id = 4;



    -- CODE: Avoid Using the HAVING Clause!

    select time_id,sum(amount_sold) from sales
    group by time_id
    having time_id between '01-JAN-01' and '28-FEB-01';
     
    select time_id,sum(amount_sold) from sales
    where time_id between '01-JAN-01' and '28-FEB-01'
    group by time_id;
     
    select prod_id,sum(amount_sold) from sales
    group by prod_id
    having prod_id = 136;
     
    select prod_id,sum(amount_sold) from sales
    where prod_id = 136
    group by prod_id;

    