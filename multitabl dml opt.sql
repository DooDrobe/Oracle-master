CODE: Multitable DML Operations

    ------------------------ INSERT ALL EXAMPLE -----------------------------
     
    CREATE TABLE it_programmers AS SELECT * FROM employees WHERE 1=2;
     
    CREATE TABLE sales_representatives AS SELECT * FROM employees WHERE 1=2;
     
    INSERT INTO it_programmers SELECT * FROM employees WHERE job_id = 'IT_PROG';
     
    INSERT INTO sales_representatives SELECT * FROM employees WHERE job_id = 'SA_REP';
     
    INSERT ALL 
        WHEN job_id = 'IT_PROG' THEN INTO it_programmers
        WHEN job_id = 'SA_REP' THEN INTO sales_representatives
    SELECT * FROM employees WHERE job_id IN ('IT_PROG','SA_REP');
     
    -------------------------- MERGE EXAMPLE --------------------------------
     
    CREATE TABLE bonuses (employee_id NUMBER(6,0), bonus NUMBER(8,2), salary NUMBER(8,2), department_id NUMBER(4,0));
     
    INSERT INTO bonuses SELECT employee_id, 1000, salary, department_id FROM employees WHERE ROWNUM < 70;
     
    INSERT INTO bonuses SELECT employee_id, 1000, salary, department_id FROM employees WHERE department_id = 80 AND salary < 10000
    AND employee_id NOT IN (SELECT employee_id FROM bonuses);
     
    UPDATE bonuses b SET b.bonus = b.bonus + bonus*0.15 
    WHERE employee_id IN (SELECT employee_id FROM employees WHERE department_id = 80 AND salary < 10000);
     
    DELETE FROM bonuses WHERE employee_id IN (SELECT employee_id FROM employees WHERE salary >= 10000 OR department_id <> 80);
     
    MERGE INTO bonuses b
       USING (SELECT employee_id, salary, department_id FROM employees) E
       ON (b.employee_id = E.employee_id )
       WHEN MATCHED THEN 
         UPDATE SET b.bonus = b.bonus + b.bonus*0.15 
         DELETE WHERE (b.salary >= 10000 OR b.department_id != 80)
       WHEN NOT MATCHED THEN 
       INSERT (b.employee_id, b.bonus, b.salary, b.department_id)
         VALUES (E.employee_id, 1000 + 1000*0.15, E.salary, E.department_id)
         WHERE (E.salary < 10000 AND E.department_id = 80);
     
    DROP TABLE it_programmers;
    DROP TABLE sales_representatives;
    DROP TABLE bonuses;