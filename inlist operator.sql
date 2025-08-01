    select * from employees where employee_id in (100, 110, 146);
     
    select * from employees where employee_id in (100, 110, 146, 103, 124, 132, 102,
                                                  156, 187, 203, 177, 108, 123, 163,
                                                  104, 105, 188, 142, 151, 129, 109,
                                                  200, 130, 116, 104, 174, 152, 122,
                                                  155, 181, 133, 127, 158, 193, 140,
                                                  101, 119, 183, 152, 150, 119, 139);
     
    select * from employees where employee_id = 100 or
                                  employee_id = 110 or 
                                  employee_id = 146;