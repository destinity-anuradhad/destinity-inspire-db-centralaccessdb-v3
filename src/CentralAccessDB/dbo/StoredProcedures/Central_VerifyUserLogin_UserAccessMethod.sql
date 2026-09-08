-- Central_VerifyUserLogin_UserAccessMethod 5232,2
CREATE PROCEDURE [dbo].[Central_VerifyUserLogin_UserAccessMethod]
	@UserId						INT,
	@AuthenticationMethodId		INT
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM Central_Users WITH(NOLOCK) WHERE @UserId=Id AND @AuthenticationMethodId = AuhenticatedMethordId)
	BEGIN
		RAISERROR('401-Invalid user access method',16,1)
	END
END

GO

