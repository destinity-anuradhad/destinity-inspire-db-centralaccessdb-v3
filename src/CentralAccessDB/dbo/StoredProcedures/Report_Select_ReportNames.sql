CREATE PROCEDURE [dbo].[Report_Select_ReportNames]
	
AS
BEGIN	
	SET NOCOUNT ON;
	SELECT ReportId,ReportName,ReportName AS ReportNameWithType,DisplayName,ReportCategory,IsPrintCopy
	FROM ReportDetails
	WHERE Active = 1
	ORDER BY ReportId ASC
END

GO

