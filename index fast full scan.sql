    /* Index Fast Full Scan Usage - Adding a different column 
        than index has will prevent the Index Fast Full Scan */
    SELECT e.employee_id, d.department_id, e.first_name,
           d.department_name
    FROM   employees e, departments d
    WHERE  e.department_id = d.department_id;
     
    /* If all the columns are in the index, it may perform
       an Index Fast Full Scan */
    SELECT e.employee_id, d.department_id,
           d.department_name
    FROM   employees e, departments d
    WHERE  e.department_id = d.department_id;
     
    /*Index Fast Full Scan can be applied to b-tree indexes, too 
      Even if there is an order by here, it used IFF Scan */
    SELECT prod_id from sales order by prod_id;
     
    /* Optimizer thinks Index Full Scan is better here*/
    SELECT time_id from sales order by time_id;
     
    /* Optimizer uses inded Fast Full Scan*/
    SELECT time_id from sales;