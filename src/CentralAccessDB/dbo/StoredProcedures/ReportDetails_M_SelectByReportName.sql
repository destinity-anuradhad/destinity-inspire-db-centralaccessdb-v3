CREATE PROCEDURE [dbo].[ReportDetails_M_SelectByReportName]
	@ReportName		NVARCHAR(150)
AS
BEGIN
	SELECT * 
	FROM  [dbo].[ReportDetails] RD
	WHERE RD.ReportName = @ReportName
END

GO

