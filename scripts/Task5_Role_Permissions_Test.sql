USE master;
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'DeviceAgentLogin')
    CREATE LOGIN DeviceAgentLogin WITH PASSWORD = 'DeviceAgent123!';

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'TelemetryServiceLogin')
    CREATE LOGIN TelemetryServiceLogin WITH PASSWORD = 'Telemetry123!';

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'AnalystLogin')
    CREATE LOGIN AnalystLogin WITH PASSWORD = 'Analyst123!';

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'FieldTechLogin')
    CREATE LOGIN FieldTechLogin WITH PASSWORD = 'FieldTech123!';

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'ComplianceLogin')
    CREATE LOGIN ComplianceLogin WITH PASSWORD = 'Compliance123!';
GO

--------------------


USE AdventureWorks2022;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'DeviceAgentUser')
    CREATE USER DeviceAgentUser FOR LOGIN DeviceAgentLogin;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'TelemetryServiceUser')
    CREATE USER TelemetryServiceUser FOR LOGIN TelemetryServiceLogin;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'AnalystUser')
    CREATE USER AnalystUser FOR LOGIN AnalystLogin;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'FieldTechUser')
    CREATE USER FieldTechUser FOR LOGIN FieldTechLogin;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'ComplianceUser')
    CREATE USER ComplianceUser FOR LOGIN ComplianceLogin;
GO

-------------------------------------

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'DeviceAgent')
    CREATE ROLE DeviceAgent;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'TelemetryService')
    CREATE ROLE TelemetryService;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Analyst')
    CREATE ROLE Analyst;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'FieldTech')
    CREATE ROLE FieldTech;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'ComplianceOfficer')
    CREATE ROLE ComplianceOfficer;
GO


------------------------------------------

ALTER ROLE DeviceAgent ADD MEMBER DeviceAgentUser;
ALTER ROLE TelemetryService ADD MEMBER TelemetryServiceUser;
ALTER ROLE Analyst ADD MEMBER AnalystUser;
ALTER ROLE FieldTech ADD MEMBER FieldTechUser;
ALTER ROLE ComplianceOfficer ADD MEMBER ComplianceUser;
GO



--------------------ASSIGNING PERMISSIONS-----------------------------



---------DEVICE AGENT-----------------
GRANT SELECT, INSERT, UPDATE ON IoT.Device TO DeviceAgent;
DENY INSERT, UPDATE, DELETE ON IoT.Telemetry TO DeviceAgent;
DENY SELECT ON IoT.DeviceOwner TO DeviceAgent;
GO
--------------TelemetryService------------------

GRANT INSERT ON IoT.Telemetry TO TelemetryService;
GRANT INSERT ON IoT.DeviceHealth TO TelemetryService;
GRANT INSERT ON IoT.TelemetryAudit TO TelemetryService;

GRANT UPDATE (LastHeartbeat) ON IoT.Device TO TelemetryService;

DENY SELECT ON IoT.DeviceOwner TO TelemetryService;
GO
----------------Analyst----------------------

GRANT SELECT ON IoT.Telemetry TO Analyst;
GRANT SELECT ON IoT.DeviceHealth TO Analyst;

DENY INSERT, UPDATE, DELETE ON SCHEMA::IoT TO Analyst;
GO
------------------FieldTech ----------------------

GRANT INSERT, UPDATE ON IoT.MaintenanceLog TO FieldTech;
DENY SELECT ON IoT.DeviceOwner TO FieldTech;
GO
----------------ComplianceOfficer------------------

GRANT SELECT ON SCHEMA::IoT TO ComplianceOfficer;
DENY INSERT, UPDATE, DELETE ON SCHEMA::IoT TO ComplianceOfficer;
GO

