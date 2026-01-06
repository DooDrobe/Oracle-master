CODE: Tuning Star Queries

    create table sales_temp as select * from sales;
    create index sales_temp_pk on sales_temp (prod_id,cust_id,time_id,channel_id);
     
    select sum(amount_sold) from sales_temp
    where prod_id between 100 and 300
    and cust_id between 100 and 300;
     
    select sum(amount_sold) from sales_temp s, products p
    where s.prod_id = p.prod_id 
    and p.prod_id between 100 and 300
    and s.cust_id between 100 and 300;
     
    select /*+ index_rs ( sales_temp sales_temp_pk)*/sum(amount_sold) from sales_temp
    where prod_id between 100 and 300
    and cust_id between 100 and 300;
     
    select c.cust_last_name,s.amount_sold, p.prod_name, c2.channel_desc
    from sales s, products p, customers c, channels c2
    where s.prod_id = p.prod_id
    and s.cust_id = c.cust_id
    and s.channel_id = c2.channel_id
    and p.prod_id < 100
    and c2.channel_id = 2
    and c.cust_postal_code = 52773;
     
    alter session set star_transformation_enabled = true;
     
    select /*+ star_transformation fact(s)*/
    c.cust_last_name,s.amount_sold, p.prod_name, c2.channel_desc
    from sales s, products p, customers c, channels c2
    where s.prod_id = p.prod_id
    and s.cust_id = c.cust_id
    and s.channel_id = c2.channel_id
    and p.prod_id < 100
    and c2.channel_id = 2
    and c.cust_postal_code = 52773;
     
    drop table sales_temp;

CODE: Using Bind Variables

    select avg(salary) from employees where department_id = 30;
    select avg(salary) from employees where department_id = 40;
    select avg(salary) from employees where department_id = 50;
     
    select sql_id,executions,parse_calls,first_load_time,last_load_time,sql_text from v$sql
    where sql_text like '%avg(salary) from employees%'
    order by first_load_time desc;
     
    select avg(salary) from employees where department_id = :b;
     
    declare
     v_dept_id number(2);
     v_count number(2);
    begin
        for r1 in (select department_id from departments) loop
            select count(*) into v_count from employees where department_id = v_dept_id;
        end loop;
    end;
    /
     
    declare
          type c1 is ref cursor;
          r1 c1;
          l_temp all_objects.object_name%type;
      begin
          for i in 1 .. 1000
          loop
              open r1 for
              'select object_name from all_objects where object_id = ' || i;
              fetch r1 into l_temp;
              close r1;
          end loop;
      end;
    /
     
    declare
          type c1 is ref cursor;
          r1 c1;
          l_temp all_objects.object_name%type;
      begin
          for i in 1 .. 1000
          loop
              open r1 for
              'select object_name from all_objects where object_id = :x' using i;
              fetch r1 into l_temp;
              close r1;
          end loop;
    end;
    /
     
    declare
          l_temp all_objects.object_name%type;
      begin
          for r1 in (select object_name from all_objects where object_id < 1001) loop
            l_temp := r1.object_name;
          end loop;
      end;

CODE: Beware of Bind Variable Peeking

    CREATE TABLE customers_temp AS SELECT * FROM customers;
     
    SELECT COUNT(*),cust_credit_limit FROM customers_temp 
    GROUP BY cust_credit_limit
    ORDER BY COUNT(*);
     
    DELETE FROM customers_temp WHERE cust_credit_limit = 15000 AND ROWNUM < 1860;
    COMMIT;
     
    CREATE INDEX c_temp_ix ON customers_temp(cust_credit_limit);
     
    BEGIN 
        dbms_stats.gather_table_stats(ownname => 'SH', tabname => 'CUSTOMERS_TEMP',
        method_opt  => 'for columns size 254 CUST_CREDIT_LIMIT', CASCADE=>TRUE);
    END;
     
    SELECT * FROM customers_temp WHERE cust_credit_limit = 1500;
    SELECT * FROM customers_temp WHERE cust_credit_limit = 15000;
     
    SELECT * FROM customers_temp WHERE cust_credit_limit = :b;
     
    DROP TABLE customers_temp;

CODE: Cursor Sharing

    ALTER SYSTEM FLUSH SHARED_POOL;
     
     
    ALTER SESSION SET cursor_sharing = 'EXACT';
    --ALTER SESSION SET cursor_sharing = 'FORCE';
     
    SELECT * FROM employees WHERE first_name = 'Alex';
    SELECT * FROM employees WHERE first_name = 'Lex';
    SELECT * FROM employees WHERE first_name = 'David';
     
    SELECT * FROM employees WHERE first_name LIKE 'A%';
    SELECT * FROM employees WHERE first_name LIKE 'B%';
    SELECT * FROM employees WHERE first_name LIKE 'C%';
     
    SELECT * FROM employees WHERE employee_id = 102;
    SELECT * FROM employees WHERE employee_id = 125;
    SELECT * FROM employees WHERE employee_id = 166;
    SELECT * FROM employees WHERE employee_id = 102;
     
    SELECT * FROM employees WHERE salary > 1500;
    SELECT * FROM employees WHERE salary > 15000;
    SELECT * FROM employees WHERE salary > 20000;
     
    VARIABLE b NUMBER;
    EXEC :b := 1000;
    SELECT * FROM employees WHERE salary > :b;
    EXEC :b := 20000;
    SELECT * FROM employees WHERE salary > :b;
     
    set linesize 2000;
     
    SELECT sql_id,child_number,executions,loads,parse_calls,sql_text
    FROM v$sql WHERE sql_text LIKE 'SELECT * FROM employees WHERE first_name =%';
     
    SELECT sql_id,child_number,executions,loads,parse_calls,sql_text
    FROM v$sql WHERE sql_text LIKE 'SELECT * FROM employees WHERE first_name LIKE%';
     
    SELECT sql_id,child_number,executions,loads,parse_calls,sql_text
    FROM v$sql WHERE sql_text LIKE 'SELECT * FROM employees WHERE employee_id =%';
     
    SELECT sql_id,child_number,executions,loads,parse_calls,sql_text
    FROM v$sql WHERE sql_text LIKE 'SELECT * FROM employees WHERE salary >%';

CODE: Adaptive Cursor Sharing

    ALTER SYSTEM FLUSH SHARED_POOL;
     
     
    SELECT COUNT(*),country_id FROM customers GROUP BY country_id order by count(*);
    CREATE TABLE customers_temp AS SELECT * FROM customers;
    CREATE INDEX cost_temp_country_id ON customers_temp(country_id);
     
    BEGIN
    dbms_stats.gather_table_stats(ownname => 'SH', tabname => 'CUSTOMERS_TEMP',
    method_opt => 'for columns size 254 COUNTRY_ID', CASCADE=>TRUE);
    END;
     
    VARIABLE country_id NUMBER;
    EXEC :country_id := 52787;
    SELECT * FROM customers_temp WHERE country_id = :country_id;
    EXEC :country_id := 52790;
    SELECT * FROM customers_temp WHERE country_id = :country_id;
    EXEC :country_id := 52770;
    SELECT * FROM customers_temp WHERE country_id = :country_id;
    EXEC :country_id := 52788;
    SELECT * FROM customers_temp WHERE country_id = :country_id;
    EXEC :country_id := 52790;
    SELECT * FROM customers_temp WHERE country_id = :country_id;
     
    SELECT * FROM TABLE(dbms_xplan.display_cursor(NULL,NULL,'TYPICAL +PEEKED_BINDS'));
     
    SELECT sql_id,child_number,executions,loads,parse_calls,is_bind_sensitive,is_bind_aware,sql_text
    FROM v$sql WHERE sql_text LIKE 'SELECT * FROM customers_temp WHERE country_id =%';
     
    SELECT hash_value,sql_id,child_number,range_id,LOW,HIGH,predicate
    FROM v$sql_cs_selectivity;
     
    DROP TABLE customers_temp;

CODE: Adaptive Plans

    ALTER SYSTEM FLUSH SHARED_POOL;
     
    SELECT COUNT(*)
    FROM sales S, products P, customers C
    WHERE S.prod_id = P.prod_id
    AND S.cust_id = C.cust_id;
     
    SELECT * FROM TABLE(dbms_xplan.display_cursor());
     
    SELECT * FROM TABLE(dbms_xplan.display_cursor(FORMAT => 'adaptive'));
     
    SELECT /*+ GATHER_PLAN_STATISTICS */COUNT(*)
    FROM sales S, products P, customers C
    WHERE S.prod_id = P.prod_id
    AND S.cust_id = C.cust_id;
     
    SELECT * FROM TABLE(dbms_xplan.display_cursor(FORMAT => 'adaptive allstats last')); 

CODE: Dynamic Statistics (Dynamic Sampling)

    ALTER SYSTEM FLUSH SHARED_POOL;
     
     
    CREATE TABLE customers_temp AS SELECT * FROM customers;
    CREATE INDEX cost_prov_ix ON customers_temp(cust_city,cust_state_province);
     
    SELECT /*+ GATHER_PLAN_STATISTICS */ * FROM customers_temp
    WHERE cust_city='Los Angeles' AND cust_state_province='CA';
     
    SELECT * FROM TABLE(dbms_xplan.display_cursor(FORMAT => 'allstats last'));
     
    SELECT /*+ GATHER_PLAN_STATISTICS dynamic_sampling(1) */ * FROM customers_temp
    WHERE cust_city='Los Angeles' AND cust_state_province='CA';
     
    SELECT /*+ GATHER_PLAN_STATISTICS dynamic_sampling(4) */ * FROM customers_temp
    WHERE cust_city='Los Angeles' AND cust_state_province='CA';
     
    SELECT /*+ GATHER_PLAN_STATISTICS dynamic_sampling(7) */ * FROM customers_temp
    WHERE cust_city='Los Angeles' AND cust_state_province='CA';
     
    SELECT /*+ GATHER_PLAN_STATISTICS dynamic_sampling(10) */ * FROM customers_temp
    WHERE cust_city='Los Angeles' AND cust_state_province='CA';
     
    SELECT /*+ GATHER_PLAN_STATISTICS dynamic_sampling(11) */ * FROM customers_temp
    WHERE cust_city='Los Angeles' AND cust_state_province='CA';
     
    DROP TABLE customers_temp;
     
    --The dynamic sampling levels and their meanings
    https://docs.oracle.com/database/121/TGSQL/tgsql_astat.htm#TGSQL451