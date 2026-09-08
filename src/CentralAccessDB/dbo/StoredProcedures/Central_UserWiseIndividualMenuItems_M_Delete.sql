
CREATE PROCEDURE [dbo].[Central_UserWiseIndividualMenuItems_M_Delete]
	@UserId  INT,
	@ModuleId INT
AS
BEGIN


--Stehani
-- @Nov  9 2020  1:55PM

	SET NOCOUNT ON;
	SET DATEFORMAT DMY

	DELETE FROM Central_UserWiseIndividualMenuItems 
	WHERE [UserId]=@UserId AND [ModuleId] = @ModuleId
END

GO

