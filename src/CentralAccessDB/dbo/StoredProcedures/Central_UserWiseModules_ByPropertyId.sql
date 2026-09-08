CREATE PROCEDURE [dbo].[Central_UserWiseModules_ByPropertyId]
	@UserId INT,
	@PropertyId INT
AS
BEGIN
	SELECT * FROM Central_UserWiseModules
	WHERE UserId = @UserId AND PropertyId=@PropertyId
END

GO

