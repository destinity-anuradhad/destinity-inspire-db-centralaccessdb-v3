
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--[dbo].[Reports_UserRoles_Select_ByUserId]1
CREATE PROCEDURE [dbo].[Reports_UserRoles_Select_ByUserRoleId]
	@UserRoleId INT
AS
BEGIN
	SELECT * ,Name As UserRoleName FROM Central_UserRoles
	WHERE Id = @UserRoleId
END

GO

