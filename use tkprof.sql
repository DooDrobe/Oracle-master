    sqlplus / as sysdba;
     
    alter session set tracefile_identifier= TUN;
     
    alter session set sql_trace = true;
     
    select * from hr.employees;
     
    alter session set sql_trace = false;
     
    select value from v$diag_info where name = ‘Diag Trace’;
     
    cd c:\app\omr\diag\rdbms\orcl\orcl\trace
     
    tkprof file_name.trc tun_ex.txt
     
    /********************************************************************/
     
    alter session set timed_statistics=true;
     
    exec dbms_session.session_trace_enable(waits => true, binds => false);
     
    select s.prod_id,p.prod_name,s.cust_id,c.cust_first_name 
    from sh.sales s, sh.products p, sh.customers c
    where s.prod_id = p.prod_id
    and s.cust_id = c.cust_id
    and s.amount_sold > 1500;
     
    exec dbms_session.session_trace_disable;