    /* Index join scan with two indexes */
    SELECT employee_id,email FROM employees;
     
    /* Index join scan with two indexes, but with range scan included*/
    SELECT last_name,email FROM employees WHERE last_name LIKE 'B%';
     
    /* Index join scan is not performed when we add rowid to the select clause */
    SELECT rowid,employee_id,email FROM employees;