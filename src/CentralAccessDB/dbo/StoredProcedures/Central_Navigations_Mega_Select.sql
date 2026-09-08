--[dbo].[Central_Navigations_Mega_Select]46,1
CREATE PROCEDURE [dbo].[Central_Navigations_Mega_Select]
@UserId INT = 0,
@ModuleId INT = -1
AS
BEGIN

	EXEC [dbo].[Central_UserWiseMenuItems_Select] @UserId,@ModuleId
		
END

GO

