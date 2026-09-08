-- =============================================
-- Author:		Chiraj
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--UserWiseProperty_M_SelectByUserId 1
CREATE PROCEDURE [dbo].[UserWiseProperty_M_SelectByUserId]
@UserId		Int
AS
BEGIN	
	SET NOCOUNT ON;

	SELECT Id,UserId,ProductId AS PropertyId
	FROM UserWiseProperty 	
	WHERE UserId = @UserId 	
	--AND IsActive=1

END

GO

