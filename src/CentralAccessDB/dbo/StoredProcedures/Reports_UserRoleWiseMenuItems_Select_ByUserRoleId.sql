
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--[dbo].[Reports_UserRoles_Select_ByUserId]1
CREATE PROCEDURE [dbo].[Reports_UserRoleWiseMenuItems_Select_ByUserRoleId]
	@UserRoleId INT,
	@ModuleId INT
AS
BEGIN
	SELECT Name As MenuItemName,MenuItemId FROM Central_UserRoleWiseMenuItems UM
	INNER JOIN Admin_Nav_AreasWisePages M ON UM.MenuItemId = M.Id
	WHERE UM.UserRoleId = @UserRoleId AND UM.ModuleId = @ModuleId
END

GO

