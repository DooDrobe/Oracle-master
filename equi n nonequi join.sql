    /* Equijoin example */
    select * from employees e, departments d
    where e.department_id = d.department_id;
     
    /* Nonequijoin example */
    select * from employees e, jobs j
    where e.salary between j.min_salary and j.max_salary;