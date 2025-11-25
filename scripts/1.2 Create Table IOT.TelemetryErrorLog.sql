-- E. IoT.TelemetryErrorLog
IF OBJECT_ID('IoT.TelemetryErrorLog','U') IS NOT NULL DROP TABLE IoT.TelemetryErrorLog;
GO

CREATE TABLE IoT.TelemetryErrorLog
(
    ErrorID      BIGINT IDENTITY(1,1) CONSTRAINT PK_IoT_TelemetryErrorLog PRIMARY KEY,
    DeviceID     INT           NULL,
    [Timestamp]  DATETIME2(0)  NOT NULL 
        CONSTRAINT DF_IoT_TelemetryErrorLog_Timestamp DEFAULT (SYSDATETIME()),
    ErrorMessage NVARCHAR(4000) NOT NULL,
    ErrorStep    NVARCHAR(100)  NULL,
    RawPayload   NVARCHAR(MAX)  NULL
);
GO
