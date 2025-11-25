IF OBJECT_ID('IoT.usp_IngestTelemetry','P') IS NOT NULL
    DROP PROCEDURE IoT.usp_IngestTelemetry;
GO

CREATE PROCEDURE IoT.usp_IngestTelemetry
    @DeviceID     INT,
    @Speed        DECIMAL(6,2),
    @Cadence      INT,
    @Temperature  DECIMAL(5,2),
    @BatteryLevel TINYINT,
    @Latitude     DECIMAL(9,6),
    @Longitude    DECIMAL(9,6)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @StartTime          DATETIME2(3) = SYSDATETIME(),
        @ErrorStep          NVARCHAR(100) = 'Start',
        @ErrorMessage       NVARCHAR(4000),
        @RecordsInserted    INT = 0,
        @AlertCount         INT = 0,
        @TemperatureStatus  NVARCHAR(20),
        @BatteryStatus      NVARCHAR(20),
        @VibrationStatus    NVARCHAR(20),
        @IsHealthy          BIT,
        @RawPayload         NVARCHAR(MAX);

    -- Simple raw payload string for logging
    SET @RawPayload = CONCAT(
        'DeviceID=', ISNULL(CONVERT(VARCHAR(20),@DeviceID),'NULL'),
        ';Speed=', ISNULL(CONVERT(VARCHAR(20),@Speed),'NULL'),
        ';Cadence=', ISNULL(CONVERT(VARCHAR(20),@Cadence),'NULL'),
        ';Temperature=', ISNULL(CONVERT(VARCHAR(20),@Temperature),'NULL'),
        ';Battery=', ISNULL(CONVERT(VARCHAR(20),@BatteryLevel),'NULL'),
        ';Lat=', ISNULL(CONVERT(VARCHAR(30),@Latitude),'NULL'),
        ';Lon=', ISNULL(CONVERT(VARCHAR(30),@Longitude),'NULL')
    );

    BEGIN TRY
        BEGIN TRAN;

        -------------------------------------------------------------------
        -- 1. Validation
        -------------------------------------------------------------------
        SET @ErrorStep = 'Validate Device Registration';

        IF NOT EXISTS (SELECT 1 FROM IoT.Device WHERE DeviceID = @DeviceID)
            THROW 51000, 'DeviceID not registered in IoT.Device.', 1;

        SET @ErrorStep = 'Validate Temperature Range';
        -- Example sensor range: -40 to 100 degrees
        IF @Temperature IS NULL OR @Temperature < -40 OR @Temperature > 100
            THROW 51001, 'Temperature reading outside acceptable sensor range.', 1;

        SET @ErrorStep = 'Validate Battery Level';
        IF @BatteryLevel IS NULL OR @BatteryLevel < 0 OR @BatteryLevel > 100
            THROW 51002, 'Battery level must be between 0 and 100.', 1;

        SET @ErrorStep = 'Validate Coordinates';
        IF @Latitude IS NULL OR @Longitude IS NULL
            THROW 51003, 'Latitude or Longitude cannot be NULL.', 1;

        -- We still allow "invalid" coordinates but will raise an alert for them
        -------------------------------------------------------------------
        -- 2. Insert Telemetry
        -------------------------------------------------------------------
        SET @ErrorStep = 'Insert Telemetry';

        INSERT INTO IoT.Telemetry
        (
            DeviceID, [Timestamp], Speed, Cadence, Temperature, BatteryLevel,
            GPSLatitude, GPSLongitude
        )
        VALUES
        (
            @DeviceID, SYSDATETIME(), @Speed, @Cadence, @Temperature, @BatteryLevel,
            @Latitude, @Longitude
        );

        SET @RecordsInserted += 1;

        -------------------------------------------------------------------
        -- 3. Update Device LastHeartbeat
        -------------------------------------------------------------------
        SET @ErrorStep = 'Update IoT.Device LastHeartbeat';

        UPDATE IoT.Device
        SET LastHeartbeat = SYSDATETIME()
        WHERE DeviceID = @DeviceID;

        -------------------------------------------------------------------
        -- 4. Insert into DeviceHealth
        -------------------------------------------------------------------
        SET @ErrorStep = 'Calculate Device Health';

        SET @TemperatureStatus = 
            CASE 
                WHEN @Temperature > 80 THEN 'High'
                WHEN @Temperature < 0 THEN 'Low'
                ELSE 'Normal'
            END;

        SET @BatteryStatus =
            CASE 
                WHEN @BatteryLevel < 20 THEN 'Low'
                ELSE 'Normal'
            END;

        SET @VibrationStatus = 'Normal'; -- as per lab

        SET @IsHealthy = CASE 
                            WHEN @TemperatureStatus = 'Normal'
                             AND @BatteryStatus = 'Normal'
                             AND @VibrationStatus = 'Normal'
                            THEN 1 ELSE 0 END;

        INSERT INTO IoT.DeviceHealth
        (
            DeviceID, [Timestamp], IsHealthy,
            TemperatureStatus, BatteryStatus, VibrationStatus
        )
        VALUES
        (
            @DeviceID, SYSDATETIME(), @IsHealthy,
            @TemperatureStatus, @BatteryStatus, @VibrationStatus
        );

        SET @RecordsInserted += 1;

        -------------------------------------------------------------------
        -- 5. Generate Alerts
        -------------------------------------------------------------------
        SET @ErrorStep = 'Generate Alerts';

        -- Low battery
        IF @BatteryLevel < 20
        BEGIN
            INSERT INTO IoT.Alert (DeviceID, [Timestamp], AlertType, Severity, [Description])
            VALUES (@DeviceID, SYSDATETIME(), 'LowBattery', 'Medium', 'Battery level below 20%.');
            SET @AlertCount += 1;
            SET @RecordsInserted += 1;
        END

        -- High temperature
        IF @Temperature > 80
        BEGIN
            INSERT INTO IoT.Alert (DeviceID, [Timestamp], AlertType, Severity, [Description])
            VALUES (@DeviceID, SYSDATETIME(), 'HighTemperature', 'High', 'Temperature exceeds 80 degrees.');
            SET @AlertCount += 1;
            SET @RecordsInserted += 1;
        END

        -- Invalid coordinates (out of geo range)
        IF (@Latitude < -90 OR @Latitude > 90) 
           OR (@Longitude < -180 OR @Longitude > 180)
        BEGIN
            INSERT INTO IoT.Alert (DeviceID, [Timestamp], AlertType, Severity, [Description])
            VALUES (@DeviceID, SYSDATETIME(), 'InvalidCoordinates', 'Low', 'Latitude/Longitude outside valid range.');
            SET @AlertCount += 1;
            SET @RecordsInserted += 1;
        END

        -------------------------------------------------------------------
        -- 6. Insert TelemetryAudit
        -------------------------------------------------------------------
        SET @ErrorStep = 'Insert TelemetryAudit';

        INSERT INTO IoT.TelemetryAudit
        (
            DeviceID, [Timestamp], ProcessingDurationMs, RecordsInserted, [Status]
        )
        VALUES
        (
            @DeviceID,
            SYSDATETIME(),
            DATEDIFF(MILLISECOND, @StartTime, SYSDATETIME()),
            @RecordsInserted,
            'Success'
        );

        SET @RecordsInserted += 1;

        -------------------------------------------------------------------
        -- 7. Commit
        -------------------------------------------------------------------
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRAN;

        SET @ErrorMessage = ERROR_MESSAGE();

        -- Write to TelemetryErrorLog
        INSERT INTO IoT.TelemetryErrorLog
        (
            DeviceID, [Timestamp], ErrorMessage, ErrorStep, RawPayload
        )
        VALUES
        (
            @DeviceID, SYSDATETIME(), @ErrorMessage, @ErrorStep, @RawPayload
        );

        -- Re-throw for caller if needed
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO
