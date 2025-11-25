-- A. IoT.Device
IF OBJECT_ID('IoT.Device','U') IS NOT NULL DROP TABLE IoT.Device;
GO

CREATE TABLE IoT.Device
(
    DeviceID         INT IDENTITY(1,1) CONSTRAINT PK_IoT_Device PRIMARY KEY,
    SerialNumber     NVARCHAR(100) NOT NULL UNIQUE,
    DeviceType       NVARCHAR(50)  NOT NULL,
    FirmwareVersion  NVARCHAR(50)  NULL,
    RegistrationDate DATETIME2(0)  NOT NULL 
        CONSTRAINT DF_IoT_Device_RegistrationDate DEFAULT (SYSDATETIME()),
    LastHeartbeat    DATETIME2(0)  NULL,
    Status           NVARCHAR(20)  NOT NULL
        CONSTRAINT DF_IoT_Device_Status DEFAULT ('Active')
);
GO
