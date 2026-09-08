
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Reports_AuditTrail_Select]
	@PropertyId INT,
	@FromDate DateTime,
	@ToDate DateTime
AS
BEGIN
    DECLARE @DataBaseName NVARCHAR(250) = 
	(SELECT DataBaseName FROM Central_Properties
	WHERE Id = @PropertyId)


	SELECT DocNo,Username,DatabaseName,TableName,Name As Changes
	FROM [HotelResWeb_AuditTail].[dbo].[AuditTrailMaster] M
	INNER JOIN [HotelResWeb_AuditTail].[dbo].[AuditTrialProcesses] P ON M.Process = P.Code
	WHERE M.DatabaseName = @DataBaseName AND LogDate BETWEEN @FromDate AND @ToDate
END

GO

