    select distinct prod_id, cust_id from sales;
     
    select distinct prod_id, cust_id from sales order by prod_id;
     
    select prod_id, cust_id, sum(amount_sold) from sales
    group by prod_id,cust_id;
     
    select prod_id, cust_id, sum(amount_sold) from sales
    group by prod_id,cust_id
    order by prod_id;
     
    select prod_id, cust_first_name, amount_sold from sales, customers