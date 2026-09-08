---exec Central_Report_UserWiseRolesByUserId 4091
CREATE PROCEDURE [dbo].[Central_Report_UserWiseRolesByUserId]
	@UserId INT
AS
BEGIN
	SELECT UserRoleId,
		   (SELECT Name FROM [dbo].[Central_UserRoles] WHERE Id=UserRoleId) AS RoleName
	FROM [dbo].[Central_UserWiseUserRoles]
	WHERE [UserId]=@UserId
END


--select * from Central_UserWiseUserRoles order by id desc 

GO

