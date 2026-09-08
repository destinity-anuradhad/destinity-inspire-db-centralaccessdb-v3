
---Report_UserWiseRoles_Select 4248,2,1
CREATE PROCEDURE [dbo].[Report_UserWiseRoles_Select]
	@UserId INT,
	@PropertyId INT,
	@ModuleId INT
AS
BEGIN
	SELECT B.Id AS RoleId,B.Name,
	(SELECT FullName FROM Central_Users WITH(NOLOCK) WHERE Id=@UserId) AS UserName,
	(SELECT Name FROM Central_Properties WITH(NOLOCK) WHERE Id=@PropertyId) AS Property,
	(SELECT Name FROM Central_Modules WITH(NOLOCK) WHERE Id=@ModuleId) AS Module,
	(SELECT UserName FROM Central_Users WITH(NOLOCK) WHERE Id=A.ModifiedUserId) AS ModifiedBy,
	(SELECT ModifiedDate FROM Central_Users WITH(NOLOCK) WHERE Id=A.ModifiedUserId) AS ModifiedAt
	FROM Central_UserWiseUserRoles A
	INNER JOIN Central_UserRoles B ON A.UserRoleId=B.Id
	WHERE A.UserId=@UserId
END

--select * from Central_Users

GO

