
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--[dbo].[Reports_UserRoles_Select_ByUserId]1
CREATE PROCEDURE [dbo].[Reports_UserRoles_Select_ByUserId]
	@UserId INT
AS
BEGIN

	SELECT DISTINCT UWU.*,U.UserName As Name,UR.Name As UserRoleName
	FROM Central_UserWiseUserRoles UWU
	INNER JOIN Central_Users U ON UWU.UserId = U.Id
	INNER JOIN Central_UserRoles UR ON UWU.UserRoleId = UR.Id

	WHERE UWU.UserId = @UserId 


	
END


--select * from Central_UserWiseUserRoles
--select * from Central_UserRoleWiseMenuItems
--select * from Central_UserWiseIndividualMenuItems

GO

