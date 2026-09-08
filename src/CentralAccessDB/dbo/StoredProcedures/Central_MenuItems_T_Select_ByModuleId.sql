-- =============================================
-- Author		:	Ayomi Gunasekara
-- Create date	:	2020-11-11
-- Description	:	Central_Properties_T_Select_ByUserId
-- =============================================
--[dbo].[Central_MenuItems_T_Select_ByModuleId]1,34,2
CREATE PROCEDURE [dbo].[Central_MenuItems_T_Select_ByModuleId]--1,21,1
	@ModuleId INT,
	@UserId INT,
	@PropertyId INT
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT DISTINCT CM.*
	FROM Central_MenuItems CM 
	INNER JOIN Central_UserRoleWiseMenuItems URWM ON CM.MenuItemId = URWM.MenuItemId
	INNER JOIN Central_UserWiseModules UM ON URWM.ModuleId = UM.ModuleId
	INNER JOIN Central_UserWiseUserRoles UUR ON URWM.UserRoleId = UUR.UserRoleId
	INNER JOIN Central_UserWiseProperties UP ON UM.UserId = UP.UserId
	INNER JOIN Central_UserRoleWiseMenuItems URM ON UM.ModuleId = URM.ModuleId
	WHERE UM.ModuleId = @ModuleId AND UUR.UserId = @UserId AND UP.PropertyId = @PropertyId AND CM.ModuleId=@ModuleId

	UNION 

	SELECT DISTINCT CM.*
	FROM Central_MenuItems CM 
	INNER JOIN Central_UserWiseIndividualMenuItems URWM ON CM.MenuItemId = URWM.MenuItemId
	INNER JOIN Central_UserWiseModules UM ON URWM.ModuleId = UM.ModuleId
	INNER JOIN Central_UserWiseUserRoles UUR ON URWM.UserId = UUR.UserId
	INNER JOIN Central_UserWiseProperties UP ON UM.UserId = UP.UserId
	INNER JOIN Central_UserWiseIndividualMenuItems URM ON UM.ModuleId = URM.ModuleId
	WHERE UM.ModuleId = @ModuleId AND UUR.UserId = @UserId AND UP.PropertyId = @PropertyId AND CM.ModuleId=@ModuleId

END

GO

