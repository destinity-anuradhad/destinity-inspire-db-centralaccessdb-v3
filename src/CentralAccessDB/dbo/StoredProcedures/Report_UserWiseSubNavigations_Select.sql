--exec [Report_UserWiseSubNavigations_Select] 4248,17,1,1
CREATE PROCEDURE [dbo].[Report_UserWiseSubNavigations_Select]
	@UserId INT,
	@PropertyId INT,
	@ModuleId INT,
	@MainAreaId INT
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

	SELECT [Id] AS SubAreaId,[Name] AS SubArea
	FROM [dbo].[Admin_Nav_MainNavigationWiseAreas]
	WHERE Id IN (SELECT AreaId FROM #TempAccesGrandedPages)
	AND ModuleId=@ModuleId
	AND [MainNavigationId]=@MainAreaId

	DROP TABLE #TempAccesGrandedPages
END

GO

