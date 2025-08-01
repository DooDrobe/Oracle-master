    select * from employees e right outer join departments d
      using(department_id);
     
    select * from departments d left outer join employees e
      using(department_id);
     
    select * from employees e left outer join departments d
      using(department_id);
     
    select * from departments d right outer join employees e
      using(department_id);
      
    select /*+ USE_MERGE(e d) */* from employees e left outer join departments d
      using(department_id);
     
    select /*+ USE_NL(e d) */* from employees e left outer join departments d
      using(department_id);
     
    select /*+ USE_NL(d e) */* from employees e right outer join departments d
      using(department_id);
     
    select * from employees e full outer join departments d
      using(department_id);
     
    select * from employees e, departments d
      where e.department_id = d.department_id(+);
     
    select * from employees e, departments d
      where e.department_id(+) = d.department_id(+);
     
    select * from employees e left outer join departments d
      using(department_id)
      union
    select * from employees e right outer join departments d
      using(department_id);