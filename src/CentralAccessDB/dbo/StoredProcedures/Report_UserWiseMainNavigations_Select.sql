---exec [Report_UserWiseMainNavigations_Select] 4248,17,1
CREATE PROCEDURE [dbo].[Report_UserWiseMainNavigations_Select]
	@UserId INT,
	@PropertyId INT,
	@ModuleId INT
AS
BEGIN
	SELECT DISTINCT  A.[MenuItemId]
					,B.Name AS PageName
					,B.AreaId
	INTO #TempAccesGrandedPages
	FROM [Central_UserWiseIndividualMenuItems] A
	INNER JOIN [dbo].[Admin_Nav_AreasWisePages] B ON B.Id=A.MenuItemId
	WHERE A.UserId=@UserId 
	AND A.[ModuleId]=@ModuleId
	AND A.PropertyId=@PropertyId
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

---select * from [dbo].[Central_UserRoleWiseMenuItems]
---select * from [dbo].[Central_UserWiseIndividualMenuItems]

GO

