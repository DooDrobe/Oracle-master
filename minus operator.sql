    SELECT employee_id FROM employees where employee_id between 145 and 179
    MINUS
    SELECT employee_id FROM employees WHERE first_name LIKE 'A%';
     
    SELECT employee_id FROM employees e where employee_id between 145 and 179
    and not exists
    (SELECT employee_id FROM employees t WHERE first_name LIKE 'A%' and e.employee_id = t.employee_id);