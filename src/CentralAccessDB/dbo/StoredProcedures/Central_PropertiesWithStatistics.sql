--EXEC Central_PropertiesWithStatistics 1
CREATE PROCEDURE [dbo].[Central_PropertiesWithStatistics]
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;

    CREATE TABLE #DashboardFiguresResult
    (
        PropertyId INT,
        InHouseReservations INT,
        toBeCheckInToday INT,
        TobeCheckOutToday INT,
        Occupancy DECIMAL(18,2),
        hotelDate NVARCHAR(20),
        ExpectedArrivals DECIMAL(18,2),
        ExpectedDeparture DECIMAL(18,2),
        OOORooms DECIMAL(18,2),
        GuestPortal_StayChangeRequest INT,
        GuestPortal_Preferences INT
    );

    DECLARE @FinalSelect TABLE
    (
        Id INT,
        Rooms INT,
        Occupancy DECIMAL(18,2),
        Arrivals INT,
        hotelDate NVARCHAR(20)
    );

    DECLARE @PropertyId INT;

    DECLARE PropertyCursor CURSOR LOCAL FAST_FORWARD FOR
        SELECT CC.Id
        FROM [dbo].[Central_Properties] CC
        LEFT JOIN [dbo].[Central_UserWiseProperties] CUWP 
            ON CC.Id = CUWP.PropertyId
        WHERE CUWP.UserId = @UserId;

    OPEN PropertyCursor;

    FETCH NEXT FROM PropertyCursor INTO @PropertyId;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC [HotelResWeb]..[DashboardFigures_SelectForDisplay] @PropertyId;

        INSERT INTO @FinalSelect
        (
            Id,
            Rooms,
            Occupancy,
            Arrivals,
            hotelDate
        )
        SELECT
            @PropertyId,
            ISNULL((
                SELECT COUNT(RD.Id)
                FROM [HotelResWeb]..[RoomDetails] RD WITH (NOLOCK)
                WHERE RD.PropertyId = @PropertyId
                  AND RD.ConciderForOccupancy = 1
                  AND RD.ISACtive = 1
            ), 0),
            ISNULL(DF.Occupancy, 0),
            ISNULL(CAST(DF.ExpectedArrivals AS INT), 0),
            DF.hotelDate
        FROM #DashboardFiguresResult DF
        WHERE DF.PropertyId = @PropertyId;

        FETCH NEXT FROM PropertyCursor INTO @PropertyId;
    END;

    CLOSE PropertyCursor;
    DEALLOCATE PropertyCursor;

    SELECT 
	Id,
            Rooms,
            Occupancy,
            Arrivals,
            CONVERT(DATE, hotelDate, 103) hotelDate
    FROM @FinalSelect;

    DROP TABLE #DashboardFiguresResult;
END

GO

