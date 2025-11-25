-- B. IoT.Telemetry
IF OBJECT_ID('IoT.Telemetry','U') IS NOT NULL DROP TABLE IoT.Telemetry;
GO

CREATE TABLE IoT.Telemetry
(
    TelemetryID   BIGINT IDENTITY(1,1) CONSTRAINT PK_IoT_Telemetry PRIMARY KEY,
    DeviceID      INT           NOT NULL,
    [Timestamp]   DATETIME2(0)  NOT NULL 
        CONSTRAINT DF_IoT_Telemetry_Timestamp DEFAULT (SYSDATETIME()),
    Speed         DECIMAL(6,2)  NULL,
    Cadence       INT           NULL,
    Temperature   DECIMAL(5,2)  NULL,
    BatteryLevel  TINYINT       NULL,
    GPSLatitude   DECIMAL(9,6)  NULL,
    GPSLongitude  DECIMAL(9,6)  NULL,
    CONSTRAINT FK_IoT_Telemetry_Device 
        FOREIGN KEY (DeviceID) REFERENCES IoT.Device(DeviceID)
);
GO
