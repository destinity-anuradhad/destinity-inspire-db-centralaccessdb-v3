--exec Report_RoleWiseSubNavigations_Select 4179,1,1,1040,1
CREATE PROCEDURE [dbo].[Report_RoleWiseSubNavigations_Select]
	@UserId INT,
	@PropertyId INT,
	@ModuleId INT,
	@RoleId INT,
	@MainAreaId INT
AS
BEGIN
	SELECT DISTINCT A.[MenuItemId],B.Name AS PageName,B.AreaId
	INTO #TempAccesGrandedPages
	FROM [dbo].[Central_UserRoleWiseMenuItems] A
	INNER JOIN [dbo].[Admin_Nav_AreasWisePages] B ON B.Id=A.MenuItemId
	WHERE A.[UserRoleId]=@RoleId 
	AND A.[ModuleId]=@ModuleId
	AND B.ModuleId=@ModuleId

	SELECT [Id] AS SubAreaId,[Name] AS SubArea
	FROM [dbo].[Admin_Nav_MainNavigationWiseAreas]
	WHERE Id IN (SELECT AreaId FROM #TempAccesGrandedPages)
	AND ModuleId=@ModuleId
	AND [MainNavigationId]=@MainAreaId

	DROP TABLE #TempAccesGrandedPages
END

GO

