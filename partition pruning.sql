-- CODE: Partition Pruning

    create table sales_temp as select * from sales;
     
    select sum(amount_sold) from sales_temp where time_id between '01-JAN-01' and '31-DEC-03';
     
    select sum(amount_sold) from sales where time_id between '01-JAN-01' and '31-DEC-03';
     
    drop table sales_temp;