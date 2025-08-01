    SELECT * FROM departments d WHERE department_id NOT IN
      (SELECT department_id FROM employees e WHERE d.department_id = e.department_id);
     
    SELECT * FROM departments d WHERE NOT EXISTS
      (SELECT 1 FROM employees e WHERE d.department_id = e.department_id);
     
    SELECT /*+ HASH_AJ */* FROM departments d WHERE NOT EXISTS
      (SELECT 1 FROM employees e WHERE d.department_id = e.department_id);
      
    SELECT * FROM departments d WHERE NOT EXISTS
      (SELECT /*+ HASH_AJ */1 FROM employees e WHERE d.department_id = e.department_id);
     
    SELECT * FROM employees e WHERE NOT EXISTS
      (SELECT 1 FROM departments d WHERE d.department_id = e.department_id);