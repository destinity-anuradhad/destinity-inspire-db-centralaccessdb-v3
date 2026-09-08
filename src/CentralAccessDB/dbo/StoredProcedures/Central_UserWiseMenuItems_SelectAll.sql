-- =============================================
-- Author:		Chamathka Sooriyapala
-- Create date: 2020-11-12
-- Description:	Select use wise menu 
-- =============================================
-- Central_UserWiseMenuItems_SelectAll 1,6
CREATE PROCEDURE [dbo].[Central_UserWiseMenuItems_SelectAll]
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

		SELECT LVL1.*,
		(
			SELECT 
			Id, 
			Name, 
			URL, 
			IsActive 
			FROM Admin_Nav_MainNavigationWiseAreas LVL2 
			WHERE LVL2.MainNavigationId = LVL1.Id
			AND ModuleId = @ModuleId
			AND IsActive = 1
			FOR JSON AUTO
		) AreasString ,
		(
				SELECT  Id, Name, URL, IsActive, AreaId 
				FROM Admin_Nav_AreasWisePages LVL3 			
				WHERE ModuleId = @ModuleId
				AND IsActive = 1
				FOR JSON AUTO
			)AS PagesString	
	FROM Admin_Nav_MainNavigations LVL1
	WHERE ModuleId = @ModuleId

	DROP TABLE #AccessibleMenuItems
END

GO

