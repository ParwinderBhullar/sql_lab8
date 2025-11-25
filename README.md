# Lab 8 – IoT Operations Platform  
SQL Development – AdventureWorks2022  
Author: Parwinder Singh

## 1. Overview
This lab implements a complete IoT Operations Platform using SQL Server 2022.  
The project includes transactional telemetry ingestion, concurrency testing, and  
a full role-based access control model.

## 2. Contents
- **/scripts** – All SQL files (schema, tables, stored procedures, roles, tests)  
- **/screenshots** – Evidence for Tasks 3, 4, 5, and 6  
- **Lab8_IoT_Report.docx** – Technical report  
- **README.md** – Repository documentation

## 3. Completed Tasks
- Created IoT schema and tables  
- Implemented transactional ingestion workflow  
- Demonstrated failure scenarios with rollback  
- Performed concurrency and isolation level tests  
- Designed and validated role-based permissions  

## 4. How to Run
1. Restore `AdventureWorks2022`  
2. Execute scripts in the following order:
   - `01_schema_setup.sql`
   - `02_tables.sql`
   - `03_ingestion_procedure.sql`
   - `04_failure_tests.sql`
   - `05_concurrency_tests.sql`
   - `06_roles_permissions.sql`
   - `07_permission_validation.sql`

## 5. Notes
All screenshots required by the lab are included in the `screenshots` folder.
