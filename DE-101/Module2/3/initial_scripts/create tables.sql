CREATE SCHEMA stage;
CREATE SCHEMA dm;
SET search_path TO "$user",public,stage,dm;
DROP TABLE IF EXISTS stage.orders;
CREATE TABLE stage.orders(
   Row_ID        INTEGER  NOT NULL PRIMARY KEY 
  ,Order_ID      VARCHAR(14) NOT NULL
  ,Order_Date    DATE  NOT NULL
  ,Ship_Date     DATE  NOT NULL
  ,Ship_Mode     VARCHAR(14) NOT NULL
  ,Customer_ID   VARCHAR(8) NOT NULL
  ,Customer_Name VARCHAR(22) NOT NULL
  ,Segment       VARCHAR(11) NOT NULL
  ,Country       VARCHAR(13) NOT NULL
  ,City          VARCHAR(17) NOT NULL
  ,State         VARCHAR(20) NOT NULL
  ,Postal_Code   INTEGER 
  ,Region        VARCHAR(7) NOT NULL
  ,Product_ID    VARCHAR(15) NOT NULL
  ,Category      VARCHAR(15) NOT NULL
  ,SubCategory   VARCHAR(11) NOT NULL
  ,Product_Name  VARCHAR(127) NOT NULL
  ,Sales         NUMERIC(9,4) NOT NULL
  ,Quantity      INTEGER  NOT NULL
  ,Discount      NUMERIC(4,2) NOT NULL
  ,Profit        NUMERIC(21,16) NOT NULL
);
DROP TABLE IF EXISTS stage.people;
CREATE TABLE stage.people(
   Person VARCHAR(17) NOT NULL PRIMARY KEY
  ,Region VARCHAR(7) NOT NULL
);
DROP TABLE IF EXISTS stage.returns;
CREATE TABLE stage.returns(
   Returned   VARCHAR(3) NOT NULL 
  ,Order_ID   VARCHAR(14) NOT NULL 
);
COPY stage.orders
FROM '/var/lib/postgresql/csv/orders.csv' DELIMITER ',' CSV HEADER;
COPY stage.people
FROM '/var/lib/postgresql/csv/people.csv' DELIMITER ',' CSV HEADER;
COPY stage.returns
FROM '/var/lib/postgresql/csv/returns.csv' DELIMITER ',' CSV HEADER;