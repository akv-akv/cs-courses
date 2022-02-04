# Kimball's ETL Subsystems in Pentaho DI


Ralph Kimball defines 34 ETL subsystems divided into 4 key categories:
- [Extracting: Getting data into the data warehouse](#extracting-getting-data-into-the-data-warehouse)
- [Cleansing and conforming data](#cleansing-and-conforming-data)
- [Delivering: Prepare for presentation](#delivering-prepare-for-presentation)
- [Managing the ETL environment](#managing-the-etl-environment)

The purpose of this research is to find functions in Pentaho DI that allow to implement these subsystems. 

## Extracting: Getting data into the data warehouse


### Extract System (subsystem 3)

Pentaho DI provides plenty of tools that help user to connect to various all popular data sources including Excel, JSON, Zipped files, TXT files, many flavours of databases and even cloud storage. Here are some of them:

- Text file input
- JSON input
- Microsoft Excel input
- Table input
- MongoDB input
- Parquet input

## Cleansing and conforming data

### Data Cleansing System (subsystem 4)

### Error Event Tracking (subsystem 5)

There is out of the box logging and error handling functionality.

<img src="./images/5_errors.png" width="500">

### Deduplication (subsystem 7)

The purpose of this system is to eliminate redundant rows from the data. 
    
<img src="./images/7_deduplication.png" width="800">


## Delivering: Prepare for presentation

### Slowly Changing Dimension (SCD) Manager (subsystem 9)

SCD of various types could be implemented with Dimension lookup/update tool.

<img src="./images/9_dim_lookup.png" width="600">

### Surrogate Key Generator (subsystem 10)

Surrogate keys could be generated using “Dimension lookup / update” and “Combination lookup / update”

<img src="./images/10_surrogate_key_gen.png" width="600">

### Fact Table Builders (subsystem 13)

### Surrogate Key Pipeline (subsystem 14)

<img src="./images/14_surrogate_key_pipeline.png" width="800">

### Multi-Valued Bridge Table Builder (subsystem 15)

### Late Arriving Data Handler (subsystem 16)

### Dimension Manager (subsystem 17)

### Fact Table Provider (subsystem 18)

### Aggregate Builder (subsystem 19)

### OLAP Cube Builder (subsystem 20)

### Data Propagation Manager (subsystem 21)


## Managing the ETL environment

### Job Scheduler (subsystem 22) 
### Backup System (subsystem 23) 
### Recovery and Restart (subsystem 24) 
### Version Control (subsystem 25)
### Version Migration (subsystem 26) 
### Workflow Monitor (subsystem 27) 
### Sorting (subsystem 28)

<img src="./images/28_sorting.png" width="800">

### Lineage and Dependency (subsystem 29) 
### Problem Escalation (subsystem 30) 
### Paralleling and Pipelining (subsystem 31) 
### Security (subsystem 32) 
### Compliance Manager (subsystem 33)
### Metadata Repository (subsystem 34)