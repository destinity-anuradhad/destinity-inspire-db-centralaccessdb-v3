---Report_Parameters_byReportName 'UserWiseRoles'
CREATE PROCEDURE [dbo].[Report_Parameters_byReportId]
	@ReportId INT
AS
BEGIN



	SET NOCOUNT ON;
	
	SELECT *, 
	[ReportName] AS ReportNameWithType
	FROM [dbo].[ReportDetails]
	WHERE ReportId = @ReportId
	
END

GO

