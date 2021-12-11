SELECT o.region, p.person, SUM(sales) as sales
    FROM orders o
    JOIN people p
        ON o.region = p.region
    GROUP BY o.region, p.person
    ORDER BY o.region, p.person