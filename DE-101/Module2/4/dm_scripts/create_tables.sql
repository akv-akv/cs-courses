DROP TABLE IF EXISTS dm.fact_orders;

/* Create calendar table */



DROP TABLE IF EXISTS dm.dim_dates;
CREATE TABLE dm.dim_dates
    (
        pk_id integer
      , date date
      , year integer
      , quarter integer
      , month_name  varchar(20)
      , month_number integer
      , week_number integer 
      , weekday_name  varchar(20)
      , weekday_number integer
      , isweekend smallint
      , CONSTRAINT dim_dates_pk PRIMARY KEY (pk_id)    
    );


/* Create dim_products table*/ 
DROP TABLE IF EXISTS dm.dim_products;
CREATE TABLE dm.dim_products
  (
      pk_id integer
    , pk_bk_id varchar(50)
    , name varchar(255)
    , category varchar(50)
    , subcategory varchar(50)
    , CONSTRAINT dim_products_pk PRIMARY KEY (pk_id) 
  );

/* Create dim_addresses table*/ 
DROP TABLE IF EXISTS dm.dim_addresses;
CREATE TABLE dm.dim_addresses
  (
    pk_id integer
    , postal_code varchar(10)
    , country varchar(50)
    , city varchar(50)
    , state varchar(50)
    , region varchar(50)
    , manager varchar(50)
    , CONSTRAINT dim_addresses_pk PRIMARY KEY (pk_id) 
  );

/* Create dim_ship_modes table*/ 
DROP TABLE IF EXISTS dm.dim_ship_modes;
CREATE TABLE dm.dim_ship_modes
  (
    pk_id integer
    , name varchar(50)
    , CONSTRAINT dim_ship_modes_pk PRIMARY KEY (pk_id)
  );

/* Create dim_customers table*/ 
DROP TABLE IF EXISTS dm.dim_customers;
CREATE TABLE dm.dim_customers
  (
    pk_id integer
    , pk_bk_id varchar(50)
    , name varchar(150)
    , segment varchar(50)
    , CONSTRAINT dim_customers_pk PRIMARY KEY (pk_id)
  );


CREATE TABLE dm.fact_orders
  (
    pk_id INTEGER
    , pk_bk_id varchar(20)
    , fk_order_date_id INTEGER
    , fk_ship_date_id INTEGER
    , fk_ship_mode_id INTEGER
    , fk_product_id INTEGER
    , fk_customer_id INTEGER
    , fk_address_id INTEGER
    , sales NUMERIC(9,4)
    , quantity SMALLINT
    , discount NUMERIC(4,2)
    , profit NUMERIC(9,4)
    , isreturned SMALLINT
    , CONSTRAINT dim_fact_orders_pk PRIMARY KEY (pk_id)
    , CONSTRAINT fk_order_date 
        FOREIGN KEY (fk_order_date_id)
        REFERENCES dm.dim_dates (pk_id)
    , CONSTRAINT fk_ship_date 
        FOREIGN KEY (fk_ship_date_id)
        REFERENCES dm.dim_dates (pk_id)
    , CONSTRAINT fk_ship_mode
        FOREIGN KEY (fk_ship_mode_id)
        REFERENCES dm.dim_ship_modes (pk_id)
    , CONSTRAINT fk_customer
        FOREIGN KEY (fk_customer_id)
        REFERENCES dm.dim_customers (pk_id)
    , CONSTRAINT fk_address
        FOREIGN KEY (fk_address_id)
        REFERENCES dm.dim_addresses (pk_id)
  );