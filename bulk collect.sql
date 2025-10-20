-- CODE: Using BULK COLLECT

    DECLARE
    CURSOR c1 IS SELECT cust_id, cust_email FROM customers ORDER BY cust_id;
    TYPE r_type IS TABLE OF c1%rowtype;
    r1 r_type := r_type();
    idx PLS_INTEGER := 0;
    BEGIN
    OPEN c1;
    LOOP
    idx:=idx+1;
    r1.extend;
    FETCH c1 INTO r1(idx);
    EXIT WHEN c1%notfound;
    END LOOP;
    CLOSE c1;
    END;
    /
     
    DECLARE
    CURSOR c2 IS SELECT cust_id, cust_email FROM customers ORDER BY cust_id;
    TYPE r_type IS TABLE OF c2%rowtype;
    r1 r_type := r_type();
    BEGIN
    OPEN c2;
    FETCH c2 BULK COLLECT INTO r1;
    CLOSE c2;
    END;
    /
     
    DECLARE
    CURSOR c3 IS SELECT cust_id, cust_email FROM customers ORDER BY cust_id;
    TYPE r_type IS TABLE OF c3%rowtype;
    r1 r_type := r_type();
    BEGIN
    OPEN c3;
    FETCH c3 BULK COLLECT INTO r1 LIMIT 100;
    CLOSE c3;
    END;
    /
     
    DECLARE
    CURSOR c4 IS SELECT cust_id, cust_email FROM customers ORDER BY cust_id;
    TYPE r_type IS TABLE OF c4%rowtype;
    r1 r_type := r_type();
    BEGIN
    OPEN c4;
    LOOP
    FETCH c4 BULK COLLECT INTO r1 LIMIT 100;
    EXIT WHEN c4%notfound;
    END LOOP;
    CLOSE c4;
    END;
    /
     
    DECLARE
    CURSOR c5 IS SELECT cust_id, cust_email FROM customers ORDER BY cust_id;
    TYPE r_type IS TABLE OF c5%rowtype;
    r1 r_type := r_type();
    BEGIN
    OPEN c5;
    LOOP
    FETCH c5 BULK COLLECT INTO r1 LIMIT 1000;
    EXIT WHEN c5%notfound;
    END LOOP;
    CLOSE c5;
    END;
    /
     
    DECLARE
    CURSOR c6 IS SELECT cust_id, cust_email FROM customers ORDER BY cust_id;
    TYPE r_type IS TABLE OF c6%rowtype;
    r1 r_type := r_type();
    BEGIN
    OPEN c6;
    LOOP
    FETCH c6 BULK COLLECT INTO r1 LIMIT 100000;
    EXIT WHEN c6%notfound;
    END LOOP;
    CLOSE c6;
    END;
    /
     
    DECLARE
    TYPE r_type IS TABLE OF varchar2(100) index by pls_integer;
    r1 r_type;
    BEGIN
    FOR r2 IN (SELECT cust_id, cust_email FROM customers ORDER BY cust_id) LOOP
    r1(r2.cust_id) := r2.cust_email;
    END LOOP;
    END;
    /