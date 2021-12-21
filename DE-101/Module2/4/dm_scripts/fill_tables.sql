/* Fill calendar table with data */
TRUNCATE TABLE dm.dim_dates  CASCADE;
INSERT INTO dm.dim_dates
  (
    pk_id
    , date
    , year
    , quarter
    , month_name
    , month_number
    , week_number
    , weekday_name
    , weekday_number
    , isweekend
  )
SELECT TO_CHAR(dt, 'yyyymmdd')::INT as pk_id
  , dt::DATE as date
  , EXTRACT(YEAR from dt) as year
  , EXTRACT(QUARTER from dt) as quarter
  , TO_CHAR(dt, 'TMMonth') AS month_name
  , EXTRACT(MONTH FROM dt) as month_number
  , EXTRACT(WEEK FROM dt) AS week_number
  , TO_CHAR(dt, 'DY') AS weekday_name
  , EXTRACT(ISODOW FROM dt) AS weekday_number
  , CASE
      WHEN EXTRACT(ISODOW FROM dt) IN (6, 7) 
        THEN 1
      ELSE 0
    END AS isweekend
from generate_series(date '2000-01-01',
                       date '2030-01-01',
                       interval '1 day') as t(dt)
ORDER BY 1;

/* Fill dim_products table */

TRUNCATE TABLE dm.dim_products  CASCADE;
WITH cte AS
  (
    SELECT DISTINCT product_id
        , product_name
        , category
        , subcategory
      FROM stage.orders
  )
INSERT INTO dm.dim_products
  (
    pk_id 
    , pk_bk_id 
    , name 
    , category
    , subcategory
  )
SELECT row_number() OVER (), cte.*
  FROM cte;

/* Fill dim_ship_modes table */
TRUNCATE TABLE dm.dim_ship_modes  CASCADE;
WITH cte AS
  (
    SELECT DISTINCT ship_mode
      FROM stage.orders
  )
INSERT INTO dm.dim_ship_modes
  (
    pk_id
    , name
  )
SELECT ROW_NUMBER() OVER ()
    , ship_mode
  FROM cte;


/* Fill dim_addresses table */
TRUNCATE TABLE dm.dim_addresses  CASCADE;
WITH cte AS
  (
    SELECT DISTINCT 
         postal_code
        , country
        , city
        , state
        , o.region
        , person as manager
      FROM stage.orders o
      LEFT JOIN stage.people p
        ON o.region = p.region

  )
INSERT INTO dm.dim_addresses
  (
    pk_id
    , postal_code
    , country
    , city
    , state
    , region
    , manager
  )
SELECT ROW_NUMBER() OVER ()
    , cte.*
  FROM cte;


/* Fill dim_customers table */
TRUNCATE TABLE dm.dim_customers CASCADE;
WITH cte AS
  (
    SELECT DISTINCT 
         customer_id
        , customer_name
        , segment
      FROM stage.orders o
  )
INSERT INTO dm.dim_customers
  (
    pk_id
    , pk_bk_id
    , name
    , segment
  )
SELECT ROW_NUMBER() OVER ()
    , cte.*
  FROM cte;


/* Fill fact_orders table */
TRUNCATE TABLE dm.fact_orders;
WITH cte AS 
  (
    SELECT 
        o.order_id
        , od.pk_id
        , sd.pk_id
        , sm.pk_id
        , p.pk_id
        , c.pk_id
        , a.pk_id 
        , o.sales
        , o.quantity
        , o.discount
        , o.profit  
        , CASE WHEN r.returned = 'Yes' THEN 1 ELSE 0 END  as isreturned
      FROM stage.orders o
      JOIN dm.dim_dates od
        ON o.order_date = od.date
      JOIN dm.dim_dates sd
        ON o.ship_date = sd.date
      JOIN dm.dim_ship_modes sm
        ON sm.name = o.ship_mode
      JOIN dm.dim_products p
        ON p.pk_bk_id = o.product_id
        AND p.name = o.product_name
        AND p.category = o.category
        AND p.subcategory = o.subcategory
      JOIN dm.dim_customers c
         ON c.pk_bk_id = o.customer_id
      JOIN dm.dim_addresses a
        ON a.postal_code = CAST(o.postal_code as VARCHAR(10))
        AND a.city = o.city
        AND a.country = o.country
        AND a.state = o.STATE
      LEFT JOIN (SELECT DISTINCT * FROM stage.returns) r
        ON o.order_id = r.order_id
  )
INSERT INTO dm.fact_orders
  (
    pk_id 
    , pk_bk_id 
    , fk_order_date_id
    , fk_ship_date_id
    , fk_ship_mode_id
    , fk_product_id 
    , fk_customer_id
    , fk_address_id
    , sales 
    , quantity
    , discount 
    , profit 
    , isreturned
  )
SELECT ROW_NUMBER() OVER ()
    , cte.*
  FROM cte;


