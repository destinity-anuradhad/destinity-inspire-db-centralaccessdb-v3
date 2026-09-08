---Report_UserWiseRoles 
CREATE PROCEDURE [dbo].[Report_UserWiseRoles]
	@PropertyId		INT=-1,
	@UserId			INT=-1
AS
BEGIN
	SELECT  B.Id AS RoleId,B.Name AS 'Role',C.FullName ,E.Name AS Property,C.EmpNumber,C.ModifiedDate,
	A.CreatedDate,C.Email,C.MobileNumber
	FROM Central_UserWiseUserRoles  A WITH(NOLOCK)
	INNER JOIN Central_UserRoles B WITH(NOLOCK) ON A.UserRoleId=B.Id
	INNER JOIN Central_Users C WITH(NOLOCK) ON C.Id = A.UserId 
	INNER JOIN Central_UserWiseProperties D WITH(NOLOCK) ON C.Id = D.UserId
	INNER JOIN Central_Properties E WITH(NOLOCK) ON E.Id = D.PropertyId 
	WHERE (@PropertyId=-1 OR D.PropertyId=@PropertyId) AND (@UserId=-1 OR C.Id=@UserId) 
	ORDER BY C.Id DESC
END

GO

