-- CODE: Index Usage

    SELECT cust_first_name, cust_last_name, cust_year_of_birth FROM customers
    WHERE cust_id = 975;
     
    SELECT cust_first_name, cust_last_name, cust_year_of_birth FROM customers
    WHERE cust_id <> 975;
     
    SELECT cust_first_name, cust_last_name, cust_year_of_birth FROM customers
    WHERE cust_id < 5000;
     
    SELECT /*+ INDEX(customers CUSTOMERS_PK) */cust_first_name, cust_last_name, cust_year_of_birth FROM customers
    WHERE cust_id < 5000;
     
    SELECT /*+ INDEX(customers CUSTOMERS_PK) */ cust_first_name, cust_last_name, cust_year_of_birth FROM customers
    WHERE cust_id < 500;
     
    SELECT cust_first_name, cust_last_name, cust_year_of_birth FROM customers
    WHERE cust_id < 100;
     
    SELECT cust_first_name, cust_last_name FROM customers
    WHERE cust_id BETWEEN 100 AND 130; 
     
    SELECT cust_year_of_birth FROM customers
    WHERE cust_id < 50;
     
    SELECT cust_year_of_birth,cust_last_name FROM customers
    WHERE cust_id < 50;
     
    SELECT E.employee_id, E.last_name, E.job_id, E.manager_id, D.department_name,D.department_id, C.country_name 
    FROM employees E, departments D, locations L, countries C
    WHERE E.department_id = D.department_id
    AND D.location_id = L.location_id
    AND L.country_id = C.country_id
    AND E.employee_id BETWEEN 120 AND 199;
     
    SELECT E.employee_id, E.last_name, E.job_id,E.manager_id, D.department_name,D.department_id, C.country_name 
    FROM employees E, departments D, locations L, countries C
    WHERE E.department_id = D.department_id
    AND D.location_id = L.location_id
    AND L.country_id = C.country_id
    AND E.employee_id BETWEEN 120 AND 199
    AND E.department_id IN (50,80);