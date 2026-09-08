
---exec Report_UserAccessChangeLog_Select 4181
CREATE PROCEDURE [dbo].[Report_UserAccessChangeLog_Select] 
	@UserId INT
AS
BEGIN
	SELECT *, (SELECT UserName FROM Central_Users with (nolock) WHERE Id=@UserId) AS UserName
	FROM Central_UserPasswordResetExpiredDetails with (nolock)
	WHERE UserId=@UserId
END

GO

