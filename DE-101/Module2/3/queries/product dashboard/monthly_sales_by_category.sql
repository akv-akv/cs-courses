SELECT    category
        , to_char(order_date, 'YYYY-MM') as month  
        , ROUND(SUM(Sales),2) as sales
    FROM orders
    GROUP BY to_char(order_date, 'YYYY-MM'), category
    ORDER BY category, to_char(order_date, 'YYYY-MM');