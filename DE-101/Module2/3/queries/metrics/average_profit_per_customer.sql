WITH cte AS
    (
        SELECT SUM(Profit) as ProfitPerCustomer
            FROM orders
            GROUP BY customer_id
    )
SELECT AVG(ProfitPerCustomer) as ProfitPerCutomer
    FROM cte;
