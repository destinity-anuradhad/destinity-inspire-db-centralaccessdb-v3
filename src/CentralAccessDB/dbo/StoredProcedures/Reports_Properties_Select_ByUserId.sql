
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--[dbo].[Reports_UserRoles_Select_ByUserId]1
CREATE PROCEDURE [dbo].[Reports_Properties_Select_ByUserId]
	@UserId INT
AS
BEGIN

	SELECT * FROM Central_UserWiseProperties UP 
	INNER JOIN Central_Properties CP  ON UP.PropertyId = CP.Id
	WHERE UP.UserId = @UserId


END


--select * from Central_UserWiseUserRoles
--select * from Central_UserRoleWiseMenuItems
--select * from Central_UserWiseIndividualMenuItems

GO

