CODE: Tuning the Join Order

    SELECT /*+ ORDERED */P.prod_name,C.cust_first_name,S.amount_sold FROM  customers C, products P, sales S
    WHERE S.cust_id = C.cust_id
    AND P.prod_id = S.prod_id;
     
    SELECT /*+ ORDERED */P.prod_name,C.cust_first_name,S.amount_sold FROM sales S, customers C, products P
    WHERE S.prod_id = P.prod_id
    AND S.cust_id = C.cust_id;
     
    SELECT /*+ ORDERED */P.prod_name,C.cust_first_name,S.amount_sold FROM sales S, products P , customers C
    WHERE S.prod_id = P.prod_id
    AND S.cust_id = C.cust_id;
     
    SELECT /*+ ORDERED */P.prod_name,C.cust_first_name,S.amount_sold FROM  products P , sales S, customers C
    WHERE S.prod_id = P.prod_id
    AND S.cust_id = C.cust_id;
     
    SELECT P.prod_name,C.cust_first_name,S.amount_sold FROM  products P , sales S, customers C
    WHERE S.prod_id = P.prod_id
    AND S.cust_id = C.cust_id;