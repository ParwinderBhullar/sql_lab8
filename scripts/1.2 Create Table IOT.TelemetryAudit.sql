-- F. IoT.TelemetryAudit
IF OBJECT_ID('IoT.TelemetryAudit','U') IS NOT NULL DROP TABLE IoT.TelemetryAudit;
GO

CREATE TABLE IoT.TelemetryAudit
(
    AuditID            BIGINT IDENTITY(1,1) CONSTRAINT PK_IoT_TelemetryAudit PRIMARY KEY,
    DeviceID           INT           NOT NULL,
    [Timestamp]        DATETIME2(0)  NOT NULL 
        CONSTRAINT DF_IoT_TelemetryAudit_Timestamp DEFAULT (SYSDATETIME()),
    ProcessingDurationMs INT         NULL,
    RecordsInserted    INT           NULL,
    [Status]           NVARCHAR(20)  NOT NULL,
    CONSTRAINT FK_IoT_TelemetryAudit_Device
        FOREIGN KEY (DeviceID) REFERENCES IoT.Device(DeviceID)
);
GO
