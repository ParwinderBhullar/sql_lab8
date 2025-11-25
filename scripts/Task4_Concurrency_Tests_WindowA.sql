BEGIN TRAN;
UPDATE IoT.Device
SET Status = 'MaintA'
WHERE DeviceID = 1;


BEGIN TRAN;
UPDATE IoT.Device
SET Status = 'UpdatingFirmware'
WHERE DeviceID = 1;

WAITFOR DELAY '00:00:20';

EXEC IoT.usp_IngestTelemetry
    @DeviceID = 1,
    @Speed = 25,
    @Cadence = 80,
    @Temperature = 35,
    @BatteryLevel = 70,
    @Latitude = 43.700000,
    @Longitude = -79.400000;

EXEC IoT.usp_IngestTelemetry
    @DeviceID = 1,
    @Speed = 30,
    @Cadence = 90,
    @Temperature = 32,
    @BatteryLevel = 50,
    @Latitude = 43.699500,
    @Longitude = -79.399900;

EXEC IoT.usp_IngestTelemetry
    @DeviceID = 1,
    @Speed = 18,
    @Cadence = 60,
    @Temperature = 28,
    @BatteryLevel = 60,
    @Latitude = 43.700500,
    @Longitude = -79.401000;



SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT TOP 10 * FROM IoT.Telemetry ORDER BY Timestamp DESC;


SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT TOP 10 * FROM IoT.Telemetry ORDER BY Timestamp DESC;

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT TOP 10 * FROM IoT.Telemetry ORDER BY Timestamp DESC;

SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
SELECT TOP 10 * FROM IoT.Telemetry ORDER BY Timestamp DESC;


SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT TOP 10 * FROM IoT.Telemetry ORDER BY Timestamp DESC;

