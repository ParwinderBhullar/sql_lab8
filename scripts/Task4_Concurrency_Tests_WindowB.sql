UPDATE IoT.Device
SET Status = 'MaintB'
WHERE DeviceID = 1;

EXEC IoT.usp_IngestTelemetry
    @DeviceID = 1,
    @Speed = 22,
    @Cadence = 80,
    @Temperature = 30,
    @BatteryLevel = 75,
    @Latitude = 43.7,
    @Longitude = -79.4;
