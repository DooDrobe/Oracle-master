    select * from departments d where exists
      (select 1 from employees e where d.department_id = e.department_id);
      
    select * from departments d where department_id in
      (select department_id from employees e where d.department_id = e.department_id);
     
    select * from employees e where exists
      (select 1 from departments d where d.department_id = e.department_id);