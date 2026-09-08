
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--dbo.[Reports_UserWiseMenuItems_Select_ByUserId]8,1,1,1
CREATE PROCEDURE [dbo].[Reports_UserWiseMenuItems_Select_ByUserId]
	@UserId INT,
	@PropertyId INT,
	@ModuleId INT,
	@TypeId INT
AS
BEGIN

	IF(@TypeId = 1)
	BEGIN
		SELECT DISTINCT URMI.*,CM.Name As MenuItemName,U.UserName As UserName,''As UserRoleName,
		(SELECT Name FROM Central_Properties WHERE Id = @PropertyId)As PropertyName,
		(SELECT Name FROM Central_Modules WHERE Id = @ModuleId)As ModuleName
		FROM Central_UserWiseIndividualMenuItems URMI
		INNER JOIN Admin_Nav_AreasWisePages CM ON URMI.MenuItemId = CM.Id
		INNER JOIN Central_Users U ON URMI.UserId = U.Id
	
		WHERE (URMI.UserId = @UserId) AND (URMI.PropertyId = @PropertyId) AND (URMI.ModuleId = @ModuleId) 	
	END

	ELSE IF(@TypeId = 2)
	BEGIN
		SELECT DISTINCT URMI.*,CM.Name As MenuItemName,U.UserName,R.Name As UserRoleName,'' As PropertyName
		FROM Central_UserRoleWiseMenuItems URMI
		INNER JOIN Central_UserWiseUserRoles UR ON URMI.UserRoleId = UR.UserRoleId
		INNER JOIN Admin_Nav_AreasWisePages CM ON URMI.MenuItemId = CM.Id
		INNER JOIN Central_UserRoles R On URMI.UserRoleId = R.Id
		INNER JOIN Central_Users U ON UR.UserId = U.Id
		WHERE (UR.UserId = @UserId) 	
	END

	ELSE
	BEGIN
		SELECT DISTINCT MenuItemId,CM.Name As MenuItemName,U.UserName As UserName,''As UserRoleName,
		(SELECT Id FROM Central_Properties WHERE Id = @PropertyId)As PropertyName,
		(SELECT Id FROM Central_Modules WHERE Id = @ModuleId)As ModuleName
		FROM Central_UserWiseIndividualMenuItems URMI
		INNER JOIN Admin_Nav_AreasWisePages CM ON URMI.MenuItemId = CM.Id
		INNER JOIN Central_Users U ON URMI.UserId = U.Id
		WHERE (URMI.UserId = @UserId) AND (URMI.PropertyId = @PropertyId) AND (URMI.ModuleId = @ModuleId)
		
		UNION 

		SELECT DISTINCT MenuItemId,CM.Name As MenuItemName,U.UserName,R.Name As UserRoleName,''As PropertyName,'' As ModuleName

		FROM Central_UserRoleWiseMenuItems URMI
		INNER JOIN Central_UserWiseUserRoles UR ON URMI.UserRoleId = UR.UserRoleId
		INNER JOIN Admin_Nav_AreasWisePages CM ON URMI.MenuItemId = CM.Id
		INNER JOIN Central_UserRoles R On URMI.UserRoleId = R.Id
		INNER JOIN Central_Users U ON UR.UserId = U.Id
		WHERE (UR.UserId = @UserId) 	
	END

END

--select * from Central_UserRoleWiseMenuItems
--select * from Central_UserWiseIndividualMenuItems

GO

