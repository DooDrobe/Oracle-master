    EXEC DBMS_RESULT_CACHE.FLUSH;
     
    SELECT * FROM V$RESULT_CACHE_OBJECTS;
     
    SELECT cust_id, AVG(amount_sold) FROM sales
    GROUP BY cust_id
    order by cust_id;
     
    SELECT /*+ RESULT_CACHE */ cust_id, AVG(amount_sold) FROM sales
    GROUP BY cust_id
    order by cust_id;
     
    SELECT /*+ RESULT_CACHE */ cust_id, MIN(amount_sold), AVG(amount_sold) FROM sales
    GROUP BY cust_id
    order by cust_id;
     
    SELECT * FROM V$RESULT_CACHE_OBJECTS;
     
    select result_cache from user_tables where table_name = 'SALES';
     
    ALTER TABLE SALES RESULT_CACHE (MODE FORCE);
     
    SELECT cust_id, MAX(amount_sold) FROM sales
    GROUP BY cust_id
    order by cust_id;
     
    ALTER TABLE SALES RESULT_CACHE (MODE DEFAULT);