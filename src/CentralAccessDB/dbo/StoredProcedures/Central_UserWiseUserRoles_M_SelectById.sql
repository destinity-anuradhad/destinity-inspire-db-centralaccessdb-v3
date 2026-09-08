
CREATE PROCEDURE [dbo].[Central_UserWiseUserRoles_M_SelectById]
@UserId INT
AS
BEGIN


--Stehani
-- @Nov  9 2020  4:12PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT * FROM Central_UserWiseUserRoles WHERE UserId=@UserId
END

GO

