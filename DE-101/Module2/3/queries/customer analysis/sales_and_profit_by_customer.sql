SELECT customer_id, customer_name, SUM(sales) as Sales, SUM(profit) as profit
    FROM orders
    GROUP BY customer_id, customer_name
    ORDER BY SUM(profit) DESC