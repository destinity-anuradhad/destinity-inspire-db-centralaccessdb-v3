
CREATE PROCEDURE [dbo].[Central_UserWiseProperties_M_Delete]
@UserId  INT
AS
BEGIN


--Stehani
-- @Nov  9 2020  3:45PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	DELETE FROM Central_UserWiseProperties WHERE UserId= @UserId
END

GO

