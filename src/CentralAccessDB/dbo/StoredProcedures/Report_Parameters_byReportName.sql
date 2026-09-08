---Report_Parameters_byReportName 'UserWiseRoles'
CREATE PROCEDURE [dbo].[Report_Parameters_byReportName]
	@reportName VARCHAR(200) 
AS
BEGIN



	SET NOCOUNT ON;
	
	SELECT *, 
	[ReportName] AS ReportNameWithType
	FROM [dbo].[ReportDetails]
	WHERE ReportName = @reportName
	
END

GO

