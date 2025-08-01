    select * from employees where employee_id = 103 or department_id = 80;
     
    select /*+ use_concat */* from employees where employee_id = 103 or department_id = 80;