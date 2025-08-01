    CREATE CLUSTER emp_dep_cluster (dep_id NUMBER(4,0))
        TABLESPACE users
        STORAGE (INITIAL 250K     NEXT 50K )
        HASH IS dep_id HASHKEYS 500;
     
    create table emps_clustered (
        employee_id number(6,0) primary key,
        first_name varchar2(20),
        last_name varchar2(25),
        department_id number(4,0)
    ) cluster emp_dep_cluster (department_id);
     
    insert into emps_clustered (employee_id,first_name,last_name,department_id)
    select employee_id,first_name,last_name,department_id from employees;
     
    create table deps_clustered (
        department_id number(4,0) primary key,
        department_name varchar2(30)
    ) cluster emp_dep_cluster (department_id);
     
    insert into deps_clustered (department_id,department_name)
    select department_id,department_name from departments;
     
    select employee_id,first_name,department_name from employees e, departments d
    where e.department_id = d.department_id
    and e.department_id = 80;
     
    select employee_id,first_name,department_name from emps_clustered e, deps_clustered d
    where e.department_id = d.department_id
    and e.department_id = 80;
     
    select employee_id,first_name,department_name from emps_clustered e, deps_clustered d
    where e.department_id = d.department_id
    and e.department_id > 80;
     
    select employee_id,first_name,department_name from employees e, departments d
    where e.department_id = d.department_id
    and e.department_id > 80;
     
    select * from emps_clustered;
     
    drop table deps_clustered;
    drop table emps_clustered;
    drop cluster emp_dep_cluster;