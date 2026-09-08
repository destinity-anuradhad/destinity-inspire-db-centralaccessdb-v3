CREATE PROCEDURE [dbo].[Central_UserRoleWiseMenuItems_M_SelectById]
	@UserRoleId	int,
	@ModuleId	int
AS
BEGIN


--Stehani
-- @Nov  9 2020 10:50AM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	SELECT * FROM Central_UserRoleWiseMenuItems 
	WHERE [UserRoleId] =@UserRoleId AND [ModuleId] = @ModuleId
END

GO

