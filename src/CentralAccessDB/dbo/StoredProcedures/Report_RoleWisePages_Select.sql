---Report_RoleWisePages_Select 4179,1,1,1040,10,2
CREATE PROCEDURE [dbo].[Report_RoleWisePages_Select]
	@UserId INT,
	@PropertyId INT,
	@ModuleId INT,
	@RoleId INT,
	@MainAreaId INT,
	@SubAreaId INT
AS
BEGIN
	SELECT DISTINCT A.[MenuItemId],B.Name AS PageName,B.AreaId
	INTO #TempAccesGrandedPages
	FROM [dbo].[Central_UserRoleWiseMenuItems] A
	INNER JOIN [dbo].[Admin_Nav_AreasWisePages] B ON B.Id=A.MenuItemId
	WHERE A.[UserRoleId]=@RoleId 
	AND A.[ModuleId]=@ModuleId
	AND B.ModuleId=@ModuleId

	SELECT [MenuItemId] AS PageId,
		   PageName
	FROM #TempAccesGrandedPages
	WHERE AreaId=@SubAreaId

	DROP TABLE #TempAccesGrandedPages
END

GO

