
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--EXEC Central_UserWiseIndividualMenuItems_ByModuleId 1,0
CREATE PROCEDURE [dbo].[Central_UserWiseIndividualMenuItems_ByModuleId]
	@ModuleId INT,
	@UserId INT,
	@PropertyId INT
AS
BEGIN
	SELECT * FROM Central_UserWiseIndividualMenuItems
	WHERE UserId = @UserId AND ModuleId = @ModuleId AND PropertyId=@PropertyId
END

GO

