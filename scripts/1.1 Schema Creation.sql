USE AdventureWorks2022;
GO

-- Create schema only if it does NOT already exist
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'IoT')
BEGIN
    EXEC('CREATE SCHEMA IoT AUTHORIZATION dbo;');
END
GO