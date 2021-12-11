# Homework 2

## 2.3 - SQL queries

1. Save initial excel file to csv
```
python save_to_csv.py
```

2. Initialize database and insert tables into it
```
docker-compose up -d
```
This command will run PostgreSQL database and fill it with data from csv files created in step 1.

3. Run queries
Queries are located in ["queries"](./3/queries/) folder  that is linked to the postgres docker container.

Run pgcli from command line:            
```
pgcli -h localhost -U postgres
```
To get query results run from pgcli:
```
\i queries/total_sales.sql
```

## 2.4 - Data modelling

### Task
Design Dimensional Model for initial [Superstore Excel File](./3/initial_data/Sample%20-%20Superstore.xls):

### Solution
- Conceptual model
  
  ![](./2.4/conceptual_model.png)
- Logical model
  
  ![](./2.4/logic_model.png)
- Physical model
  
  ![](./2.4/physical_model.png)

## 2.6 - Dashboarding