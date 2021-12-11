SELECT CAST(SUM(profit) as FLOAT)/SUM(sales) as ProfitRatio
    FROM orders;