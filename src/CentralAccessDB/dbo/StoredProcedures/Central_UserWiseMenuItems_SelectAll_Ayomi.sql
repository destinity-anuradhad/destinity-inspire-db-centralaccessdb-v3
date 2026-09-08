-- =============================================
-- Author:		Chamathka Sooriyapala
-- Create date: 2020-11-12
-- Description:	Select use wise menu 
-- =============================================
-- Central_UserWiseMenuItems_SelectAll 1,6
Create PROCEDURE [dbo].[Central_UserWiseMenuItems_SelectAll_Ayomi]
	@UserId		INT,
	@ModuleId	INT = -1
AS
BEGIN
	
	SELECT X.*
	INTO #AccessibleMenuItems
	FROM 
	(
		SELECT B.MenuItemId
		FROM Central_UserWiseUserRoles A
		INNER JOIN Central_UserRoleWiseMenuItems B ON DBO.GetEncryption(A.UserRoleId, @UserId) = DBO.GetEncryption(A.UserRoleId, @UserId)
		WHERE UserId = @UserId
		UNION
		SELECT A.MenuItemId 
		FROM [dbo].[Central_UserWiseIndividualMenuItems] A
		WHERE DBO.GetEncryption(A.MenuItemId, @UserId)  = A.EncryptedMenuItemId
	) AS X

	--Modified by Ayomi 09-02-2021
	SELECT DISTINCT * 
	INTO #Admin_Nav_AreasWisePages
	FROM Admin_Nav_AreasWisePages LVL3
	WHERE LVL3.IsMainMenuNavigation = 1

	--SELECT B.* FROM
	--(
		SELECT [Id], [Name], [Description], [Url], [DisplayOrder], [IsActive], [TemplateId], [ModuleId], [IsMainMenuNavigation],
		(
			SELECT 	[Id], [MainNavigationId], [Name], [Description], [Url], [ImageUrl], [DisplayOrder], [IsActive], [IsMainMenuNavigation], [ModuleId],
			(
				SELECT [Id], [RootPageId], [AreaId], [Name], [Url], [Icon], [ImageURL], [DispayOrder], [IsActive], [ModuleId], [IsMainMenuNavigation]
				FROM #Admin_Nav_AreasWisePages LVL3
				WHERE 
				[AreaId] = LVL2.Id
				AND IsActive = 1
				AND ModuleId = @ModuleId
				FOR JSON AUTO
			) AS 'PagesString'
			FROM [dbo].[Admin_Nav_MainNavigationWiseAreas] LVL2
			WHERE MainNavigationId = LVL1.Id
			AND ISNULL(LVL2.IsActive,0) = 1
			AND ISNULL(LVL2.IsMainMenuNavigation,0) = 1
			AND ModuleId = @ModuleId
			FOR JSON AUTO
		) AS 'AreasString'
		FROM 
		[dbo].[Admin_Nav_MainNavigations] LVL1
		WHERE ISNULL(LVL1.IsActive,0) = 1
		AND ModuleId = @ModuleId		
	--) AS x
	
	
	--Modified by Ayomi 09-02-2021
	
	--SELECT LVL1.*,
	--	(
	--		SELECT 
	--		Id, 
	--		Name, 
	--		URL, 
	--		IsActive 
	--		FROM Admin_Nav_MainNavigationWiseAreas LVL2 
	--		WHERE LVL2.MainNavigationId = LVL1.Id
	--		AND ModuleId = @ModuleId
	--		AND IsActive = 1
	--		FOR JSON AUTO
	--	) AreasString ,
	--	(
	--		SELECT  Id, Name, URL, IsActive, AreaId 
	--		FROM Admin_Nav_AreasWisePages LVL3 					
	--		WHERE 

	--		AND ModuleId = @ModuleId
	--		AND IsActive = 1
	--		FOR JSON AUTO
	--	)AS PagesString	
	--FROM Admin_Nav_MainNavigations LVL1
	--WHERE 
	--ModuleId = @ModuleId

	DROP TABLE #Admin_Nav_AreasWisePages
	DROP TABLE #AccessibleMenuItems
END

GO

