-- CODE: Create Materialized Views

    SELECT C.cust_id, cust_first_name,cust_last_name, prod_id, COUNT(*) num_sold FROM sales S, customers C
    WHERE S.cust_id = C.cust_id
    GROUP BY C.cust_id,cust_first_name, cust_last_name, prod_id
    ORDER BY num_sold DESC;
     
    CREATE MATERIALIZED VIEW vw_cust_num_sold
    ENABLE QUERY REWRITE AS
    SELECT C.cust_id, cust_first_name,cust_last_name, prod_id, COUNT(*) num_sold FROM sales S, customers C
    WHERE S.cust_id = C.cust_id
    GROUP BY C.cust_id,cust_first_name, cust_last_name, prod_id
    ORDER BY num_sold DESC;
     
    SELECT * FROM vw_cust_num_sold;
     
    SELECT cust_id,prod_name,num_sold
    FROM vw_cust_num_sold V, products P
    WHERE V.prod_id = P.prod_id
    AND V.prod_id = 13;
     
    SELECT cust_id,prod_name,num_sold
    FROM vw_cust_num_sold V, products P
    WHERE V.prod_id = P.prod_id(+)
    AND V.prod_id = 13;
     
    SELECT C.cust_id, cust_first_name,cust_last_name, prod_id, COUNT(*) num_sold FROM sales S, customers C
    WHERE S.cust_id = C.cust_id
    AND prod_id = 13
    GROUP BY C.cust_id,cust_first_name, cust_last_name, prod_id
    ORDER BY num_sold DESC;
     
    DROP MATERIALIZED VIEW vw_cust_num_sold;