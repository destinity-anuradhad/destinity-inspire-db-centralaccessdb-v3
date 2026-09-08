-- =============================================
-- Author:		Yasiru
-- Create date: 2017-8-29
-- Description:	
-- =============================================
--[User_M_VerifyUserByGuid]"955878edb9e9405fae40be4431770f6277e755a0f3db46a8a30d6d8207f19b5c"
CREATE PROCEDURE [dbo].[User_M_VerifyUserByGuid]
@CookieValue NVARCHAR(500)

AS
BEGIN
	IF EXISTS (SELECT * FROM Users WHERE Guid = @CookieValue)
	BEGIN	
		SELECT 1 		
	END 
	ELSE
	BEGIN
		SELECT 0
	END

END

GO

