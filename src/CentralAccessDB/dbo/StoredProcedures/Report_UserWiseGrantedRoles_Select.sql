CREATE PROCEDURE [dbo].[Report_UserWiseGrantedRoles_Select]
	@UserId INT
AS
BEGIN
	SELECT DISTINCT A.UserRoleId,
	(SELECT Name FROM Central_UserRoles WHERE Id=A.UserRoleId) AS RoleName
	FROM Central_UserWiseUserRoles A
	WHERE A.UserId=@UserId
END

GO

