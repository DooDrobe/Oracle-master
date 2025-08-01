    GRANT select_catalog_role TO hr;
    GRANT SELECT ANY DICTIONARY TO hr;
     
    SELECT * FROM employees e, departments d
    WHERE d.department_id = e.department_id
    AND d.manager_id = 110;
     
    SELECT /*+ use_hash(d e) */ * FROM employees e, departments d
    WHERE d.department_id = e.department_id
    AND d.manager_id = 110;