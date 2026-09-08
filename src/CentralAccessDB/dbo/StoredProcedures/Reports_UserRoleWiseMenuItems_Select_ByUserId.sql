

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Reports_UserRoleWiseMenuItems_Select_ByUserId]--1
	@UserId INT
AS
BEGIN

	SELECT DISTINCT URMI.*,CM.Name As MenuItemName
	FROM Central_UserWiseUserRoles UWUR 
	INNER JOIN  Central_UserRoleWiseMenuItems URMI  ON URMI.UserRoleId = UWUR.UserRoleId
	INNER JOIN Admin_Nav_AreasWisePages CM ON URMI.MenuItemId = CM.Id
	WHERE UserId = @UserId 


	
END


--select * from Central_UserWiseUserRoles
--select * from Central_UserRoleWiseMenuItems
--select * from Central_UserWiseIndividualMenuItems

GO

