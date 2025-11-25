-- C. IoT.DeviceHealth
IF OBJECT_ID('IoT.DeviceHealth','U') IS NOT NULL DROP TABLE IoT.DeviceHealth;
GO

CREATE TABLE IoT.DeviceHealth
(
    HealthID          BIGINT IDENTITY(1,1) CONSTRAINT PK_IoT_DeviceHealth PRIMARY KEY,
    DeviceID          INT           NOT NULL,
    [Timestamp]       DATETIME2(0)  NOT NULL 
        CONSTRAINT DF_IoT_DeviceHealth_Timestamp DEFAULT (SYSDATETIME()),
    IsHealthy         BIT           NOT NULL,
    TemperatureStatus NVARCHAR(20)  NOT NULL,
    BatteryStatus     NVARCHAR(20)  NOT NULL,
    VibrationStatus   NVARCHAR(20)  NOT NULL,
    CONSTRAINT FK_IoT_DeviceHealth_Device
        FOREIGN KEY (DeviceID) REFERENCES IoT.Device(DeviceID)
);
GO
