    select * from employees where rownum < 11;
     
    select * from employees where rownum < 11 order by employee_id desc;
     
    select * from employees fetch first 10 rows only;