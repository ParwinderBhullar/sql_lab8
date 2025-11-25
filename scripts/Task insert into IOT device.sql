INSERT INTO IoT.Device (SerialNumber, DeviceType, FirmwareVersion)
VALUES ('SN-X100', 'SmartBike', '1.0.0');

SELECT * FROM IoT.Device;

EXEC IoT.usp_IngestTelemetry
    @DeviceID = 9999,         -- invalid device
    @Speed = 25,
    @Cadence = 80,
    @Temperature = 25,
    @BatteryLevel = 80,
    @Latitude = 43.700000,
    @Longitude = -79.400000;

SELECT * FROM IoT.Telemetry;
SELECT * FROM IoT.DeviceHealth;
SELECT * FROM IoT.Alert;
SELECT * FROM IoT.TelemetryAudit;



SELECT * FROM IoT.TelemetryErrorLog;



EXEC IoT.usp_IngestTelemetry
    @DeviceID = 1,
    @Speed = 20,
    @Cadence = 70,
    @Temperature = 30,
    @BatteryLevel = 150,
    @Latitude = 43.7,
    @Longitude = -79.4;

SELECT * FROM IoT.Telemetry;
SELECT * FROM IoT.DeviceHealth;
SELECT * FROM IoT.Alert;
SELECT * FROM IoT.TelemetryAudit;

SELECT * FROM IoT.TelemetryErrorLog;


EXEC IoT.usp_IngestTelemetry
    @DeviceID = 1,
    @Speed = 22,
    @Cadence = 85,
    @Temperature = 28,
    @BatteryLevel = 70,
    @Latitude = NULL,
    @Longitude = -79.4;


SELECT * FROM IoT.Telemetry;
SELECT * FROM IoT.DeviceHealth;
SELECT * FROM IoT.Alert;
SELECT * FROM IoT.TelemetryAudit;

SELECT * FROM IoT.TelemetryErrorLog;
