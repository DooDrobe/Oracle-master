    /* Index usage with order by */
    SELECT * FROM departments ORDER BY department_id;
     
    /* Index usage with order by, one column of an index - causes index full scan*/
    SELECT last_name,first_name FROM employees ORDER BY last_name;
     
    /* Index usage with order by, one column of an index - causes unnecessary sort operation*/
    SELECT last_name,first_name FROM employees ORDER BY first_name;
     
    /* Index usage with order by, but with wrong order - causes unnecessary sort operation */
    SELECT last_name,first_name FROM employees ORDER BY first_name,last_name;
     
    /* Index usage with order by, with right order of the index - there is no unncessary sort */
    SELECT last_name,first_name FROM employees ORDER BY last_name,first_name;
     
    /* Index usage with order by, wit unindexed column - there is no unncessary sort */
    SELECT last_name,first_name FROM employees ORDER BY last_name,salary;
     
    /* Index usage order by - when use * , it performed full table scan */
    SELECT * FROM employees ORDER BY last_name,first_name;
     
    /* Index usage with group by - using a column with no index leads a full table scan */
    SELECT salary,count(*) FROM employees e 
    WHERE salary IS NOT NULL
    GROUP BY salary;
     
    /* Index usage with group by - using indexed columns may lead to a index full scan */
    SELECT department_id,count(*) FROM employees e 
    WHERE department_id IS NOT NULL
    GROUP BY department_id;
     
    /* Index usage with group by - using more columns than ONE index has may prevent index full scan */ 
    SELECT department_id,manager_id,count(*) FROM employees e 
    WHERE department_id IS NOT NULL
    GROUP BY department_id, manager_id;
     
    /* Index usage with merge join */
    SELECT e.employee_id, e.last_name, e.first_name, e.department_id, 
           d.department_name
    FROM   employees e, departments d
    WHERE  e.department_id = d.department_id;