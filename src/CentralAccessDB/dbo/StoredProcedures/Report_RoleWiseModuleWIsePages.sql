
CREATE   PROCEDURE [dbo].[Report_RoleWiseModuleWIsePages]
	
AS
BEGIN
	SELECT 
	A.UserRoleId AS RoleId,
	A.ModuleId AS ModuleId,
	A.MenuItemId AS PageId,
	B.Name AS UserRole,
	C.Name AS Module,
	F.Name AS MainNavigation,
	E.Name AS Area,
	D.Name AS Page
	FROM Central_UserRoleWiseMenuItems				A WITH(NOLOCK)
	INNER JOIN Central_UserRoles					B WITH(NOLOCK)	ON B.Id=A.UserRoleId
	INNER JOIN Central_Modules						C WITH(NOLOCK)	ON C.Id=A.ModuleId
	INNER JOIN Admin_Nav_AreasWisePages				D WITH(NOLOCK)	ON D.Id=A.MenuItemId AND D.ModuleId=A.ModuleId
	INNER JOIN Admin_Nav_MainNavigationWiseAreas	E WITH(NOLOCK)	ON E.Id=D.AreaId	AND E.ModuleId=A.ModuleId
	INNER JOIN Admin_Nav_MainNavigations			F WITH(NOLOCK)	ON F.Id=E.MainNavigationId AND F.ModuleId=A.ModuleId
	WHERE   D.IsActive=1
		AND B.IsActive=1
		AND C.IsActive=1
		AND E.IsActive=1
		AND F.IsActive=1
	GROUP BY A.UserRoleId,A.ModuleId,A.MenuItemId,B.Name,C.Name,D.Name,F.Name,E.Name
END

GO

