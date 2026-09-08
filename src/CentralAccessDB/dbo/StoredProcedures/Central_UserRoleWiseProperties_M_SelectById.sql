
CREATE PROCEDURE [dbo].[Central_UserRoleWiseProperties_M_SelectById]
@UserRoleId  INT
AS
BEGIN


--Stehani
-- @Nov  9 2020  1:55PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT * FROM Central_UserRoleWiseProperties WHERE[UserRoleId] = @UserRoleId
END

GO

