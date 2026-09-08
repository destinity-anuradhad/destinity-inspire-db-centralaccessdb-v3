-- =============================================
-- Author:		Chiraj
-- Create date: 2020-10-15
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[UserWiseRoles_M_Select_ByUserId] 
@UserId int,
@PropertyId INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * 
	FROM UserWiseRoles
	WHERE UserId = @UserId AND PropertyId=@PropertyId
END

GO

