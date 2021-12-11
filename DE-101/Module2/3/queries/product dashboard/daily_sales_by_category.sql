SELECT category
    ,order_date as month  
    , ROUND(SUM(Sales),2) as sales
    FROM orders
    GROUP BY order_date, category
    ORDER BY category, order_date;