CREATE PROCEDURE [dbo].[Reports_SelectUserNameById] 
@UserId INT
AS
BEGIN
	SELECT UserName,FullName FROM Central_Users WHERE Id=@UserId
END

GO

