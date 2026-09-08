--exec [Report_UserWisePages_Select] 4248,17,1,1,1
CREATE PROCEDURE [dbo].[Report_UserWisePages_Select]
	@UserId INT,
	@PropertyId INT,
	@ModuleId INT,
	@MainAreaId INT,
	@SubAreaId INT
AS
BEGIN
	SELECT DISTINCT A.[MenuItemId],B.Name AS PageName,B.AreaId
	INTO #TempAccesGrandedPages
	FROM [Central_UserWiseIndividualMenuItems] A
	INNER JOIN [dbo].[Admin_Nav_AreasWisePages] B ON B.Id=A.MenuItemId
	WHERE A.UserId=@UserId 
	AND A.[ModuleId]=@ModuleId
	AND A.PropertyId=@PropertyId
	AND B.ModuleId=@ModuleId

	SELECT [MenuItemId] AS PageId,
		   PageName
	FROM #TempAccesGrandedPages
	WHERE AreaId=@SubAreaId

	DROP TABLE #TempAccesGrandedPages
END

GO

