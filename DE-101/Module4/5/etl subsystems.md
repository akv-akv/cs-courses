# Kimball's ETL Subsystems in Pentaho DI


Ralph Kimball defines 34 ETL subsystems divided into 4 key categories:
- [Extracting: Getting data into the data warehouse](#extracting-getting-data-into-the-data-warehouse)
- [Cleansing and conforming data](#cleansing-and-conforming-data)
- [Delivering: Prepare for presentation](#delivering-prepare-for-presentation)
- [Managing the ETL environment](#managing-the-etl-environment)

The purpose of this research is to find functions in Pentaho DI that allow to implement these subsystems. 

## Extracting: Getting data into the data warehouse

### Data Profiling (subsystem 1) 


### Change Data Capture (subsystem 2)


### Extract System (subsystem 3)

Pentaho DI provides plenty of tools that help user to connect to various sources and get data out of them. 


## Cleansing and conforming data

### Data Cleansing System (subsystem 4)

### Error Event Tracking (subsystem 5)
### Audit Dimension Creation (subsystem 6) 
### Deduplication (subsystem 7)
### Data Conformance (subsystem 8) 


## Delivering: Prepare for presentation

### Slowly Changing Dimension (SCD) Manager (subsystem 9)

### Surrogate Key Generator (subsystem 10)

### Hierarchy Manager (subsystem 11)

### Special Dimensions Manager (subsystem 12)

### Fact Table Builders (subsystem 13)

### Surrogate Key Pipeline (subsystem 14)

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
### Lineage and Dependency (subsystem 29) 
### Problem Escalation (subsystem 30) 
### Paralleling and Pipelining (subsystem 31) 
### Security (subsystem 32) 
### Compliance Manager (subsystem 33)
### Metadata Repository (subsystem 34)