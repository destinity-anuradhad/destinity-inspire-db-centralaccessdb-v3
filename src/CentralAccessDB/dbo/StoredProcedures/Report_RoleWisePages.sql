---Report_Roles 2
CREATE PROCEDURE [dbo].[Report_RoleWisePages]
	@ModuleId		INT=-1
AS
BEGIN
	SELECT B.Name AS Role,C.Name AS Module,D.Name AS Page
	FROM  Central_UserRoles B WITH(NOLOCK) 
	INNER JOIN Central_UserRoleWiseMenuItems A WITH(NOLOCK) ON A.UserRoleId = B.Id
	INNER JOIN Central_Modules C WITH(NOLOCK) ON C.Id = A.ModuleId
	INNER JOIN Admin_Nav_AreasWisePages D WITH(NOLOCK) ON D.Id = A.MenuItemId
	WHERE (@ModuleId=-1 OR C.Id = @ModuleId) 
	AND B.IsActive=1
	AND C.IsActive=1
	AND D.IsActive=1
	ORDER BY B.Name,D.Name
END

GO

