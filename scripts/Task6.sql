--ROLE 1 DeviceAgentUser

--TEST1

EXECUTE AS USER = 'DeviceAgentUser';
UPDATE IoT.Device SET Status = 'Active' WHERE DeviceID = 1;
SELECT SUSER_NAME() AS ServerLogin, USER_NAME() AS DBUser;
REVERT;


--TEST 2 DENIED

EXECUTE AS USER = 'DeviceAgentUser';
INSERT INTO IoT.Telemetry (DeviceID, Speed) VALUES (1, 50);
REVERT;

--ROLE 2 — TelemetryServiceUser

EXECUTE AS USER = 'TelemetryServiceUser';
INSERT INTO IoT.Telemetry (DeviceID, Speed, Temperature)
VALUES (1, 33, 28);
REVERT;


EXECUTE AS USER = 'TelemetryServiceUser';
SELECT * FROM IoT.DeviceOwner;
REVERT;



--ROLE 3 — AnalystUser

EXECUTE AS USER = 'AnalystUser';
SELECT TOP 5 DeviceID, Speed, Temperature FROM IoT.Telemetry;
REVERT;


EXECUTE AS USER = 'AnalystUser';
DELETE FROM IoT.Telemetry WHERE DeviceID = 1;
REVERT;

--ROLE 4 — FieldTechUser

EXECUTE AS USER = 'FieldTechUser';
INSERT INTO IoT.MaintenanceLog (DeviceID, TechnicianName, Notes)
VALUES (1, 'Tech Mike', 'Routine service completed');
REVERT;

EXECUTE AS USER = 'FieldTechUser';
SELECT * FROM IoT.DeviceOwner;
REVERT;



---ROLE 5 — ComplianceUser


EXECUTE AS USER = 'ComplianceUser';
SELECT TOP 10 * FROM IoT.Device;
SELECT TOP 10 * FROM IoT.Telemetry;
REVERT;


EXECUTE AS USER = 'ComplianceUser';
UPDATE IoT.Telemetry SET Speed = 5 WHERE DeviceID = 1;
REVERT;
