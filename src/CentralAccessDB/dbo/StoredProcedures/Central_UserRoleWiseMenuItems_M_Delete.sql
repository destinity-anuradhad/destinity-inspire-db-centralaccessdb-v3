
CREATE PROCEDURE [dbo].[Central_UserRoleWiseMenuItems_M_Delete]
	@Id	INT
AS
BEGIN


--Stehani
-- @Nov  9 2020 12:53PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	DELETE FROM Central_UserRoleWiseMenuItems WHERE Id=@Id
END

GO

