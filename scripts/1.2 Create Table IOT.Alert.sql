-- D. IoT.Alert
IF OBJECT_ID('IoT.Alert','U') IS NOT NULL DROP TABLE IoT.Alert;
GO

CREATE TABLE IoT.Alert
(
    AlertID     BIGINT IDENTITY(1,1) CONSTRAINT PK_IoT_Alert PRIMARY KEY,
    DeviceID    INT           NOT NULL,
    [Timestamp] DATETIME2(0)  NOT NULL 
        CONSTRAINT DF_IoT_Alert_Timestamp DEFAULT (SYSDATETIME()),
    AlertType   NVARCHAR(50)  NOT NULL,
    Severity    NVARCHAR(20)  NOT NULL,
    [Description] NVARCHAR(400) NULL,
    CONSTRAINT FK_IoT_Alert_Device
        FOREIGN KEY (DeviceID) REFERENCES IoT.Device(DeviceID)
);
GO
