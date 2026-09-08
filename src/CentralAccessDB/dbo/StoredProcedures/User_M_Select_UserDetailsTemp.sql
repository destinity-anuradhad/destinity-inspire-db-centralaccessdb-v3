-- =============================================
-- Author:		Chiraj
-- Create date: 2020-10-15
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[User_M_Select_UserDetailsTemp]
@UserName		Nvarchar(50)
AS
BEGIN	
	SET NOCOUNT ON;

	SELECT *
	FROM Users U
	WHERE U.Username = @UserName

END

GO

