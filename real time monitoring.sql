    select * from sales s, customers c
    where s.cust_id = c.cust_id and
    channel_id = 9;
     
    select /*+ monitor */* from sales s, customers c
    where s.cust_id = c.cust_id and
    channel_id = 9;
     
    alter system flush shared_pool;
    alter system flush buffer_cache;
     
    SELECT /*+ PARALLEL(4) */ c.cust_first_name, c.cust_last_name, 
      MAX(QUANTITY_SOLD), AVG(QUANTITY_SOLD)
    FROM sales s, customers c, countries ct, costs cs
    WHERE s.cust_id = c.cust_id
    and s.channel_id = :v_channel_id
    and c.country_id = ct.country_id
    --and cs.prod_id = s.prod_id
    GROUP BY c.cust_first_name, c.cust_last_name
    order by c.cust_first_name, c.cust_last_name;