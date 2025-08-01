    /*Index skip scan usage with equality operator*/
    SELECT * FROM employees WHERE first_name = 'Alex';
     
    /* Index range scan occurs if we use the first column of the index */
    SELECT * FROM employees WHERE last_name = 'King';
     
    /* Using index skip scan with adding a new index */
    SELECT * FROM employees WHERE salary BETWEEN 6000 AND 7000;
    CREATE INDEX dept_sal_ix ON employees (department_id,salary);
    DROP INDEX dept_sal_ix;
     
    /* Using index skip scan with adding a new index
       This time the cost increases significantly */
    ALTER INDEX customers_yob_bix invisible;
    SELECT * FROM customers WHERE cust_year_of_birth BETWEEN 1989 AND 1990;
    CREATE INDEX customers_gen_dob_ix ON customers (cust_gender,cust_year_of_birth);
    DROP INDEX customers_gen_dob_ix;
    ALTER INDEX customers_yob_bix visible;

    