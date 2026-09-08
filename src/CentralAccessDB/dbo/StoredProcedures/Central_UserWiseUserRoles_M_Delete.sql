
CREATE PROCEDURE [dbo].[Central_UserWiseUserRoles_M_Delete]
@UserId INT
AS
BEGIN


--Stehani
-- @Nov  9 2020  4:12PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	DELETE FROM Central_UserWiseUserRoles WHERE UserId=@UserId
END

GO

