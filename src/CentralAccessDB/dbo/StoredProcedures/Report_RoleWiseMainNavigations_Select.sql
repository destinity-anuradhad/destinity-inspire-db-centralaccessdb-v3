--Report_RoleWiseMainNavigations_Select 4179,1,1,1041
CREATE PROCEDURE [dbo].[Report_RoleWiseMainNavigations_Select]
	@UserId INT,
	@PropertyId INT,
	@ModuleId INT,
	@RoleId INT
AS
BEGIN

	SELECT DISTINCT A.[MenuItemId],B.Name AS PageName,B.AreaId
	INTO #TempAccesGrandedPages
	FROM [dbo].[Central_UserRoleWiseMenuItems] A
	INNER JOIN [dbo].[Admin_Nav_AreasWisePages] B ON B.Id=A.MenuItemId
	WHERE A.[UserRoleId]=@RoleId 
	AND A.[ModuleId]=@ModuleId
	AND B.ModuleId=@ModuleId

	SELECT DISTINCT [MainNavigationId]
	INTO #TempAccessGrandedMainAreas
	FROM [dbo].[Admin_Nav_MainNavigationWiseAreas]
	WHERE Id IN (SELECT AreaId FROM #TempAccesGrandedPages)
	AND ModuleId=@ModuleId

	SELECT [Id] AS MainAreaId,
		   [Name] AS MainArea
	FROM [dbo].[Admin_Nav_MainNavigations]
	WHERE Id IN (SELECT [MainNavigationId] FROM #TempAccessGrandedMainAreas)
	AND ModuleId=@ModuleId

	DROP TABLE #TempAccesGrandedPages
	DROP TABLE #TempAccessGrandedMainAreas

END

GO

