
CREATE PROCEDURE [dbo].[Central_UserWiseModules_M_Delete]
	@UserId	INT
AS
BEGIN


--Stehani
-- @Nov  9 2020  3:22PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	DELETE FROM Central_UserWiseModules WHERE [UserId]=@UserId
END

GO

