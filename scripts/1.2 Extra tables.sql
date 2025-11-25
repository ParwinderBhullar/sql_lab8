-- Optional support table: IoT.DeviceOwner (customer-linked)
IF OBJECT_ID('IoT.DeviceOwner','U') IS NOT NULL DROP TABLE IoT.DeviceOwner;
GO

CREATE TABLE IoT.DeviceOwner
(
    DeviceID   INT  NOT NULL CONSTRAINT PK_IoT_DeviceOwner PRIMARY KEY,
    CustomerID INT  NOT NULL,
    CreatedAt  DATETIME2(0) NOT NULL 
        CONSTRAINT DF_IoT_DeviceOwner_CreatedAt DEFAULT (SYSDATETIME()),
    CONSTRAINT FK_IoT_DeviceOwner_Device
        FOREIGN KEY (DeviceID) REFERENCES IoT.Device(DeviceID),
    CONSTRAINT FK_IoT_DeviceOwner_Customer
        FOREIGN KEY (CustomerID) REFERENCES Sales.Customer(CustomerID)
);
GO

-- Optional support table: IoT.MaintenanceLog
IF OBJECT_ID('IoT.MaintenanceLog','U') IS NOT NULL DROP TABLE IoT.MaintenanceLog;
GO

CREATE TABLE IoT.MaintenanceLog
(
    MaintenanceID  INT IDENTITY(1,1) CONSTRAINT PK_IoT_MaintenanceLog PRIMARY KEY,
    DeviceID       INT           NOT NULL,
    TechnicianName NVARCHAR(100) NULL,
    [Timestamp]    DATETIME2(0)  NOT NULL 
        CONSTRAINT DF_IoT_MaintenanceLog_Timestamp DEFAULT (SYSDATETIME()),
    Notes          NVARCHAR(1000) NULL,
    CONSTRAINT FK_IoT_MaintenanceLog_Device
        FOREIGN KEY (DeviceID) REFERENCES IoT.Device(DeviceID)
);
GO
